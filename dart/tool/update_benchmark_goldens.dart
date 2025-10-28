import 'dart:convert';
import 'dart:io';

import '../benchmarks/cork_benchmarks.dart' as cork_benchmarks;

/// Runs the cork benchmark suite and writes the results to a JSON golden file.
Future<void> main(List<String> args) async {
  final results = await cork_benchmarks.runCorkBenchmarks();
  final sortedKeys = results.keys.toList()..sort();
  final ordered = <String, double>{
    for (final key in sortedKeys)
      key: double.parse(results[key]!.toStringAsFixed(6)),
  };

  final encoder = const JsonEncoder.withIndent('  ');
  final file = File('benchmarks/cork_benchmarks_golden.json');
  await file.create(recursive: true);
  await file.writeAsString('${encoder.convert(ordered)}\n');

  stdout.writeln('Wrote benchmark goldens to ${file.path}');
}
