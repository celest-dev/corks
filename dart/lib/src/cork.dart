import 'dart:convert';
import 'dart:typed_data';

import 'package:corks_cedar/src/crypto.dart';
import 'package:fixnum/fixnum.dart';
import 'package:protobuf/protobuf.dart' show GeneratedMessage;

import 'exceptions.dart';
import 'proto.dart';
import 'proto/corks/v1/cork.pb.dart' as corksv1;
import 'proto/google/protobuf/any.pb.dart' as anypb;
import 'signer.dart';

/// High-level API for the Celest cork credential described in
/// `docs/corks_spec.md`.
///
/// Instances are immutable protobuf payloads that support deterministic
/// serialization, signing, verification, and attenuation through caveats.
///
/// ### Example
/// ```dart
/// import 'dart:typed_data';
/// import 'package:corks_cedar/corks_cedar.dart';
/// import 'package:corks_cedar/src/proto/cedar/v3/entity_uid.pb.dart' as cedar;
///
/// final keyId = Uint8List.fromList(List<int>.generate(16, (i) => i));
/// final masterKey = Uint8List.fromList(List<int>.generate(32, (i) => i + 16));
/// final signer = Signer(keyId, masterKey);
///
/// final builder = Cork.builder(keyId)
///   ..issuer = cedar.EntityUid(type: 'Service', id: 'celest-cloud')
///   ..bearer = cedar.EntityUid(type: 'Session', id: 'sess-123')
///   ..notAfter = DateTime.now().toUtc().add(const Duration(hours: 1));
///
/// // Caveat helpers wrap the registry payloads documented in Spec §9.
/// builder.addCaveat(buildExpiryCaveat(DateTime.now().toUtc().add(
///   const Duration(hours: 1),
/// )));
/// builder.addCaveat(buildOrganizationScopeCaveat(
///   organizationId: 'org:acme',
///   projectId: 'proj:web',
///   environmentId: 'env:prod',
/// ));
///
/// final signed = await builder.build().sign(signer);
/// await Cork.parse(signed.toString()).verify(signer); // throws if invalid
/// ```
class Cork {
  /// Convenience factory that builds a cork via [CorkBuilder] and immediately
  /// signs it with the supplied fields.  Useful for tests and migration flows
  /// that already have caveats materialised.
  factory Cork({
    required Uint8List keyId,
    Uint8List? nonce,
    required GeneratedMessage issuer,
    required GeneratedMessage bearer,
    GeneratedMessage? audience,
    GeneratedMessage? claims,
    List<corksv1.Caveat>? caveats,
    DateTime? issuedAt,
    DateTime? notAfter,
  }) {
    final builder =
        CorkBuilder(keyId)
          ..issuer = issuer
          ..bearer = bearer
          ..audience = audience
          ..claims = claims
          ..notAfter = notAfter;
    if (issuedAt != null) {
      builder.issuedAt = issuedAt;
    }
    if (nonce != null) {
      builder.nonce = nonce;
    }

    if (caveats != null) {
      for (final caveat in caveats) {
        builder.addCaveat(caveat);
      }
    }

    return builder.build();
  }

  Cork._(this._proto);

  static const int currentVersion = 1;

  final corksv1.Cork _proto;

  /// Parses a base64-encoded [Cork].
  factory Cork.parse(String token) {
    try {
      final normalized = base64Url.normalize(token);
      final bytes = base64Url.decode(normalized);
      final message = corksv1.Cork.fromBuffer(bytes);
      return Cork._(message);
    } on Object catch (error) {
      throw InvalidCorkException('Failed to decode cork: $error');
    }
  }

  /// Decodes a binary-encoded [Cork].
  factory Cork.decode(Uint8List bytes) {
    try {
      final message = corksv1.Cork.fromBuffer(bytes);
      return Cork._(message);
    } on Object catch (error) {
      throw InvalidCorkException('Failed to decode cork: $error');
    }
  }

  /// Creates a [Cork] from its protocol buffer representation.
  factory Cork.fromProto(corksv1.Cork message) => Cork._(message.deepCopy());

  /// Creates a [Cork] from its JSON representation.
  factory Cork.fromJson(Map<String, Object?> json) {
    final message =
        corksv1.Cork()..mergeFromProto3Json(json, typeRegistry: typeRegistry);
    return Cork._(message);
  }

  corksv1.Cork toProto() => _proto.deepCopy();

  /// Returns a [CorkBuilder] initialised with [keyId].
  static CorkBuilder builder(Uint8List keyId) => CorkBuilder(keyId);

  /// Protocol version embedded in the underlying protobuf.
  int get version => _proto.version;

  /// Random nonce used when deriving the per-cork root key.
  Uint8List get nonce => Uint8List.fromList(_proto.nonce);

  /// Identifier for the master key that signed this cork.
  Uint8List get keyId => Uint8List.fromList(_proto.keyId);

  /// Issuer entity packed as `google.protobuf.Any` (Cedar EntityUid).
  anypb.Any? get issuer => _proto.hasIssuer() ? _proto.issuer.deepCopy() : null;

  /// Bearer entity representing the authorised principal.
  anypb.Any? get bearer => _proto.hasBearer() ? _proto.bearer.deepCopy() : null;

  /// Optional audience that the cork is scoped to.
  anypb.Any? get audience =>
      _proto.hasAudience() ? _proto.audience.deepCopy() : null;

  /// Optional structured claims payload carried alongside the cork.
  anypb.Any? get claims => _proto.hasClaims() ? _proto.claims.deepCopy() : null;

  /// Ordered caveat list copied out of the protobuf payload.
  List<corksv1.Caveat> get caveats => [
    for (final caveat in _proto.caveats) caveat.deepCopy(),
  ];

  /// Millisecond timestamp representing when the cork was minted.
  Int64 get issuedAt => _proto.issuedAt;

  /// Optional millisecond expiry timestamp, or `null` for non-expiring corks.
  Int64? get notAfter => _proto.hasNotAfter() ? _proto.notAfter : null;

  /// Tail signature captured in the protobuf.
  ///
  /// Throws if the cork is unsigned.
  Uint8List get tailSignature {
    final signature = _proto.tailSignature;
    if (signature.isEmpty) {
      throw MissingSignatureError();
    }
    return Uint8List.fromList(signature);
  }

  /// Serializes the cork to a protobuf binary buffer.
  ///
  /// Requires the cork to be signed.
  Uint8List encode() {
    if (_proto.tailSignature.isEmpty) {
      throw MissingSignatureError();
    }
    return Uint8List.fromList(_proto.writeToBuffer());
  }

  /// Produces a new [Cork] signed with [signer].
  Future<Cork> sign(Signer signer) async {
    final message = _proto.deepCopy();
    // Spec §5 describes the chained MAC construction used here.
    final signature = await computeTailSignature(message, signer);
    message.tailSignature = signature;
    return Cork._(message);
  }

  /// Recomputes the chained MAC with [signer] and throws
  /// [InvalidSignatureException] if verification fails.
  Future<void> verify(Signer signer) async {
    final expected = _proto.tailSignature;
    if (expected.isEmpty) {
      throw MissingSignatureError();
    }
    // Spec §5: verification recomputes the signature over every field.
    final actual = await computeTailSignature(_proto, signer);
    if (!constantTimeEquals(expected, actual)) {
      throw InvalidSignatureException(
        expected: Uint8List.fromList(expected),
        actual: actual,
      );
    }
  }

  /// Returns a [CorkBuilder] initialised from this cork so callers can append
  /// caveats without mutating the existing instance.
  CorkBuilder rebuild() => CorkBuilder._fromProto(_proto.deepCopy());

  @override
  /// Encodes the cork to URL-safe base64, omitting padding.
  String toString() {
    final bytes = encode();
    return base64Url.encode(bytes).replaceAll('=', '');
  }
}

/// Fluent builder that enforces the structural rules from Spec §4 before a
/// cork is signed.  It validates required fields, enforces nonce length, and
/// copies caveats so templates can be reused safely.
class CorkBuilder {
  /// Creates a builder for a new cork with the given [keyId].
  ///
  /// The builder pre-populates `nonce` using secure randomness and `issuedAt`
  /// using the current UTC timestamp.
  CorkBuilder(Uint8List keyId)
    : _version = Cork.currentVersion,
      _nonce = secureRandomBytes(nonceSize),
      _keyId = Uint8List.fromList(keyId),
      _issuedAt = Int64(DateTime.timestamp().millisecondsSinceEpoch);

  CorkBuilder._fromProto(corksv1.Cork message)
    : _version = message.version,
      _nonce = Uint8List.fromList(message.nonce),
      _keyId = Uint8List.fromList(message.keyId),
      _issuer = message.hasIssuer() ? message.issuer.deepCopy() : null,
      _bearer = message.hasBearer() ? message.bearer.deepCopy() : null,
      _audience = message.hasAudience() ? message.audience.deepCopy() : null,
      _claims = message.hasClaims() ? message.claims.deepCopy() : null,
      _issuedAt =
          message.hasIssuedAt()
              ? message.issuedAt
              : Int64(DateTime.timestamp().millisecondsSinceEpoch),
      _notAfter = message.hasNotAfter() ? message.notAfter : null {
    for (final caveat in message.caveats) {
      _caveats.add(caveat.deepCopy());
    }
  }

  int _version;
  Uint8List _nonce;
  Uint8List _keyId;
  GeneratedMessage? _issuer;
  GeneratedMessage? _bearer;
  GeneratedMessage? _audience;
  GeneratedMessage? _claims;
  final List<corksv1.Caveat> _caveats = [];
  Int64 _issuedAt;
  Int64? _notAfter;

  /// Overrides the protocol [version]. Primarily used in tests when simulating
  /// migration scenarios.
  CorkBuilder version(int version) {
    _version = version;
    return this;
  }

  /// Overrides the randomly generated [nonce].  Ensures the provided value has
  /// the required length.
  set nonce(Uint8List nonce) {
    if (nonce.length != nonceSize) {
      throw InvalidCorkException('nonce must be $nonceSize bytes');
    }
    _nonce = Uint8List.fromList(nonce);
  }

  /// Updates the key identifier that will be embedded in the resulting cork.
  set keyId(Uint8List keyId) {
    _keyId = Uint8List.fromList(keyId);
  }

  /// Sets the issuer entity backing the cork.
  set issuer(GeneratedMessage issuer) {
    _issuer = issuer;
  }

  /// Sets the bearer (authorised principal) entity.
  set bearer(GeneratedMessage bearer) {
    _bearer = bearer;
  }

  /// Optionally sets the audience entity.
  set audience(GeneratedMessage? audience) {
    _audience = audience;
  }

  /// Optionally sets the claims payload packed into the cork.
  set claims(GeneratedMessage? claims) {
    _claims = claims;
  }

  /// Adds [caveat] to the builder, storing a defensive copy so the caller can
  /// reuse the original instance when minting discharges or parallel corks.
  void addCaveat(corksv1.Caveat caveat) {
    _caveats.add(caveat.deepCopy());
  }

  /// Overrides the minted timestamp using the provided [issuedAt] instant.
  set issuedAt(DateTime issuedAt) {
    _issuedAt = Int64(issuedAt.toUtc().millisecondsSinceEpoch);
  }

  /// Overrides or clears the expiry timestamp.
  set notAfter(DateTime? notAfter) {
    final millis = notAfter?.toUtc().millisecondsSinceEpoch;
    if (millis == null || millis == 0) {
      _notAfter = null;
    } else {
      _notAfter = Int64(millis);
    }
  }

  /// Ensures the builder contains all mandatory fields before encoding.
  void validate() {
    final missing = <String>[];
    if (_version == 0) {
      missing.add('version');
    }
    if (_nonce.length != nonceSize) {
      missing.add('nonce');
    }
    if (_keyId.isEmpty) {
      missing.add('keyId');
    }
    if (_issuer == null) {
      missing.add('issuer');
    }
    if (_bearer == null) {
      missing.add('bearer');
    }
    if (_issuedAt == Int64.ZERO) {
      missing.add('issuedAt');
    }
    for (var i = 0; i < _caveats.length; i++) {
      final caveat = _caveats[i];
      if (!caveat.hasCaveatVersion() || caveat.caveatVersion == 0) {
        missing.add('caveat[$i].version');
      }
      if (!caveat.hasCaveatId() || caveat.caveatId.isEmpty) {
        missing.add('caveat[$i].id');
      }
      final hasBody = caveat.hasFirstParty() || caveat.hasThirdParty();
      if (!hasBody) {
        missing.add('caveat[$i].body');
      }
    }
    if (missing.isNotEmpty) {
      throw InvalidCorkException('missing ${missing.join(', ')}');
    }
  }

  /// Emits an unsigned [Cork].
  ///
  /// Call [Cork.sign] with a configured [Signer] to produce a transferable
  /// token.
  Cork build() {
    validate();

    final message = corksv1.Cork(
      version: _version,
      nonce: Uint8List.fromList(_nonce),
      keyId: Uint8List.fromList(_keyId),
      issuedAt: _issuedAt,
    );

    final issuer = _packMessage(_issuer);
    if (issuer != null) {
      message.issuer = issuer;
    }
    final bearer = _packMessage(_bearer);
    if (bearer != null) {
      message.bearer = bearer;
    }
    final audience = _packMessage(_audience);
    if (audience != null) {
      message.audience = audience;
    }
    final claims = _packMessage(_claims);
    if (claims != null) {
      message.claims = claims;
    }

    if (_notAfter != null) {
      message.notAfter = _notAfter!;
    }

    message.caveats.addAll(_caveats.map((c) => c.deepCopy()));

    return Cork._(message);
  }

  anypb.Any? _packMessage(GeneratedMessage? message) {
    if (message == null) {
      return null;
    }
    final packed = message.packIntoAny();
    return packed.deepCopy();
  }
}
