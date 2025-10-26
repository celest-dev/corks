import 'dart:typed_data';

import 'package:corks_cedar/corks_cedar.dart';
import 'package:corks_cedar/src/proto/celest/corks/v1/cork.pb.dart' as corksv1;
import 'package:corks_cedar/src/proto/google/protobuf/wrappers.pb.dart'
    as wrappers;
import 'package:fixnum/fixnum.dart';
import 'package:test/test.dart';

void main() {
  group('third-party discharge integration', () {
    test('client obtains and verifies discharge from service', () async {
      final sharedSecret = Uint8List.fromList(
        List<int>.generate(32, (index) => 0x40 + index),
      );
      final codec = SharedSecretTicketCodec(sharedSecret: sharedSecret);

      final serviceKeyId = Uint8List.fromList(
        List<int>.generate(16, (index) => 0xA0 + index),
      );
      final serviceIssuer =
          wrappers.StringValue(value: 'celest::third-party::integration');

      Map<String, Object?>? transportMetadata;
      Map<String, Object?>? serviceMetadata;
      Map<String, Object?>? decodedTicketMetadata;
      var issueCount = 0;

      final service = ThirdPartyDischargeService(
        decoder: codec.decoder,
        issuer: serviceIssuer,
        keyId: serviceKeyId,
        now: () => DateTime.utc(2025, 3, 1, 10),
        onBuild: (builder, decoded, request) {
          serviceMetadata = request.metadata;
          decodedTicketMetadata = decoded.metadata;

          final sessionId = decoded.metadata['session_id'] as String?;
          final sessionVersion = decoded.metadata['session_version'] as int?;
          expect(sessionId, isNotNull);
          expect(sessionVersion, isNotNull);

          final state = corksv1.SessionState()
            ..sessionId = sessionId!
            ..version = Int64(sessionVersion!);
          builder.appendFirstPartyCaveat(
            namespace: 'celest.auth',
            predicate: 'session_state',
            payload: state,
          );
        },
      );

      final client = ThirdPartyDischargeClient(
        transport: (uri, ticket, metadata, caveat) async {
          issueCount++;
          expect(uri.toString(), equals('https://third-party.example/sso'));
          transportMetadata = metadata;

          return service.issue(
            ThirdPartyDischargeRequest(
              ticket: ticket,
              metadata: metadata,
            ),
          );
        },
        cacheTtl: const Duration(minutes: 15),
        now: () => DateTime.utc(2025, 3, 1, 9, 45),
      );

      final corkBuilder = CorkBuilder(
        Uint8List.fromList(List<int>.generate(16, (index) => index + 1)),
      )
        ..issuer = wrappers.StringValue(value: 'celest::issuer::demo')
        ..bearer = wrappers.StringValue(value: 'users/alice')
        ..notAfter = DateTime.utc(2025, 3, 1, 12);

      final ticketExpiry = DateTime.utc(2025, 3, 1, 11);
      final options = codec.createOptions(
        location: 'https://third-party.example/sso',
        tag: List<int>.generate(32, (index) => 0x80 + index),
        metadata: {
          'session_id': 'sess-123',
          'session_version': 7,
        },
        notAfter: ticketExpiry,
      );

      await corkBuilder.appendThirdPartyCaveat(options);
      final cork = corkBuilder.build();

      final discharges = await client.fetchDischarges(
        cork,
        metadata: {'ip_address': '203.0.113.5'},
      );

      expect(issueCount, equals(1));
      expect(discharges, hasLength(1));

      final entry = discharges.entries.single;
      final thirdPartyCaveat =
          cork.caveats.singleWhere((caveat) => caveat.hasThirdParty());
      final decodedTicket =
          await codec.decode(thirdPartyCaveat.thirdParty.ticket);

      final discharge = entry.value;
      discharge.verify(caveatRootKey: decodedTicket.caveatRootKey);

      expect(transportMetadata, equals({'ip_address': '203.0.113.5'}));
      expect(serviceMetadata, equals({'ip_address': '203.0.113.5'}));
      expect(
        decodedTicketMetadata,
        equals({'session_id': 'sess-123', 'session_version': 7}),
      );
      expect(
        decodedTicket.notAfter,
        equals(ticketExpiry),
      );

      final issuerAny = discharge.issuer;
      expect(issuerAny, isNotNull);
      final issuerValue = wrappers.StringValue();
      issuerAny!.unpackInto(issuerValue);
      expect(issuerValue.value, equals('celest::third-party::integration'));

      final notAfter = discharge.notAfter;
      expect(
        notAfter?.toInt(),
        equals(ticketExpiry.millisecondsSinceEpoch),
      );

  expect(discharge.caveats, hasLength(1));
  expect(discharge.caveats.single.hasFirstParty(), isTrue);
  final firstParty = discharge.caveats.single.firstParty;
      expect(firstParty.namespace, equals('celest.auth'));
      expect(firstParty.predicate, equals('session_state'));
      final sessionState = corksv1.SessionState();
      firstParty.payload.unpackInto(sessionState);
      expect(sessionState.sessionId, equals('sess-123'));
      expect(sessionState.version.toInt(), equals(7));

      // Second call should use the cached discharge without contacting service.
      final cached = await client.fetchDischarges(
        cork,
        metadata: {'ip_address': '203.0.113.5'},
      );
      expect(cached.keys, equals(discharges.keys));
      expect(issueCount, equals(1), reason: 'discharge served from cache');
    });
  });
}
