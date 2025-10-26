import 'dart:convert';
import 'dart:typed_data';

import 'package:fixnum/fixnum.dart';
import 'package:protobuf/protobuf.dart';

import 'crypto.dart';
import 'exceptions.dart';
import 'proto.dart';
import 'proto/celest/corks/v1/cork.pb.dart' as corksv1;
import 'proto/google/protobuf/any.pb.dart' as anypb;

const int _defaultCaveatVersion = 1;

/// Represents a discharge macaroon fulfilling a third-party caveat.
final class Discharge {
  Discharge._(this._proto);

  /// Protocol revision supported by the discharge implementation.
  static const int currentVersion = 1;

  final corksv1.Discharge _proto;

  /// Parses a base64url encoded discharge token.
  factory Discharge.parse(String token) {
    try {
      final bytes = base64Url.decode(base64Url.normalize(token));
      return Discharge.decode(Uint8List.fromList(bytes));
    } on Object catch (error) {
      throw InvalidCorkException('Failed to decode discharge: $error');
    }
  }

  /// Decodes a binary-encoded discharge message.
  factory Discharge.decode(Uint8List bytes) {
    try {
      return Discharge._(corksv1.Discharge.fromBuffer(bytes));
    } on Object catch (error) {
      throw InvalidCorkException('Failed to decode discharge: $error');
    }
  }

  /// Constructs a discharge from its protobuf representation.
  factory Discharge.fromProto(corksv1.Discharge message) {
    return Discharge._(message.deepCopy());
  }

  corksv1.Discharge toProto() => _proto.deepCopy();

  int get version => _proto.version;
  Uint8List get nonce => Uint8List.fromList(_proto.nonce);
  Uint8List get keyId => Uint8List.fromList(_proto.keyId);
  Uint8List get parentCaveatId => Uint8List.fromList(_proto.parentCaveatId);
  anypb.Any? get issuer => _proto.hasIssuer() ? _proto.issuer.deepCopy() : null;
  List<corksv1.Caveat> get caveats => [
    for (final c in _proto.caveats) c.deepCopy(),
  ];
  Int64 get issuedAt => _proto.issuedAt;
  Int64? get notAfter => _proto.hasNotAfter() ? _proto.notAfter : null;

  Uint8List get tailSignature {
    final signature = _proto.tailSignature;
    if (signature.isEmpty) {
      throw MissingSignatureError();
    }
    return Uint8List.fromList(signature);
  }

  /// Encodes the discharge as a protobuf binary payload.
  Uint8List encode() {
    if (_proto.tailSignature.isEmpty) {
      throw MissingSignatureError();
    }
    return Uint8List.fromList(_proto.writeToBuffer());
  }

  /// Encodes the discharge as base64url without padding.
  @override
  String toString() {
    return base64Url.encode(encode()).replaceAll('=', '');
  }

  /// Verifies the discharge using the derived caveat root key.
  void verify({required Uint8List caveatRootKey}) {
    final expected = _proto.tailSignature;
    if (expected.isEmpty) {
      throw MissingSignatureError();
    }
    final actual = computeDischargeTailSignature(
      message: _proto,
      caveatRootKey: caveatRootKey,
    );
    if (!constantTimeEquals(expected, actual)) {
      throw InvalidSignatureException(
        expected: Uint8List.fromList(expected),
        actual: actual,
      );
    }
  }
}

/// Builder that signs and emits discharge macaroons for third-party caveats.
final class DischargeBuilder {
  DischargeBuilder({
    required Uint8List parentCaveatId,
    required Uint8List caveatRootKey,
    required Uint8List keyId,
    GeneratedMessage? issuer,
  }) : _version = Discharge.currentVersion,
       _nonce = secureRandomBytes(nonceSize),
       _parentCaveatId = Uint8List.fromList(parentCaveatId),
       _keyId = Uint8List.fromList(keyId),
       _issuer = issuer?.deepCopy(),
       _rootKey = Uint8List.fromList(caveatRootKey),
       _issuedAt = Int64(DateTime.timestamp().millisecondsSinceEpoch);

  int _version;
  Uint8List _nonce;
  final Uint8List _parentCaveatId;
  Uint8List _keyId;
  GeneratedMessage? _issuer;
  final List<corksv1.Caveat> _caveats = <corksv1.Caveat>[];
  Int64 _issuedAt;
  Int64? _notAfter;
  final Uint8List _rootKey;

  /// Overrides the discharge version (useful for tests or migrations).
  set version(int value) {
    _version = value;
  }

  /// Overrides the randomly generated nonce. The nonce must be [nonceSize] bytes.
  set nonce(Uint8List value) {
    if (value.length != nonceSize) {
      throw InvalidCorkException('nonce must be $nonceSize bytes');
    }
    _nonce = Uint8List.fromList(value);
  }

  /// Sets the key identifier embedded in the discharge.
  set keyId(Uint8List value) {
    if (value.isEmpty) {
      throw const InvalidCorkException('keyId missing');
    }
    _keyId = Uint8List.fromList(value);
  }

  /// Sets the issuer of the discharge.
  set issuer(GeneratedMessage? message) {
    _issuer = message?.deepCopy();
  }

  /// Overrides the issuance timestamp.
  set issuedAt(DateTime value) {
    _issuedAt = Int64(value.toUtc().millisecondsSinceEpoch);
  }

  /// Overrides or clears the expiry timestamp.
  set notAfter(DateTime? value) {
    final millis = value?.toUtc().millisecondsSinceEpoch;
    _notAfter = millis == null ? null : Int64(millis);
  }

  /// Adds a raw caveat to the discharge.
  void addCaveat(corksv1.Caveat caveat) {
    _caveats.add(caveat.deepCopy());
  }

  /// Appends a first-party caveat scoped to this third-party issuer.
  void appendFirstPartyCaveat({
    required String namespace,
    required String predicate,
    GeneratedMessage? payload,
  }) {
    if (namespace.isEmpty) {
      throw const InvalidCorkException('caveat namespace must be set');
    }
    if (predicate.isEmpty) {
      throw const InvalidCorkException('caveat predicate must be set');
    }
    final body = corksv1.FirstPartyCaveat(
      namespace: namespace,
      predicate: predicate,
    );
    if (payload != null) {
      body.payload = payload.packIntoAny();
    }
    final caveat = corksv1.Caveat(
      caveatVersion: _defaultCaveatVersion,
      caveatId: secureRandomBytes(16),
      firstParty: body,
    );
    addCaveat(caveat);
  }

  void _validate() {
    final missing = <String>[];
    if (_version == 0) {
      missing.add('version');
    }
    if (_nonce.length != nonceSize) {
      missing.add('nonce');
    }
    if (_parentCaveatId.isEmpty) {
      missing.add('parentCaveatId');
    }
    if (_keyId.isEmpty) {
      missing.add('keyId');
    }
    if (_rootKey.length != tagSize) {
      missing.add('rootKey');
    }
    if (_issuedAt == Int64.ZERO) {
      missing.add('issuedAt');
    }
    if (missing.isNotEmpty) {
      throw InvalidCorkException('missing ${missing.join(', ')}');
    }
  }

  corksv1.Discharge _buildProto() {
    _validate();
    final discharge = corksv1.Discharge(
      version: _version,
      nonce: Uint8List.fromList(_nonce),
      keyId: Uint8List.fromList(_keyId),
      parentCaveatId: Uint8List.fromList(_parentCaveatId),
      issuedAt: _issuedAt,
    );
    if (_issuer != null) {
      discharge.issuer = _issuer!.packIntoAny();
    }
    discharge.caveats.addAll(_caveats.map((c) => c.deepCopy()));
    if (_notAfter != null) {
      discharge.notAfter = _notAfter!;
    }
    return discharge;
  }

  /// Emits a signed discharge token.
  Discharge build() {
    final message = _buildProto();
    message.tailSignature = computeDischargeTailSignature(
      message: message,
      caveatRootKey: _rootKey,
    );
    return Discharge._(message);
  }
}

/// Computes the chained MAC for a discharge message using the derived caveat root key.
Uint8List computeDischargeTailSignature({
  required corksv1.Discharge message,
  required Uint8List caveatRootKey,
}) {
  if (message.version == 0) {
    throw const InvalidCorkException('discharge version not set');
  }
  if (message.nonce.length != nonceSize) {
    throw InvalidCorkException('nonce must be $nonceSize bytes');
  }
  if (message.keyId.isEmpty) {
    throw const InvalidCorkException('keyId missing');
  }
  if (caveatRootKey.length != tagSize) {
    throw InvalidCorkException('derived key must be $tagSize bytes');
  }

  var tag = hmacSha256(caveatRootKey, utf8.encode(macContext));
  tag = hmacSha256(tag, encodeUint32(message.version));
  tag = hmacSha256(tag, Uint8List.fromList(message.nonce));
  tag = hmacSha256(tag, Uint8List.fromList(message.keyId));
  tag = _hashAny(tag, message.hasIssuer() ? message.issuer : null);
  for (final caveat in message.caveats) {
    tag = hmacSha256(tag, Uint8List.fromList(caveat.writeToBuffer()));
  }
  tag = hmacSha256(tag, encodeUint64(message.issuedAt));
  tag = hmacSha256(tag, encodeUint64(message.notAfter));
  return tag;
}

Uint8List _hashAny(Uint8List tag, anypb.Any? any) {
  if (any == null || any.value.isEmpty) {
    return tag;
  }
  return hmacSha256(tag, Uint8List.fromList(any.writeToBuffer()));
}
