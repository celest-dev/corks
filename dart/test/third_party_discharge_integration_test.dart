import 'dart:convert';
import 'dart:typed_data';

import 'package:corks_cedar/corks_cedar.dart';
import 'package:corks_cedar/src/proto/celest/corks/v1/cork.pb.dart' as corksv1;
import 'package:corks_cedar/src/proto/google/protobuf/wrappers.pb.dart'
    as wrappers;
import 'package:fixnum/fixnum.dart';
import 'package:test/test.dart';

void main() {
  group('third-party discharge integration', () {
    test(
      'client obtains and verifies discharges from multiple services',
      () async {
        const ssoUri = 'https://third-party.example/sso';
        const auditUri = 'https://third-party.example/audit';

        final sharedSecret = Uint8List.fromList(
          List<int>.generate(32, (index) => 0x40 + index),
        );
        final codec = SharedSecretTicketCodec(sharedSecret: sharedSecret);

        final ssoKeyId = Uint8List.fromList(
          List<int>.generate(16, (index) => 0xA0 + index),
        );
        final auditKeyId = Uint8List.fromList(
          List<int>.generate(16, (index) => 0xB0 + index),
        );

        final issueCountByUri = <String, int>{ssoUri: 0, auditUri: 0};
        final transportMetadataByUri = <String, Map<String, Object?>>{};
        final serviceMetadataByUri = <String, Map<String, Object?>>{};
        final decodedTicketMetadataByUri = <String, Map<String, Object?>>{};

        ThirdPartyDischargeService buildService({
          required String uri,
          required wrappers.StringValue issuer,
          required Uint8List keyId,
          required void Function(
            DischargeBuilder builder,
            DecodedDischargeTicket decoded,
            ThirdPartyDischargeRequest request,
          )
          onBuild,
        }) {
          return ThirdPartyDischargeService(
            decoder: codec.decoder,
            issuer: issuer,
            keyId: keyId,
            now: () => DateTime.utc(2025, 3, 1, 10),
            onBuild: (builder, decoded, request) {
              serviceMetadataByUri[uri] = request.metadata;
              decodedTicketMetadataByUri[uri] = decoded.metadata;
              onBuild(builder, decoded, request);
            },
          );
        }

        final services = <String, ThirdPartyDischargeService>{
          ssoUri: buildService(
            uri: ssoUri,
            issuer: wrappers.StringValue(value: 'celest::third-party::sso'),
            keyId: ssoKeyId,
            onBuild: (builder, decoded, _) {
              final sessionId = decoded.metadata['session_id'] as String?;
              final sessionVersion =
                  decoded.metadata['session_version'] as int?;
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
          ),
          auditUri: buildService(
            uri: auditUri,
            issuer: wrappers.StringValue(value: 'celest::third-party::audit'),
            keyId: auditKeyId,
            onBuild: (builder, decoded, _) {
              final actions =
                  (decoded.metadata['actions'] as List<Object?>?)
                      ?.whereType<String>()
                      .toList(growable: false) ??
                  const <String>[];
              final resource = decoded.metadata['resource'] as String?;

              expect(actions, isNotEmpty);
              expect(resource, isNotNull);

              builder.appendFirstPartyCaveat(
                namespace: 'celest.audit',
                predicate: 'actions',
                payload: corksv1.ActionScope()..actions.addAll(actions),
              );
              builder.appendFirstPartyCaveat(
                namespace: 'celest.audit',
                predicate: 'resource',
                payload: wrappers.StringValue(value: resource!),
              );
            },
          ),
        };

        final client = ThirdPartyDischargeClient(
          transport: (uri, ticket, metadata, _) async {
            issueCountByUri.update(uri.toString(), (value) => value + 1);
            transportMetadataByUri[uri.toString()] = metadata;

            final service = services[uri.toString()];
            expect(
              service,
              isNotNull,
              reason: 'unexpected service at ${uri.toString()}',
            );
            return service!.issue(
              ThirdPartyDischargeRequest(ticket: ticket, metadata: metadata),
            );
          },
          cacheTtl: const Duration(minutes: 15),
          now: () => DateTime.utc(2025, 3, 1, 9, 45),
        );

        final corkBuilder =
            CorkBuilder(
                Uint8List.fromList(
                  List<int>.generate(16, (index) => index + 1),
                ),
              )
              ..issuer = wrappers.StringValue(value: 'celest::issuer::demo')
              ..bearer = wrappers.StringValue(value: 'users/alice')
              ..notAfter = DateTime.utc(2025, 3, 1, 12);

        final ssoTicketExpiry = DateTime.utc(2025, 3, 1, 11);
        final auditTicketExpiry = DateTime.utc(2025, 3, 1, 10, 45);

        await corkBuilder.appendThirdPartyCaveat(
          codec.createOptions(
            location: ssoUri,
            tag: List<int>.generate(32, (index) => 0x80 + index),
            metadata: {'session_id': 'sess-123', 'session_version': 7},
            notAfter: ssoTicketExpiry,
          ),
        );
        await corkBuilder.appendThirdPartyCaveat(
          codec.createOptions(
            location: auditUri,
            tag: List<int>.generate(32, (index) => 0x90 + index),
            metadata: {
              'resource': 'projects/example-stack',
              'actions': ['list', 'describe'],
            },
            notAfter: auditTicketExpiry,
          ),
        );

        final cork = corkBuilder.build();

        final requestMetadata = {'ip_address': '203.0.113.5'};
        final discharges = await client.fetchDischarges(
          cork,
          metadata: requestMetadata,
        );

        expect(issueCountByUri[ssoUri], equals(1));
        expect(issueCountByUri[auditUri], equals(1));
        expect(discharges, hasLength(2));

        final thirdPartyCaveats = cork.caveats
            .where((caveat) => caveat.hasThirdParty())
            .toList();
        expect(thirdPartyCaveats, hasLength(2));

        final decodedTickets = <String, DecodedDischargeTicket>{};
        final locationById = <String, String>{};
        for (final caveat in thirdPartyCaveats) {
          final id = base64UrlEncode(
            Uint8List.fromList(caveat.caveatId),
          ).replaceAll('=', '');
          locationById[id] = caveat.thirdParty.location;
          decodedTickets[id] = await codec.decode(caveat.thirdParty.ticket);
        }

        expect(decodedTickets.keys, unorderedEquals(discharges.keys));

        expect(transportMetadataByUri[ssoUri], equals(requestMetadata));
        expect(transportMetadataByUri[auditUri], equals(requestMetadata));
        expect(serviceMetadataByUri[ssoUri], equals(requestMetadata));
        expect(serviceMetadataByUri[auditUri], equals(requestMetadata));
        expect(
          decodedTicketMetadataByUri[ssoUri],
          equals({'session_id': 'sess-123', 'session_version': 7}),
        );
        expect(
          decodedTicketMetadataByUri[auditUri],
          equals({
            'resource': 'projects/example-stack',
            'actions': ['list', 'describe'],
          }),
        );

        for (final entry in discharges.entries) {
          final location = locationById[entry.key];
          expect(location, isNotNull);
          final decoded = decodedTickets[entry.key];
          expect(decoded, isNotNull);
          entry.value.verify(caveatRootKey: decoded!.caveatRootKey);

          switch (location) {
            case ssoUri:
              final issuerAny = entry.value.issuer;
              expect(issuerAny, isNotNull);
              final issuerValue = wrappers.StringValue();
              issuerAny!.unpackInto(issuerValue);
              expect(issuerValue.value, equals('celest::third-party::sso'));

              expect(
                entry.value.notAfter?.toInt(),
                equals(ssoTicketExpiry.millisecondsSinceEpoch),
              );

              expect(entry.value.caveats, hasLength(1));
              expect(entry.value.caveats.single.hasFirstParty(), isTrue);
              final firstParty = entry.value.caveats.single.firstParty;
              expect(firstParty.namespace, equals('celest.auth'));
              expect(firstParty.predicate, equals('session_state'));
              final sessionState = corksv1.SessionState();
              firstParty.payload.unpackInto(sessionState);
              expect(sessionState.sessionId, equals('sess-123'));
              expect(sessionState.version.toInt(), equals(7));
              break;
            case auditUri:
              final issuerAny = entry.value.issuer;
              expect(issuerAny, isNotNull);
              final issuerValue = wrappers.StringValue();
              issuerAny!.unpackInto(issuerValue);
              expect(issuerValue.value, equals('celest::third-party::audit'));

              expect(
                entry.value.notAfter?.toInt(),
                equals(auditTicketExpiry.millisecondsSinceEpoch),
              );

              expect(entry.value.caveats.length, equals(2));
              final actionsCaveat = entry.value.caveats.firstWhere(
                (caveat) =>
                    caveat.hasFirstParty() &&
                    caveat.firstParty.predicate == 'actions',
              );
              final actionScope = corksv1.ActionScope();
              actionsCaveat.firstParty.payload.unpackInto(actionScope);
              expect(actionScope.actions, equals(['list', 'describe']));

              final resourceCaveat = entry.value.caveats.firstWhere(
                (caveat) =>
                    caveat.hasFirstParty() &&
                    caveat.firstParty.predicate == 'resource',
              );
              final resourceValue = wrappers.StringValue();
              resourceCaveat.firstParty.payload.unpackInto(resourceValue);
              expect(resourceValue.value, equals('projects/example-stack'));
              break;
            default:
              fail('unexpected discharge location $location');
          }
        }

        // Second call should use the cached discharges without contacting services.
        final cached = await client.fetchDischarges(
          cork,
          metadata: requestMetadata,
        );
        expect(cached.keys, unorderedEquals(discharges.keys));
        expect(issueCountByUri[ssoUri], equals(1));
        expect(issueCountByUri[auditUri], equals(1));
      },
    );
  });
}
