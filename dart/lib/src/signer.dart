import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart' as crypto;

import 'crypto.dart';

/// Contract for deriving cork signing material without exposing master keys.
///
/// Implementations may back onto in-memory keys, hardware security modules, or
/// cloud KMS providers. All implementations are required to return defensive
/// copies of any secret material.
abstract interface class Signer {
  /// Creates an in-memory signer that holds the raw master key material.
  factory Signer(Uint8List keyId, Uint8List masterKey) = InMemorySigner;

  /// Creates a signer whose root key derivation is delegated to [deriveRootKey].
  factory Signer.mock({
    required Uint8List keyId,
    required FutureOr<Uint8List> Function(Uint8List nonce, Uint8List keyId)
    deriveRootKey,
  }) = MockSigner;

  /// Identifier embedded in every cork signed with this signer.
  Uint8List get keyId;

  /// Derives the per-cork root key using the signer’s backing key material.
  ///
  /// Implementations may perform network calls.
  Future<Uint8List> deriveCorkRootKey({
    required Uint8List nonce,
    required Uint8List keyId,
  });
}

/// In-memory signer used for tests and local development.
final class InMemorySigner implements Signer {
  InMemorySigner(Uint8List keyId, Uint8List masterKey)
    : _keyId = Uint8List.fromList(keyId),
      _masterKey = Uint8List.fromList(masterKey);

  final Uint8List _keyId;
  final Uint8List _masterKey;

  static const String _rootContext = 'celest/cork/v1';

  static Uint8List _deriveLocalRootKey(
    Uint8List masterKey,
    Uint8List nonce,
    Uint8List keyId,
  ) {
    final hmac = crypto.Hmac(crypto.sha256, masterKey);
    final context = utf8.encode(_rootContext);
    final input = Uint8List(nonce.length + keyId.length + context.length);
    var offset = 0;
    input.setRange(offset, offset + nonce.length, nonce);
    offset += nonce.length;
    input.setRange(offset, offset + keyId.length, keyId);
    offset += keyId.length;
    input.setRange(offset, offset + context.length, context);
    return Uint8List.fromList(hmac.convert(input).bytes);
  }

  @override
  Uint8List get keyId => _keyId.asUnmodifiableView();

  @override
  Future<Uint8List> deriveCorkRootKey({
    required Uint8List nonce,
    required Uint8List keyId,
  }) async {
    if (!bytesEqual(keyId, _keyId)) {
      throw ArgumentError('provided key id does not match signer key id');
    }
    return _deriveLocalRootKey(_masterKey, nonce, keyId);
  }
}

/// Mock signer that delegates root key derivation to the supplied callback.
///
/// This is a lightweight stand-in for remote signers such as AWS KMS where the
/// root key computation occurs outside of the local process. The callback is
/// invoked on every derivation request so tests can inspect the nonce if
/// desired.
final class MockSigner implements Signer {
  MockSigner({
    required Uint8List keyId,
    required FutureOr<Uint8List> Function(Uint8List nonce, Uint8List keyId)
    deriveRootKey,
  }) : _keyId = Uint8List.fromList(keyId),
       _deriveRootKeyCallback = deriveRootKey;

  final Uint8List _keyId;
  final FutureOr<Uint8List> Function(Uint8List nonce, Uint8List keyId)
  _deriveRootKeyCallback;

  @override
  Uint8List get keyId => Uint8List.fromList(_keyId);

  @override
  Future<Uint8List> deriveCorkRootKey({
    required Uint8List nonce,
    required Uint8List keyId,
  }) async {
    if (!bytesEqual(keyId, _keyId)) {
      throw ArgumentError('provided key id does not match signer key id');
    }
    final derived = await Future.sync(
      () => _deriveRootKeyCallback(
        Uint8List.fromList(nonce),
        Uint8List.fromList(keyId),
      ),
    );
    return Uint8List.fromList(derived);
  }
}
