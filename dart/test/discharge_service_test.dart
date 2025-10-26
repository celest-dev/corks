import 'dart:typed_data';

import 'package:corks_cedar/corks_cedar.dart';
import 'package:corks_cedar/src/crypto.dart';
import 'package:corks_cedar/src/proto/corks/v1/cork.pb.dart' as corksv1;
import 'package:corks_cedar/src/proto/google/protobuf/wrappers.pb.dart'
    as wrappers;
import 'package:test/test.dart';

void main() {
  group('ThirdPartyDischargeService', () {
    test('issues discharge using decoder and hook', () async {
      final ticketBytes = Uint8List.fromList('ticket'.codeUnits);
      final caveatId = Uint8List.fromList(List<int>.generate(16, (i) => i + 1));
      final rootKey = Uint8List.fromList(List<int>.filled(tagSize, 0xAB));
      final presetCaveat = corksv1.Caveat(
        caveatVersion: 1,
        caveatId: Uint8List.fromList(List<int>.generate(16, (i) => 0xAA + i)),
        firstParty: corksv1.FirstPartyCaveat(
          namespace: 'celest.audit',
          predicate: 'approved',
        ),
      );
      final expiry = DateTime.utc(2030, 1, 1);
      final issuedAt = DateTime.utc(2025, 1, 2, 3, 4, 5);

      final service = ThirdPartyDischargeService(
        decoder: (ticket) async {
          expect(ticket, equals(ticketBytes));
          return DecodedDischargeTicket(
            caveatId: caveatId,
            caveatRootKey: rootKey,
            caveats: [presetCaveat],
            notAfter: expiry,
            metadata: {'subject': 'session-123'},
          );
        },
        issuer: wrappers.StringValue(value: 'celest::third-party'),
        keyId: List<int>.generate(16, (i) => 0x10 + i),
        now: () => issuedAt,
        onBuild: (builder, decoded, request) {
          expect(request.metadata['ip'], '203.0.113.10');
          expect(decoded.metadata['subject'], 'session-123');
          builder.appendFirstPartyCaveat(
            namespace: 'celest.audit',
            predicate: 'risk_score',
            payload: wrappers.UInt32Value(value: 42),
          );
        },
      );

      final discharge = await service.issue(
        ThirdPartyDischargeRequest(
          ticket: ticketBytes,
          metadata: {'ip': '203.0.113.10'},
        ),
      );

      expect(discharge.version, Discharge.currentVersion);
      expect(discharge.parentCaveatId, equals(caveatId));
      expect(
        discharge.keyId,
        equals(Uint8List.fromList(List<int>.generate(16, (i) => 0x10 + i))),
      );
      expect(discharge.issuer, isNotNull);
      expect(discharge.toProto().caveats, hasLength(2));
      expect(discharge.notAfter, isNotNull);
      expect(
        DateTime.fromMillisecondsSinceEpoch(
          discharge.notAfter!.toInt(),
          isUtc: true,
        ),
        equals(expiry),
      );

      // Signature should verify with the decoded root key.
      discharge.verify(caveatRootKey: rootKey);

      // Ensure base64 encoding round-trips.
      final roundTrip = Discharge.parse(discharge.toString());
      expect(roundTrip.parentCaveatId, equals(discharge.parentCaveatId));
      roundTrip.verify(caveatRootKey: rootKey);
    });
  });

  group('DischargeBuilder', () {
    test('enforces derived key length', () {
      final builder = DischargeBuilder(
        parentCaveatId: Uint8List.fromList(List<int>.filled(16, 0x01)),
        caveatRootKey: Uint8List(16),
        keyId: Uint8List.fromList(List<int>.filled(16, 0x02)),
      );

      expect(() => builder.build(), throwsA(isA<InvalidCorkException>()));
    });

    test('appendFirstPartyCaveat generates identifiers', () {
      final builder = DischargeBuilder(
        parentCaveatId: Uint8List.fromList(List<int>.filled(16, 0x01)),
        caveatRootKey: Uint8List.fromList(List<int>.filled(tagSize, 0x03)),
        keyId: Uint8List.fromList(List<int>.filled(16, 0x04)),
      )..appendFirstPartyCaveat(
        namespace: 'celest.third_party',
        predicate: 'rate_limited',
      );

      final discharge = builder.build();
      expect(discharge.toProto().caveats, hasLength(1));
      final caveatId = discharge.toProto().caveats.single.caveatId;
      expect(caveatId, hasLength(16));
    });
  });
}
