/// Crypto utilities shared across cork implementations.
library;

import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:crypto/crypto.dart' as crypto;
import 'package:cryptography/cryptography.dart';
import 'package:fixnum/fixnum.dart';

import 'exceptions.dart';
import 'proto/celest/corks/v1/cork.pb.dart' as corksv1;
import 'proto/google/protobuf/any.pb.dart' as anypb;
import 'signer.dart';

const int nonceSize = 24;
const String macContext = 'celest:cork:v1';
const int tagSize = 32;
final Int64 _byteMask = Int64(0xff);
final Random _random = Random.secure();

/// Fills a [Uint8List] with secure random data of [length] bytes.
Uint8List secureRandomBytes(int length) {
  final bytes = Uint8List(length);
  for (var i = 0; i < bytes.length; i++) {
    bytes[i] = _random.nextInt(256);
  }
  return bytes;
}

Uint8List hmacSha256(List<int> key, List<int> data) {
  final hmac = crypto.Hmac(crypto.sha256, key);
  return Uint8List.fromList(hmac.convert(data).bytes);
}

Uint8List encodeUint32(int value) {
  const int uint32Length = 4;
  final data = ByteData(uint32Length);
  data.setUint32(0, value, Endian.big);
  return data.buffer.asUint8List();
}

Uint8List encodeUint64(Int64 value) {
  // Manual big-endian packing keeps dart2js compatibility
  // (ByteData.setUint64 isn't supported).
  final bytes = Uint8List(8);
  var current = value.toUnsigned(64);
  for (var i = 7; i >= 0; i--) {
    bytes[i] = (current & _byteMask).toInt();
    current = current >> 8;
  }
  return bytes;
}

bool bytesEqual(List<int> a, List<int> b) {
  if (identical(a, b)) {
    return true;
  }
  if (a.length != b.length) {
    return false;
  }
  for (var i = 0; i < a.length; i++) {
    if (a[i] != b[i]) {
      return false;
    }
  }
  return true;
}

bool constantTimeEquals(List<int> a, List<int> b) {
  if (a.length != b.length) {
    return false;
  }
  var diff = 0;
  for (var i = 0; i < a.length; i++) {
    diff |= a[i] ^ b[i];
  }
  return diff == 0;
}

Future<Uint8List> computeTailSignature(
  corksv1.Cork message,
  Signer signer,
) async {
  if (message.version == 0) {
    throw InvalidCorkException('cork version not set');
  }
  final nonce = Uint8List.fromList(message.nonce);
  if (nonce.length != nonceSize) {
    throw InvalidCorkException('nonce must be $nonceSize bytes');
  }
  final keyId = Uint8List.fromList(message.keyId);
  if (keyId.isEmpty) {
    throw InvalidCorkException('keyId missing');
  }
  final signerKeyId = signer.keyId;
  if (!constantTimeEquals(keyId, signerKeyId)) {
    throw InvalidCorkException('signer key id does not match cork');
  }
  final rootKey = await signer.deriveCorkRootKey(nonce: nonce, keyId: keyId);
  if (rootKey.length != tagSize) {
    throw InvalidCorkException('derived root key must be $tagSize bytes');
  }
  var tag = hmacSha256(rootKey, utf8.encode(macContext));

  tag = hmacSha256(tag, encodeUint32(message.version));
  tag = hmacSha256(tag, nonce);
  tag = hmacSha256(tag, keyId);

  tag = _hashAny(tag, message.hasIssuer() ? message.issuer : null);
  tag = _hashAny(tag, message.hasBearer() ? message.bearer : null);
  tag = _hashAny(tag, message.hasAudience() ? message.audience : null);
  tag = _hashAny(tag, message.hasClaims() ? message.claims : null);

  for (final caveat in message.caveats) {
    final encoded = caveat.writeToBuffer();
    tag = hmacSha256(tag, encoded);
  }

  tag = hmacSha256(tag, encodeUint64(message.issuedAt));
  tag = hmacSha256(tag, encodeUint64(message.notAfter));

  return tag;
}

Uint8List _hashAny(Uint8List tag, anypb.Any? message) {
  if (message == null) {
    return tag;
  }
  final encoded = message.writeToBuffer();
  return hmacSha256(tag, encoded);
}

/// Derives a caveat root key for third-party caveats using HKDF-SHA256.
Uint8List deriveCaveatRootKey({
  required Uint8List tag,
  required Uint8List caveatId,
  Uint8List? salt,
  int length = tagSize,
}) {
  if (tag.length != tagSize) {
    throw InvalidCorkException('tag must be $tagSize bytes');
  }
  if (length <= 0 || length > tagSize) {
    throw InvalidCorkException(
      'derived key length must be between 1 and $tagSize',
    );
  }
  final info = _buildAssociatedData(caveatId, salt);
  final okm = _hkdf(tag, info, length: length);
  return okm;
}

/// Encrypts a challenge payload for third-party caveats using ChaCha20-Poly1305.
Future<Uint8List> encryptChallenge({
  required Uint8List tag,
  required Uint8List caveatId,
  Uint8List? salt,
  required Uint8List derivedKey,
  Uint8List? nonce,
}) async {
  if (tag.length != tagSize) {
    throw InvalidCorkException('tag must be $tagSize bytes');
  }
  if (derivedKey.length != tagSize) {
    throw InvalidCorkException('derived key must be $tagSize bytes');
  }

  final cipher = Chacha20.poly1305Aead();
  final usedNonce = nonce != null
      ? Uint8List.fromList(nonce)
      : secureRandomBytes(cipher.nonceLength);
  if (usedNonce.length != cipher.nonceLength) {
    throw InvalidCorkException(
      'challenge nonce must be ${cipher.nonceLength} bytes',
    );
  }

  final secretKey = SecretKey(tag);
  final associatedData = _buildAssociatedData(caveatId, salt);
  final secretBox = await cipher.encrypt(
    derivedKey,
    secretKey: secretKey,
    nonce: usedNonce,
    aad: associatedData,
  );

  final macBytes = secretBox.mac.bytes;
  final combined = Uint8List(
    usedNonce.length + secretBox.cipherText.length + macBytes.length,
  );
  var offset = 0;
  combined.setRange(offset, offset + usedNonce.length, usedNonce);
  offset += usedNonce.length;
  combined.setRange(
    offset,
    offset + secretBox.cipherText.length,
    secretBox.cipherText,
  );
  offset += secretBox.cipherText.length;
  combined.setRange(offset, offset + macBytes.length, macBytes);
  return combined;
}

/// Decrypts a challenge payload, returning the embedded derived key.
Future<Uint8List> decryptChallenge({
  required Uint8List tag,
  required Uint8List caveatId,
  Uint8List? salt,
  required Uint8List challenge,
}) async {
  if (tag.length != tagSize) {
    throw InvalidCorkException('tag must be $tagSize bytes');
  }

  final cipher = Chacha20.poly1305Aead();
  final nonceLength = cipher.nonceLength;
  final macLength = cipher.macAlgorithm.macLength;
  if (challenge.length < nonceLength + macLength) {
    throw InvalidCorkException('challenge payload too short');
  }

  final nonce = challenge.sublist(0, nonceLength);
  final body = challenge.sublist(nonceLength);
  final cipherText = body.sublist(0, body.length - macLength);
  final macBytes = body.sublist(body.length - macLength);

  final secretKey = SecretKey(tag);
  final secretBox = SecretBox(cipherText, nonce: nonce, mac: Mac(macBytes));

  final associatedData = _buildAssociatedData(caveatId, salt);
  final plain = await cipher.decrypt(
    secretBox,
    secretKey: secretKey,
    aad: associatedData,
  );
  return Uint8List.fromList(plain);
}

Uint8List _buildAssociatedData(Uint8List caveatId, Uint8List? salt) {
  final totalLength = caveatId.length + (salt?.length ?? 0);
  final data = Uint8List(totalLength);
  data.setRange(0, caveatId.length, caveatId);
  if (salt != null && salt.isNotEmpty) {
    data.setRange(caveatId.length, totalLength, salt);
  }
  return data;
}

Uint8List _hkdf(Uint8List ikm, Uint8List info, {int length = tagSize}) {
  final prk = _hkdfExtract(Uint8List(0), ikm);
  final result = BytesBuilder(copy: false);
  var previous = Uint8List(0);
  var counter = 1;
  while (result.length < length) {
    final buffer = BytesBuilder(copy: false);
    if (previous.isNotEmpty) {
      buffer.add(previous);
    }
    buffer.add(info);
    buffer.add([counter]);
    previous = hmacSha256(prk, buffer.toBytes());
    result.add(previous);
    counter++;
  }
  final okm = result.toBytes();
  return Uint8List.fromList(okm.sublist(0, length));
}

Uint8List _hkdfExtract(Uint8List salt, Uint8List ikm) {
  final effectiveSalt = salt.isEmpty ? Uint8List(tagSize) : salt;
  return hmacSha256(effectiveSalt, ikm);
}
