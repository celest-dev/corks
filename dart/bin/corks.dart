import 'dart:io';

import 'package:corks_cedar/src/cli/command_runner.dart';

Future<void> main(List<String> arguments) async {
  final exitCode = await runCorksCommand(
    arguments,
    stdout: stdout,
    stderr: stderr,
  );
  exit(exitCode);
}
