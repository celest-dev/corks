import 'dart:async';
import 'dart:typed_data';

import 'package:corks_cedar/corks_cedar.dart';
import 'package:corks_cedar/src/proto/google/protobuf/any.pb.dart';
import 'package:protobuf/protobuf.dart';
import 'package:protobuf/src/protobuf/mixins/well_known.dart';

extension AnyHelper<T extends GeneratedMessage> on T {
  /// Unpacks an [Any] message into this message.
  T unpackAny(Any any) {
    if (!any.canUnpackInto(this)) {
      throw ArgumentError(
        'Cannot unpack ${any.typeUrl} into $runtimeType',
      );
    }
    any.unpackInto(this);
    return this;
  }

  /// Packs this message into an [Any] message.
  Any packIntoAny() => switch (this) {
        final Any any => any,
        final AnyMixin anotherAny => Any()..mergeFromMessage(anotherAny),
        _ => Any.pack(this),
      };
}

extension SignProto on Signer {
  Future<Uint8List> signProto(GeneratedMessage message) async {
    final any = message.packIntoAny();
    final block = BytesBuilder(copy: false)
      ..add(any.typeUrl.codeUnits)
      ..add(any.value);
    return sign(block.takeBytes());
  }
}
