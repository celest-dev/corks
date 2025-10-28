import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:corks_cedar/src/proto.dart';
import 'package:corks_cedar/src/proto/celest/corks/v1/cork.pb.dart' as corksv1;
import 'package:corks_cedar/src/proto/google/protobuf/any.pb.dart' as anypb;

import '../cork.dart';
import '../discharge.dart';

final JsonEncoder _prettyJson = const JsonEncoder.withIndent('  ');

String bytesToHex(List<int> bytes) {
  final buffer = StringBuffer();
  for (final byte in bytes) {
    buffer.write(byte.toRadixString(16).padLeft(2, '0'));
  }
  return buffer.toString();
}

String bytesToBase64(List<int> bytes) =>
    base64Url.encode(bytes).replaceAll('=', '');

String formatTimestamp(int millis) {
  final instant = DateTime.fromMillisecondsSinceEpoch(millis, isUtc: true);
  return instant.toIso8601String();
}

Object? anyToJson(anypb.Any? message) {
  if (message == null || message.value.isEmpty) {
    return null;
  }
  try {
    return message.toProto3Json(typeRegistry: typeRegistry);
  } on ArgumentError catch (_) {
    return <String, Object?>{
      '@type': message.typeUrl,
      'valueBase64': bytesToBase64(message.value),
    };
  }
}

String formatAny(anypb.Any? message) {
  final json = anyToJson(message);
  if (json == null) {
    return 'n/a';
  }
  if (json is String) {
    return json;
  }
  return _prettyJson.convert(json);
}

Map<String, Object?> corkSummary(Cork cork) {
  final proto = cork.toProto();
  return <String, Object?>{
    'type': 'cork',
    'version': proto.version,
    'keyId': _byteEncodings(proto.keyId),
    'nonce': _byteEncodings(proto.nonce),
    'issuer': anyToJson(proto.hasIssuer() ? proto.issuer : null),
    'bearer': anyToJson(proto.hasBearer() ? proto.bearer : null),
    'audience': anyToJson(proto.hasAudience() ? proto.audience : null),
    'claims': anyToJson(proto.hasClaims() ? proto.claims : null),
    'issuedAt': _timestamp(proto.issuedAt.toInt()),
    if (proto.hasNotAfter() && proto.notAfter != 0)
      'notAfter': _timestamp(proto.notAfter.toInt()),
    'caveats': _caveatSummaries(proto.caveats),
  };
}

Map<String, Object?> dischargeSummary(Discharge discharge) {
  final proto = discharge.toProto();
  return <String, Object?>{
    'type': 'discharge',
    'version': proto.version,
    'keyId': _byteEncodings(proto.keyId),
    'nonce': _byteEncodings(proto.nonce),
    'parentCaveatId': _byteEncodings(proto.parentCaveatId),
    'issuer': anyToJson(proto.hasIssuer() ? proto.issuer : null),
    'issuedAt': _timestamp(proto.issuedAt.toInt()),
    if (proto.hasNotAfter() && proto.notAfter != 0)
      'notAfter': _timestamp(proto.notAfter.toInt()),
    'caveats': _caveatSummaries(proto.caveats),
  };
}

List<Map<String, Object?>> _caveatSummaries(Iterable<corksv1.Caveat> caveats) {
  final entries = <Map<String, Object?>>[];
  var index = 0;
  for (final caveat in caveats) {
    final entry = <String, Object?>{
      'index': index,
      'caveatId': _byteEncodings(caveat.caveatId),
      'version': caveat.caveatVersion,
    };
    if (caveat.hasFirstParty()) {
      entry['type'] = 'first-party';
      entry['namespace'] = caveat.firstParty.namespace;
      entry['predicate'] = caveat.firstParty.predicate;
      if (caveat.firstParty.hasPayload()) {
        entry['payload'] = anyToJson(caveat.firstParty.payload);
      }
    } else if (caveat.hasThirdParty()) {
      final third = caveat.thirdParty;
      entry['type'] = 'third-party';
      entry['location'] = third.location;
      entry['ticket'] = _byteEncodings(third.ticket);
      entry['challenge'] = _byteEncodings(third.challenge);
      if (third.hasSalt() && third.salt.isNotEmpty) {
        entry['salt'] = _byteEncodings(third.salt);
      }
    }
    entries.add(entry);
    index++;
  }
  return entries;
}

Map<String, Object?> _timestamp(int millis) => <String, Object?>{
  'epochMillis': millis,
  'iso8601': formatTimestamp(millis),
};

Map<String, Object?> _byteEncodings(List<int> value) => <String, Object?>{
  'hex': bytesToHex(value),
  'base64': bytesToBase64(value),
  'length': value.length,
};

Future<String> readToken(
  ArgResults argResults, {
  required String tokenOption,
  required String fileOption,
}) async {
  final tokenValue = argResults[tokenOption] as String?;
  final filePath = argResults[fileOption] as String?;

  final providedToken = tokenValue != null && tokenValue.trim().isNotEmpty;
  final providedFile = filePath != null && filePath.trim().isNotEmpty;

  if (providedToken == providedFile) {
    throw UsageException(
      'Provide exactly one of --$tokenOption or --$fileOption.',
      '',
    );
  }

  if (providedToken) {
    return tokenValue.trim();
  }

  final path = filePath!.trim();
  if (path == '-') {
    return stdin.readLineSync()?.trim() ?? '';
  }

  final file = File(path);
  if (!await file.exists()) {
    throw UsageException('Token file not found: $path', '');
  }
  return (await file.readAsString()).trim();
}

Uint8List decodeKey(String input, {required String encoding}) {
  final normalized = input.replaceAll(RegExp(r'\s+'), '');
  switch (encoding) {
    case 'hex':
      if (normalized.length.isOdd) {
        throw FormatException('Hex input must have an even length');
      }
      final bytes = Uint8List(normalized.length ~/ 2);
      for (var i = 0; i < bytes.length; i++) {
        final start = i * 2;
        final value = normalized.substring(start, start + 2);
        bytes[i] = int.parse(value, radix: 16);
      }
      return bytes;
    case 'base64':
      final padded = base64Url.normalize(normalized);
      return Uint8List.fromList(base64Url.decode(padded));
    default:
      throw FormatException('Unsupported encoding: $encoding');
  }
}

Map<String, Discharge> parseDischarges(Iterable<String> sources) {
  final discharges = <String, Discharge>{};
  for (final raw in sources) {
    final trimmed = raw.trim();
    if (trimmed.isEmpty) {
      continue;
    }
    final discharge = Discharge.parse(trimmed);
    final parentId = bytesToBase64(discharge.parentCaveatId);
    discharges[parentId] = discharge;
  }
  return discharges;
}

Future<List<String>> readDischargeFiles(Iterable<String> paths) async {
  final tokens = <String>[];
  for (final path in paths) {
    final trimmed = path.trim();
    if (trimmed.isEmpty) {
      continue;
    }
    final file = File(trimmed);
    if (!await file.exists()) {
      throw UsageException('Discharge file not found: $trimmed', '');
    }
    tokens.add((await file.readAsString()).trim());
  }
  return tokens;
}
