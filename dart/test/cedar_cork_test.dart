import 'dart:math';
import 'dart:typed_data';

import 'package:cedar/cedar.dart';
import 'package:corks_cedar/corks_cedar.dart';
import 'package:test/test.dart';

final random = Random.secure();
Uint8List get secretKey {
  const size = 32;
  final key = Uint8List(size);
  for (var i = 0; i < size; i++) {
    key[i] = random.nextInt(256);
  }
  return key;
}

extension on String {
  Uint8List get bytes => Uint8List.fromList(codeUnits);
}

typedef _TestCase = ({
  String description,
  CorkBuilder Function() create,
  Matcher? expectError,
});

final aId = 'a'.bytes;
final aKey = secretKey;
final bId = 'b'.bytes;
final bKey = secretKey;
final issuer = CedarEntityId('Organization', 'acme-corp');
final bearer = CedarEntityId('User', 'alice');

final _caveat = JsonExpr.equals(
  JsonExpr.getAttribute(
    JsonExpr.variable(CedarVariable.principal),
    'name',
  ),
  JsonExpr.value(
    CedarValueJson.string('Alice'),
  ),
);

final _tests = <_TestCase>[
  (
    description: 'empty',
    create: () => CedarCork.builder(),
    expectError: throwsInvalidCork,
  ),
  (
    description: 'missing issuer',
    create: () => CedarCork.builder()..bearer = CedarEntityId('User', 'alice'),
    expectError: throwsInvalidCork,
  ),
  (
    description: 'missing bearer',
    create: () => CedarCork.builder()
      ..issuer = CedarEntityId('Organization', 'acme-corp'),
    expectError: throwsInvalidCork,
  ),
  (
    description: 'valid minimal',
    create: () => CedarCork.builder(aId)
      ..issuer = CedarEntityId('Organization', 'acme-corp')
      ..bearer = CedarEntityId('User', 'alice'),
    expectError: null,
  ),
  (
    description: 'valid full',
    create: () => CedarCork.builder(aId)
      ..issuer = issuer
      ..bearer = bearer
      ..audience = issuer
      ..claims = CedarEntity(
        id: bearer,
        parents: [issuer],
        attributes: {
          'name': CedarValueJson.string('Alice'),
          'email': CedarValueJson.string('alice@acme.com'),
        },
      )
      ..addCaveat(_caveat),
    expectError: null,
  ),
];

final throwsInvalidCork = throwsA(isA<InvalidCorkException>());
final throwsInvalidSignature = throwsA(isA<InvalidSignatureException>());
final throwsMismatchedKey = throwsA(isA<MismatchedKeyError>());
final throwsMissingSignature = throwsA(isA<MissingSignatureError>());

void main() {
  group('Cork', () {
    final signer = Signer(aId, aKey);

    for (final t in _tests) {
      group(t.description, () {
        test('builder', () {
          final builder = t.create();
          expect(builder.build, t.expectError ?? returnsNormally);
        });

        if (t.expectError == null) {
          test('sign/verify', () async {
            final cork = t.create().build();
            await expectLater(
              reason: 'Cannot verify an unsigned cork',
              () => cork.verify(signer),
              throwsMissingSignature,
            );
            final signed = await cork.sign(signer);

            await expectLater(signed.verify(signer), completes);
            await expectLater(
              signed.verify(signer),
              completes,
              reason: 'A signer should not depend on internal state',
            );
            await expectLater(
              signed.verify(Signer(aId, aKey)),
              completes,
              reason: 'A signer should not depend on internal state',
            );

            final invalidKeypairs = [
              (bId, bKey, throwsMismatchedKey),
              (aId, bKey, throwsInvalidSignature),
              (bId, aKey, throwsMismatchedKey),
            ];

            for (final (id, key, throwsError) in invalidKeypairs) {
              await expectLater(
                () => signed.verify(Signer(id, key)),
                throwsError,
                reason: 'Mismatched key should fail verification',
              );
            }
          });

          test('encode/decode', () async {
            final cork = await t.create().build().sign(signer);

            expect(cork.toProto(), equals(cork.toProto()));
            expect(
              Cork.fromProto(cork.toProto()).toProto(),
              equals(cork.toProto()),
            );

            final encoded = cork.toString();
            final decoded = Cork.parse(encoded);
            expect(decoded.toProto(), equals(cork.toProto()));

            await expectLater(decoded.verify(signer), completes);
          });
        }
      });
    }
  });
}
