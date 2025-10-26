import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart' as crypto;
import 'package:meta/meta.dart';

import 'crypto.dart';

const String _kCorkRootContext = 'celest/cork/v1';

/// Contract for deriving cork signing material without exposing master keys.
///
/// Implementations may back onto in-memory keys, hardware security modules, or
/// cloud KMS providers. All implementations are required to return defensive
/// copies of any secret material.
abstract interface class Signer {
  /// Creates an in-memory signer that holds the raw master key material.
  factory Signer(Uint8List keyId, Uint8List masterKey) = InMemorySigner;

  /// Identifier embedded in every cork signed with this signer.
  Uint8List get keyId;

  /// Computes a keyed MAC over [message] using the signer’s backing key.
  ///
  /// [context] provides domain separation so different protocol features do
  /// not collide even when they reuse the same master key material.
  Future<Uint8List> computeMac({
    required Uint8List message,
    required Uint8List keyId,
    required String context,
  });

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

  @override
  Uint8List get keyId => _keyId.asUnmodifiableView();

  @override
  Future<Uint8List> computeMac({
    required Uint8List message,
    required Uint8List keyId,
    required String context,
  }) async {
    if (!bytesEqual(keyId, _keyId)) {
      throw ArgumentError('provided key id does not match signer key id');
    }
    final hmac = crypto.Hmac(crypto.sha256, _masterKey);
    final contextBytes = utf8.encode(context);
    final input = Uint8List(message.length + contextBytes.length);
    input.setRange(0, message.length, message);
    input.setRange(message.length, input.length, contextBytes);
    return Uint8List.fromList(hmac.convert(input).bytes);
  }

  @override
  Future<Uint8List> deriveCorkRootKey({
    required Uint8List nonce,
    required Uint8List keyId,
  }) async {
    if (!bytesEqual(keyId, _keyId)) {
      throw ArgumentError('provided key id does not match signer key id');
    }
    final payload = Uint8List(nonce.length + keyId.length)
      ..setRange(0, nonce.length, nonce)
      ..setRange(nonce.length, nonce.length + keyId.length, keyId);
    return computeMac(
      message: payload,
      keyId: keyId,
      context: _kCorkRootContext,
    );
  }
}

/// Mock signer that delegates root key derivation to the supplied callback.
///
/// This is a lightweight stand-in for remote signers such as AWS KMS where the
/// root key computation occurs outside of the local process. The callback is
/// invoked on every derivation request so tests can inspect the nonce if
/// desired.
@visibleForTesting
final class MockSigner implements Signer {
  MockSigner({
    required Uint8List keyId,
    required FutureOr<Uint8List> Function(Uint8List nonce, Uint8List keyId)
    deriveRootKey,
    FutureOr<Uint8List> Function(
      Uint8List message,
      Uint8List keyId,
      String context,
    )?
    computeMac,
  }) : _keyId = Uint8List.fromList(keyId),
       _deriveRootKeyCallback = deriveRootKey,
       _computeMacCallback =
           computeMac ??
           ((message, providedKeyId, context) {
             if (context != _kCorkRootContext) {
               throw UnsupportedError(
                 'MockSigner.computeMac not provided for context $context',
               );
             }
             if (message.length < providedKeyId.length) {
               throw ArgumentError(
                 'message must contain nonce followed by key id',
                 'message',
               );
             }
             final nonceLength = message.length - providedKeyId.length;
             final nonce = Uint8List.fromList(message.sublist(0, nonceLength));
             final embeddedKeyId = Uint8List.fromList(
               message.sublist(nonceLength),
             );
             return deriveRootKey(nonce, embeddedKeyId);
           });

  final Uint8List _keyId;
  final FutureOr<Uint8List> Function(Uint8List nonce, Uint8List keyId)
  _deriveRootKeyCallback;
  final FutureOr<Uint8List> Function(
    Uint8List message,
    Uint8List keyId,
    String context,
  )
  _computeMacCallback;

  @override
  Uint8List get keyId => _keyId.asUnmodifiableView();

  @override
  Future<Uint8List> computeMac({
    required Uint8List message,
    required Uint8List keyId,
    required String context,
  }) async {
    if (!bytesEqual(keyId, _keyId)) {
      throw ArgumentError('provided key id does not match signer key id');
    }
    final mac = await Future.sync(
      () => _computeMacCallback(
        Uint8List.fromList(message),
        Uint8List.fromList(keyId),
        context,
      ),
    );
    return Uint8List.fromList(mac);
  }

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
