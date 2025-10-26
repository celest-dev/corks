// This is a generated file - do not edit.
//
// Generated from cedar/v4/entity.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'entity_uid.pb.dart' as $0;
import 'value.pb.dart' as $1;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class Entity extends $pb.GeneratedMessage {
  factory Entity({
    $0.EntityUid? uid,
    $core.Iterable<$0.EntityUid>? parents,
    $core.Iterable<$core.MapEntry<$core.String, $1.Value>>? attributes,
    $core.Iterable<$core.MapEntry<$core.String, $1.Value>>? tags,
  }) {
    final result = create();
    if (uid != null) result.uid = uid;
    if (parents != null) result.parents.addAll(parents);
    if (attributes != null) result.attributes.addEntries(attributes);
    if (tags != null) result.tags.addEntries(tags);
    return result;
  }

  Entity._();

  factory Entity.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Entity.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Entity',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'cedar.v4'),
      createEmptyInstance: create)
    ..aOM<$0.EntityUid>(1, _omitFieldNames ? '' : 'uid',
        subBuilder: $0.EntityUid.create)
    ..pPM<$0.EntityUid>(2, _omitFieldNames ? '' : 'parents',
        subBuilder: $0.EntityUid.create)
    ..m<$core.String, $1.Value>(3, _omitFieldNames ? '' : 'attributes',
        entryClassName: 'Entity.AttributesEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OM,
        valueCreator: $1.Value.create,
        valueDefaultOrMaker: $1.Value.getDefault,
        packageName: const $pb.PackageName('cedar.v4'))
    ..m<$core.String, $1.Value>(4, _omitFieldNames ? '' : 'tags',
        entryClassName: 'Entity.TagsEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OM,
        valueCreator: $1.Value.create,
        valueDefaultOrMaker: $1.Value.getDefault,
        packageName: const $pb.PackageName('cedar.v4'))
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Entity clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Entity copyWith(void Function(Entity) updates) =>
      super.copyWith((message) => updates(message as Entity)) as Entity;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Entity create() => Entity._();
  @$core.override
  Entity createEmptyInstance() => create();
  static $pb.PbList<Entity> createRepeated() => $pb.PbList<Entity>();
  @$core.pragma('dart2js:noInline')
  static Entity getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Entity>(create);
  static Entity? _defaultInstance;

  @$pb.TagNumber(1)
  $0.EntityUid get uid => $_getN(0);
  @$pb.TagNumber(1)
  set uid($0.EntityUid value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasUid() => $_has(0);
  @$pb.TagNumber(1)
  void clearUid() => $_clearField(1);
  @$pb.TagNumber(1)
  $0.EntityUid ensureUid() => $_ensure(0);

  @$pb.TagNumber(2)
  $pb.PbList<$0.EntityUid> get parents => $_getList(1);

  @$pb.TagNumber(3)
  $pb.PbMap<$core.String, $1.Value> get attributes => $_getMap(2);

  @$pb.TagNumber(4)
  $pb.PbMap<$core.String, $1.Value> get tags => $_getMap(3);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
