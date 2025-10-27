import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:corks_cedar/corks_cedar.dart';
import 'package:corks_cedar/src/proto/celest/corks/v1/cork.pb.dart' as corksv1;
import 'package:corks_cedar/src/proto/google/protobuf/wrappers.pb.dart'
    as wrappers;
import 'package:http/http.dart' as http;

final Uint8List _fleetKeyId = Uint8List.fromList(
  List<int>.generate(16, (i) => i),
);
final Uint8List _sharedSecret = Uint8List.fromList(
  List<int>.generate(32, (i) => 0x20 + i),
);

final SharedSecretTicketCodec _codec = SharedSecretTicketCodec(
  sharedSecret: _sharedSecret,
);
final Random _random = Random.secure();

Future<void> main(List<String> arguments) async {
  final command = arguments.isEmpty ? 'sso' : arguments.first;
  final httpClient = http.Client();
  final dischargeClient = ThirdPartyDischargeClient(
    transport: _httpTransport(httpClient),
    cacheTtl: const Duration(minutes: 5),
  );

  try {
    switch (command) {
      case 'sso':
        await _runSso(dischargeClient);
        break;
      case 'audit':
        await _runAudit(dischargeClient);
        break;
      case 'both':
        await _runBoth(dischargeClient);
        break;
      default:
        _printUsage();
        exitCode = 64;
    }
  } finally {
    httpClient.close();
  }
}

ThirdPartyDischargeTransport _httpTransport(http.Client client) {
  return (
    Uri location,
    Uint8List ticket,
    Map<String, Object?> metadata,
    corksv1.ThirdPartyCaveat caveat,
  ) async {
    final response = await client.post(
      location,
      headers: {'content-type': 'application/json'},
      body: jsonEncode({
        'ticket': base64Url.encode(ticket).replaceAll('=', ''),
        if (metadata.isNotEmpty) 'metadata': metadata,
      }),
    );

    if (response.statusCode != 200) {
      throw InvalidCorkException(
        'third-party returned ${response.statusCode}: ${response.body}',
      );
    }

    final payload = jsonDecode(response.body) as Map<String, Object?>;
    final dischargeToken = payload['discharge'] as String?;
    if (dischargeToken == null || dischargeToken.isEmpty) {
      throw const InvalidCorkException('response missing discharge token');
    }
    return Discharge.parse(dischargeToken);
  };
}

Future<void> _runSso(ThirdPartyDischargeClient client) async {
  print('Requesting SSO discharge...');

  final metadata = <String, Object?>{
    'session_id': 'sess-${DateTime.now().millisecondsSinceEpoch}',
    'session_version': 42,
  };

  final requestContext = <String, Object?>{'ip_address': '203.0.113.5'};

  await _fetchAndVerify(
    client: client,
    plans: [
      _CaveatPlan(
        label: 'sso',
        location: 'http://localhost:8080/sso:issue',
        ticketMetadata: metadata,
        ticketNotAfter: DateTime.now().toUtc().add(const Duration(minutes: 5)),
      ),
    ],
    requestMetadata: requestContext,
  );
}

Future<void> _runAudit(ThirdPartyDischargeClient client) async {
  print('Requesting audit discharge...');

  final metadata = <String, Object?>{
    'resource': 'projects/example-stack',
    'actions': ['list', 'describe'],
  };

  await _fetchAndVerify(
    client: client,
    plans: [
      _CaveatPlan(
        label: 'audit',
        location: 'http://localhost:8080/audit:issue',
        ticketMetadata: metadata,
        ticketNotAfter: DateTime.now().toUtc().add(const Duration(minutes: 5)),
      ),
    ],
  );
}

Future<void> _runBoth(ThirdPartyDischargeClient client) async {
  print('Requesting SSO and audit discharges...');

  final now = DateTime.now().toUtc();

  await _fetchAndVerify(
    client: client,
    plans: [
      _CaveatPlan(
        label: 'sso',
        location: 'http://localhost:8080/sso:issue',
        ticketMetadata: {
          'session_id': 'sess-${DateTime.now().millisecondsSinceEpoch}',
          'session_version': 1,
        },
        ticketNotAfter: now.add(const Duration(minutes: 5)),
      ),
      _CaveatPlan(
        label: 'audit',
        location: 'http://localhost:8080/audit:issue',
        ticketMetadata: {
          'resource': 'projects/example-stack',
          'actions': ['list', 'describe'],
        },
        ticketNotAfter: now.add(const Duration(minutes: 7)),
      ),
    ],
    requestMetadata: {'ip_address': '203.0.113.5'},
  );
}

class _CaveatPlan {
  const _CaveatPlan({
    required this.label,
    required this.location,
    required this.ticketMetadata,
    this.ticketNotAfter,
  });

  final String label;
  final String location;
  final Map<String, Object?> ticketMetadata;
  final DateTime? ticketNotAfter;
}

Future<void> _fetchAndVerify({
  required ThirdPartyDischargeClient client,
  required List<_CaveatPlan> plans,
  Map<String, Object?> requestMetadata = const <String, Object?>{},
}) async {
  if (plans.isEmpty) {
    throw ArgumentError('At least one caveat plan is required');
  }

  final builder = _createBaseBuilder();
  final planByLocation = <String, _CaveatPlan>{};
  for (final plan in plans) {
    planByLocation[plan.location] = plan;
    final options = _codec.createOptions(
      location: plan.location,
      tag: _randomBytes(32),
      metadata: plan.ticketMetadata,
      notAfter:
          plan.ticketNotAfter ??
          DateTime.now().toUtc().add(const Duration(minutes: 5)),
    );
    await builder.appendThirdPartyCaveat(options);
  }

  final cork = builder.build();
  final decodedTickets = <String, DecodedDischargeTicket>{};
  final labelById = <String, String>{};
  final locationById = <String, String>{};

  for (final caveat in cork.caveats.where((c) => c.hasThirdParty())) {
    final plan = planByLocation[caveat.thirdParty.location];
    if (plan == null) {
      continue;
    }
    final id = _encodeId(caveat.caveatId);
    locationById[id] = caveat.thirdParty.location;
    labelById[id] = plan.label;
    decodedTickets[id] = await _codec.decode(caveat.thirdParty.ticket);
  }

  if (decodedTickets.length != plans.length) {
    throw StateError(
      'expected ${plans.length} third-party caveat(s) but decoded ${decodedTickets.length}',
    );
  }

  final discharges = await client.fetchDischarges(
    cork,
    metadata: requestMetadata,
  );

  if (discharges.isEmpty) {
    throw StateError('no discharges returned');
  }

  print('Verifying ${discharges.length} discharge(s)...');
  for (final entry in discharges.entries) {
    final decoded = decodedTickets[entry.key];
    if (decoded == null) {
      throw StateError('missing decoded ticket for caveat ${entry.key}');
    }
    entry.value.verify(caveatRootKey: decoded.caveatRootKey);
    final label = labelById[entry.key] ?? 'caveat ${entry.key}';
    final location = locationById[entry.key] ?? '<unknown>';
    print('  - $label ($location): discharge=${entry.value.toString()}');
  }

  print('All discharges verified.');
}

CorkBuilder _createBaseBuilder() {
  return CorkBuilder(_fleetKeyId)
    ..issuer = wrappers.StringValue(value: 'celest::example::issuer')
    ..bearer = wrappers.StringValue(value: 'users/alice')
    ..notAfter = DateTime.now().toUtc().add(const Duration(minutes: 10));
}

Uint8List _randomBytes(int length) {
  final values = List<int>.generate(length, (_) => _random.nextInt(256));
  return Uint8List.fromList(values);
}

String _encodeId(List<int> bytes) {
  return base64Url.encode(Uint8List.fromList(bytes)).replaceAll('=', '');
}

void _printUsage() {
  print('Usage: dart run bin/client.dart <command>');
  print('Commands:');
  print('  sso    Issue a discharge for the SSO third-party caveat');
  print('  audit  Issue a discharge for the audit logging caveat');
  print('  both   Issue discharges for SSO and audit caveats together');
}
