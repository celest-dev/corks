import 'dart:typed_data';

import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';

import 'cork.dart';
import 'signer.dart';

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
  })  : _expected = expected,
        _actual = actual;

  final Digest _expected;
  final Digest _actual;

  @override
  String toString() => 'Signatures do not match:\n'
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

/// {@template corks.mismatched_key_error}
/// Thrown when a [Signer] key ID does not match the [Cork] ID.
/// {@endtemplate}
final class MismatchedKeyError extends ArgumentError {
  /// {@macro corks.mismatched_key_error}
  MismatchedKeyError({required Uint8List keyId, required Uint8List corkId})
      : super(
          'Signer key ID and cork ID do not match:\n'
          'Key ID:  ${hex.encode(keyId)}\n'
          'Cork ID: ${hex.encode(corkId)}',
        );
}
