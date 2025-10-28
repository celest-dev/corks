import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:corks_cedar/corks_cedar.dart';
import 'package:corks_cedar/src/proto/celest/corks/v1/cork.pb.dart' as corksv1;
import 'package:corks_cedar/src/proto/google/protobuf/wrappers.pb.dart'
    as wrappers;
import 'package:fixnum/fixnum.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';

final Uint8List _sharedSecret = Uint8List.fromList(
  List<int>.generate(32, (i) => 0x20 + i),
);
final Uint8List _dischargeKeyId = Uint8List.fromList(
  List<int>.generate(16, (i) => 0xA0 + i),
);

final SharedSecretTicketCodec _codec = SharedSecretTicketCodec(
  sharedSecret: _sharedSecret,
);

final ThirdPartyDischargeService _ssoService = ThirdPartyDischargeService(
  decoder: _codec.decoder,
  issuer: wrappers.StringValue(value: 'celest::third-party::sso'),
  keyId: _dischargeKeyId,
  onBuild: (builder, decoded, request) {
    final sessionId = decoded.metadata['session_id'] as String?;
    final sessionVersion = decoded.metadata['session_version'] as int? ?? 0;
    if (sessionId == null || sessionId.isEmpty) {
      throw const InvalidCorkException('ticket missing session_id');
    }
    final state = corksv1.SessionState()
      ..sessionId = sessionId
      ..version = Int64(sessionVersion);
    builder.appendFirstPartyCaveat(
      namespace: 'celest.auth',
      predicate: 'session_state',
      payload: state,
    );
  },
);

final ThirdPartyDischargeService _auditService = ThirdPartyDischargeService(
  decoder: _codec.decoder,
  issuer: wrappers.StringValue(value: 'celest::third-party::audit'),
  keyId: _dischargeKeyId,
  onBuild: (builder, decoded, request) {
    final actions =
        (decoded.metadata['actions'] as List<Object?>?)
            ?.whereType<String>()
            .toList(growable: false) ??
        const <String>[];
    if (actions.isNotEmpty) {
      builder.appendFirstPartyCaveat(
        namespace: 'celest.audit',
        predicate: 'actions',
        payload: corksv1.ActionScope()..actions.addAll(actions),
      );
    }
    final resource = decoded.metadata['resource'] as String?;
    if (resource != null) {
      builder.appendFirstPartyCaveat(
        namespace: 'celest.audit',
        predicate: 'resource',
        payload: wrappers.StringValue(value: resource),
      );
    }
  },
);

Future<void> main(List<String> args) async {
  final router = Router()
    ..post('/sso%3Aissue', (request) => _handleDischarge(request, _ssoService))
    ..post(
      '/audit%3Aissue',
      (request) => _handleDischarge(request, _auditService),
    );

  final handler = const Pipeline()
      .addMiddleware(logRequests())
      .addHandler(router.call);
  final server = await serve(handler, 'localhost', 8080);
  print('Third-party discharge service listening on port ${server.port}');
}

Future<Response> _handleDischarge(
  Request request,
  ThirdPartyDischargeService service,
) async {
  try {
    final body = await request.readAsString();
    final payload = jsonDecode(body) as Map<String, Object?>;
    final ticket = _decodeTicket(payload['ticket']);
    final metadata =
        (payload['metadata'] as Map<String, Object?>?) ??
        const <String, Object?>{};

    final discharge = await service.issue(
      ThirdPartyDischargeRequest(ticket: ticket, metadata: metadata),
    );

    return Response.ok(
      jsonEncode({'discharge': discharge.toString()}),
      headers: {'content-type': 'application/json'},
    );
  } on InvalidCorkException catch (error) {
    return Response(
      400,
      body: jsonEncode({'error': error.message}),
      headers: {'content-type': 'application/json'},
    );
  } on Object catch (error, stackTrace) {
    stderr.writeln('discharge failed: $error');
    stderr.writeln(stackTrace);
    return Response.internalServerError(
      body: jsonEncode({'error': error.toString()}),
    );
  }
}

Uint8List _decodeTicket(Object? value) {
  if (value is! String || value.isEmpty) {
    throw const InvalidCorkException('ticket payload missing');
  }
  final normalized = base64Url.normalize(value);
  return Uint8List.fromList(base64Url.decode(normalized));
}
