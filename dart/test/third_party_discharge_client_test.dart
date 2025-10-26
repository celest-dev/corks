import 'dart:convert';
import 'dart:typed_data';

import 'package:corks_cedar/corks_cedar.dart';
import 'package:corks_cedar/src/crypto.dart';
import 'package:corks_cedar/src/proto/celest/corks/v1/cork.pb.dart' as corksv1;
import 'package:corks_cedar/src/proto/google/protobuf/wrappers.pb.dart'
    as wrappers;
import 'package:test/test.dart';

void main() {
  group('ThirdPartyDischargeClient', () {
    late Cork cork;
    late Map<String, corksv1.Caveat> caveatByTicket;

    setUp(() {
      final keyId = Uint8List.fromList(List<int>.filled(16, 0x01));
      final builder = Cork.builder(keyId)
        ..issuer = wrappers.StringValue(value: 'celest::service')
        ..bearer = wrappers.StringValue(value: 'celest::session');

      caveatByTicket = <String, corksv1.Caveat>{};
      for (var index = 0; index < 2; index++) {
        final location = 'https://tp.example/discharge/$index';
        final ticket = Uint8List.fromList('ticket-$index'.codeUnits);
        final challenge = Uint8List.fromList(List<int>.filled(24, index));
        final caveatId = Uint8List.fromList(
          List<int>.generate(16, (i) => index + i + 1),
        );
        final thirdParty = corksv1.ThirdPartyCaveat(
          location: location,
          ticket: ticket,
          challenge: challenge,
        );
        final caveat = corksv1.Caveat(
          caveatVersion: 1,
          caveatId: caveatId,
          thirdParty: thirdParty,
        );
        builder.addCaveat(caveat);
        caveatByTicket[_encode(ticket)] = caveat;
      }

      cork = builder.build();
    });

    test('caches discharges until expiry', () async {
      var now = DateTime.utc(2025, 1, 1);
      var requestCount = 0;

      Discharge makeDischarge(corksv1.Caveat caveat) {
        final builder = DischargeBuilder(
          parentCaveatId: Uint8List.fromList(caveat.caveatId),
          caveatRootKey: Uint8List.fromList(List<int>.filled(tagSize, 0xAA)),
          keyId: Uint8List.fromList(List<int>.filled(16, 0xBB)),
        )..notAfter = now.add(const Duration(hours: 1));
        return builder.build();
      }

      final client = ThirdPartyDischargeClient(
        transport: (uri, ticket, metadata, caveat) async {
          requestCount++;
          final parent = caveatByTicket[_encode(ticket)]!;
          expect(uri.toString(), parent.thirdParty.location);
          expect(ticket, equals(parent.thirdParty.ticket));
          expect(metadata, isEmpty);
          return makeDischarge(parent);
        },
        now: () => now,
      );

      final first = await client.fetchDischarges(cork);
      expect(first.keys, hasLength(2));
      expect(requestCount, equals(2));

      final second = await client.fetchDischarges(cork);
      expect(second.keys, hasLength(2));
      expect(requestCount, equals(2), reason: 'cache should avoid re-fetches');

      now = now.add(const Duration(hours: 2));
      final third = await client.fetchDischarges(cork);
      expect(third.keys, hasLength(2));
      expect(requestCount, equals(4), reason: 'expired entries refetched');
    });

    test('honours cache TTL when shorter than discharge expiry', () async {
      var now = DateTime.utc(2025, 2, 2, 10);
      var requestCount = 0;

      final client = ThirdPartyDischargeClient(
        transport: (uri, ticket, metadata, caveat) async {
          requestCount++;
          final parent = caveatByTicket[_encode(ticket)]!;
          final builder = DischargeBuilder(
            parentCaveatId: Uint8List.fromList(parent.caveatId),
            caveatRootKey: Uint8List.fromList(List<int>.filled(tagSize, 0xCC)),
            keyId: Uint8List.fromList(List<int>.filled(16, 0xDD)),
          )..notAfter = now.add(const Duration(hours: 4));
          return builder.build();
        },
        cacheTtl: const Duration(minutes: 5),
        now: () => now,
      );

      await client.fetchDischarges(cork);
      expect(requestCount, equals(2));

      now = now.add(const Duration(minutes: 4));
      await client.fetchDischarges(cork);
      expect(requestCount, equals(2), reason: 'TTL not reached');

      now = now.add(const Duration(minutes: 2));
      await client.fetchDischarges(cork);
      expect(requestCount, equals(4), reason: 'TTL expired so refetched');
    });

    test('passes metadata resolver output to transport', () async {
      final metadataCalls = <String, Map<String, Object?>>{};

      final client = ThirdPartyDischargeClient(
        transport: (uri, ticket, metadata, caveat) async {
          metadataCalls[uri.path] = metadata;
          final parent = caveatByTicket[_encode(ticket)]!;
          return DischargeBuilder(
            parentCaveatId: Uint8List.fromList(parent.caveatId),
            caveatRootKey: Uint8List.fromList(List<int>.filled(tagSize, 0xEE)),
            keyId: Uint8List.fromList(List<int>.filled(16, 0xFF)),
          ).build();
        },
        now: DateTime.now,
      );

      await client.fetchDischarges(
        cork,
        metadataResolver: (caveat) => {
          'ticket': String.fromCharCodes(caveat.ticket),
        },
      );

      expect(metadataCalls.length, equals(2));
      metadataCalls.forEach((_, data) {
        expect(data.keys, equals(['ticket']));
        expect(data['ticket'], startsWith('ticket-'));
      });
    });

    test('throws when a location cannot be parsed', () async {
      final keyId = Uint8List.fromList(List<int>.filled(16, 0x01));
      final builder = Cork.builder(keyId)
        ..issuer = wrappers.StringValue(value: 'celest::service')
        ..bearer = wrappers.StringValue(value: 'celest::session');

      builder.addCaveat(
        corksv1.Caveat(
          caveatVersion: 1,
          caveatId: Uint8List.fromList(List<int>.filled(16, 7)),
          thirdParty: corksv1.ThirdPartyCaveat(
            location: 'not a uri',
            ticket: Uint8List.fromList('bad'.codeUnits),
            challenge: Uint8List(24),
          ),
        ),
      );
      final invalidCork = builder.build();

      final client = ThirdPartyDischargeClient(
        transport: (_, _, _, _) async => DischargeBuilder(
          parentCaveatId: Uint8List(16),
          caveatRootKey: Uint8List.fromList(List<int>.filled(tagSize, 0x11)),
          keyId: Uint8List.fromList(List<int>.filled(16, 0x12)),
        ).build(),
      );

      expect(
        () => client.fetchDischarges(invalidCork),
        throwsA(isA<InvalidCorkException>()),
      );
    });
  });
}

String _encode(List<int> bytes) =>
    base64UrlEncode(Uint8List.fromList(bytes)).replaceAll('=', '');
