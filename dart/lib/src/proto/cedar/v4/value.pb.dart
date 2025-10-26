// This is a generated file - do not edit.
//
// Generated from cedar/v4/value.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import '../../google/protobuf/wrappers.pb.dart' as $0;
import 'entity_uid.pb.dart' as $1;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

enum Value_Value {
  string,
  long,
  bool_3,
  set,
  record,
  extensionCall,
  entity,
  decimal,
  notSet
}

class Value extends $pb.GeneratedMessage {
  factory Value({
    $0.StringValue? string,
    $0.Int64Value? long,
    $0.BoolValue? bool_3,
    SetValue? set,
    RecordValue? record,
    ExtensionCall? extensionCall,
    EntityValue? entity,
    DecimalValue? decimal,
  }) {
    final result = create();
    if (string != null) result.string = string;
    if (long != null) result.long = long;
    if (bool_3 != null) result.bool_3 = bool_3;
    if (set != null) result.set = set;
    if (record != null) result.record = record;
    if (extensionCall != null) result.extensionCall = extensionCall;
    if (entity != null) result.entity = entity;
    if (decimal != null) result.decimal = decimal;
    return result;
  }

  Value._();

  factory Value.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Value.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, Value_Value> _Value_ValueByTag = {
    1: Value_Value.string,
    2: Value_Value.long,
    3: Value_Value.bool_3,
    4: Value_Value.set,
    5: Value_Value.record,
    6: Value_Value.extensionCall,
    7: Value_Value.entity,
    8: Value_Value.decimal,
    0: Value_Value.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Value',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'cedar.v4'),
      createEmptyInstance: create)
    ..oo(0, [1, 2, 3, 4, 5, 6, 7, 8])
    ..aOM<$0.StringValue>(1, _omitFieldNames ? '' : 'string',
        subBuilder: $0.StringValue.create)
    ..aOM<$0.Int64Value>(2, _omitFieldNames ? '' : 'long',
        subBuilder: $0.Int64Value.create)
    ..aOM<$0.BoolValue>(3, _omitFieldNames ? '' : 'bool',
        subBuilder: $0.BoolValue.create)
    ..aOM<SetValue>(4, _omitFieldNames ? '' : 'set',
        subBuilder: SetValue.create)
    ..aOM<RecordValue>(5, _omitFieldNames ? '' : 'record',
        subBuilder: RecordValue.create)
    ..aOM<ExtensionCall>(6, _omitFieldNames ? '' : 'extensionCall',
        subBuilder: ExtensionCall.create)
    ..aOM<EntityValue>(7, _omitFieldNames ? '' : 'entity',
        subBuilder: EntityValue.create)
    ..aOM<DecimalValue>(8, _omitFieldNames ? '' : 'decimal',
        subBuilder: DecimalValue.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Value clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Value copyWith(void Function(Value) updates) =>
      super.copyWith((message) => updates(message as Value)) as Value;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Value create() => Value._();
  @$core.override
  Value createEmptyInstance() => create();
  static $pb.PbList<Value> createRepeated() => $pb.PbList<Value>();
  @$core.pragma('dart2js:noInline')
  static Value getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Value>(create);
  static Value? _defaultInstance;

  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  @$pb.TagNumber(5)
  @$pb.TagNumber(6)
  @$pb.TagNumber(7)
  @$pb.TagNumber(8)
  Value_Value whichValue() => _Value_ValueByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  @$pb.TagNumber(5)
  @$pb.TagNumber(6)
  @$pb.TagNumber(7)
  @$pb.TagNumber(8)
  void clearValue() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  $0.StringValue get string => $_getN(0);
  @$pb.TagNumber(1)
  set string($0.StringValue value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasString() => $_has(0);
  @$pb.TagNumber(1)
  void clearString() => $_clearField(1);
  @$pb.TagNumber(1)
  $0.StringValue ensureString() => $_ensure(0);

  @$pb.TagNumber(2)
  $0.Int64Value get long => $_getN(1);
  @$pb.TagNumber(2)
  set long($0.Int64Value value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasLong() => $_has(1);
  @$pb.TagNumber(2)
  void clearLong() => $_clearField(2);
  @$pb.TagNumber(2)
  $0.Int64Value ensureLong() => $_ensure(1);

  @$pb.TagNumber(3)
  $0.BoolValue get bool_3 => $_getN(2);
  @$pb.TagNumber(3)
  set bool_3($0.BoolValue value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasBool_3() => $_has(2);
  @$pb.TagNumber(3)
  void clearBool_3() => $_clearField(3);
  @$pb.TagNumber(3)
  $0.BoolValue ensureBool_3() => $_ensure(2);

  @$pb.TagNumber(4)
  SetValue get set => $_getN(3);
  @$pb.TagNumber(4)
  set set(SetValue value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasSet() => $_has(3);
  @$pb.TagNumber(4)
  void clearSet() => $_clearField(4);
  @$pb.TagNumber(4)
  SetValue ensureSet() => $_ensure(3);

  @$pb.TagNumber(5)
  RecordValue get record => $_getN(4);
  @$pb.TagNumber(5)
  set record(RecordValue value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasRecord() => $_has(4);
  @$pb.TagNumber(5)
  void clearRecord() => $_clearField(5);
  @$pb.TagNumber(5)
  RecordValue ensureRecord() => $_ensure(4);

  @$pb.TagNumber(6)
  ExtensionCall get extensionCall => $_getN(5);
  @$pb.TagNumber(6)
  set extensionCall(ExtensionCall value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasExtensionCall() => $_has(5);
  @$pb.TagNumber(6)
  void clearExtensionCall() => $_clearField(6);
  @$pb.TagNumber(6)
  ExtensionCall ensureExtensionCall() => $_ensure(5);

  @$pb.TagNumber(7)
  EntityValue get entity => $_getN(6);
  @$pb.TagNumber(7)
  set entity(EntityValue value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasEntity() => $_has(6);
  @$pb.TagNumber(7)
  void clearEntity() => $_clearField(7);
  @$pb.TagNumber(7)
  EntityValue ensureEntity() => $_ensure(6);

  @$pb.TagNumber(8)
  DecimalValue get decimal => $_getN(7);
  @$pb.TagNumber(8)
  set decimal(DecimalValue value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasDecimal() => $_has(7);
  @$pb.TagNumber(8)
  void clearDecimal() => $_clearField(8);
  @$pb.TagNumber(8)
  DecimalValue ensureDecimal() => $_ensure(7);
}

class SetValue extends $pb.GeneratedMessage {
  factory SetValue({
    $core.Iterable<Value>? elements,
  }) {
    final result = create();
    if (elements != null) result.elements.addAll(elements);
    return result;
  }

  SetValue._();

  factory SetValue.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SetValue.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SetValue',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'cedar.v4'),
      createEmptyInstance: create)
    ..pPM<Value>(1, _omitFieldNames ? '' : 'elements', subBuilder: Value.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetValue clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetValue copyWith(void Function(SetValue) updates) =>
      super.copyWith((message) => updates(message as SetValue)) as SetValue;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SetValue create() => SetValue._();
  @$core.override
  SetValue createEmptyInstance() => create();
  static $pb.PbList<SetValue> createRepeated() => $pb.PbList<SetValue>();
  @$core.pragma('dart2js:noInline')
  static SetValue getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SetValue>(create);
  static SetValue? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Value> get elements => $_getList(0);
}

class RecordValue extends $pb.GeneratedMessage {
  factory RecordValue({
    $core.Iterable<$core.MapEntry<$core.String, Value>>? attributes,
  }) {
    final result = create();
    if (attributes != null) result.attributes.addEntries(attributes);
    return result;
  }

  RecordValue._();

  factory RecordValue.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RecordValue.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RecordValue',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'cedar.v4'),
      createEmptyInstance: create)
    ..m<$core.String, Value>(1, _omitFieldNames ? '' : 'attributes',
        entryClassName: 'RecordValue.AttributesEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OM,
        valueCreator: Value.create,
        valueDefaultOrMaker: Value.getDefault,
        packageName: const $pb.PackageName('cedar.v4'))
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordValue clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordValue copyWith(void Function(RecordValue) updates) =>
      super.copyWith((message) => updates(message as RecordValue))
          as RecordValue;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RecordValue create() => RecordValue._();
  @$core.override
  RecordValue createEmptyInstance() => create();
  static $pb.PbList<RecordValue> createRepeated() => $pb.PbList<RecordValue>();
  @$core.pragma('dart2js:noInline')
  static RecordValue getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RecordValue>(create);
  static RecordValue? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbMap<$core.String, Value> get attributes => $_getMap(0);
}

class ExtensionCall extends $pb.GeneratedMessage {
  factory ExtensionCall({
    $core.String? fn,
    Value? arg,
  }) {
    final result = create();
    if (fn != null) result.fn = fn;
    if (arg != null) result.arg = arg;
    return result;
  }

  ExtensionCall._();

  factory ExtensionCall.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ExtensionCall.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ExtensionCall',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'cedar.v4'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'fn')
    ..aOM<Value>(2, _omitFieldNames ? '' : 'arg', subBuilder: Value.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExtensionCall clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExtensionCall copyWith(void Function(ExtensionCall) updates) =>
      super.copyWith((message) => updates(message as ExtensionCall))
          as ExtensionCall;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ExtensionCall create() => ExtensionCall._();
  @$core.override
  ExtensionCall createEmptyInstance() => create();
  static $pb.PbList<ExtensionCall> createRepeated() =>
      $pb.PbList<ExtensionCall>();
  @$core.pragma('dart2js:noInline')
  static ExtensionCall getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ExtensionCall>(create);
  static ExtensionCall? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get fn => $_getSZ(0);
  @$pb.TagNumber(1)
  set fn($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasFn() => $_has(0);
  @$pb.TagNumber(1)
  void clearFn() => $_clearField(1);

  @$pb.TagNumber(2)
  Value get arg => $_getN(1);
  @$pb.TagNumber(2)
  set arg(Value value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasArg() => $_has(1);
  @$pb.TagNumber(2)
  void clearArg() => $_clearField(2);
  @$pb.TagNumber(2)
  Value ensureArg() => $_ensure(1);
}

class EntityValue extends $pb.GeneratedMessage {
  factory EntityValue({
    $1.EntityUid? uid,
  }) {
    final result = create();
    if (uid != null) result.uid = uid;
    return result;
  }

  EntityValue._();

  factory EntityValue.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory EntityValue.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'EntityValue',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'cedar.v4'),
      createEmptyInstance: create)
    ..aOM<$1.EntityUid>(1, _omitFieldNames ? '' : 'uid',
        subBuilder: $1.EntityUid.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EntityValue clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EntityValue copyWith(void Function(EntityValue) updates) =>
      super.copyWith((message) => updates(message as EntityValue))
          as EntityValue;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static EntityValue create() => EntityValue._();
  @$core.override
  EntityValue createEmptyInstance() => create();
  static $pb.PbList<EntityValue> createRepeated() => $pb.PbList<EntityValue>();
  @$core.pragma('dart2js:noInline')
  static EntityValue getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<EntityValue>(create);
  static EntityValue? _defaultInstance;

  @$pb.TagNumber(1)
  $1.EntityUid get uid => $_getN(0);
  @$pb.TagNumber(1)
  set uid($1.EntityUid value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasUid() => $_has(0);
  @$pb.TagNumber(1)
  void clearUid() => $_clearField(1);
  @$pb.TagNumber(1)
  $1.EntityUid ensureUid() => $_ensure(0);
}

class DecimalValue extends $pb.GeneratedMessage {
  factory DecimalValue({
    $core.String? value,
  }) {
    final result = create();
    if (value != null) result.value = value;
    return result;
  }

  DecimalValue._();

  factory DecimalValue.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DecimalValue.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DecimalValue',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'cedar.v4'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'value')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DecimalValue clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DecimalValue copyWith(void Function(DecimalValue) updates) =>
      super.copyWith((message) => updates(message as DecimalValue))
          as DecimalValue;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DecimalValue create() => DecimalValue._();
  @$core.override
  DecimalValue createEmptyInstance() => create();
  static $pb.PbList<DecimalValue> createRepeated() =>
      $pb.PbList<DecimalValue>();
  @$core.pragma('dart2js:noInline')
  static DecimalValue getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DecimalValue>(create);
  static DecimalValue? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get value => $_getSZ(0);
  @$pb.TagNumber(1)
  set value($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasValue() => $_has(0);
  @$pb.TagNumber(1)
  void clearValue() => $_clearField(1);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
