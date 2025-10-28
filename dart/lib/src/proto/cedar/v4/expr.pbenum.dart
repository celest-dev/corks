// This is a generated file - do not edit.
//
// Generated from cedar/v4/expr.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class Variable extends $pb.ProtobufEnum {
  static const Variable VARIABLE_UNSPECIFIED =
      Variable._(0, _omitEnumNames ? '' : 'VARIABLE_UNSPECIFIED');
  static const Variable VARIABLE_PRINCIPAL =
      Variable._(1, _omitEnumNames ? '' : 'VARIABLE_PRINCIPAL');
  static const Variable VARIABLE_ACTION =
      Variable._(2, _omitEnumNames ? '' : 'VARIABLE_ACTION');
  static const Variable VARIABLE_RESOURCE =
      Variable._(3, _omitEnumNames ? '' : 'VARIABLE_RESOURCE');
  static const Variable VARIABLE_CONTEXT =
      Variable._(4, _omitEnumNames ? '' : 'VARIABLE_CONTEXT');

  static const $core.List<Variable> values = <Variable>[
    VARIABLE_UNSPECIFIED,
    VARIABLE_PRINCIPAL,
    VARIABLE_ACTION,
    VARIABLE_RESOURCE,
    VARIABLE_CONTEXT,
  ];

  static final $core.List<Variable?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static Variable? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const Variable._(super.value, super.name);
}

class SlotId extends $pb.ProtobufEnum {
  static const SlotId SLOT_ID_UNSPECIFIED =
      SlotId._(0, _omitEnumNames ? '' : 'SLOT_ID_UNSPECIFIED');
  static const SlotId SLOT_ID_PRINCIPAL =
      SlotId._(1, _omitEnumNames ? '' : 'SLOT_ID_PRINCIPAL');
  static const SlotId SLOT_ID_RESOURCE =
      SlotId._(2, _omitEnumNames ? '' : 'SLOT_ID_RESOURCE');

  static const $core.List<SlotId> values = <SlotId>[
    SLOT_ID_UNSPECIFIED,
    SLOT_ID_PRINCIPAL,
    SLOT_ID_RESOURCE,
  ];

  static final $core.List<SlotId?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 2);
  static SlotId? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const SlotId._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
