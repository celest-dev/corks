import 'dart:convert';
import 'dart:typed_data';

import 'package:corks_cedar/src/cli/command_runner.dart';
import 'package:corks_cedar/src/cli/utils.dart';
import 'package:corks_cedar/src/cork.dart';
import 'package:corks_cedar/src/crypto.dart';
import 'package:corks_cedar/src/discharge.dart';
import 'package:corks_cedar/src/proto/celest/corks/v1/cork.pb.dart' as corksv1;
import 'package:corks_cedar/src/proto/google/protobuf/any.pb.dart' as anypb;
import 'package:corks_cedar/src/proto/google/protobuf/wrappers.pb.dart'
    as wrappers;
import 'package:corks_cedar/src/signer.dart';
import 'package:corks_cedar/src/third_party_ticket.dart';
import 'package:test/test.dart';

void main() {
  group('corks CLI', () {
    test('inspect prints cork summary', () async {
      final fixture = await _CorkFixture.create();
      final buffers = _CliBuffers();

      final code = await runCorksCommand(
        ['inspect', '--token', fixture.token],
        stdout: buffers.stdout,
        stderr: buffers.stderr,
      );

      expect(code, equals(0), reason: buffers.stderrContents);
      expect(buffers.stderrContents, isEmpty, reason: buffers.stderrContents);
      expect(buffers.stdoutContents, contains('Type: cork'));
      expect(
        buffers.stdoutContents,
        contains('Predicate: celest.auth::actions'),
      );
    });

    test('verify validates signature and third-party discharges', () async {
      final fixture = await _CorkFixture.create(withThirdParty: true);
      final buffers = _CliBuffers();

      final code = await runCorksCommand(
        [
          'verify',
          '--token',
          fixture.token,
          '--key-id',
          fixture.keyIdHex,
          '--master-key',
          fixture.masterKeyHex,
          '--discharge',
          fixture.dischargeToken!,
        ],
        stdout: buffers.stdout,
        stderr: buffers.stderr,
      );

      expect(code, equals(0), reason: buffers.stderrContents);
      expect(buffers.stderrContents, isEmpty, reason: buffers.stderrContents);
      expect(buffers.stdoutContents, contains('Signature: valid'));
      expect(
        buffers.stdoutContents,
        contains('Third-party caveats: 1/1 verified'),
      );
    });

    test('verify reports missing discharges', () async {
      final fixture = await _CorkFixture.create(withThirdParty: true);
      final buffers = _CliBuffers();

      final code = await runCorksCommand(
        [
          'verify',
          '--token',
          fixture.token,
          '--key-id',
          fixture.keyIdHex,
          '--master-key',
          fixture.masterKeyHex,
        ],
        stdout: buffers.stdout,
        stderr: buffers.stderr,
      );

      expect(code, equals(1));
      expect(buffers.stderrContents, contains('Missing discharges'));
    });

    test('verify handles corks without third-party caveats', () async {
      final fixture = await _CorkFixture.create();
      final buffers = _CliBuffers();

      final code = await runCorksCommand(
        [
          'verify',
          '--token',
          fixture.token,
          '--key-id',
          fixture.keyIdHex,
          '--master-key',
          fixture.masterKeyHex,
        ],
        stdout: buffers.stdout,
        stderr: buffers.stderr,
      );

      expect(code, equals(0));
      expect(buffers.stdoutContents, contains('Third-party caveats: none'));
    });
  });
}

class _CliBuffers {
  final StringBuffer stdout = StringBuffer();
  final StringBuffer stderr = StringBuffer();

  String get stdoutContents => stdout.toString();
  String get stderrContents => stderr.toString();
}

class _CorkFixture {
  _CorkFixture({
    required this.cork,
    required this.signer,
    required this.token,
    required this.keyIdHex,
    required this.masterKeyHex,
    this.discharge,
  }) : dischargeToken = discharge?.toString();

  static Future<_CorkFixture> create({bool withThirdParty = false}) async {
    final keyId = Uint8List.fromList(List<int>.generate(16, (i) => i + 1));
    final masterKey = Uint8List.fromList(
      List<int>.generate(32, (i) => 0x20 + i),
    );
    final signer = Signer(keyId, masterKey);

    final builder = CorkBuilder(keyId)
      ..issuer = wrappers.StringValue(value: 'celest::issuer::test')
      ..bearer = wrappers.StringValue(value: 'users/tester')
      ..appendActionScopeCaveat(const ['read']);

    Discharge? discharge;
    if (withThirdParty) {
      final sharedSecret = Uint8List.fromList(
        List<int>.generate(32, (i) => 0x40 + i),
      );
      final codec = SharedSecretTicketCodec(sharedSecret: sharedSecret);
      final baseCork = builder.build();
      final tag = await _tagAfterCaveats(baseCork.toProto(), signer);

      await builder.appendThirdPartyCaveat(
        codec.createOptions(
          location: 'https://third-party.example/verify',
          tag: tag,
          metadata: const {'scope': 'limited'},
        ),
      );

      final unsignedWithThird = builder.build();
      final signedPreview = await unsignedWithThird.sign(signer);
      final third = signedPreview.caveats.firstWhere(
        (caveat) => caveat.hasThirdParty(),
      );
      final decoded = await codec.decode(third.thirdParty.ticket);

      final dischargeBuilder = DischargeBuilder(
        parentCaveatId: Uint8List.fromList(third.caveatId),
        caveatRootKey: decoded.caveatRootKey,
        keyId: Uint8List.fromList(List<int>.generate(16, (i) => 0x90 + i)),
        issuer: wrappers.StringValue(value: 'celest::third-party'),
      )..issuedAt = DateTime.utc(2025, 1, 1, 12);
      discharge = dischargeBuilder.build();

      // Replace builder state with signed preview to keep deterministic output.
      return _CorkFixture(
        cork: signedPreview,
        signer: signer,
        token: signedPreview.toString(),
        keyIdHex: bytesToHex(keyId),
        masterKeyHex: bytesToHex(masterKey),
        discharge: discharge,
      );
    }

    final unsigned = builder.build();
    final signed = await unsigned.sign(signer);

    return _CorkFixture(
      cork: signed,
      signer: signer,
      token: signed.toString(),
      keyIdHex: bytesToHex(keyId),
      masterKeyHex: bytesToHex(masterKey),
    );
  }

  final Cork cork;
  final Signer signer;
  final String token;
  final String keyIdHex;
  final String masterKeyHex;
  final Discharge? discharge;
  final String? dischargeToken;
}

Future<Uint8List> _tagAfterCaveats(corksv1.Cork proto, Signer signer) async {
  var tag = await _initialTag(proto, signer);
  for (final caveat in proto.caveats) {
    tag = hmacSha256(tag, caveat.writeToBuffer());
  }
  return tag;
}

Future<Uint8List> _initialTag(corksv1.Cork proto, Signer signer) async {
  final rootKey = await signer.deriveCorkRootKey(
    nonce: Uint8List.fromList(proto.nonce),
    keyId: Uint8List.fromList(proto.keyId),
  );
  var tag = hmacSha256(rootKey, utf8.encode(macContext));
  tag = hmacSha256(tag, encodeUint32(proto.version));
  tag = hmacSha256(tag, Uint8List.fromList(proto.nonce));
  tag = hmacSha256(tag, Uint8List.fromList(proto.keyId));
  tag = _hashAny(tag, proto.hasIssuer() ? proto.issuer : null);
  tag = _hashAny(tag, proto.hasBearer() ? proto.bearer : null);
  tag = _hashAny(tag, proto.hasAudience() ? proto.audience : null);
  tag = _hashAny(tag, proto.hasClaims() ? proto.claims : null);
  return tag;
}

Uint8List _hashAny(Uint8List tag, anypb.Any? message) {
  if (message == null || message.value.isEmpty) {
    return tag;
  }
  return hmacSha256(tag, Uint8List.fromList(message.writeToBuffer()));
}
