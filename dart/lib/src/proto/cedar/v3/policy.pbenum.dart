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

class Effect extends $pb.ProtobufEnum {
  static const Effect EFFECT_UNSPECIFIED =
      Effect._(0, _omitEnumNames ? '' : 'EFFECT_UNSPECIFIED');
  static const Effect EFFECT_PERMIT =
      Effect._(1, _omitEnumNames ? '' : 'EFFECT_PERMIT');
  static const Effect EFFECT_FORBID =
      Effect._(2, _omitEnumNames ? '' : 'EFFECT_FORBID');

  static const $core.List<Effect> values = <Effect>[
    EFFECT_UNSPECIFIED,
    EFFECT_PERMIT,
    EFFECT_FORBID,
  ];

  static final $core.List<Effect?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 2);
  static Effect? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const Effect._(super.value, super.name);
}

class ConditionKind extends $pb.ProtobufEnum {
  static const ConditionKind CONDITION_KIND_UNSPECIFIED =
      ConditionKind._(0, _omitEnumNames ? '' : 'CONDITION_KIND_UNSPECIFIED');
  static const ConditionKind CONDITION_KIND_WHEN =
      ConditionKind._(1, _omitEnumNames ? '' : 'CONDITION_KIND_WHEN');
  static const ConditionKind CONDITION_KIND_UNLESS =
      ConditionKind._(2, _omitEnumNames ? '' : 'CONDITION_KIND_UNLESS');

  static const $core.List<ConditionKind> values = <ConditionKind>[
    CONDITION_KIND_UNSPECIFIED,
    CONDITION_KIND_WHEN,
    CONDITION_KIND_UNLESS,
  ];

  static final $core.List<ConditionKind?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 2);
  static ConditionKind? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const ConditionKind._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
