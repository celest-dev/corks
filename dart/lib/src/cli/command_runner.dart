import 'dart:async';
import 'dart:io' as io;

import 'package:args/command_runner.dart';

import 'inspect_command.dart';
import 'verify_command.dart';

class CorksCommandRunner extends CommandRunner<int> {
  CorksCommandRunner({StringSink? stdout, StringSink? stderr})
    : _stdout = stdout ?? io.stdout,
      _stderr = stderr ?? io.stderr,
      super('corks', 'Celest cork tooling for inspection and verification.') {
    addCommand(InspectCommand(_stdout, _stderr));
    addCommand(VerifyCommand(_stdout, _stderr));
  }

  final StringSink _stdout;
  final StringSink _stderr;

  @override
  Future<int> run(Iterable<String> args) async {
    try {
      final result = await super.run(args);
      return result ?? 0;
    } on UsageException catch (error) {
      _stderr.writeln(error.message);
      if (error.usage.isNotEmpty) {
        _stderr.writeln();
        _stderr.writeln(error.usage);
      }
      return 64;
    }
  }
}

Future<int> runCorksCommand(
  List<String> args, {
  StringSink? stdout,
  StringSink? stderr,
}) async {
  final runner = CorksCommandRunner(stdout: stdout, stderr: stderr);
  try {
    return await runner.run(args);
  } on UsageException {
    // Already reported by the overridden run.
    return 64;
  } catch (error) {
    (stderr ?? io.stderr).writeln('Error: $error');
    return 1;
  }
}
