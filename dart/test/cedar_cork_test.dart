import 'dart:convert';
import 'dart:typed_data';

import 'package:convert/convert.dart';
import 'package:corks_cedar/src/cork.dart';
import 'package:corks_cedar/src/crypto.dart';
import 'package:corks_cedar/src/exceptions.dart';
import 'package:corks_cedar/src/proto.dart';
import 'package:corks_cedar/src/proto/corks/v1/cork.pb.dart' as corksv1;
import 'package:corks_cedar/src/proto/google/protobuf/any.pb.dart' as anypb;
import 'package:corks_cedar/src/proto/google/protobuf/wrappers.pb.dart'
    as wrappers;
import 'package:corks_cedar/src/signer.dart';
import 'package:test/test.dart';

void main() {
  group('Cork', () {
    test('tail signature matches specification', () async {
      final keyId = utf8.encode('cork-key-0001');
      final masterKey = _hex(
        '00112233445566778899aabbccddeeff00112233445566778899aabbccddeeff',
      );

      final builder =
          CorkBuilder(keyId)
            ..nonce = _hex('000102030405060708090a0b0c0d0e0f1011121314151617')
            ..issuer = wrappers.StringValue(value: 'celest::issuer/auth')
            ..bearer = wrappers.StringValue(value: 'celest::principal/alice')
            ..audience = wrappers.StringValue(value: 'celest::service/hub')
            ..claims = wrappers.StringValue(value: 'session:abc123')
            ..issuedAt = DateTime.fromMillisecondsSinceEpoch(
              1_700_000_000 * 1000,
              isUtc: true,
            )
            ..notAfter = DateTime.fromMillisecondsSinceEpoch(
              (1_700_000_000 + 3600) * 1000,
              isUtc: true,
            )
            ..addCaveat(
              _firstPartyCaveat(
                _hex('0a0b0c0d0e0f10111213141516171819'),
                'celest.auth',
                'allow_all',
                wrappers.BoolValue(value: true),
              ),
            );

      final cork = builder.build();
      final signer = Signer(keyId, masterKey);
      final signed = await cork.sign(signer);

      expect(signed.tailSignature.isNotEmpty, isTrue);

      final expected = await computeTailSignature(signed.toProto(), signer);
      expect(signed.tailSignature, equals(expected));

      final token = signed.toString();
      expect(token.contains('='), isFalse);

      final decoded = Cork.parse(token);
      expect(decoded.encode(), equals(signed.encode()));
      await expectLater(decoded.verify(signer), completes);

      final tampered =
          signed.toProto().deepCopy()
            ..audience =
                wrappers.StringValue(
                  value: 'celest::service/analytics',
                ).packIntoAny();
      final tamperedCork = Cork.fromProto(tampered);
      await expectLater(
        tamperedCork.verify(signer),
        throwsA(isA<InvalidSignatureException>()),
      );

      final wrongKeySigner = Signer(
        Uint8List.fromList(utf8.encode('cork-key-0002')),
        masterKey,
      );
      await expectLater(
        signed.verify(wrongKeySigner),
        throwsA(
          isA<InvalidCorkException>().having(
            (e) => e.message,
            'message',
            contains('key id does not match'),
          ),
        ),
      );
    });

    test('builder validation', () {
      final builder =
          CorkBuilder(Uint8List(0))
            ..nonce = _hex('ffffffffffffffffffffffffffffffffffffffffffffffff')
            ..issuer = wrappers.StringValue(value: 'celest::issuer')
            ..bearer = wrappers.StringValue(value: 'celest::principal');

      expect(
        builder.validate,
        throwsA(
          isA<InvalidCorkException>().having(
            (e) => e.message,
            'message',
            contains('keyId'),
          ),
        ),
      );

      builder
        ..keyId = Uint8List.fromList(utf8.encode('validation-key'))
        ..addCaveat(corksv1.Caveat());

      expect(
        builder.validate,
        throwsA(
          isA<InvalidCorkException>().having(
            (e) => e.message,
            'message',
            allOf([isNot(contains('keyId')), contains('caveat[0].version')]),
          ),
        ),
      );

      final okBuilder =
          CorkBuilder(Uint8List.fromList(utf8.encode('validation-key')))
            ..nonce = _hex('0102030405060708090a0b0c0d0e0f101112131415161718')
            ..issuer = wrappers.StringValue(value: 'celest::issuer')
            ..bearer = wrappers.StringValue(value: 'celest::principal')
            ..addCaveat(
              _firstPartyCaveat(
                _hex('ffffffffffffffffffffffffffffffff'),
                'celest.auth',
                'allow_all',
                wrappers.BoolValue(value: true),
              ),
            )
            ..notAfter = DateTime.fromMillisecondsSinceEpoch(0, isUtc: true);

      expect(okBuilder.build, returnsNormally);
    });
  });
}

corksv1.Caveat _firstPartyCaveat(
  Uint8List id,
  String namespace,
  String predicate,
  wrappers.BoolValue payload,
) {
  return corksv1.Caveat()
    ..caveatVersion = 1
    ..caveatId = id
    ..firstParty = corksv1.FirstPartyCaveat(
      namespace: namespace,
      predicate: predicate,
      payload: payload.packIntoAny(),
    );
}

Uint8List _hex(String input) => hex.decoder.convert(input);
