import 'dart:typed_data';

import 'package:convert/convert.dart';

/// {@template corks.invalid_cork_exception}
/// Thrown when a cork is invalid or corrupted and cannot be processed.
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
/// Thrown when a cork signature does not match the expected value.
/// {@endtemplate}
final class InvalidSignatureException implements Exception {
  /// {@macro corks.invalid_signature_exception}
  InvalidSignatureException({
    required Uint8List expected,
    required Uint8List actual,
  }) : _expected = Uint8List.fromList(expected),
       _actual = Uint8List.fromList(actual);

  final Uint8List _expected;
  final Uint8List _actual;

  @override
  String toString() =>
      'Signatures do not match: '
      'expected ${hex.encode(_expected)}, '
      'got ${hex.encode(_actual)}';
}

/// {@template corks.missing_signature_error}
/// Thrown when a cork is missing a tail signature.
/// {@endtemplate}
final class MissingSignatureError extends StateError {
  /// {@macro corks.missing_signature_error}
  MissingSignatureError() : super('Cork tail signature not present.');
}
