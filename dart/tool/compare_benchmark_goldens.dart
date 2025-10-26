import 'dart:convert';
import 'dart:io';

import '../benchmarks/cork_benchmarks.dart' as cork_benchmarks;

/// Maximum allowed relative drift before flagging a regression.
const double _relativeThreshold = 0.10; // 10%

/// Maximum allowed absolute drift (microseconds) to catch tiny benches.
const double _absoluteThreshold = 1.0;

Future<void> main(List<String> args) async {
  final goldenFile = File('benchmarks/cork_benchmarks_golden.json');
  if (!goldenFile.existsSync()) {
    stderr.writeln('Missing golden file at ${goldenFile.path}.');
    exitCode = 1;
    return;
  }

  final goldenJson = jsonDecode(await goldenFile.readAsString()) as Map;
  final golden = goldenJson.map<String, double>(
    (key, value) => MapEntry(key as String, (value as num).toDouble()),
  );

  final current = await cork_benchmarks.runCorkBenchmarks();

  final allKeys = <String>{...golden.keys, ...current.keys}.toList()..sort();
  const header =
      'Benchmark                              Baseline   Current   Δ (µs)   Δ%     Status';
  stdout.writeln(header);
  stdout.writeln('-' * header.length);
  for (final key in allKeys) {
    final baseline = golden[key];
    final measurement = current[key];
    if (baseline == null || measurement == null) {
      stdout.writeln(key.padRight(36) + _formatOptional(baseline, measurement));
      continue;
    }

    final delta = measurement - baseline;
    final absDelta = delta.abs();
    final relDelta = baseline == 0 ? double.infinity : absDelta / baseline;
    final status = _classify(absDelta, relDelta);

    stdout.writeln(
      '${key.padRight(36)}${baseline.toStringAsFixed(3).padLeft(10)}'
      '${measurement.toStringAsFixed(3).padLeft(10)}${_formatSigned(delta).padLeft(9)}'
      '${(relDelta * 100).toStringAsFixed(2).padLeft(7)}%   $status',
    );
  }
}

String _classify(double absDelta, double relDelta) {
  if (absDelta <= _absoluteThreshold || relDelta <= _relativeThreshold) {
    return 'within threshold';
  }
  return 'exceeds threshold';
}

String _formatSigned(double value) {
  final sign = value >= 0 ? '+' : '-';
  return '$sign${value.abs().toStringAsFixed(3)}';
}

String _formatOptional(double? baseline, double? measurement) {
  final baseText = baseline == null ? 'n/a' : baseline.toStringAsFixed(3);
  final currentText = measurement == null
      ? 'n/a'
      : measurement.toStringAsFixed(3);
  final note = baseline == null
      ? 'new benchmark'
      : 'missing current measurement';
  return '${baseText.padLeft(10)}${currentText.padLeft(10)}   $note';
}
