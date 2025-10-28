import 'dart:typed_data';

import 'package:corks_cedar/corks_cedar.dart';
import 'package:corks_cedar/src/crypto.dart';
import 'package:corks_cedar/src/proto/google/protobuf/wrappers.pb.dart'
    as wrappers;
import 'package:test/test.dart';

void main() {
  group('SharedSecretTicketCodec', () {
    test('encrypts and decodes tickets with metadata', () async {
      final secret = Uint8List.fromList(List<int>.generate(tagSize, (i) => i));
      final codec = SharedSecretTicketCodec(sharedSecret: secret);
      final caveatId = Uint8List.fromList(List<int>.filled(16, 1));
      final rootKey = Uint8List.fromList(List<int>.filled(tagSize, 2));

      final ticket = await codec.encryptTicket(
        caveatId: caveatId,
        caveatRootKey: rootKey,
        metadata: {
          'session_id': 'sess-123',
          'actors': ['alice', 'bob'],
          'claims': {'device': 'ios', 'confidence': 0.9},
          'count': 1,
          'active': true,
          'maybe': null,
        },
        notAfter: DateTime.utc(2030, 1, 1),
      );

      final decoded = await codec.decode(ticket);
      expect(decoded.caveatId, equals(caveatId));
      expect(decoded.caveatRootKey, equals(rootKey));
      expect(decoded.metadata['session_id'], 'sess-123');
      expect(decoded.metadata['actors'], ['alice', 'bob']);
      final claims = decoded.metadata['claims'] as Map<String, Object?>;
      expect(claims['device'], 'ios');
      expect(claims['confidence'], closeTo(0.9, 1e-9));
      expect(decoded.metadata['count'], 1);
      expect(decoded.metadata['active'], isTrue);
      expect(decoded.metadata['maybe'], isNull);
      expect(decoded.notAfter, DateTime.utc(2030, 1, 1));
    });

    test('createOptions integrates with cork builder', () async {
      final secret = Uint8List.fromList(
        List<int>.generate(tagSize, (i) => 0x10 + i),
      );
      final codec = SharedSecretTicketCodec(sharedSecret: secret);
      final keyId = Uint8List.fromList(List<int>.filled(16, 3));
      final builder = Cork.builder(keyId)
        ..issuer = wrappers.StringValue(value: 'celest::service')
        ..bearer = wrappers.StringValue(value: 'celest::session');

      final options = codec.createOptions(
        location: 'https://third-party.example/discharge',
        tag: Uint8List.fromList(List<int>.filled(tagSize, 0xAA)),
        metadata: {'scope': 'sso'},
        notAfter: DateTime.utc(2035, 5, 5),
      );

      await builder.appendThirdPartyCaveat(options);
      final cork = builder.build();
      expect(cork.caveats, hasLength(1));

      final thirdParty = cork.caveats.single.thirdParty;
      final decoded = await codec.decode(thirdParty.ticket);
      expect(decoded.metadata['scope'], 'sso');
      expect(decoded.notAfter, DateTime.utc(2035, 5, 5));
      expect(decoded.caveatId, cork.caveats.single.caveatId);
    });
  });
}
