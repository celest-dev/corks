// This is a generated file - do not edit.
//
// Generated from cedar/v3/policy.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'entity_uid.pb.dart' as $0;
import 'expr.pb.dart' as $1;
import 'policy.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'policy.pbenum.dart';

class PolicySet extends $pb.GeneratedMessage {
  factory PolicySet({
    $core.Iterable<$core.MapEntry<$core.String, Policy>>? policies,
    $core.Iterable<$core.MapEntry<$core.String, Policy>>? templates,
    $core.Iterable<TemplateLink>? templateLinks,
  }) {
    final result = create();
    if (policies != null) result.policies.addEntries(policies);
    if (templates != null) result.templates.addEntries(templates);
    if (templateLinks != null) result.templateLinks.addAll(templateLinks);
    return result;
  }

  PolicySet._();

  factory PolicySet.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PolicySet.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PolicySet',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'cedar.v3'),
      createEmptyInstance: create)
    ..m<$core.String, Policy>(1, _omitFieldNames ? '' : 'policies',
        entryClassName: 'PolicySet.PoliciesEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OM,
        valueCreator: Policy.create,
        valueDefaultOrMaker: Policy.getDefault,
        packageName: const $pb.PackageName('cedar.v3'))
    ..m<$core.String, Policy>(2, _omitFieldNames ? '' : 'templates',
        entryClassName: 'PolicySet.TemplatesEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OM,
        valueCreator: Policy.create,
        valueDefaultOrMaker: Policy.getDefault,
        packageName: const $pb.PackageName('cedar.v3'))
    ..pc<TemplateLink>(
        3, _omitFieldNames ? '' : 'templateLinks', $pb.PbFieldType.PM,
        subBuilder: TemplateLink.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PolicySet clone() => PolicySet()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PolicySet copyWith(void Function(PolicySet) updates) =>
      super.copyWith((message) => updates(message as PolicySet)) as PolicySet;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PolicySet create() => PolicySet._();
  @$core.override
  PolicySet createEmptyInstance() => create();
  static $pb.PbList<PolicySet> createRepeated() => $pb.PbList<PolicySet>();
  @$core.pragma('dart2js:noInline')
  static PolicySet getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PolicySet>(create);
  static PolicySet? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbMap<$core.String, Policy> get policies => $_getMap(0);

  @$pb.TagNumber(2)
  $pb.PbMap<$core.String, Policy> get templates => $_getMap(1);

  @$pb.TagNumber(3)
  $pb.PbList<TemplateLink> get templateLinks => $_getList(2);
}

class Policy extends $pb.GeneratedMessage {
  factory Policy({
    $core.String? id,
    Effect? effect,
    PrincipalConstraint? principal,
    ActionConstraint? action,
    ResourceConstraint? resource,
    $core.Iterable<Condition>? conditions,
    Annotations? annotations,
    Position? position,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (effect != null) result.effect = effect;
    if (principal != null) result.principal = principal;
    if (action != null) result.action = action;
    if (resource != null) result.resource = resource;
    if (conditions != null) result.conditions.addAll(conditions);
    if (annotations != null) result.annotations = annotations;
    if (position != null) result.position = position;
    return result;
  }

  Policy._();

  factory Policy.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Policy.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Policy',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'cedar.v3'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..e<Effect>(2, _omitFieldNames ? '' : 'effect', $pb.PbFieldType.OE,
        defaultOrMaker: Effect.EFFECT_UNSPECIFIED,
        valueOf: Effect.valueOf,
        enumValues: Effect.values)
    ..aOM<PrincipalConstraint>(3, _omitFieldNames ? '' : 'principal',
        subBuilder: PrincipalConstraint.create)
    ..aOM<ActionConstraint>(4, _omitFieldNames ? '' : 'action',
        subBuilder: ActionConstraint.create)
    ..aOM<ResourceConstraint>(5, _omitFieldNames ? '' : 'resource',
        subBuilder: ResourceConstraint.create)
    ..pc<Condition>(6, _omitFieldNames ? '' : 'conditions', $pb.PbFieldType.PM,
        subBuilder: Condition.create)
    ..aOM<Annotations>(7, _omitFieldNames ? '' : 'annotations',
        subBuilder: Annotations.create)
    ..aOM<Position>(8, _omitFieldNames ? '' : 'position',
        subBuilder: Position.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Policy clone() => Policy()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Policy copyWith(void Function(Policy) updates) =>
      super.copyWith((message) => updates(message as Policy)) as Policy;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Policy create() => Policy._();
  @$core.override
  Policy createEmptyInstance() => create();
  static $pb.PbList<Policy> createRepeated() => $pb.PbList<Policy>();
  @$core.pragma('dart2js:noInline')
  static Policy getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Policy>(create);
  static Policy? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  Effect get effect => $_getN(1);
  @$pb.TagNumber(2)
  set effect(Effect value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasEffect() => $_has(1);
  @$pb.TagNumber(2)
  void clearEffect() => $_clearField(2);

  @$pb.TagNumber(3)
  PrincipalConstraint get principal => $_getN(2);
  @$pb.TagNumber(3)
  set principal(PrincipalConstraint value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasPrincipal() => $_has(2);
  @$pb.TagNumber(3)
  void clearPrincipal() => $_clearField(3);
  @$pb.TagNumber(3)
  PrincipalConstraint ensurePrincipal() => $_ensure(2);

  @$pb.TagNumber(4)
  ActionConstraint get action => $_getN(3);
  @$pb.TagNumber(4)
  set action(ActionConstraint value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasAction() => $_has(3);
  @$pb.TagNumber(4)
  void clearAction() => $_clearField(4);
  @$pb.TagNumber(4)
  ActionConstraint ensureAction() => $_ensure(3);

  @$pb.TagNumber(5)
  ResourceConstraint get resource => $_getN(4);
  @$pb.TagNumber(5)
  set resource(ResourceConstraint value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasResource() => $_has(4);
  @$pb.TagNumber(5)
  void clearResource() => $_clearField(5);
  @$pb.TagNumber(5)
  ResourceConstraint ensureResource() => $_ensure(4);

  @$pb.TagNumber(6)
  $pb.PbList<Condition> get conditions => $_getList(5);

  @$pb.TagNumber(7)
  Annotations get annotations => $_getN(6);
  @$pb.TagNumber(7)
  set annotations(Annotations value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasAnnotations() => $_has(6);
  @$pb.TagNumber(7)
  void clearAnnotations() => $_clearField(7);
  @$pb.TagNumber(7)
  Annotations ensureAnnotations() => $_ensure(6);

  @$pb.TagNumber(8)
  Position get position => $_getN(7);
  @$pb.TagNumber(8)
  set position(Position value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasPosition() => $_has(7);
  @$pb.TagNumber(8)
  void clearPosition() => $_clearField(8);
  @$pb.TagNumber(8)
  Position ensurePosition() => $_ensure(7);
}

class Annotations extends $pb.GeneratedMessage {
  factory Annotations({
    $core.Iterable<$core.MapEntry<$core.String, $core.String>>? annotations,
  }) {
    final result = create();
    if (annotations != null) result.annotations.addEntries(annotations);
    return result;
  }

  Annotations._();

  factory Annotations.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Annotations.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Annotations',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'cedar.v3'),
      createEmptyInstance: create)
    ..m<$core.String, $core.String>(1, _omitFieldNames ? '' : 'annotations',
        entryClassName: 'Annotations.AnnotationsEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OS,
        packageName: const $pb.PackageName('cedar.v3'))
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Annotations clone() => Annotations()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Annotations copyWith(void Function(Annotations) updates) =>
      super.copyWith((message) => updates(message as Annotations))
          as Annotations;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Annotations create() => Annotations._();
  @$core.override
  Annotations createEmptyInstance() => create();
  static $pb.PbList<Annotations> createRepeated() => $pb.PbList<Annotations>();
  @$core.pragma('dart2js:noInline')
  static Annotations getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Annotations>(create);
  static Annotations? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbMap<$core.String, $core.String> get annotations => $_getMap(0);
}

class Position extends $pb.GeneratedMessage {
  factory Position({
    $core.String? filename,
    $core.int? offset,
    $core.int? line,
    $core.int? column,
  }) {
    final result = create();
    if (filename != null) result.filename = filename;
    if (offset != null) result.offset = offset;
    if (line != null) result.line = line;
    if (column != null) result.column = column;
    return result;
  }

  Position._();

  factory Position.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Position.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Position',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'cedar.v3'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'filename')
    ..a<$core.int>(2, _omitFieldNames ? '' : 'offset', $pb.PbFieldType.OU3)
    ..a<$core.int>(3, _omitFieldNames ? '' : 'line', $pb.PbFieldType.OU3)
    ..a<$core.int>(4, _omitFieldNames ? '' : 'column', $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Position clone() => Position()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Position copyWith(void Function(Position) updates) =>
      super.copyWith((message) => updates(message as Position)) as Position;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Position create() => Position._();
  @$core.override
  Position createEmptyInstance() => create();
  static $pb.PbList<Position> createRepeated() => $pb.PbList<Position>();
  @$core.pragma('dart2js:noInline')
  static Position getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Position>(create);
  static Position? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get filename => $_getSZ(0);
  @$pb.TagNumber(1)
  set filename($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasFilename() => $_has(0);
  @$pb.TagNumber(1)
  void clearFilename() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get offset => $_getIZ(1);
  @$pb.TagNumber(2)
  set offset($core.int value) => $_setUnsignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasOffset() => $_has(1);
  @$pb.TagNumber(2)
  void clearOffset() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get line => $_getIZ(2);
  @$pb.TagNumber(3)
  set line($core.int value) => $_setUnsignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasLine() => $_has(2);
  @$pb.TagNumber(3)
  void clearLine() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get column => $_getIZ(3);
  @$pb.TagNumber(4)
  set column($core.int value) => $_setUnsignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasColumn() => $_has(3);
  @$pb.TagNumber(4)
  void clearColumn() => $_clearField(4);
}

enum PrincipalConstraint_Constraint { all, equals, in_, isIn, is_5, notSet }

class PrincipalConstraint extends $pb.GeneratedMessage {
  factory PrincipalConstraint({
    PrincipalAll? all,
    PrincipalEquals? equals,
    PrincipalIn? in_,
    PrincipalIsIn? isIn,
    PrincipalIs? is_5,
  }) {
    final result = create();
    if (all != null) result.all = all;
    if (equals != null) result.equals = equals;
    if (in_ != null) result.in_ = in_;
    if (isIn != null) result.isIn = isIn;
    if (is_5 != null) result.is_5 = is_5;
    return result;
  }

  PrincipalConstraint._();

  factory PrincipalConstraint.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PrincipalConstraint.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, PrincipalConstraint_Constraint>
      _PrincipalConstraint_ConstraintByTag = {
    1: PrincipalConstraint_Constraint.all,
    2: PrincipalConstraint_Constraint.equals,
    3: PrincipalConstraint_Constraint.in_,
    4: PrincipalConstraint_Constraint.isIn,
    5: PrincipalConstraint_Constraint.is_5,
    0: PrincipalConstraint_Constraint.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PrincipalConstraint',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'cedar.v3'),
      createEmptyInstance: create)
    ..oo(0, [1, 2, 3, 4, 5])
    ..aOM<PrincipalAll>(1, _omitFieldNames ? '' : 'all',
        subBuilder: PrincipalAll.create)
    ..aOM<PrincipalEquals>(2, _omitFieldNames ? '' : 'equals',
        subBuilder: PrincipalEquals.create)
    ..aOM<PrincipalIn>(3, _omitFieldNames ? '' : 'in',
        subBuilder: PrincipalIn.create)
    ..aOM<PrincipalIsIn>(4, _omitFieldNames ? '' : 'isIn',
        subBuilder: PrincipalIsIn.create)
    ..aOM<PrincipalIs>(5, _omitFieldNames ? '' : 'is',
        subBuilder: PrincipalIs.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PrincipalConstraint clone() => PrincipalConstraint()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PrincipalConstraint copyWith(void Function(PrincipalConstraint) updates) =>
      super.copyWith((message) => updates(message as PrincipalConstraint))
          as PrincipalConstraint;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PrincipalConstraint create() => PrincipalConstraint._();
  @$core.override
  PrincipalConstraint createEmptyInstance() => create();
  static $pb.PbList<PrincipalConstraint> createRepeated() =>
      $pb.PbList<PrincipalConstraint>();
  @$core.pragma('dart2js:noInline')
  static PrincipalConstraint getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PrincipalConstraint>(create);
  static PrincipalConstraint? _defaultInstance;

  PrincipalConstraint_Constraint whichConstraint() =>
      _PrincipalConstraint_ConstraintByTag[$_whichOneof(0)]!;
  void clearConstraint() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  PrincipalAll get all => $_getN(0);
  @$pb.TagNumber(1)
  set all(PrincipalAll value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasAll() => $_has(0);
  @$pb.TagNumber(1)
  void clearAll() => $_clearField(1);
  @$pb.TagNumber(1)
  PrincipalAll ensureAll() => $_ensure(0);

  @$pb.TagNumber(2)
  PrincipalEquals get equals => $_getN(1);
  @$pb.TagNumber(2)
  set equals(PrincipalEquals value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasEquals() => $_has(1);
  @$pb.TagNumber(2)
  void clearEquals() => $_clearField(2);
  @$pb.TagNumber(2)
  PrincipalEquals ensureEquals() => $_ensure(1);

  @$pb.TagNumber(3)
  PrincipalIn get in_ => $_getN(2);
  @$pb.TagNumber(3)
  set in_(PrincipalIn value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasIn_() => $_has(2);
  @$pb.TagNumber(3)
  void clearIn_() => $_clearField(3);
  @$pb.TagNumber(3)
  PrincipalIn ensureIn_() => $_ensure(2);

  @$pb.TagNumber(4)
  PrincipalIsIn get isIn => $_getN(3);
  @$pb.TagNumber(4)
  set isIn(PrincipalIsIn value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasIsIn() => $_has(3);
  @$pb.TagNumber(4)
  void clearIsIn() => $_clearField(4);
  @$pb.TagNumber(4)
  PrincipalIsIn ensureIsIn() => $_ensure(3);

  @$pb.TagNumber(5)
  PrincipalIs get is_5 => $_getN(4);
  @$pb.TagNumber(5)
  set is_5(PrincipalIs value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasIs_5() => $_has(4);
  @$pb.TagNumber(5)
  void clearIs_5() => $_clearField(5);
  @$pb.TagNumber(5)
  PrincipalIs ensureIs_5() => $_ensure(4);
}

class PrincipalAll extends $pb.GeneratedMessage {
  factory PrincipalAll() => create();

  PrincipalAll._();

  factory PrincipalAll.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PrincipalAll.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PrincipalAll',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'cedar.v3'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PrincipalAll clone() => PrincipalAll()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PrincipalAll copyWith(void Function(PrincipalAll) updates) =>
      super.copyWith((message) => updates(message as PrincipalAll))
          as PrincipalAll;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PrincipalAll create() => PrincipalAll._();
  @$core.override
  PrincipalAll createEmptyInstance() => create();
  static $pb.PbList<PrincipalAll> createRepeated() =>
      $pb.PbList<PrincipalAll>();
  @$core.pragma('dart2js:noInline')
  static PrincipalAll getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PrincipalAll>(create);
  static PrincipalAll? _defaultInstance;
}

enum PrincipalEquals_Component { slot, entity, notSet }

class PrincipalEquals extends $pb.GeneratedMessage {
  factory PrincipalEquals({
    $1.SlotId? slot,
    $0.EntityUid? entity,
  }) {
    final result = create();
    if (slot != null) result.slot = slot;
    if (entity != null) result.entity = entity;
    return result;
  }

  PrincipalEquals._();

  factory PrincipalEquals.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PrincipalEquals.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, PrincipalEquals_Component>
      _PrincipalEquals_ComponentByTag = {
    1: PrincipalEquals_Component.slot,
    2: PrincipalEquals_Component.entity,
    0: PrincipalEquals_Component.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PrincipalEquals',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'cedar.v3'),
      createEmptyInstance: create)
    ..oo(0, [1, 2])
    ..e<$1.SlotId>(1, _omitFieldNames ? '' : 'slot', $pb.PbFieldType.OE,
        defaultOrMaker: $1.SlotId.SLOT_ID_UNSPECIFIED,
        valueOf: $1.SlotId.valueOf,
        enumValues: $1.SlotId.values)
    ..aOM<$0.EntityUid>(2, _omitFieldNames ? '' : 'entity',
        subBuilder: $0.EntityUid.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PrincipalEquals clone() => PrincipalEquals()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PrincipalEquals copyWith(void Function(PrincipalEquals) updates) =>
      super.copyWith((message) => updates(message as PrincipalEquals))
          as PrincipalEquals;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PrincipalEquals create() => PrincipalEquals._();
  @$core.override
  PrincipalEquals createEmptyInstance() => create();
  static $pb.PbList<PrincipalEquals> createRepeated() =>
      $pb.PbList<PrincipalEquals>();
  @$core.pragma('dart2js:noInline')
  static PrincipalEquals getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PrincipalEquals>(create);
  static PrincipalEquals? _defaultInstance;

  PrincipalEquals_Component whichComponent() =>
      _PrincipalEquals_ComponentByTag[$_whichOneof(0)]!;
  void clearComponent() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  $1.SlotId get slot => $_getN(0);
  @$pb.TagNumber(1)
  set slot($1.SlotId value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSlot() => $_has(0);
  @$pb.TagNumber(1)
  void clearSlot() => $_clearField(1);

  @$pb.TagNumber(2)
  $0.EntityUid get entity => $_getN(1);
  @$pb.TagNumber(2)
  set entity($0.EntityUid value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasEntity() => $_has(1);
  @$pb.TagNumber(2)
  void clearEntity() => $_clearField(2);
  @$pb.TagNumber(2)
  $0.EntityUid ensureEntity() => $_ensure(1);
}

enum PrincipalIn_Component { slot, entity, notSet }

class PrincipalIn extends $pb.GeneratedMessage {
  factory PrincipalIn({
    $1.SlotId? slot,
    $0.EntityUid? entity,
  }) {
    final result = create();
    if (slot != null) result.slot = slot;
    if (entity != null) result.entity = entity;
    return result;
  }

  PrincipalIn._();

  factory PrincipalIn.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PrincipalIn.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, PrincipalIn_Component>
      _PrincipalIn_ComponentByTag = {
    1: PrincipalIn_Component.slot,
    2: PrincipalIn_Component.entity,
    0: PrincipalIn_Component.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PrincipalIn',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'cedar.v3'),
      createEmptyInstance: create)
    ..oo(0, [1, 2])
    ..e<$1.SlotId>(1, _omitFieldNames ? '' : 'slot', $pb.PbFieldType.OE,
        defaultOrMaker: $1.SlotId.SLOT_ID_UNSPECIFIED,
        valueOf: $1.SlotId.valueOf,
        enumValues: $1.SlotId.values)
    ..aOM<$0.EntityUid>(2, _omitFieldNames ? '' : 'entity',
        subBuilder: $0.EntityUid.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PrincipalIn clone() => PrincipalIn()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PrincipalIn copyWith(void Function(PrincipalIn) updates) =>
      super.copyWith((message) => updates(message as PrincipalIn))
          as PrincipalIn;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PrincipalIn create() => PrincipalIn._();
  @$core.override
  PrincipalIn createEmptyInstance() => create();
  static $pb.PbList<PrincipalIn> createRepeated() => $pb.PbList<PrincipalIn>();
  @$core.pragma('dart2js:noInline')
  static PrincipalIn getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PrincipalIn>(create);
  static PrincipalIn? _defaultInstance;

  PrincipalIn_Component whichComponent() =>
      _PrincipalIn_ComponentByTag[$_whichOneof(0)]!;
  void clearComponent() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  $1.SlotId get slot => $_getN(0);
  @$pb.TagNumber(1)
  set slot($1.SlotId value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSlot() => $_has(0);
  @$pb.TagNumber(1)
  void clearSlot() => $_clearField(1);

  @$pb.TagNumber(2)
  $0.EntityUid get entity => $_getN(1);
  @$pb.TagNumber(2)
  set entity($0.EntityUid value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasEntity() => $_has(1);
  @$pb.TagNumber(2)
  void clearEntity() => $_clearField(2);
  @$pb.TagNumber(2)
  $0.EntityUid ensureEntity() => $_ensure(1);
}

enum PrincipalIsIn_In { slot, entity, notSet }

class PrincipalIsIn extends $pb.GeneratedMessage {
  factory PrincipalIsIn({
    $core.String? entityType,
    $1.SlotId? slot,
    $0.EntityUid? entity,
  }) {
    final result = create();
    if (entityType != null) result.entityType = entityType;
    if (slot != null) result.slot = slot;
    if (entity != null) result.entity = entity;
    return result;
  }

  PrincipalIsIn._();

  factory PrincipalIsIn.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PrincipalIsIn.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, PrincipalIsIn_In> _PrincipalIsIn_InByTag = {
    2: PrincipalIsIn_In.slot,
    3: PrincipalIsIn_In.entity,
    0: PrincipalIsIn_In.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PrincipalIsIn',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'cedar.v3'),
      createEmptyInstance: create)
    ..oo(0, [2, 3])
    ..aOS(1, _omitFieldNames ? '' : 'entityType')
    ..e<$1.SlotId>(2, _omitFieldNames ? '' : 'slot', $pb.PbFieldType.OE,
        defaultOrMaker: $1.SlotId.SLOT_ID_UNSPECIFIED,
        valueOf: $1.SlotId.valueOf,
        enumValues: $1.SlotId.values)
    ..aOM<$0.EntityUid>(3, _omitFieldNames ? '' : 'entity',
        subBuilder: $0.EntityUid.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PrincipalIsIn clone() => PrincipalIsIn()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PrincipalIsIn copyWith(void Function(PrincipalIsIn) updates) =>
      super.copyWith((message) => updates(message as PrincipalIsIn))
          as PrincipalIsIn;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PrincipalIsIn create() => PrincipalIsIn._();
  @$core.override
  PrincipalIsIn createEmptyInstance() => create();
  static $pb.PbList<PrincipalIsIn> createRepeated() =>
      $pb.PbList<PrincipalIsIn>();
  @$core.pragma('dart2js:noInline')
  static PrincipalIsIn getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PrincipalIsIn>(create);
  static PrincipalIsIn? _defaultInstance;

  PrincipalIsIn_In whichIn() => _PrincipalIsIn_InByTag[$_whichOneof(0)]!;
  void clearIn() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  $core.String get entityType => $_getSZ(0);
  @$pb.TagNumber(1)
  set entityType($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasEntityType() => $_has(0);
  @$pb.TagNumber(1)
  void clearEntityType() => $_clearField(1);

  @$pb.TagNumber(2)
  $1.SlotId get slot => $_getN(1);
  @$pb.TagNumber(2)
  set slot($1.SlotId value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasSlot() => $_has(1);
  @$pb.TagNumber(2)
  void clearSlot() => $_clearField(2);

  @$pb.TagNumber(3)
  $0.EntityUid get entity => $_getN(2);
  @$pb.TagNumber(3)
  set entity($0.EntityUid value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasEntity() => $_has(2);
  @$pb.TagNumber(3)
  void clearEntity() => $_clearField(3);
  @$pb.TagNumber(3)
  $0.EntityUid ensureEntity() => $_ensure(2);
}

class PrincipalIs extends $pb.GeneratedMessage {
  factory PrincipalIs({
    $core.String? entityType,
  }) {
    final result = create();
    if (entityType != null) result.entityType = entityType;
    return result;
  }

  PrincipalIs._();

  factory PrincipalIs.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PrincipalIs.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PrincipalIs',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'cedar.v3'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'entityType')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PrincipalIs clone() => PrincipalIs()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PrincipalIs copyWith(void Function(PrincipalIs) updates) =>
      super.copyWith((message) => updates(message as PrincipalIs))
          as PrincipalIs;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PrincipalIs create() => PrincipalIs._();
  @$core.override
  PrincipalIs createEmptyInstance() => create();
  static $pb.PbList<PrincipalIs> createRepeated() => $pb.PbList<PrincipalIs>();
  @$core.pragma('dart2js:noInline')
  static PrincipalIs getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PrincipalIs>(create);
  static PrincipalIs? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get entityType => $_getSZ(0);
  @$pb.TagNumber(1)
  set entityType($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasEntityType() => $_has(0);
  @$pb.TagNumber(1)
  void clearEntityType() => $_clearField(1);
}

enum ActionConstraint_Constraint { all, equals, in_, inSet, notSet }

class ActionConstraint extends $pb.GeneratedMessage {
  factory ActionConstraint({
    ActionAll? all,
    ActionEquals? equals,
    ActionIn? in_,
    ActionInSet? inSet,
  }) {
    final result = create();
    if (all != null) result.all = all;
    if (equals != null) result.equals = equals;
    if (in_ != null) result.in_ = in_;
    if (inSet != null) result.inSet = inSet;
    return result;
  }

  ActionConstraint._();

  factory ActionConstraint.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ActionConstraint.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, ActionConstraint_Constraint>
      _ActionConstraint_ConstraintByTag = {
    1: ActionConstraint_Constraint.all,
    2: ActionConstraint_Constraint.equals,
    3: ActionConstraint_Constraint.in_,
    4: ActionConstraint_Constraint.inSet,
    0: ActionConstraint_Constraint.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ActionConstraint',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'cedar.v3'),
      createEmptyInstance: create)
    ..oo(0, [1, 2, 3, 4])
    ..aOM<ActionAll>(1, _omitFieldNames ? '' : 'all',
        subBuilder: ActionAll.create)
    ..aOM<ActionEquals>(2, _omitFieldNames ? '' : 'equals',
        subBuilder: ActionEquals.create)
    ..aOM<ActionIn>(3, _omitFieldNames ? '' : 'in', subBuilder: ActionIn.create)
    ..aOM<ActionInSet>(4, _omitFieldNames ? '' : 'inSet',
        subBuilder: ActionInSet.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ActionConstraint clone() => ActionConstraint()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ActionConstraint copyWith(void Function(ActionConstraint) updates) =>
      super.copyWith((message) => updates(message as ActionConstraint))
          as ActionConstraint;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ActionConstraint create() => ActionConstraint._();
  @$core.override
  ActionConstraint createEmptyInstance() => create();
  static $pb.PbList<ActionConstraint> createRepeated() =>
      $pb.PbList<ActionConstraint>();
  @$core.pragma('dart2js:noInline')
  static ActionConstraint getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ActionConstraint>(create);
  static ActionConstraint? _defaultInstance;

  ActionConstraint_Constraint whichConstraint() =>
      _ActionConstraint_ConstraintByTag[$_whichOneof(0)]!;
  void clearConstraint() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  ActionAll get all => $_getN(0);
  @$pb.TagNumber(1)
  set all(ActionAll value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasAll() => $_has(0);
  @$pb.TagNumber(1)
  void clearAll() => $_clearField(1);
  @$pb.TagNumber(1)
  ActionAll ensureAll() => $_ensure(0);

  @$pb.TagNumber(2)
  ActionEquals get equals => $_getN(1);
  @$pb.TagNumber(2)
  set equals(ActionEquals value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasEquals() => $_has(1);
  @$pb.TagNumber(2)
  void clearEquals() => $_clearField(2);
  @$pb.TagNumber(2)
  ActionEquals ensureEquals() => $_ensure(1);

  @$pb.TagNumber(3)
  ActionIn get in_ => $_getN(2);
  @$pb.TagNumber(3)
  set in_(ActionIn value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasIn_() => $_has(2);
  @$pb.TagNumber(3)
  void clearIn_() => $_clearField(3);
  @$pb.TagNumber(3)
  ActionIn ensureIn_() => $_ensure(2);

  @$pb.TagNumber(4)
  ActionInSet get inSet => $_getN(3);
  @$pb.TagNumber(4)
  set inSet(ActionInSet value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasInSet() => $_has(3);
  @$pb.TagNumber(4)
  void clearInSet() => $_clearField(4);
  @$pb.TagNumber(4)
  ActionInSet ensureInSet() => $_ensure(3);
}

class ActionAll extends $pb.GeneratedMessage {
  factory ActionAll() => create();

  ActionAll._();

  factory ActionAll.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ActionAll.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ActionAll',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'cedar.v3'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ActionAll clone() => ActionAll()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ActionAll copyWith(void Function(ActionAll) updates) =>
      super.copyWith((message) => updates(message as ActionAll)) as ActionAll;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ActionAll create() => ActionAll._();
  @$core.override
  ActionAll createEmptyInstance() => create();
  static $pb.PbList<ActionAll> createRepeated() => $pb.PbList<ActionAll>();
  @$core.pragma('dart2js:noInline')
  static ActionAll getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ActionAll>(create);
  static ActionAll? _defaultInstance;
}

class ActionEquals extends $pb.GeneratedMessage {
  factory ActionEquals({
    $0.EntityUid? entity,
  }) {
    final result = create();
    if (entity != null) result.entity = entity;
    return result;
  }

  ActionEquals._();

  factory ActionEquals.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ActionEquals.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ActionEquals',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'cedar.v3'),
      createEmptyInstance: create)
    ..aOM<$0.EntityUid>(1, _omitFieldNames ? '' : 'entity',
        subBuilder: $0.EntityUid.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ActionEquals clone() => ActionEquals()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ActionEquals copyWith(void Function(ActionEquals) updates) =>
      super.copyWith((message) => updates(message as ActionEquals))
          as ActionEquals;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ActionEquals create() => ActionEquals._();
  @$core.override
  ActionEquals createEmptyInstance() => create();
  static $pb.PbList<ActionEquals> createRepeated() =>
      $pb.PbList<ActionEquals>();
  @$core.pragma('dart2js:noInline')
  static ActionEquals getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ActionEquals>(create);
  static ActionEquals? _defaultInstance;

  @$pb.TagNumber(1)
  $0.EntityUid get entity => $_getN(0);
  @$pb.TagNumber(1)
  set entity($0.EntityUid value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasEntity() => $_has(0);
  @$pb.TagNumber(1)
  void clearEntity() => $_clearField(1);
  @$pb.TagNumber(1)
  $0.EntityUid ensureEntity() => $_ensure(0);
}

class ActionIn extends $pb.GeneratedMessage {
  factory ActionIn({
    $0.EntityUid? entity,
  }) {
    final result = create();
    if (entity != null) result.entity = entity;
    return result;
  }

  ActionIn._();

  factory ActionIn.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ActionIn.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ActionIn',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'cedar.v3'),
      createEmptyInstance: create)
    ..aOM<$0.EntityUid>(1, _omitFieldNames ? '' : 'entity',
        subBuilder: $0.EntityUid.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ActionIn clone() => ActionIn()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ActionIn copyWith(void Function(ActionIn) updates) =>
      super.copyWith((message) => updates(message as ActionIn)) as ActionIn;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ActionIn create() => ActionIn._();
  @$core.override
  ActionIn createEmptyInstance() => create();
  static $pb.PbList<ActionIn> createRepeated() => $pb.PbList<ActionIn>();
  @$core.pragma('dart2js:noInline')
  static ActionIn getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ActionIn>(create);
  static ActionIn? _defaultInstance;

  @$pb.TagNumber(1)
  $0.EntityUid get entity => $_getN(0);
  @$pb.TagNumber(1)
  set entity($0.EntityUid value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasEntity() => $_has(0);
  @$pb.TagNumber(1)
  void clearEntity() => $_clearField(1);
  @$pb.TagNumber(1)
  $0.EntityUid ensureEntity() => $_ensure(0);
}

class ActionInSet extends $pb.GeneratedMessage {
  factory ActionInSet({
    $core.Iterable<$0.EntityUid>? entities,
  }) {
    final result = create();
    if (entities != null) result.entities.addAll(entities);
    return result;
  }

  ActionInSet._();

  factory ActionInSet.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ActionInSet.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ActionInSet',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'cedar.v3'),
      createEmptyInstance: create)
    ..pc<$0.EntityUid>(1, _omitFieldNames ? '' : 'entities', $pb.PbFieldType.PM,
        subBuilder: $0.EntityUid.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ActionInSet clone() => ActionInSet()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ActionInSet copyWith(void Function(ActionInSet) updates) =>
      super.copyWith((message) => updates(message as ActionInSet))
          as ActionInSet;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ActionInSet create() => ActionInSet._();
  @$core.override
  ActionInSet createEmptyInstance() => create();
  static $pb.PbList<ActionInSet> createRepeated() => $pb.PbList<ActionInSet>();
  @$core.pragma('dart2js:noInline')
  static ActionInSet getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ActionInSet>(create);
  static ActionInSet? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$0.EntityUid> get entities => $_getList(0);
}

enum ResourceConstraint_Constraint { all, equals, in_, isIn, is_5, notSet }

class ResourceConstraint extends $pb.GeneratedMessage {
  factory ResourceConstraint({
    ResourceAll? all,
    ResourceEquals? equals,
    ResourceIn? in_,
    ResourceIsIn? isIn,
    ResourceIs? is_5,
  }) {
    final result = create();
    if (all != null) result.all = all;
    if (equals != null) result.equals = equals;
    if (in_ != null) result.in_ = in_;
    if (isIn != null) result.isIn = isIn;
    if (is_5 != null) result.is_5 = is_5;
    return result;
  }

  ResourceConstraint._();

  factory ResourceConstraint.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ResourceConstraint.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, ResourceConstraint_Constraint>
      _ResourceConstraint_ConstraintByTag = {
    1: ResourceConstraint_Constraint.all,
    2: ResourceConstraint_Constraint.equals,
    3: ResourceConstraint_Constraint.in_,
    4: ResourceConstraint_Constraint.isIn,
    5: ResourceConstraint_Constraint.is_5,
    0: ResourceConstraint_Constraint.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ResourceConstraint',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'cedar.v3'),
      createEmptyInstance: create)
    ..oo(0, [1, 2, 3, 4, 5])
    ..aOM<ResourceAll>(1, _omitFieldNames ? '' : 'all',
        subBuilder: ResourceAll.create)
    ..aOM<ResourceEquals>(2, _omitFieldNames ? '' : 'equals',
        subBuilder: ResourceEquals.create)
    ..aOM<ResourceIn>(3, _omitFieldNames ? '' : 'in',
        subBuilder: ResourceIn.create)
    ..aOM<ResourceIsIn>(4, _omitFieldNames ? '' : 'isIn',
        subBuilder: ResourceIsIn.create)
    ..aOM<ResourceIs>(5, _omitFieldNames ? '' : 'is',
        subBuilder: ResourceIs.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResourceConstraint clone() => ResourceConstraint()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResourceConstraint copyWith(void Function(ResourceConstraint) updates) =>
      super.copyWith((message) => updates(message as ResourceConstraint))
          as ResourceConstraint;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ResourceConstraint create() => ResourceConstraint._();
  @$core.override
  ResourceConstraint createEmptyInstance() => create();
  static $pb.PbList<ResourceConstraint> createRepeated() =>
      $pb.PbList<ResourceConstraint>();
  @$core.pragma('dart2js:noInline')
  static ResourceConstraint getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ResourceConstraint>(create);
  static ResourceConstraint? _defaultInstance;

  ResourceConstraint_Constraint whichConstraint() =>
      _ResourceConstraint_ConstraintByTag[$_whichOneof(0)]!;
  void clearConstraint() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  ResourceAll get all => $_getN(0);
  @$pb.TagNumber(1)
  set all(ResourceAll value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasAll() => $_has(0);
  @$pb.TagNumber(1)
  void clearAll() => $_clearField(1);
  @$pb.TagNumber(1)
  ResourceAll ensureAll() => $_ensure(0);

  @$pb.TagNumber(2)
  ResourceEquals get equals => $_getN(1);
  @$pb.TagNumber(2)
  set equals(ResourceEquals value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasEquals() => $_has(1);
  @$pb.TagNumber(2)
  void clearEquals() => $_clearField(2);
  @$pb.TagNumber(2)
  ResourceEquals ensureEquals() => $_ensure(1);

  @$pb.TagNumber(3)
  ResourceIn get in_ => $_getN(2);
  @$pb.TagNumber(3)
  set in_(ResourceIn value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasIn_() => $_has(2);
  @$pb.TagNumber(3)
  void clearIn_() => $_clearField(3);
  @$pb.TagNumber(3)
  ResourceIn ensureIn_() => $_ensure(2);

  @$pb.TagNumber(4)
  ResourceIsIn get isIn => $_getN(3);
  @$pb.TagNumber(4)
  set isIn(ResourceIsIn value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasIsIn() => $_has(3);
  @$pb.TagNumber(4)
  void clearIsIn() => $_clearField(4);
  @$pb.TagNumber(4)
  ResourceIsIn ensureIsIn() => $_ensure(3);

  @$pb.TagNumber(5)
  ResourceIs get is_5 => $_getN(4);
  @$pb.TagNumber(5)
  set is_5(ResourceIs value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasIs_5() => $_has(4);
  @$pb.TagNumber(5)
  void clearIs_5() => $_clearField(5);
  @$pb.TagNumber(5)
  ResourceIs ensureIs_5() => $_ensure(4);
}

class ResourceAll extends $pb.GeneratedMessage {
  factory ResourceAll() => create();

  ResourceAll._();

  factory ResourceAll.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ResourceAll.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ResourceAll',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'cedar.v3'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResourceAll clone() => ResourceAll()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResourceAll copyWith(void Function(ResourceAll) updates) =>
      super.copyWith((message) => updates(message as ResourceAll))
          as ResourceAll;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ResourceAll create() => ResourceAll._();
  @$core.override
  ResourceAll createEmptyInstance() => create();
  static $pb.PbList<ResourceAll> createRepeated() => $pb.PbList<ResourceAll>();
  @$core.pragma('dart2js:noInline')
  static ResourceAll getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ResourceAll>(create);
  static ResourceAll? _defaultInstance;
}

enum ResourceEquals_Component { slot, entity, notSet }

class ResourceEquals extends $pb.GeneratedMessage {
  factory ResourceEquals({
    $1.SlotId? slot,
    $0.EntityUid? entity,
  }) {
    final result = create();
    if (slot != null) result.slot = slot;
    if (entity != null) result.entity = entity;
    return result;
  }

  ResourceEquals._();

  factory ResourceEquals.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ResourceEquals.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, ResourceEquals_Component>
      _ResourceEquals_ComponentByTag = {
    1: ResourceEquals_Component.slot,
    2: ResourceEquals_Component.entity,
    0: ResourceEquals_Component.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ResourceEquals',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'cedar.v3'),
      createEmptyInstance: create)
    ..oo(0, [1, 2])
    ..e<$1.SlotId>(1, _omitFieldNames ? '' : 'slot', $pb.PbFieldType.OE,
        defaultOrMaker: $1.SlotId.SLOT_ID_UNSPECIFIED,
        valueOf: $1.SlotId.valueOf,
        enumValues: $1.SlotId.values)
    ..aOM<$0.EntityUid>(2, _omitFieldNames ? '' : 'entity',
        subBuilder: $0.EntityUid.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResourceEquals clone() => ResourceEquals()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResourceEquals copyWith(void Function(ResourceEquals) updates) =>
      super.copyWith((message) => updates(message as ResourceEquals))
          as ResourceEquals;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ResourceEquals create() => ResourceEquals._();
  @$core.override
  ResourceEquals createEmptyInstance() => create();
  static $pb.PbList<ResourceEquals> createRepeated() =>
      $pb.PbList<ResourceEquals>();
  @$core.pragma('dart2js:noInline')
  static ResourceEquals getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ResourceEquals>(create);
  static ResourceEquals? _defaultInstance;

  ResourceEquals_Component whichComponent() =>
      _ResourceEquals_ComponentByTag[$_whichOneof(0)]!;
  void clearComponent() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  $1.SlotId get slot => $_getN(0);
  @$pb.TagNumber(1)
  set slot($1.SlotId value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSlot() => $_has(0);
  @$pb.TagNumber(1)
  void clearSlot() => $_clearField(1);

  @$pb.TagNumber(2)
  $0.EntityUid get entity => $_getN(1);
  @$pb.TagNumber(2)
  set entity($0.EntityUid value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasEntity() => $_has(1);
  @$pb.TagNumber(2)
  void clearEntity() => $_clearField(2);
  @$pb.TagNumber(2)
  $0.EntityUid ensureEntity() => $_ensure(1);
}

enum ResourceIn_Component { slot, entity, notSet }

class ResourceIn extends $pb.GeneratedMessage {
  factory ResourceIn({
    $1.SlotId? slot,
    $0.EntityUid? entity,
  }) {
    final result = create();
    if (slot != null) result.slot = slot;
    if (entity != null) result.entity = entity;
    return result;
  }

  ResourceIn._();

  factory ResourceIn.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ResourceIn.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, ResourceIn_Component>
      _ResourceIn_ComponentByTag = {
    1: ResourceIn_Component.slot,
    2: ResourceIn_Component.entity,
    0: ResourceIn_Component.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ResourceIn',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'cedar.v3'),
      createEmptyInstance: create)
    ..oo(0, [1, 2])
    ..e<$1.SlotId>(1, _omitFieldNames ? '' : 'slot', $pb.PbFieldType.OE,
        defaultOrMaker: $1.SlotId.SLOT_ID_UNSPECIFIED,
        valueOf: $1.SlotId.valueOf,
        enumValues: $1.SlotId.values)
    ..aOM<$0.EntityUid>(2, _omitFieldNames ? '' : 'entity',
        subBuilder: $0.EntityUid.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResourceIn clone() => ResourceIn()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResourceIn copyWith(void Function(ResourceIn) updates) =>
      super.copyWith((message) => updates(message as ResourceIn)) as ResourceIn;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ResourceIn create() => ResourceIn._();
  @$core.override
  ResourceIn createEmptyInstance() => create();
  static $pb.PbList<ResourceIn> createRepeated() => $pb.PbList<ResourceIn>();
  @$core.pragma('dart2js:noInline')
  static ResourceIn getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ResourceIn>(create);
  static ResourceIn? _defaultInstance;

  ResourceIn_Component whichComponent() =>
      _ResourceIn_ComponentByTag[$_whichOneof(0)]!;
  void clearComponent() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  $1.SlotId get slot => $_getN(0);
  @$pb.TagNumber(1)
  set slot($1.SlotId value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSlot() => $_has(0);
  @$pb.TagNumber(1)
  void clearSlot() => $_clearField(1);

  @$pb.TagNumber(2)
  $0.EntityUid get entity => $_getN(1);
  @$pb.TagNumber(2)
  set entity($0.EntityUid value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasEntity() => $_has(1);
  @$pb.TagNumber(2)
  void clearEntity() => $_clearField(2);
  @$pb.TagNumber(2)
  $0.EntityUid ensureEntity() => $_ensure(1);
}

enum ResourceIsIn_In { slot, entity, notSet }

class ResourceIsIn extends $pb.GeneratedMessage {
  factory ResourceIsIn({
    $core.String? entityType,
    $1.SlotId? slot,
    $0.EntityUid? entity,
  }) {
    final result = create();
    if (entityType != null) result.entityType = entityType;
    if (slot != null) result.slot = slot;
    if (entity != null) result.entity = entity;
    return result;
  }

  ResourceIsIn._();

  factory ResourceIsIn.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ResourceIsIn.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, ResourceIsIn_In> _ResourceIsIn_InByTag = {
    2: ResourceIsIn_In.slot,
    3: ResourceIsIn_In.entity,
    0: ResourceIsIn_In.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ResourceIsIn',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'cedar.v3'),
      createEmptyInstance: create)
    ..oo(0, [2, 3])
    ..aOS(1, _omitFieldNames ? '' : 'entityType')
    ..e<$1.SlotId>(2, _omitFieldNames ? '' : 'slot', $pb.PbFieldType.OE,
        defaultOrMaker: $1.SlotId.SLOT_ID_UNSPECIFIED,
        valueOf: $1.SlotId.valueOf,
        enumValues: $1.SlotId.values)
    ..aOM<$0.EntityUid>(3, _omitFieldNames ? '' : 'entity',
        subBuilder: $0.EntityUid.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResourceIsIn clone() => ResourceIsIn()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResourceIsIn copyWith(void Function(ResourceIsIn) updates) =>
      super.copyWith((message) => updates(message as ResourceIsIn))
          as ResourceIsIn;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ResourceIsIn create() => ResourceIsIn._();
  @$core.override
  ResourceIsIn createEmptyInstance() => create();
  static $pb.PbList<ResourceIsIn> createRepeated() =>
      $pb.PbList<ResourceIsIn>();
  @$core.pragma('dart2js:noInline')
  static ResourceIsIn getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ResourceIsIn>(create);
  static ResourceIsIn? _defaultInstance;

  ResourceIsIn_In whichIn() => _ResourceIsIn_InByTag[$_whichOneof(0)]!;
  void clearIn() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  $core.String get entityType => $_getSZ(0);
  @$pb.TagNumber(1)
  set entityType($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasEntityType() => $_has(0);
  @$pb.TagNumber(1)
  void clearEntityType() => $_clearField(1);

  @$pb.TagNumber(2)
  $1.SlotId get slot => $_getN(1);
  @$pb.TagNumber(2)
  set slot($1.SlotId value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasSlot() => $_has(1);
  @$pb.TagNumber(2)
  void clearSlot() => $_clearField(2);

  @$pb.TagNumber(3)
  $0.EntityUid get entity => $_getN(2);
  @$pb.TagNumber(3)
  set entity($0.EntityUid value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasEntity() => $_has(2);
  @$pb.TagNumber(3)
  void clearEntity() => $_clearField(3);
  @$pb.TagNumber(3)
  $0.EntityUid ensureEntity() => $_ensure(2);
}

class ResourceIs extends $pb.GeneratedMessage {
  factory ResourceIs({
    $core.String? entityType,
  }) {
    final result = create();
    if (entityType != null) result.entityType = entityType;
    return result;
  }

  ResourceIs._();

  factory ResourceIs.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ResourceIs.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ResourceIs',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'cedar.v3'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'entityType')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResourceIs clone() => ResourceIs()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResourceIs copyWith(void Function(ResourceIs) updates) =>
      super.copyWith((message) => updates(message as ResourceIs)) as ResourceIs;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ResourceIs create() => ResourceIs._();
  @$core.override
  ResourceIs createEmptyInstance() => create();
  static $pb.PbList<ResourceIs> createRepeated() => $pb.PbList<ResourceIs>();
  @$core.pragma('dart2js:noInline')
  static ResourceIs getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ResourceIs>(create);
  static ResourceIs? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get entityType => $_getSZ(0);
  @$pb.TagNumber(1)
  set entityType($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasEntityType() => $_has(0);
  @$pb.TagNumber(1)
  void clearEntityType() => $_clearField(1);
}

class Condition extends $pb.GeneratedMessage {
  factory Condition({
    ConditionKind? kind,
    $1.Expr? body,
  }) {
    final result = create();
    if (kind != null) result.kind = kind;
    if (body != null) result.body = body;
    return result;
  }

  Condition._();

  factory Condition.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Condition.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Condition',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'cedar.v3'),
      createEmptyInstance: create)
    ..e<ConditionKind>(1, _omitFieldNames ? '' : 'kind', $pb.PbFieldType.OE,
        defaultOrMaker: ConditionKind.CONDITION_KIND_UNSPECIFIED,
        valueOf: ConditionKind.valueOf,
        enumValues: ConditionKind.values)
    ..aOM<$1.Expr>(2, _omitFieldNames ? '' : 'body', subBuilder: $1.Expr.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Condition clone() => Condition()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Condition copyWith(void Function(Condition) updates) =>
      super.copyWith((message) => updates(message as Condition)) as Condition;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Condition create() => Condition._();
  @$core.override
  Condition createEmptyInstance() => create();
  static $pb.PbList<Condition> createRepeated() => $pb.PbList<Condition>();
  @$core.pragma('dart2js:noInline')
  static Condition getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Condition>(create);
  static Condition? _defaultInstance;

  @$pb.TagNumber(1)
  ConditionKind get kind => $_getN(0);
  @$pb.TagNumber(1)
  set kind(ConditionKind value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasKind() => $_has(0);
  @$pb.TagNumber(1)
  void clearKind() => $_clearField(1);

  @$pb.TagNumber(2)
  $1.Expr get body => $_getN(1);
  @$pb.TagNumber(2)
  set body($1.Expr value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasBody() => $_has(1);
  @$pb.TagNumber(2)
  void clearBody() => $_clearField(2);
  @$pb.TagNumber(2)
  $1.Expr ensureBody() => $_ensure(1);
}

class TemplateLink extends $pb.GeneratedMessage {
  factory TemplateLink({
    $core.String? templateId,
    $core.String? newId,
    $core.Iterable<$core.MapEntry<$core.String, $0.EntityUid>>? values,
  }) {
    final result = create();
    if (templateId != null) result.templateId = templateId;
    if (newId != null) result.newId = newId;
    if (values != null) result.values.addEntries(values);
    return result;
  }

  TemplateLink._();

  factory TemplateLink.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory TemplateLink.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TemplateLink',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'cedar.v3'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'templateId')
    ..aOS(2, _omitFieldNames ? '' : 'newId')
    ..m<$core.String, $0.EntityUid>(3, _omitFieldNames ? '' : 'values',
        entryClassName: 'TemplateLink.ValuesEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OM,
        valueCreator: $0.EntityUid.create,
        valueDefaultOrMaker: $0.EntityUid.getDefault,
        packageName: const $pb.PackageName('cedar.v3'))
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TemplateLink clone() => TemplateLink()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TemplateLink copyWith(void Function(TemplateLink) updates) =>
      super.copyWith((message) => updates(message as TemplateLink))
          as TemplateLink;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TemplateLink create() => TemplateLink._();
  @$core.override
  TemplateLink createEmptyInstance() => create();
  static $pb.PbList<TemplateLink> createRepeated() =>
      $pb.PbList<TemplateLink>();
  @$core.pragma('dart2js:noInline')
  static TemplateLink getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TemplateLink>(create);
  static TemplateLink? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get templateId => $_getSZ(0);
  @$pb.TagNumber(1)
  set templateId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTemplateId() => $_has(0);
  @$pb.TagNumber(1)
  void clearTemplateId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get newId => $_getSZ(1);
  @$pb.TagNumber(2)
  set newId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasNewId() => $_has(1);
  @$pb.TagNumber(2)
  void clearNewId() => $_clearField(2);

  @$pb.TagNumber(3)
  $pb.PbMap<$core.String, $0.EntityUid> get values => $_getMap(2);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
