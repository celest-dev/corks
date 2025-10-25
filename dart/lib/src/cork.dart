import 'dart:async';
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

/// A Celest cork credential that supports deterministic serialization,
/// signing, verification, and caveat attenuation.
///
/// Instances are immutable protobuf payloads. They follow the structure
/// described in `docs/corks_spec.md` and are interoperable with Celest
/// services.
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
/// final cork = await Cork(
///   keyId: keyId,
///   issuer: cedar.EntityUid(type: 'Service', id: 'celest-cloud'),
///   bearer: cedar.EntityUid(type: 'Session', id: 'sess-123'),
///   notAfter: DateTime.now().toUtc().add(const Duration(hours: 1)),
/// )
///   .sign(signer);
///
/// await cork.verify(signer);
/// ```
class Cork {
  /// Builds a cork via [CorkBuilder] using the provided fields.
  ///
  /// Useful for tests and migration flows where caveats are already
  /// materialized. The resulting instance is unsigned; call [sign] to produce a
  /// transferable token.
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
  ///
  /// Throws [InvalidCorkException] if the token cannot be decoded.
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
  ///
  /// Throws [InvalidCorkException] if the buffer cannot be decoded.
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

  /// Returns a [CorkBuilder] initialized with [keyId].
  static CorkBuilder builder(Uint8List keyId) => CorkBuilder(keyId);

  /// Protocol version embedded in the underlying protobuf.
  int get version => _proto.version;

  /// Random nonce used when deriving the per-cork root key.
  Uint8List get nonce => Uint8List.fromList(_proto.nonce);

  /// Identifier for the master key that signed this cork.
  Uint8List get keyId => Uint8List.fromList(_proto.keyId);

  /// Issuer entity packed as `google.protobuf.Any` (Cedar EntityUid).
  anypb.Any? get issuer => _proto.hasIssuer() ? _proto.issuer.deepCopy() : null;

  /// Bearer entity representing the authorized principal.
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
  /// Throws [MissingSignatureError] if the cork is unsigned.
  Uint8List get tailSignature {
    final signature = _proto.tailSignature;
    if (signature.isEmpty) {
      throw MissingSignatureError();
    }
    return Uint8List.fromList(signature);
  }

  /// Serializes this cork to a protobuf binary buffer.
  ///
  /// Throws [MissingSignatureError] if the cork has not been signed.
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

  /// Recomputes the chained MAC with [signer] and compares it with the stored
  /// signature.
  ///
  /// Throws [MissingSignatureError] if the cork is unsigned and
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

  /// Returns a [CorkBuilder] initialized from this cork.
  ///
  /// The returned builder lets callers append caveats without mutating this
  /// instance.
  CorkBuilder rebuild() => CorkBuilder._fromProto(_proto.deepCopy());

  /// Encodes the cork to URL-safe base64, omitting padding.
  @override
  String toString() {
    final bytes = encode();
    return base64Url.encode(bytes).replaceAll('=', '');
  }
}

/// Fluent builder that enforces the structural rules from Spec §4 before a
/// cork is signed.
///
/// The builder validates required fields, enforces nonce length, and copies
/// caveats so templates can be reused safely.
const _defaultCaveatNamespace = 'celest.auth';
const _expiryPredicate = 'expiry';
const _organizationScopePredicate = 'organization_scope';
const _actionScopePredicate = 'actions';
const _ipBindingPredicate = 'ip_binding';
const _sessionStatePredicate = 'session_state';
const _defaultCaveatVersion = 1;
const _caveatIdSize = 16;

/// Callback invoked by [ThirdPartyCaveatOptions] to encrypt a discharge ticket.
typedef ThirdPartyTicketEncrypter =
    FutureOr<List<int>> Function(Uint8List caveatId, Uint8List caveatRootKey);

/// Options that control how a third-party caveat is constructed.
final class ThirdPartyCaveatOptions {
  ThirdPartyCaveatOptions({
    required this.location,
    required List<int> tag,
    List<int>? salt,
    List<int>? caveatId,
    List<int>? challengeNonce,
    required this.encryptTicket,
  }) : _tag = Uint8List.fromList(tag),
       _salt = salt == null ? null : Uint8List.fromList(salt),
       _caveatId = caveatId == null ? null : Uint8List.fromList(caveatId),
       _challengeNonce =
           challengeNonce == null ? null : Uint8List.fromList(challengeNonce);

  final String location;
  final ThirdPartyTicketEncrypter encryptTicket;
  final Uint8List _tag;
  final Uint8List? _salt;
  final Uint8List? _caveatId;
  final Uint8List? _challengeNonce;

  /// Attenuation tag used when deriving the third-party root key.
  Uint8List get tag => Uint8List.fromList(_tag);

  /// Optional HKDF salt mixed into the derived key.
  Uint8List? get salt {
    final value = _salt;
    if (value == null || value.isEmpty) {
      return null;
    }
    return Uint8List.fromList(value);
  }

  /// Optional caller-provided caveat identifier.
  Uint8List? get caveatId {
    final value = _caveatId;
    if (value == null || value.isEmpty) {
      return null;
    }
    return Uint8List.fromList(value);
  }

  /// Optional nonce to use when encrypting the challenge payload.
  Uint8List? get challengeNonce {
    final value = _challengeNonce;
    if (value == null || value.isEmpty) {
      return null;
    }
    return Uint8List.fromList(value);
  }
}

class CorkBuilder {
  /// Creates a builder for a new cork with the given [keyId].
  ///
  /// The builder pre-populates [nonce] using secure randomness and [issuedAt]
  /// with the current UTC timestamp.
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
  corksv1.Expiry? _defaultExpiry;
  corksv1.OrganizationScope? _defaultOrganizationScope;
  corksv1.ActionScope? _defaultActionScope;

  /// Overrides the protocol [version].
  ///
  /// This is primarily useful in tests when simulating migration scenarios.
  CorkBuilder version(int version) {
    _version = version;
    return this;
  }

  /// Overrides the randomly generated [nonce].
  ///
  /// Throws [InvalidCorkException] if the provided nonce has the wrong length.
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

  /// Sets the bearer (authorized principal) entity.
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

  /// Adds [caveat] to the builder.
  ///
  /// Stores a defensive copy so the caller can reuse the original instance
  /// when minting discharges or parallel corks.
  void addCaveat(corksv1.Caveat caveat) {
    _caveats.add(caveat.deepCopy());
  }

  /// Overrides the minted timestamp using the provided [issuedAt] instant.
  set issuedAt(DateTime issuedAt) {
    _issuedAt = Int64(issuedAt.toUtc().millisecondsSinceEpoch);
  }

  /// Overrides or clears the expiry timestamp.
  ///
  /// Pass `null` to create a non-expiring cork.
  set notAfter(DateTime? notAfter) {
    final millis = notAfter?.toUtc().millisecondsSinceEpoch;
    if (millis == null || millis == 0) {
      _notAfter = null;
    } else {
      _notAfter = Int64(millis);
    }
  }

  /// Configures the default expiry caveat and synchronises metadata.
  set defaultExpiry(DateTime? notAfter) {
    if (notAfter == null || notAfter.millisecondsSinceEpoch == 0) {
      _notAfter = null;
      _defaultExpiry = null;
      return;
    }
    final millis = Int64(notAfter.toUtc().millisecondsSinceEpoch);
    _notAfter = millis;
    _defaultExpiry = corksv1.Expiry(notAfter: millis).deepCopy();
  }

  /// Appends a first-party expiry caveat that attenuates the cork.
  void appendExpiryCaveat(DateTime notAfter) {
    final millis = notAfter.toUtc().millisecondsSinceEpoch;
    if (millis == 0) {
      throw InvalidCorkException('expiry notAfter must be set');
    }
    final payload = corksv1.Expiry(notAfter: Int64(millis));
    _caveats.add(_firstPartyCaveat(_expiryPredicate, payload));
  }

  /// Appends a first-party organization scope caveat.
  void appendOrganizationScopeCaveat(corksv1.OrganizationScope scope) {
    _caveats.add(
      _firstPartyCaveat(_organizationScopePredicate, scope.deepCopy()),
    );
  }

  /// Appends a first-party action scope caveat.
  void appendActionScopeCaveat(List<String> actions) {
    if (actions.isEmpty) {
      throw InvalidCorkException('action scope requires at least one action');
    }
    final scope = corksv1.ActionScope()..actions.addAll(actions);
    _caveats.add(_firstPartyCaveat(_actionScopePredicate, scope));
  }

  /// Appends a first-party IP binding caveat.
  void appendIpBindingCaveat(List<String> cidrs) {
    if (cidrs.isEmpty) {
      throw InvalidCorkException('ip binding requires at least one CIDR');
    }
    final binding = corksv1.IpBinding()..cidrs.addAll(cidrs);
    _caveats.add(_firstPartyCaveat(_ipBindingPredicate, binding));
  }

  /// Appends a first-party session state caveat for revocation.
  void appendSessionStateCaveat(corksv1.SessionState state) {
    if (!state.hasSessionId() || state.sessionId.isEmpty) {
      throw InvalidCorkException('session state requires sessionId');
    }
    _caveats.add(_firstPartyCaveat(_sessionStatePredicate, state.deepCopy()));
  }

  /// Appends a third-party caveat that delegates discharge to an external service.
  Future<CorkBuilder> appendThirdPartyCaveat(
    ThirdPartyCaveatOptions options,
  ) async {
    if (options.location.isEmpty) {
      throw InvalidCorkException('third-party location is required');
    }
    final encryptTicket = options.encryptTicket;

    final tag = options.tag;
    final salt = options.salt;
    final providedId = options.caveatId;
    final caveatId =
        providedId == null || providedId.isEmpty
            ? secureRandomBytes(_caveatIdSize)
            : Uint8List.fromList(providedId);

    final derived = deriveCaveatRootKey(
      tag: tag,
      caveatId: caveatId,
      salt: salt,
    );

    final ticketBytes = await Future.sync(
      () => encryptTicket(
        Uint8List.fromList(caveatId),
        Uint8List.fromList(derived),
      ),
    );
    final ticket = Uint8List.fromList(ticketBytes);
    if (ticket.isEmpty) {
      throw InvalidCorkException('encrypted ticket must not be empty');
    }

    final challenge = await encryptChallenge(
      tag: tag,
      caveatId: caveatId,
      salt: salt,
      derivedKey: derived,
      nonce: options.challengeNonce,
    );

    final thirdParty = corksv1.ThirdPartyCaveat(
      location: options.location,
      ticket: ticket,
      challenge: challenge,
    );
    if (salt != null && salt.isNotEmpty) {
      thirdParty.salt = Uint8List.fromList(salt);
    }

    final caveat = corksv1.Caveat(
      caveatVersion: _defaultCaveatVersion,
      caveatId: Uint8List.fromList(caveatId),
      thirdParty: thirdParty,
    );
    _caveats.add(caveat);
    return this;
  }

  /// Adds a default organization scope caveat. Pass `null` to clear it.
  set defaultOrganizationScope(corksv1.OrganizationScope? scope) {
    _defaultOrganizationScope = scope?.deepCopy();
  }

  /// Adds a default action scope caveat. Empty or `null` clears it.
  set defaultActionScope(List<String>? actions) {
    if (actions == null || actions.isEmpty) {
      _defaultActionScope = null;
      return;
    }
    final scope = corksv1.ActionScope()..actions.addAll(actions);
    _defaultActionScope = scope.deepCopy();
  }

  /// Ensures the builder contains all mandatory fields before encoding.
  ///
  /// Throws [InvalidCorkException] when a required field is missing or
  /// malformed.
  void validate() {
    final caveats = _buildCaveats();
    _validateWithCaveats(caveats);
  }

  void _validateWithCaveats(List<corksv1.Caveat> caveats) {
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
    for (var i = 0; i < caveats.length; i++) {
      final caveat = caveats[i];
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
    final caveats = _buildCaveats();
    _validateWithCaveats(caveats);

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

    message.caveats.addAll(caveats.map((c) => c.deepCopy()));

    return Cork._(message);
  }

  anypb.Any? _packMessage(GeneratedMessage? message) {
    if (message == null) {
      return null;
    }
    final packed = message.packIntoAny();
    return packed.deepCopy();
  }

  List<corksv1.Caveat> _buildCaveats() {
    final caveats = <corksv1.Caveat>[];
    caveats.addAll(_buildDefaultCaveats());
    for (final caveat in _caveats) {
      caveats.add(caveat.deepCopy());
    }
    return caveats;
  }

  List<corksv1.Caveat> _buildDefaultCaveats() {
    final defaults = <corksv1.Caveat>[];
    if (_defaultExpiry != null) {
      defaults.add(
        _firstPartyCaveat(_expiryPredicate, _defaultExpiry!.deepCopy()),
      );
    }
    if (_defaultOrganizationScope != null) {
      defaults.add(
        _firstPartyCaveat(
          _organizationScopePredicate,
          _defaultOrganizationScope!.deepCopy(),
        ),
      );
    }
    if (_defaultActionScope != null) {
      defaults.add(
        _firstPartyCaveat(
          _actionScopePredicate,
          _defaultActionScope!.deepCopy(),
        ),
      );
    }
    return defaults;
  }

  corksv1.Caveat _firstPartyCaveat(String predicate, GeneratedMessage payload) {
    final packed = payload.packIntoAny().deepCopy();
    return corksv1.Caveat(
      caveatVersion: _defaultCaveatVersion,
      caveatId: secureRandomBytes(_caveatIdSize),
      firstParty: corksv1.FirstPartyCaveat(
        namespace: _defaultCaveatNamespace,
        predicate: predicate,
        payload: packed,
      ),
    );
  }
}
