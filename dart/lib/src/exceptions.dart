import 'package:crypto/crypto.dart';

import 'cork.dart';

/// {@template corks.invalid_cork_exception}
/// Thrown when a [Cork] is invalid or corrupted and cannot be processed.
/// {@endtemplate}
final class InvalidCorkException extends FormatException {
  /// {@macro corks.invalid_cork_exception}
  const InvalidCorkException([super.message]);

  @override
  String toString() {
    final s = StringBuffer('Invalid cork');
    if (message.isNotEmpty) {
      s.write(': $message');
    }
    return s.toString();
  }
}

/// {@template corks.invalid_signature_exception}
/// Thrown when a [Cork] signature does not match the expected value.
/// {@endtemplate}
final class InvalidSignatureException implements Exception {
  /// {@macro corks.invalid_signature_exception}
  const InvalidSignatureException({
    required Digest expected,
    required Digest actual,
  }) : _expected = expected,
       _actual = actual;

  final Digest _expected;
  final Digest _actual;

  @override
  String toString() =>
      'Signatures do not match:\n'
      'Expected: $_expected\n'
      'Got:      $_actual';
}

/// {@template corks.missing_signature_error}
/// Thrown when a [Cork] is missing a signature.
/// {@endtemplate}
final class MissingSignatureError extends StateError {
  /// {@macro corks.missing_signature_error}
  MissingSignatureError() : super('Cork has not been signed.');
}
