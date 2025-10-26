import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';
import 'package:fixnum/fixnum.dart';

import 'cork.dart';
import 'crypto.dart';
import 'discharge_service.dart';
import 'exceptions.dart';
import 'proto/celest/corks/v1/cork.pb.dart' as corksv1;
import 'proto/google/protobuf/struct.pb.dart' as structpb;

/// Codec that wraps third-party tickets using a shared symmetric key.
///
/// The ticket payload is encrypted with ChaCha20-Poly1305 and embeds the
/// derived caveat root key, optional metadata, and an optional expiry bound.
/// This codec pairs with [ThirdPartyDischargeService] via [decoder].
final class SharedSecretTicketCodec {
  SharedSecretTicketCodec({
    required List<int> sharedSecret,
    Chacha20? algorithm,
  }) : _secretKey = SecretKey(List<int>.from(sharedSecret)),
       _cipher = algorithm ?? Chacha20.poly1305Aead() {
    if (sharedSecret.length != tagSize) {
      throw InvalidCorkException('shared secret must be $tagSize bytes');
    }
  }

  final SecretKey _secretKey;
  final Chacha20 _cipher;

  /// Nonce length used by the underlying AEAD.
  int get nonceLength => _cipher.nonceLength;

  /// Encrypts the derived key and metadata for inclusion in a cork ticket.
  Future<List<int>> encryptTicket({
    required Uint8List caveatId,
    required Uint8List caveatRootKey,
    Map<String, Object?> metadata = const <String, Object?>{},
    DateTime? notAfter,
  }) async {
    if (caveatRootKey.length != tagSize) {
      throw InvalidCorkException('caveat root key must be $tagSize bytes');
    }
    final envelope = corksv1.ThirdPartyTicket(
      caveatId: Uint8List.fromList(caveatId),
      caveatRootKey: Uint8List.fromList(caveatRootKey),
    );
    if (metadata.isNotEmpty) {
      envelope.metadata = _structFromMap(metadata);
    }
    if (notAfter != null && notAfter.millisecondsSinceEpoch != 0) {
      envelope.notAfter = Int64(notAfter.toUtc().millisecondsSinceEpoch);
    }

    final plain = envelope.writeToBuffer();
    final nonce = secureRandomBytes(_cipher.nonceLength);
    final secretBox = await _cipher.encrypt(
      plain,
      secretKey: _secretKey,
      nonce: nonce,
    );

    final macBytes = secretBox.mac.bytes;
    final combinedLength =
        nonce.length + secretBox.cipherText.length + macBytes.length;
    final ticket = Uint8List(combinedLength);
    var offset = 0;
    ticket.setRange(offset, offset + nonce.length, nonce);
    offset += nonce.length;
    ticket.setRange(
      offset,
      offset + secretBox.cipherText.length,
      secretBox.cipherText,
    );
    offset += secretBox.cipherText.length;
    ticket.setRange(offset, offset + macBytes.length, macBytes);
    return ticket;
  }

  /// Returns a decoder suitable for [ThirdPartyDischargeService].
  DischargeTicketDecoder get decoder =>
      (ticket) => decode(ticket);

  /// Decrypts a ticket emitted by [encryptTicket].
  Future<DecodedDischargeTicket> decode(List<int> ticket) async {
    final payload = Uint8List.fromList(ticket);
    final nonceLength = _cipher.nonceLength;
    final macLength = _cipher.macAlgorithm.macLength;
    if (payload.length < nonceLength + macLength + 1) {
      throw const InvalidCorkException('ticket payload too short');
    }

    final nonce = payload.sublist(0, nonceLength);
    final body = payload.sublist(nonceLength);
    final cipherText = body.sublist(0, body.length - macLength);
    final macBytes = body.sublist(body.length - macLength);

    final secretBox = SecretBox(cipherText, nonce: nonce, mac: Mac(macBytes));
    final plain = await _cipher.decrypt(secretBox, secretKey: _secretKey);
    final envelope = corksv1.ThirdPartyTicket.fromBuffer(plain);

    if (!envelope.hasCaveatId() || envelope.caveatId.isEmpty) {
      throw const InvalidCorkException('ticket missing caveat id');
    }
    if (!envelope.hasCaveatRootKey() || envelope.caveatRootKey.isEmpty) {
      throw const InvalidCorkException('ticket missing caveat root key');
    }

    DateTime? expiry;
    if (envelope.hasNotAfter() && envelope.notAfter != 0) {
      expiry = DateTime.fromMillisecondsSinceEpoch(
        envelope.notAfter.toInt(),
        isUtc: true,
      );
    }

    final metadata = envelope.hasMetadata()
        ? _structToMap(envelope.metadata)
        : const <String, Object?>{};

    return DecodedDischargeTicket(
      caveatId: envelope.caveatId,
      caveatRootKey: envelope.caveatRootKey,
      notAfter: expiry,
      metadata: metadata,
    );
  }

  /// Convenience helper that wraps [ThirdPartyCaveatOptions] creation.
  ThirdPartyCaveatOptions createOptions({
    required String location,
    required List<int> tag,
    Map<String, Object?> metadata = const <String, Object?>{},
    DateTime? notAfter,
    List<int>? salt,
    List<int>? caveatId,
    List<int>? challengeNonce,
  }) {
    return ThirdPartyCaveatOptions(
      location: location,
      tag: tag,
      salt: salt,
      caveatId: caveatId,
      challengeNonce: challengeNonce,
      encryptTicket: (id, rootKey) => encryptTicket(
        caveatId: id,
        caveatRootKey: rootKey,
        metadata: metadata,
        notAfter: notAfter,
      ),
    );
  }
}

structpb.Struct _structFromMap(Map<String, Object?> map) {
  final struct = structpb.Struct();
  map.forEach((key, value) {
    struct.fields[key] = _valueFromObject(value);
  });
  return struct;
}

structpb.Value _valueFromObject(Object? value) {
  final result = structpb.Value();
  if (value == null) {
    result.nullValue = structpb.NullValue.NULL_VALUE;
  } else if (value is bool) {
    result.boolValue = value;
  } else if (value is num) {
    result.numberValue = value.toDouble();
  } else if (value is String) {
    result.stringValue = value;
  } else if (value is Map<String, Object?>) {
    result.structValue = _structFromMap(value);
  } else if (value is Iterable<Object?>) {
    final list = structpb.ListValue();
    for (final entry in value) {
      list.values.add(_valueFromObject(entry));
    }
    result.listValue = list;
  } else {
    throw ArgumentError('Unsupported metadata value: ${value.runtimeType}');
  }
  return result;
}

Map<String, Object?> _structToMap(structpb.Struct struct) {
  final map = <String, Object?>{};
  struct.fields.forEach((key, value) {
    map[key] = _objectFromValue(value);
  });
  return map;
}

Object? _objectFromValue(structpb.Value value) {
  switch (value.whichKind()) {
    case structpb.Value_Kind.boolValue:
      return value.boolValue;
    case structpb.Value_Kind.listValue:
      return [
        for (final entry in value.listValue.values) _objectFromValue(entry),
      ];
    case structpb.Value_Kind.nullValue:
      return null;
    case structpb.Value_Kind.numberValue:
      final number = value.numberValue;
      if (number == number.truncateToDouble()) {
        return number.toInt();
      }
      return number;
    case structpb.Value_Kind.stringValue:
      return value.stringValue;
    case structpb.Value_Kind.structValue:
      return _structToMap(value.structValue);
    case structpb.Value_Kind.notSet:
      return null;
  }
}
