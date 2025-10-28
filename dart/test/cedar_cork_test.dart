import 'dart:convert';
import 'dart:typed_data';

import 'package:convert/convert.dart';
import 'package:corks_cedar/corks_cedar.dart';
import 'package:corks_cedar/src/crypto.dart';
import 'package:corks_cedar/src/proto.dart';
import 'package:corks_cedar/src/proto/celest/corks/v1/cork.pb.dart' as corksv1;
import 'package:corks_cedar/src/proto/google/protobuf/any.pb.dart' as anypb;
import 'package:corks_cedar/src/proto/google/protobuf/wrappers.pb.dart'
    as wrappers;
import 'package:fixnum/fixnum.dart';
import 'package:test/test.dart';

void main() {
  group('Cork', () {
    test('tail signature matches specification', () async {
      final keyId = utf8.encode('cork-key-0001');
      final masterKey = _hex(
        '00112233445566778899aabbccddeeff00112233445566778899aabbccddeeff',
      );

      final builder = CorkBuilder(keyId)
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

      final tampered = signed.toProto().deepCopy()
        ..audience = wrappers.StringValue(
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
      final builder = CorkBuilder(Uint8List(0))
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

    test('builder adds default caveats', () {
      final keyId = utf8.encode('defaults-key');
      final builder = CorkBuilder(Uint8List.fromList(keyId))
        ..issuer = wrappers.StringValue(value: 'celest::issuer')
        ..bearer = wrappers.StringValue(value: 'celest::bearer');

      final expiryInstant = DateTime.utc(2024, 12, 1, 12);
      builder.defaultExpiry = expiryInstant;

      final scope = corksv1.OrganizationScope(
        organizationId: 'org-123',
        projectId: 'proj-abc',
        environmentId: 'env-main',
      );
      builder.defaultOrganizationScope = scope;

      final actions = ['read', 'write'];
      builder.defaultActionScope = actions;

      // Mutate inputs after configuration to confirm defensive copies.
      scope.organizationId = 'mutated';
      actions[0] = 'mutated';

      builder.addCaveat(
        _firstPartyCaveat(
          _hex('00112233445566778899aabbccddeeff'),
          'celest.auth',
          'allow_all',
          wrappers.BoolValue(value: true),
        ),
      );

      final cork = builder.build();
      final proto = cork.toProto();

      expect(proto.hasNotAfter(), isTrue);
      expect(
        proto.notAfter,
        equals(Int64(expiryInstant.millisecondsSinceEpoch)),
      );

      expect(proto.caveats, hasLength(4));

      final expiryCaveat = proto.caveats[0];
      expect(expiryCaveat.firstParty.namespace, 'celest.auth');
      expect(expiryCaveat.firstParty.predicate, 'expiry');
      final expiryPayload = corksv1.Expiry();
      expiryCaveat.firstParty.payload.unpackInto(expiryPayload);
      expect(expiryPayload.notAfter, proto.notAfter);

      final orgCaveat = proto.caveats[1];
      expect(orgCaveat.firstParty.predicate, 'organization_scope');
      final orgPayload = corksv1.OrganizationScope();
      orgCaveat.firstParty.payload.unpackInto(orgPayload);
      expect(orgPayload.organizationId, 'org-123');
      expect(orgPayload.projectId, 'proj-abc');
      expect(orgPayload.environmentId, 'env-main');

      final actionCaveat = proto.caveats[2];
      expect(actionCaveat.firstParty.predicate, 'actions');
      final actionPayload = corksv1.ActionScope();
      actionCaveat.firstParty.payload.unpackInto(actionPayload);
      expect(actionPayload.actions, ['read', 'write']);

      final appended = proto.caveats[3];
      expect(appended, isNot(same(proto.caveats[0])));
      final manual = _firstPartyCaveat(
        _hex('00112233445566778899aabbccddeeff'),
        'celest.auth',
        'allow_all',
        wrappers.BoolValue(value: true),
      );
      expect(appended.caveatVersion, manual.caveatVersion);
      expect(appended.firstParty.predicate, manual.firstParty.predicate);
      expect(appended.caveatId, manual.caveatId);
    });

    test('clearing default caveats removes defaults', () {
      final builder =
          CorkBuilder(Uint8List.fromList(utf8.encode('clear-defaults')))
            ..issuer = wrappers.StringValue(value: 'celest::issuer')
            ..bearer = wrappers.StringValue(value: 'celest::bearer');

      builder.defaultExpiry = DateTime.now();
      builder.defaultOrganizationScope = corksv1.OrganizationScope(
        organizationId: 'tenant-1',
      );
      builder.defaultActionScope = ['read'];

      builder.defaultExpiry = null;
      builder.defaultOrganizationScope = null;
      builder.defaultActionScope = const <String>[];

      final cork = builder.build();
      final proto = cork.toProto();
      expect(proto.hasNotAfter(), isFalse);
      expect(proto.caveats, isEmpty);
    });

    test('builder first-party helpers append caveats', () {
      final builder =
          CorkBuilder(Uint8List.fromList(utf8.encode('first-party-helpers')))
            ..issuer = wrappers.StringValue(value: 'celest::issuer')
            ..bearer = wrappers.StringValue(value: 'celest::bearer');

      expect(
        () => builder.appendExpiryCaveat(
          DateTime.fromMillisecondsSinceEpoch(0, isUtc: true),
        ),
        throwsA(isA<InvalidCorkException>()),
      );

      final expiryInstant = DateTime.utc(2025, 7, 1, 12);
      builder.appendExpiryCaveat(expiryInstant);

      final scope = corksv1.OrganizationScope(
        organizationId: 'org-123',
        projectId: 'proj-abc',
      );
      builder.appendOrganizationScopeCaveat(scope);

      final actions = ['read', 'write'];
      builder.appendActionScopeCaveat(actions);

      builder.appendIpBindingCaveat(['10.0.0.0/8', '192.168.0.0/16']);

      final sessionState = corksv1.SessionState(
        sessionId: 'sess-123',
        version: Int64(3),
      );
      builder.appendSessionStateCaveat(sessionState);

      scope.organizationId = 'mutated';
      actions[0] = 'mutated';
      sessionState.version = Int64(9);

      expect(
        () => builder.appendActionScopeCaveat([]),
        throwsA(isA<InvalidCorkException>()),
      );
      expect(
        () => builder.appendIpBindingCaveat([]),
        throwsA(isA<InvalidCorkException>()),
      );
      expect(
        () => builder.appendSessionStateCaveat(corksv1.SessionState()),
        throwsA(isA<InvalidCorkException>()),
      );

      final cork = builder.build();
      final proto = cork.toProto();

      expect(proto.caveats, hasLength(5));

      final expiryCaveat = proto.caveats[0];
      expect(expiryCaveat.firstParty.predicate, 'expiry');
      final expiryPayload = corksv1.Expiry();
      expiryCaveat.firstParty.payload.unpackInto(expiryPayload);
      expect(
        expiryPayload.notAfter,
        Int64(expiryInstant.millisecondsSinceEpoch),
      );

      final orgCaveat = proto.caveats[1];
      expect(orgCaveat.firstParty.predicate, 'organization_scope');
      final orgPayload = corksv1.OrganizationScope();
      orgCaveat.firstParty.payload.unpackInto(orgPayload);
      expect(orgPayload.organizationId, 'org-123');
      expect(orgPayload.projectId, 'proj-abc');

      final actionCaveat = proto.caveats[2];
      expect(actionCaveat.firstParty.predicate, 'actions');
      final actionPayload = corksv1.ActionScope();
      actionCaveat.firstParty.payload.unpackInto(actionPayload);
      expect(actionPayload.actions, ['read', 'write']);

      final ipCaveat = proto.caveats[3];
      expect(ipCaveat.firstParty.predicate, 'ip_binding');
      final ipPayload = corksv1.IpBinding();
      ipCaveat.firstParty.payload.unpackInto(ipPayload);
      expect(
        ipPayload.cidrs,
        unorderedEquals(['10.0.0.0/8', '192.168.0.0/16']),
      );

      final sessionCaveat = proto.caveats[4];
      expect(sessionCaveat.firstParty.predicate, 'session_state');
      final sessionPayload = corksv1.SessionState();
      sessionCaveat.firstParty.payload.unpackInto(sessionPayload);
      expect(sessionPayload.sessionId, 'sess-123');
      expect(sessionPayload.version, Int64(3));
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
