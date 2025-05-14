import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:collection/collection.dart';
import 'package:corks_cedar/corks_cedar.dart';
import 'package:corks_cedar/corks_proto.dart' as proto;
import 'package:corks_cedar/src/proto.dart';
import 'package:corks_cedar/src/proto/google/protobuf/any.pb.dart';
import 'package:crypto/crypto.dart';
import 'package:protobuf/protobuf.dart';

final class Cork {
  Cork._({
    required this.id,
    required this.issuer,
    required this.bearer,
    this.audience,
    this.claims,
    required List<Any> caveats,
    Uint8List? signature,
  }) : _caveats = caveats,
       _signature = signature;

  /// Parses a base64-encoded [Cork].
  factory Cork.parse(String token) => Cork.decode(base64Url.decode(token));

  /// Decodes a binary-encoded [Cork].
  factory Cork.decode(Uint8List bytes) {
    final message = proto.Cork.fromBuffer(bytes);
    return Cork.fromProto(message);
  }

  /// Creates a [Cork] from its protocol buffer representation.
  factory Cork.fromProto(proto.Cork proto) => Cork._(
    id: Uint8List.fromList(proto.id),
    issuer: proto.issuer..freeze(),
    bearer: proto.bearer..freeze(),
    audience: proto.hasAudience() ? (proto.audience..freeze()) : null,
    claims: proto.hasClaims() ? (proto.claims..freeze()) : null,
    caveats: [for (final caveat in proto.caveats) caveat..freeze()],
    signature: Uint8List.fromList(proto.signature),
  );

  /// Creates a [Cork] from its JSON representation.
  factory Cork.fromJson(Map<String, Object?> json) {
    final message =
        proto.Cork()..mergeFromProto3Json(json, typeRegistry: typeRegistry);
    return Cork.fromProto(message);
  }

  /// Creates a new [CorkBuilder].
  ///
  /// If [id] is not provided, a random nonce will be generated.
  static CorkBuilder builder([Uint8List? id]) => CorkBuilder(id);

  /// The unique identifier of the cork and its root key.
  final Uint8List id;

  /// The issuing authority of the cork.
  final Any issuer;

  /// The bearer of the cork, about which [claims] can be made.
  final Any bearer;

  /// The intended audience of the cork.
  final Any? audience;

  /// Claims made about the [bearer] of the cork.
  final Any? claims;

  /// The caveats to this cork's validity and usage.
  List<Any> get caveats => UnmodifiableListView(_caveats);

  final List<Any> _caveats;

  /// The final signature of the cork.
  Uint8List get signature {
    if (_signature == null) {
      throw MissingSignatureError();
    }
    return _signature!;
  }

  Uint8List? _signature;

  /// Converts the [Cork] to its protocol buffer representation.
  proto.Cork toProto() => proto.Cork(
    id: id,
    issuer: issuer,
    bearer: bearer,
    audience: audience,
    claims: claims,
    caveats: _caveats,
    signature: signature,
  );

  /// Encodes the [Cork] in binary format.
  Uint8List encode() => toProto().writeToBuffer();

  /// Encodes the [Cork] as a JSON object.
  Map<String, Object?> toJson() =>
      toProto().toProto3Json(typeRegistry: typeRegistry)
          as Map<String, Object?>;

  /// Signs the [Cork] using the provided [signer] and returns a new [Cork]
  /// with the signature.
  Future<Cork> sign(Signer signer) async {
    final signed = _clone();
    signed._signature = await signed._sign(signer);
    return signed;
  }

  /// Verifies the [signature] of the [Cork] using the provided [signer].
  Future<void> verify(Signer signer) async {
    final expected = Digest(signature);
    final actual = Digest(await _sign(signer));
    if (expected != actual) {
      throw InvalidSignatureException(expected: expected, actual: actual);
    }
  }

  /// Clones the [Cork] with the same properties.
  Cork _clone() {
    return Cork._(
      id: Uint8List.fromList(id),
      issuer: Any(
        typeUrl: issuer.typeUrl,
        value: Uint8List.fromList(issuer.value),
      ),
      bearer: Any(
        typeUrl: bearer.typeUrl,
        value: Uint8List.fromList(bearer.value),
      ),
      audience:
          audience == null
              ? null
              : Any(
                typeUrl: audience!.typeUrl,
                value: Uint8List.fromList(audience!.value),
              ),
      claims:
          claims == null
              ? null
              : Any(
                typeUrl: claims!.typeUrl,
                value: Uint8List.fromList(claims!.value),
              ),
      caveats: [
        for (final caveat in _caveats)
          Any(typeUrl: caveat.typeUrl, value: Uint8List.fromList(caveat.value)),
      ],
      signature: _signature == null ? null : Uint8List.fromList(_signature!),
    );
  }

  Future<Uint8List> _sign(Signer signer) async {
    signer.reset();

    var signature = await signer.sign(id);
    signature = await signer.signProto(issuer);
    signature = await signer.signProto(bearer);
    if (audience case final audience?) {
      signature = await signer.signProto(audience);
    }
    if (claims case final claims?) {
      signature = await signer.signProto(claims);
    }
    for (final caveat in _caveats) {
      signature = await signer.signProto(caveat);
    }

    return signature;
  }

  @override
  String toString() => base64Url.encode(encode());
}

final class CorkBuilder {
  factory CorkBuilder([Uint8List? id]) {
    if (id == null) {
      final nonceSize = sha256.blockSize;
      id = Uint8List(nonceSize);
      for (var i = 0; i < nonceSize; i++) {
        id[i] = _secureRandom.nextInt(256);
      }
    }
    return CorkBuilder._(id);
  }

  CorkBuilder._(this._id);

  static final _secureRandom = Random.secure();

  final Uint8List _id;
  Any? _issuer;
  Any? _bearer;
  Any? _audience;
  Any? _claims;
  final List<Any> _caveats = [];

  /// Sets the [Cork.issuer] of the cork.
  set issuer(GeneratedMessage issuer) {
    _issuer = issuer.packIntoAny();
  }

  /// Sets the [Cork.bearer] of the cork.
  set bearer(GeneratedMessage bearer) {
    _bearer = bearer.packIntoAny();
  }

  /// Sets the [Cork.audience] of the cork.
  set audience(GeneratedMessage audience) {
    _audience = audience.packIntoAny();
  }

  /// Sets the [Cork.claims] of the cork.
  set claims(GeneratedMessage claims) {
    _claims = claims.packIntoAny();
  }

  /// Appends a caveat to the cork's [Cork.caveats].
  void addCaveat(GeneratedMessage caveat) {
    _caveats.add(caveat.packIntoAny());
  }

  /// Validates the cork's properties before building.
  void validate() {
    if (_issuer == null) {
      throw InvalidCorkException('issuer is required');
    }
    if (_bearer == null) {
      throw InvalidCorkException('bearer is required');
    }
  }

  /// Builds and validates the [Cork].
  Cork build() {
    validate();
    return Cork._(
      id: _id,
      issuer: _issuer!,
      bearer: _bearer!,
      audience: _audience,
      claims: _claims,
      caveats: _caveats,
      signature: null,
    );
  }
}
