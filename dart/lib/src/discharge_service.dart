import 'dart:async';
import 'dart:typed_data';

import 'package:protobuf/protobuf.dart';

import 'discharge.dart';
import 'exceptions.dart';
import 'proto/celest/corks/v1/cork.pb.dart' as corksv1;

/// Immutable request passed to the discharge service when issuing a token.
final class ThirdPartyDischargeRequest {
  ThirdPartyDischargeRequest({
    required List<int> ticket,
    Map<String, Object?>? metadata,
  }) : ticket = Uint8List.fromList(ticket),
       metadata = metadata == null
           ? const <String, Object?>{}
           : Map.unmodifiable(Map<String, Object?>.from(metadata));

  /// AEAD-protected ticket generated when the cork was attenuated.
  final Uint8List ticket;

  /// Optional request-specific context (e.g., HTTP headers, user identity).
  final Map<String, Object?> metadata;
}

/// Result of decrypting the third-party ticket.
final class DecodedDischargeTicket {
  DecodedDischargeTicket({
    required List<int> caveatId,
    required List<int> caveatRootKey,
    Iterable<corksv1.Caveat>? caveats,
    DateTime? notAfter,
    Map<String, Object?>? metadata,
  }) : caveatId = Uint8List.fromList(caveatId),
       caveatRootKey = Uint8List.fromList(caveatRootKey),
       caveats = List<corksv1.Caveat>.unmodifiable(
         (caveats ?? const <corksv1.Caveat>[]).map(
           (caveat) => caveat.deepCopy(),
         ),
       ),
       notAfter = notAfter?.toUtc(),
       metadata = metadata == null
           ? const <String, Object?>{}
           : Map.unmodifiable(Map<String, Object?>.from(metadata)) {
    if (this.caveatId.isEmpty) {
      throw const InvalidCorkException('ticket missing caveat id');
    }
    if (this.caveatRootKey.isEmpty) {
      throw const InvalidCorkException('ticket missing caveat root key');
    }
  }

  /// Identifier for the originating third-party caveat.
  final Uint8List caveatId;

  /// Derived caveat root key shared with the verifier.
  final Uint8List caveatRootKey;

  /// Optional caveats injected by the attenuator.
  final List<corksv1.Caveat> caveats;

  /// Optional expiry bound extracted from the ticket.
  final DateTime? notAfter;

  /// Arbitrary metadata exposed to hooks (e.g., desired audience).
  final Map<String, Object?> metadata;
}

/// Signature for decrypting third-party tickets.
typedef DischargeTicketDecoder =
    FutureOr<DecodedDischargeTicket> Function(Uint8List ticket);

/// Hook invoked before the discharge is signed to attach additional caveats.
typedef DischargeBuilderHook =
    FutureOr<void> Function(
      DischargeBuilder builder,
      DecodedDischargeTicket ticket,
      ThirdPartyDischargeRequest request,
    );

/// Template service that decrypts tickets and issues discharge macaroons.
final class ThirdPartyDischargeService {
  ThirdPartyDischargeService({
    required DischargeTicketDecoder decoder,
    required GeneratedMessage issuer,
    required List<int> keyId,
    DateTime Function()? now,
    DischargeBuilderHook? onBuild,
  }) : _decoder = decoder,
       _issuer = issuer.deepCopy(),
       _keyId = Uint8List.fromList(keyId),
       _now = now ?? DateTime.now,
       _onBuild = onBuild;

  final DischargeTicketDecoder _decoder;
  final GeneratedMessage _issuer;
  final Uint8List _keyId;
  final DateTime Function() _now;
  final DischargeBuilderHook? _onBuild;

  /// Issues a signed discharge for the provided [request].
  Future<Discharge> issue(ThirdPartyDischargeRequest request) async {
    final decoded = await Future.sync(() => _decoder(request.ticket));

    final builder = DischargeBuilder(
      parentCaveatId: decoded.caveatId,
      caveatRootKey: decoded.caveatRootKey,
      keyId: _keyId,
      issuer: _issuer,
    )..issuedAt = _now().toUtc();

    if (decoded.notAfter != null) {
      builder.notAfter = decoded.notAfter;
    }

    for (final caveat in decoded.caveats) {
      builder.addCaveat(caveat);
    }

    final hook = _onBuild;
    if (hook != null) {
      await Future.sync(() => hook(builder, decoded, request));
    }

    return builder.build();
  }
}
