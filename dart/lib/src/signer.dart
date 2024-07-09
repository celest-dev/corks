import 'dart:async';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';

abstract interface class Signer {
  factory Signer(Uint8List keyId, Uint8List key) = _Signer;

  Uint8List get keyId;
  Future<Uint8List> sign(Uint8List bytes);
  void reset();
}

final class _Signer implements Signer {
  _Signer(this.keyId, Uint8List key)
      : hmac = Hmac(sha256, key),
        _newHmac = ((Uint8List? newKey) => Hmac(sha256, newKey ?? key));

  @override
  final Uint8List keyId;

  final Hmac Function(Uint8List? key) _newHmac;
  Hmac hmac;
  late Uint8List signature;

  @override
  Future<Uint8List> sign(Uint8List bytes) async {
    signature = await Future(() => hmac.convert(bytes).bytes as Uint8List);
    hmac = _newHmac(signature);
    return signature;
  }

  @override
  void reset() {
    hmac = _newHmac(null);
    signature = Uint8List(0);
  }
}
