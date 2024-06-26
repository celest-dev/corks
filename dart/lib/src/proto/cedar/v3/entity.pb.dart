//
//  Generated code. Do not modify.
//  source: cedar/v3/entity.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'entity_id.pb.dart' as $0;
import 'value.pb.dart' as $1;

class Entity extends $pb.GeneratedMessage {
  factory Entity({
    $0.EntityId? uid,
    $core.Iterable<$0.EntityId>? parents,
    $core.Map<$core.String, $1.Value>? attributes,
  }) {
    final $result = create();
    if (uid != null) {
      $result.uid = uid;
    }
    if (parents != null) {
      $result.parents.addAll(parents);
    }
    if (attributes != null) {
      $result.attributes.addAll(attributes);
    }
    return $result;
  }
  Entity._() : super();
  factory Entity.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Entity.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Entity', package: const $pb.PackageName(_omitMessageNames ? '' : 'cedar.v3'), createEmptyInstance: create)
    ..aOM<$0.EntityId>(1, _omitFieldNames ? '' : 'uid', subBuilder: $0.EntityId.create)
    ..pc<$0.EntityId>(2, _omitFieldNames ? '' : 'parents', $pb.PbFieldType.PM, subBuilder: $0.EntityId.create)
    ..m<$core.String, $1.Value>(3, _omitFieldNames ? '' : 'attributes', entryClassName: 'Entity.AttributesEntry', keyFieldType: $pb.PbFieldType.OS, valueFieldType: $pb.PbFieldType.OM, valueCreator: $1.Value.create, valueDefaultOrMaker: $1.Value.getDefault, packageName: const $pb.PackageName('cedar.v3'))
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Entity clone() => Entity()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Entity copyWith(void Function(Entity) updates) => super.copyWith((message) => updates(message as Entity)) as Entity;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Entity create() => Entity._();
  Entity createEmptyInstance() => create();
  static $pb.PbList<Entity> createRepeated() => $pb.PbList<Entity>();
  @$core.pragma('dart2js:noInline')
  static Entity getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Entity>(create);
  static Entity? _defaultInstance;

  @$pb.TagNumber(1)
  $0.EntityId get uid => $_getN(0);
  @$pb.TagNumber(1)
  set uid($0.EntityId v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasUid() => $_has(0);
  @$pb.TagNumber(1)
  void clearUid() => clearField(1);
  @$pb.TagNumber(1)
  $0.EntityId ensureUid() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.List<$0.EntityId> get parents => $_getList(1);

  @$pb.TagNumber(3)
  $core.Map<$core.String, $1.Value> get attributes => $_getMap(2);
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
