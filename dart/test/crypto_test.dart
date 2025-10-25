import 'dart:typed_data';

import 'package:corks_cedar/src/crypto.dart';
import 'package:corks_cedar/src/exceptions.dart';
import 'package:crypto/crypto.dart' as crypto;
import 'package:cryptography/cryptography.dart';
import 'package:test/test.dart';

void main() {
  group('deriveCaveatRootKey', () {
    test('matches HKDF-SHA256 reference implementation with salt', () {
      final tag = Uint8List.fromList(List<int>.generate(32, (i) => i));
      final caveatId = Uint8List.fromList(
        List<int>.generate(24, (i) => 255 - i),
      );
      final salt = Uint8List.fromList(
        List<int>.generate(8, (i) => i * 3 % 256),
      );

      final actual = deriveCaveatRootKey(
        tag: tag,
        caveatId: caveatId,
        salt: salt,
        length: 16,
      );
      final expected = _hkdfSha256(
        ikm: tag,
        info: _associatedData(caveatId, salt),
        length: 16,
      );

      expect(actual, expected);
    });

    test('matches HKDF-SHA256 reference implementation without salt', () {
      final tag = Uint8List.fromList(
        List<int>.generate(32, (i) => (i * 7) % 256),
      );
      final caveatId = Uint8List.fromList(List<int>.filled(12, 0xAA));

      final actual = deriveCaveatRootKey(
        tag: tag,
        caveatId: caveatId,
        length: 32,
      );
      final expected = _hkdfSha256(
        ikm: tag,
        info: _associatedData(caveatId, null),
        length: 32,
      );

      expect(actual, expected);
    });

    test('throws when tag length is invalid', () {
      final shortTag = Uint8List(16);
      final caveatId = Uint8List.fromList([1, 2, 3]);

      expect(
        () =>
            deriveCaveatRootKey(tag: shortTag, caveatId: caveatId, length: 16),
        throwsA(isA<InvalidCorkException>()),
      );
    });

    test('throws when requested key length is out of range', () {
      final tag = Uint8List.fromList(List<int>.generate(32, (i) => i));
      final caveatId = Uint8List.fromList([4, 5, 6]);

      expect(
        () => deriveCaveatRootKey(tag: tag, caveatId: caveatId, length: 0),
        throwsA(isA<InvalidCorkException>()),
      );
      expect(
        () => deriveCaveatRootKey(tag: tag, caveatId: caveatId, length: 33),
        throwsA(isA<InvalidCorkException>()),
      );
    });
  });

  group('challenge encryption', () {
    late Uint8List tag;
    late Uint8List caveatId;
    late Uint8List salt;
    late Uint8List derivedKey;
    late Uint8List nonce;

    setUp(() {
      tag = Uint8List.fromList(List<int>.generate(32, (i) => (i * 11) % 256));
      caveatId = Uint8List.fromList(List<int>.generate(16, (i) => i * i % 256));
      salt = Uint8List.fromList(List<int>.generate(4, (i) => 0xF0 + i));
      derivedKey = Uint8List.fromList(List<int>.generate(32, (i) => 255 - i));
      nonce = Uint8List.fromList(
        List<int>.generate(Chacha20.poly1305Aead().nonceLength, (i) => i + 1),
      );
    });

    test('encrypts and decrypts challenge round trip', () async {
      final challenge = await encryptChallenge(
        tag: tag,
        caveatId: caveatId,
        salt: salt,
        derivedKey: derivedKey,
        nonce: nonce,
      );

      expect(challenge.length, nonce.length + derivedKey.length + 16);

      final recovered = await decryptChallenge(
        tag: tag,
        caveatId: caveatId,
        salt: salt,
        challenge: challenge,
      );

      expect(recovered, derivedKey);
    });

    test('decrypt fails when payload is tampered', () async {
      final challenge = await encryptChallenge(
        tag: tag,
        caveatId: caveatId,
        salt: salt,
        derivedKey: derivedKey,
        nonce: nonce,
      );
      challenge[challenge.length - 5] ^= 0xFF;

      await expectLater(
        decryptChallenge(
          tag: tag,
          caveatId: caveatId,
          salt: salt,
          challenge: challenge,
        ),
        throwsA(isA<SecretBoxAuthenticationError>()),
      );
    });

    test('encryptChallenge validates tag and derived key length', () async {
      final shortTag = Uint8List(31);
      final shortKey = Uint8List(16);

      await expectLater(
        encryptChallenge(
          tag: shortTag,
          caveatId: caveatId,
          salt: salt,
          derivedKey: derivedKey,
          nonce: nonce,
        ),
        throwsA(isA<InvalidCorkException>()),
      );

      await expectLater(
        encryptChallenge(
          tag: tag,
          caveatId: caveatId,
          salt: salt,
          derivedKey: shortKey,
          nonce: nonce,
        ),
        throwsA(isA<InvalidCorkException>()),
      );
    });

    test('encryptChallenge validates nonce length', () async {
      final nonceLength = Chacha20.poly1305Aead().nonceLength;
      final badNonce = Uint8List.fromList(
        List<int>.generate(nonceLength + 1, (i) => i),
      );

      await expectLater(
        encryptChallenge(
          tag: tag,
          caveatId: caveatId,
          salt: salt,
          derivedKey: derivedKey,
          nonce: badNonce,
        ),
        throwsA(isA<InvalidCorkException>()),
      );
    });

    test('decryptChallenge validates tag and payload length', () async {
      final shortTag = Uint8List(30);
      final cipher = Chacha20.poly1305Aead();
      final tooShort = Uint8List(
        cipher.nonceLength + cipher.macAlgorithm.macLength - 1,
      );

      await expectLater(
        decryptChallenge(
          tag: shortTag,
          caveatId: caveatId,
          salt: salt,
          challenge: derivedKey,
        ),
        throwsA(isA<InvalidCorkException>()),
      );

      await expectLater(
        decryptChallenge(
          tag: tag,
          caveatId: caveatId,
          salt: salt,
          challenge: tooShort,
        ),
        throwsA(isA<InvalidCorkException>()),
      );
    });
  });
}

Uint8List _hkdfSha256({
  required Uint8List ikm,
  required Uint8List info,
  required int length,
}) {
  final prk = _hmacSha256(Uint8List(32), ikm);
  final result = BytesBuilder(copy: false);
  var previous = Uint8List(0);
  var counter = 1;

  while (result.length < length) {
    final buffer =
        BytesBuilder(copy: false)
          ..add(previous)
          ..add(info)
          ..addByte(counter);
    previous = _hmacSha256(prk, buffer.toBytes());
    result.add(previous);
    counter++;
  }

  return Uint8List.fromList(result.takeBytes().sublist(0, length));
}

Uint8List _associatedData(Uint8List caveatId, Uint8List? salt) {
  final data = BytesBuilder(copy: false)..add(caveatId);
  if (salt != null && salt.isNotEmpty) {
    data.add(salt);
  }
  return Uint8List.fromList(data.takeBytes());
}

Uint8List _hmacSha256(Uint8List key, Uint8List data) {
  final hmac = crypto.Hmac(crypto.sha256, key);
  return Uint8List.fromList(hmac.convert(data).bytes);
}
