import 'dart:convert';

import 'package:args/command_runner.dart';
import 'package:corks_cedar/src/cli/utils.dart';
import 'package:corks_cedar/src/cork.dart';
import 'package:corks_cedar/src/discharge.dart';
import 'package:corks_cedar/src/exceptions.dart';

class InspectCommand extends Command<int> {
  InspectCommand(this._stdout, this._stderr) {
    argParser
      ..addOption(
        'token',
        abbr: 't',
        help: 'Base64-encoded cork or discharge token to inspect.',
      )
      ..addOption(
        'file',
        abbr: 'f',
        help: 'Path to a file containing the token; use "-" for stdin.',
      )
      ..addFlag(
        'json',
        help: 'Emit the inspection result as JSON.',
        defaultsTo: false,
      );
  }

  final StringSink _stdout;
  final StringSink _stderr;

  @override
  String get name => 'inspect';

  @override
  String get description =>
      'Inspect cork or discharge tokens and print the caveat chain.';

  @override
  Future<int> run() async {
    try {
      final token = await readToken(
        argResults!,
        tokenOption: 'token',
        fileOption: 'file',
      );
      if (token.isEmpty) {
        throw UsageException('Token payload was empty.', usage);
      }

      final outputJson = argResults!['json'] as bool? ?? false;

      try {
        final cork = Cork.parse(token);
        final summary = corkSummary(cork);
        _emitSummary(summary, outputJson);
        return 0;
      } on InvalidCorkException {
        // Fall through and try parsing as a discharge.
      }

      try {
        final discharge = Discharge.parse(token);
        final summary = dischargeSummary(discharge);
        _emitSummary(summary, outputJson);
        return 0;
      } on InvalidCorkException catch (error) {
        _stderr.writeln('Failed to parse token: ${error.message}');
        return 1;
      }
    } on UsageException {
      rethrow;
    } on Exception catch (error) {
      _stderr.writeln('Error: $error');
      return 1;
    }
  }

  void _emitSummary(Map<String, Object?> summary, bool asJson) {
    if (asJson) {
      final encoder = const JsonEncoder.withIndent('  ');
      _stdout.writeln(encoder.convert(summary));
      return;
    }

    final type = summary['type'];
    _stdout.writeln('Type: $type');
    _stdout.writeln('Version: ${summary['version']}');

    final keyId = summary['keyId'] as Map<String, Object?>?;
    if (keyId != null) {
      _stdout.writeln('Key ID: ${_formatBytes(keyId)}');
    }

    if (summary.containsKey('nonce')) {
      final nonce = summary['nonce'] as Map<String, Object?>?;
      if (nonce != null) {
        _stdout.writeln('Nonce: ${_formatBytes(nonce)}');
      }
    }

    if (summary.containsKey('parentCaveatId')) {
      final parent = summary['parentCaveatId'] as Map<String, Object?>?;
      if (parent != null) {
        _stdout.writeln('Parent Caveat ID: ${_formatBytes(parent)}');
      }
    }

    _writeJsonBlock('Issuer', summary['issuer']);
    _writeJsonBlock('Bearer', summary['bearer']);
    _writeJsonBlock('Audience', summary['audience']);
    _writeJsonBlock('Claims', summary['claims']);

    final issuedAt = summary['issuedAt'] as Map<String, Object?>?;
    if (issuedAt != null) {
      _stdout.writeln(
        'Issued At: ${issuedAt['iso8601']} (epoch: ${issuedAt['epochMillis']})',
      );
    }
    final notAfter = summary['notAfter'] as Map<String, Object?>?;
    if (notAfter != null) {
      _stdout.writeln(
        'Not After: ${notAfter['iso8601']} (epoch: ${notAfter['epochMillis']})',
      );
    }

    final caveats = summary['caveats'] as List<Object?>? ?? const <Object?>[];
    if (caveats.isEmpty) {
      _stdout.writeln('Caveats: none');
      return;
    }

    _stdout.writeln('Caveats:');
    for (final entry in caveats) {
      if (entry is! Map<String, Object?>) {
        continue;
      }
      final index = entry['index'];
      final type = entry['type'] ?? 'unknown';
      _stdout.writeln('  [$index] $type');
      final caveatId = entry['caveatId'] as Map<String, Object?>?;
      if (caveatId != null) {
        _stdout.writeln('    ID: ${_formatBytes(caveatId)}');
      }
      final namespace = entry['namespace'];
      final predicate = entry['predicate'];
      if (namespace != null || predicate != null) {
        _stdout.writeln('    Predicate: $namespace::$predicate');
      }
      final payload = entry['payload'];
      if (payload != null) {
        _writeJsonBlock('    Payload', payload, indent: 4);
      }
      final location = entry['location'];
      if (location != null) {
        _stdout.writeln('    Location: $location');
      }
      final ticket = entry['ticket'] as Map<String, Object?>?;
      if (ticket != null) {
        _stdout.writeln(
          '    Ticket: ${_formatBytes(ticket, preferBase64: true)}',
        );
      }
      final challenge = entry['challenge'] as Map<String, Object?>?;
      if (challenge != null) {
        _stdout.writeln(
          '    Challenge: ${_formatBytes(challenge, preferBase64: true)}',
        );
      }
      final salt = entry['salt'] as Map<String, Object?>?;
      if (salt != null) {
        _stdout.writeln('    Salt: ${_formatBytes(salt)}');
      }
    }
  }

  void _writeJsonBlock(String label, Object? value, {int indent = 2}) {
    if (value == null) {
      return;
    }
    final formatted = _formatJsonValue(value);
    final indentPrefix = ' ' * indent;
    final lines = formatted.split('\n');
    _stdout.writeln('$label:');
    for (final line in lines) {
      _stdout.writeln('$indentPrefix$line');
    }
  }

  String _formatBytes(
    Map<String, Object?> encodings, {
    bool preferBase64 = false,
  }) {
    final length = encodings['length'];
    final value = preferBase64 ? encodings['base64'] : encodings['hex'];
    return '$value (${length ?? 'unknown'} bytes)';
  }

  String _formatJsonValue(Object value) {
    if (value is Map || value is Iterable) {
      return const JsonEncoder.withIndent('  ').convert(value);
    }
    return value.toString();
  }
}
