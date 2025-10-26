import 'dart:collection';
import 'dart:convert';
import 'dart:typed_data';

import 'package:fixnum/fixnum.dart';

import 'cork.dart';
import 'discharge.dart';
import 'exceptions.dart';
import 'proto/celest/corks/v1/cork.pb.dart' as corksv1;

/// Transport responsible for contacting a third-party discharge endpoint.
typedef ThirdPartyDischargeTransport =
    Future<Discharge> Function(
      Uri location,
      Uint8List ticket,
      Map<String, Object?> metadata,
      corksv1.ThirdPartyCaveat caveat,
    );

final class ThirdPartyDischargeClient {
  ThirdPartyDischargeClient({
    required ThirdPartyDischargeTransport transport,
    Duration? cacheTtl,
    DateTime Function()? now,
  }) : _transport = transport,
       _cacheTtl = cacheTtl,
       _now = now ?? DateTime.now;

  final ThirdPartyDischargeTransport _transport;
  final Duration? _cacheTtl;
  final DateTime Function() _now;
  final Map<String, _CacheEntry> _cache = HashMap<String, _CacheEntry>();

  /// Fetches discharges for every third-party caveat found in [cork].
  ///
  /// The optional [metadataResolver] allows attaching request-specific context
  /// per caveat. When omitted, [metadata] is applied to all requests.
  Future<Map<String, Discharge>> fetchDischarges(
    Cork cork, {
    Map<String, Object?> metadata = const <String, Object?>{},
    Map<String, Object?> Function(corksv1.ThirdPartyCaveat caveat)?
    metadataResolver,
  }) async {
    final caveats = cork.caveats.where((c) => c.hasThirdParty()).toList();
    if (caveats.isEmpty) {
      return const <String, Discharge>{};
    }

    final now = _now().toUtc();
    final results = <String, Discharge>{};

    for (final caveat in caveats) {
      final key = _cacheKey(caveat);
      final cached = _cache[key];
      if (cached != null && !cached.isExpired(now)) {
        results[_encodeId(caveat.caveatId)] = cached.discharge;
        continue;
      }

      final location = _parseLocation(caveat.thirdParty.location);
      final perRequestMetadata =
          metadataResolver?.call(caveat.thirdParty) ?? metadata;

      final discharge = await _transport(
        location,
        Uint8List.fromList(caveat.thirdParty.ticket),
        Map<String, Object?>.unmodifiable(perRequestMetadata),
        caveat.thirdParty,
      );

      _cache[key] = _CacheEntry(discharge, _expiryFor(discharge, now));
      results[_encodeId(caveat.caveatId)] = discharge;
    }

    return results;
  }

  /// Clears all cached discharges.
  void clearCache() => _cache.clear();

  /// Number of cached discharge entries.
  int get cacheSize => _cache.length;

  DateTime? _expiryFor(Discharge discharge, DateTime now) {
    DateTime? expiry;
    final ttl = _cacheTtl;
    if (ttl != null) {
      expiry = now.add(ttl);
    }

    final notAfter = discharge.notAfter;
    if (notAfter != null && notAfter != Int64.ZERO) {
      final dischargeExpiry = DateTime.fromMillisecondsSinceEpoch(
        notAfter.toInt(),
        isUtc: true,
      );
      expiry = expiry == null
          ? dischargeExpiry
          : (dischargeExpiry.isBefore(expiry) ? dischargeExpiry : expiry);
    }

    return expiry;
  }

  String _cacheKey(corksv1.Caveat caveat) {
    final thirdParty = caveat.thirdParty;
    final id = _encodeId(caveat.caveatId);
    final ticket = _encodeId(thirdParty.ticket);
    return '${caveat.thirdParty.location}|$id|$ticket';
  }

  Uri _parseLocation(String value) {
    final uri = Uri.tryParse(value);
    final isValid = uri != null && uri.hasScheme && uri.host.isNotEmpty;
    if (!isValid) {
      throw InvalidCorkException(
        'invalid discharge location "$value" (expected absolute URI)',
      );
    }
    if (uri.scheme != 'https') {
      throw InvalidCorkException(
        'invalid discharge location "$value" (must use https scheme)',
      );
    }
    return uri;
  }

  String _encodeId(List<int> bytes) =>
      base64UrlEncode(Uint8List.fromList(bytes)).replaceAll('=', '');
}

class _CacheEntry {
  _CacheEntry(this.discharge, this.expiresAt);

  final Discharge discharge;
  final DateTime? expiresAt;

  bool isExpired(DateTime now) => expiresAt != null && !expiresAt!.isAfter(now);
}
