import 'dart:typed_data';

import 'package:corks_cedar/corks_cedar.dart';
import 'package:corks_cedar/src/crypto.dart';
import 'package:corks_cedar/src/proto/google/protobuf/wrappers.pb.dart'
    as wrappers;
import 'package:cryptography/cryptography.dart';
import 'package:test/test.dart';

void main() {
  group('Third-party caveats', () {
    test('appendThirdPartyCaveat encrypts challenge and ticket', () async {
      final builder = CorkBuilder(
        Uint8List.fromList(List<int>.generate(16, (i) => i)),
      );
      builder
        ..issuer = wrappers.StringValue(value: 'celest::issuer')
        ..bearer = wrappers.StringValue(value: 'celest::bearer');

      final tag = Uint8List.fromList(List<int>.filled(32, 0xAB));
      final salt = Uint8List.fromList(const [0x10, 0x11, 0x12]);
      final nonceLength = Chacha20.poly1305Aead().nonceLength;
      final nonce = Uint8List.fromList(List<int>.filled(nonceLength, 0x22));

      Uint8List? capturedId;
      Uint8List? capturedKey;
      final opts = ThirdPartyCaveatOptions(
        location: 'https://discharge.celest.dev',
        tag: tag,
        salt: salt,
        challengeNonce: nonce,
        encryptTicket: (caveatId, derivedKey) {
          capturedId = Uint8List.fromList(caveatId);
          capturedKey = Uint8List.fromList(derivedKey);
          final payload = Uint8List(7 + derivedKey.length)
            ..setAll(0, 'ticket:'.codeUnits)
            ..setAll(7, derivedKey);
          return payload;
        },
      );

      await builder.appendThirdPartyCaveat(opts);
      expect(capturedId, isNotNull);
      expect(capturedKey, isNotNull);
      expect(capturedId!.length, 16);

      final expectedDerived = deriveCaveatRootKey(
        tag: tag,
        caveatId: capturedId!,
        salt: salt,
      );
      expect(capturedKey, equals(expectedDerived));

      final cork = builder.build();
      final proto = cork.toProto();
      expect(proto.caveats, hasLength(1));

      final caveat = proto.caveats.first;
      final thirdParty = caveat.thirdParty;
      expect(thirdParty.location, opts.location);
      expect(thirdParty.ticket.sublist(0, 7), 'ticket:'.codeUnits);
      expect(thirdParty.ticket.sublist(7), expectedDerived);
      expect(thirdParty.salt, equals(salt));
      expect(thirdParty.challenge.sublist(0, nonceLength), equals(nonce));

      final recovered = await decryptChallenge(
        tag: tag,
        caveatId: capturedId!,
        salt: salt,
        challenge: Uint8List.fromList(thirdParty.challenge),
      );
      expect(recovered, equals(expectedDerived));
    });

    test('appendThirdPartyCaveat validates input', () async {
      ThirdPartyCaveatOptions baseOptions({
        String? location,
        List<int>? tag,
        List<int>? caveatId,
        List<int>? nonce,
        ThirdPartyTicketEncrypter? encryptTicket,
        List<int>? salt,
      }) {
        return ThirdPartyCaveatOptions(
          location: location ?? 'https://service',
          tag: tag ?? List<int>.filled(32, 0x01),
          caveatId: caveatId ?? List<int>.filled(16, 0x02),
          challengeNonce:
              nonce ??
              List<int>.filled(Chacha20.poly1305Aead().nonceLength, 0x03),
          salt: salt,
          encryptTicket:
              encryptTicket ??
              (id, key) => Uint8List.fromList(const [0xAA, 0xBB]),
        );
      }

      Future<CorkBuilder> callAppend(ThirdPartyCaveatOptions opts) async {
        final builder = CorkBuilder(Uint8List(16))
          ..issuer = wrappers.StringValue(value: 'issuer')
          ..bearer = wrappers.StringValue(value: 'bearer');
        return builder.appendThirdPartyCaveat(opts);
      }

      await expectLater(
        callAppend(baseOptions(location: '')),
        throwsA(
          isA<InvalidCorkException>().having(
            (e) => e.message,
            'message',
            contains('location'),
          ),
        ),
      );

      await expectLater(
        callAppend(baseOptions(tag: const [0x01])),
        throwsA(
          isA<InvalidCorkException>().having(
            (e) => e.message,
            'message',
            contains('tag must be 32 bytes'),
          ),
        ),
      );

      await expectLater(
        callAppend(baseOptions(encryptTicket: (id, key) => Uint8List(0))),
        throwsA(
          isA<InvalidCorkException>().having(
            (e) => e.message,
            'message',
            contains('encrypted ticket must not be empty'),
          ),
        ),
      );

      await expectLater(
        callAppend(
          baseOptions(
            encryptTicket: (id, key) =>
                Future<List<int>>.error(StateError('boom')),
          ),
        ),
        throwsA(isA<StateError>().having((e) => e.message, 'message', 'boom')),
      );

      await expectLater(
        callAppend(
          baseOptions(
            nonce: List<int>.filled(
              Chacha20.poly1305Aead().nonceLength + 1,
              0x04,
            ),
          ),
        ),
        throwsA(
          isA<InvalidCorkException>().having(
            (e) => e.message,
            'message',
            contains('challenge nonce must'),
          ),
        ),
      );
    });
  });
}
