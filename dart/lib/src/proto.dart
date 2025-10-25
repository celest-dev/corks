import 'package:corks_cedar/src/proto/cedar/v3/entity.pb.dart' as proto;
import 'package:corks_cedar/src/proto/cedar/v3/entity_uid.pb.dart' as proto;
import 'package:corks_cedar/src/proto/cedar/v3/expr.pb.dart' as proto;
import 'package:corks_cedar/src/proto/cedar/v3/policy.pb.dart' as proto;
import 'package:corks_cedar/src/proto/cedar/v3/value.pb.dart' as proto;
import 'package:corks_cedar/src/proto/google/protobuf/any.pb.dart';
import 'package:protobuf/protobuf.dart';
import 'package:protobuf/src/protobuf/mixins/well_known.dart';

final TypeRegistry typeRegistry = TypeRegistry([
  proto.EntityUid(),
  proto.Entity(),
  proto.Expr(),
  proto.Value(),
  proto.Policy(),
]);

extension AnyHelper<T extends GeneratedMessage> on T {
  /// Unpacks an [Any] message into this message.
  T unpackAny(Any any) {
    if (!any.canUnpackInto(this)) {
      throw ArgumentError('Cannot unpack ${any.typeUrl} into $runtimeType');
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
