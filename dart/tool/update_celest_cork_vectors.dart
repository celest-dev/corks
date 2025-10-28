import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:corks_cedar/corks_cedar.dart';
import 'package:corks_cedar/src/proto.dart';
import 'package:corks_cedar/src/proto/cedar/v4/entity_uid.pb.dart'
    as cedar_proto;

Future<void> main(List<String> args) async {
  final vectors = await _buildExpectedVectors();
  final encoder = const JsonEncoder.withIndent('  ');
  final json = encoder.convert(vectors);

  final outputFile = File('../testdata/celest_cork_vectors.json');
  await outputFile.parent.create(recursive: true);
  await outputFile.writeAsString('$json\n');

  stdout.writeln('Wrote ${outputFile.path}');
}

Future<Map<String, Object?>> _buildExpectedVectors() async {
  const signerName = 'default';
  final keyId = Uint8List.fromList(List<int>.generate(16, (index) => index));
  final masterKey = Uint8List.fromList(
    List<int>.generate(32, (index) => index + 16),
  );

  final signed = await _buildSignedCork(keyId: keyId, masterKey: masterKey);
  final tampered = _tamperSignature(signed);

  final vectors = <Map<String, Object?>>[
    _vectorEntry(
      name: 'basic_valid',
      description: 'Deterministic cork signed with the default key.',
      signerName: signerName,
      cork: signed,
      expectedSignature: signed.tailSignature,
      signatureValid: true,
    ),
    _vectorEntry(
      name: 'signature_tampered',
      description: 'Tail signature first byte flipped to invalidate token.',
      signerName: signerName,
      cork: tampered,
      expectedSignature: signed.tailSignature,
      signatureValid: false,
    ),
  ];

  return {
    'version': 1,
    'signers': {
      signerName: {
        'keyId': base64Encode(keyId),
        'masterKey': base64Encode(masterKey),
      },
    },
    'vectors': vectors,
  };
}

Future<Cork> _buildSignedCork({
  required Uint8List keyId,
  required Uint8List masterKey,
}) async {
  final nonce = Uint8List.fromList(List<int>.generate(24, (index) => index));
  final builder = Cork.builder(keyId)
    ..nonce = nonce
    ..issuer = cedar_proto.EntityUid(type: 'User', id: 'issuer-alice')
    ..bearer = cedar_proto.EntityUid(type: 'User', id: 'bearer-bob')
    ..audience = cedar_proto.EntityUid(type: 'Service', id: 'celest-cloud')
    ..issuedAt = DateTime.utc(2024, 1, 1, 0, 0, 0)
    ..notAfter = DateTime.utc(2024, 1, 1, 1, 0, 0);

  final unsigned = builder.build();
  final signer = Signer(keyId, masterKey);
  return unsigned.sign(signer);
}

Cork _tamperSignature(Cork cork) {
  final proto = cork.toProto();
  final signature = proto.tailSignature.toList();
  signature[0] = signature[0] ^ 0xFF;
  proto.tailSignature = signature;
  return Cork.fromProto(proto);
}

Map<String, Object?> _vectorEntry({
  required String name,
  required String description,
  required String signerName,
  required Cork cork,
  required Uint8List expectedSignature,
  required bool signatureValid,
}) {
  final protoJson = jsonDecode(
    jsonEncode(cork.toProto().toProto3Json(typeRegistry: typeRegistry)),
  );

  return {
    'name': name,
    'description': description,
    'signer': signerName,
    'token': cork.toString(),
    'tailSignature': {
      'actual': base64Encode(cork.tailSignature),
      'expected': base64Encode(expectedSignature),
    },
    'expect': {'signatureValid': signatureValid},
    'proto': protoJson,
  };
}
