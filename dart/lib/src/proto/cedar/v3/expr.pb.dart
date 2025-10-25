// This is a generated file - do not edit.
//
// Generated from cedar/v3/expr.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'expr.pbenum.dart';
import 'value.pb.dart' as $0;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'expr.pbenum.dart';

enum Expr_Expr {
  value,
  variable,
  slot,
  unknown,
  not,
  negate,
  equals,
  notEquals,
  in_,
  lessThan,
  lessThanOrEquals,
  greaterThan,
  greaterThanOrEquals,
  and,
  or,
  add,
  subtract,
  multiply,
  contains,
  containsAll,
  containsAny,
  getAttribute,
  hasAttribute,
  like,
  is_,
  ifThenElse,
  set,
  record,
  extensionCall,
  notSet
}

class Expr extends $pb.GeneratedMessage {
  factory Expr({
    ExprValue? value,
    ExprVariable? variable,
    ExprSlot? slot,
    ExprUnknown? unknown,
    ExprNot? not,
    ExprNegate? negate,
    ExprEquals? equals,
    ExprNotEquals? notEquals,
    ExprIn? in_,
    ExprLessThan? lessThan,
    ExprLessThanOrEquals? lessThanOrEquals,
    ExprGreaterThan? greaterThan,
    ExprGreaterThanOrEquals? greaterThanOrEquals,
    ExprAnd? and,
    ExprOr? or,
    ExprAdd? add,
    ExprSubt? subtract,
    ExprMult? multiply,
    ExprContains? contains,
    ExprContainsAll? containsAll,
    ExprContainsAny? containsAny,
    ExprGetAttribute? getAttribute,
    ExprHasAttribute? hasAttribute,
    ExprLike? like,
    ExprIs? is_,
    ExprIfThenElse? ifThenElse,
    ExprSet? set,
    ExprRecord? record,
    ExprExtensionCall? extensionCall,
  }) {
    final result = create();
    if (value != null) result.value = value;
    if (variable != null) result.variable = variable;
    if (slot != null) result.slot = slot;
    if (unknown != null) result.unknown = unknown;
    if (not != null) result.not = not;
    if (negate != null) result.negate = negate;
    if (equals != null) result.equals = equals;
    if (notEquals != null) result.notEquals = notEquals;
    if (in_ != null) result.in_ = in_;
    if (lessThan != null) result.lessThan = lessThan;
    if (lessThanOrEquals != null) result.lessThanOrEquals = lessThanOrEquals;
    if (greaterThan != null) result.greaterThan = greaterThan;
    if (greaterThanOrEquals != null)
      result.greaterThanOrEquals = greaterThanOrEquals;
    if (and != null) result.and = and;
    if (or != null) result.or = or;
    if (add != null) result.add = add;
    if (subtract != null) result.subtract = subtract;
    if (multiply != null) result.multiply = multiply;
    if (contains != null) result.contains = contains;
    if (containsAll != null) result.containsAll = containsAll;
    if (containsAny != null) result.containsAny = containsAny;
    if (getAttribute != null) result.getAttribute = getAttribute;
    if (hasAttribute != null) result.hasAttribute = hasAttribute;
    if (like != null) result.like = like;
    if (is_ != null) result.is_ = is_;
    if (ifThenElse != null) result.ifThenElse = ifThenElse;
    if (set != null) result.set = set;
    if (record != null) result.record = record;
    if (extensionCall != null) result.extensionCall = extensionCall;
    return result;
  }

  Expr._();

  factory Expr.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Expr.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, Expr_Expr> _Expr_ExprByTag = {
    1: Expr_Expr.value,
    2: Expr_Expr.variable,
    3: Expr_Expr.slot,
    4: Expr_Expr.unknown,
    5: Expr_Expr.not,
    6: Expr_Expr.negate,
    7: Expr_Expr.equals,
    8: Expr_Expr.notEquals,
    9: Expr_Expr.in_,
    10: Expr_Expr.lessThan,
    11: Expr_Expr.lessThanOrEquals,
    12: Expr_Expr.greaterThan,
    13: Expr_Expr.greaterThanOrEquals,
    14: Expr_Expr.and,
    15: Expr_Expr.or,
    16: Expr_Expr.add,
    17: Expr_Expr.subtract,
    18: Expr_Expr.multiply,
    19: Expr_Expr.contains,
    20: Expr_Expr.containsAll,
    21: Expr_Expr.containsAny,
    22: Expr_Expr.getAttribute,
    23: Expr_Expr.hasAttribute,
    24: Expr_Expr.like,
    25: Expr_Expr.is_,
    26: Expr_Expr.ifThenElse,
    27: Expr_Expr.set,
    28: Expr_Expr.record,
    29: Expr_Expr.extensionCall,
    0: Expr_Expr.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Expr',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'cedar.v3'),
      createEmptyInstance: create)
    ..oo(0, [
      1,
      2,
      3,
      4,
      5,
      6,
      7,
      8,
      9,
      10,
      11,
      12,
      13,
      14,
      15,
      16,
      17,
      18,
      19,
      20,
      21,
      22,
      23,
      24,
      25,
      26,
      27,
      28,
      29
    ])
    ..aOM<ExprValue>(1, _omitFieldNames ? '' : 'value',
        subBuilder: ExprValue.create)
    ..aOM<ExprVariable>(2, _omitFieldNames ? '' : 'variable',
        subBuilder: ExprVariable.create)
    ..aOM<ExprSlot>(3, _omitFieldNames ? '' : 'slot',
        subBuilder: ExprSlot.create)
    ..aOM<ExprUnknown>(4, _omitFieldNames ? '' : 'unknown',
        subBuilder: ExprUnknown.create)
    ..aOM<ExprNot>(5, _omitFieldNames ? '' : 'not', subBuilder: ExprNot.create)
    ..aOM<ExprNegate>(6, _omitFieldNames ? '' : 'negate',
        subBuilder: ExprNegate.create)
    ..aOM<ExprEquals>(7, _omitFieldNames ? '' : 'equals',
        subBuilder: ExprEquals.create)
    ..aOM<ExprNotEquals>(8, _omitFieldNames ? '' : 'notEquals',
        subBuilder: ExprNotEquals.create)
    ..aOM<ExprIn>(9, _omitFieldNames ? '' : 'in', subBuilder: ExprIn.create)
    ..aOM<ExprLessThan>(10, _omitFieldNames ? '' : 'lessThan',
        subBuilder: ExprLessThan.create)
    ..aOM<ExprLessThanOrEquals>(11, _omitFieldNames ? '' : 'lessThanOrEquals',
        subBuilder: ExprLessThanOrEquals.create)
    ..aOM<ExprGreaterThan>(12, _omitFieldNames ? '' : 'greaterThan',
        subBuilder: ExprGreaterThan.create)
    ..aOM<ExprGreaterThanOrEquals>(
        13, _omitFieldNames ? '' : 'greaterThanOrEquals',
        subBuilder: ExprGreaterThanOrEquals.create)
    ..aOM<ExprAnd>(14, _omitFieldNames ? '' : 'and', subBuilder: ExprAnd.create)
    ..aOM<ExprOr>(15, _omitFieldNames ? '' : 'or', subBuilder: ExprOr.create)
    ..aOM<ExprAdd>(16, _omitFieldNames ? '' : 'add', subBuilder: ExprAdd.create)
    ..aOM<ExprSubt>(17, _omitFieldNames ? '' : 'subtract',
        subBuilder: ExprSubt.create)
    ..aOM<ExprMult>(18, _omitFieldNames ? '' : 'multiply',
        subBuilder: ExprMult.create)
    ..aOM<ExprContains>(19, _omitFieldNames ? '' : 'contains',
        subBuilder: ExprContains.create)
    ..aOM<ExprContainsAll>(20, _omitFieldNames ? '' : 'containsAll',
        subBuilder: ExprContainsAll.create)
    ..aOM<ExprContainsAny>(21, _omitFieldNames ? '' : 'containsAny',
        subBuilder: ExprContainsAny.create)
    ..aOM<ExprGetAttribute>(22, _omitFieldNames ? '' : 'getAttribute',
        subBuilder: ExprGetAttribute.create)
    ..aOM<ExprHasAttribute>(23, _omitFieldNames ? '' : 'hasAttribute',
        subBuilder: ExprHasAttribute.create)
    ..aOM<ExprLike>(24, _omitFieldNames ? '' : 'like',
        subBuilder: ExprLike.create)
    ..aOM<ExprIs>(25, _omitFieldNames ? '' : 'is', subBuilder: ExprIs.create)
    ..aOM<ExprIfThenElse>(26, _omitFieldNames ? '' : 'ifThenElse',
        subBuilder: ExprIfThenElse.create)
    ..aOM<ExprSet>(27, _omitFieldNames ? '' : 'set', subBuilder: ExprSet.create)
    ..aOM<ExprRecord>(28, _omitFieldNames ? '' : 'record',
        subBuilder: ExprRecord.create)
    ..aOM<ExprExtensionCall>(29, _omitFieldNames ? '' : 'extensionCall',
        subBuilder: ExprExtensionCall.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Expr clone() => Expr()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Expr copyWith(void Function(Expr) updates) =>
      super.copyWith((message) => updates(message as Expr)) as Expr;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Expr create() => Expr._();
  @$core.override
  Expr createEmptyInstance() => create();
  static $pb.PbList<Expr> createRepeated() => $pb.PbList<Expr>();
  @$core.pragma('dart2js:noInline')
  static Expr getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Expr>(create);
  static Expr? _defaultInstance;

  Expr_Expr whichExpr() => _Expr_ExprByTag[$_whichOneof(0)]!;
  void clearExpr() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  ExprValue get value => $_getN(0);
  @$pb.TagNumber(1)
  set value(ExprValue value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasValue() => $_has(0);
  @$pb.TagNumber(1)
  void clearValue() => $_clearField(1);
  @$pb.TagNumber(1)
  ExprValue ensureValue() => $_ensure(0);

  @$pb.TagNumber(2)
  ExprVariable get variable => $_getN(1);
  @$pb.TagNumber(2)
  set variable(ExprVariable value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasVariable() => $_has(1);
  @$pb.TagNumber(2)
  void clearVariable() => $_clearField(2);
  @$pb.TagNumber(2)
  ExprVariable ensureVariable() => $_ensure(1);

  @$pb.TagNumber(3)
  ExprSlot get slot => $_getN(2);
  @$pb.TagNumber(3)
  set slot(ExprSlot value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasSlot() => $_has(2);
  @$pb.TagNumber(3)
  void clearSlot() => $_clearField(3);
  @$pb.TagNumber(3)
  ExprSlot ensureSlot() => $_ensure(2);

  @$pb.TagNumber(4)
  ExprUnknown get unknown => $_getN(3);
  @$pb.TagNumber(4)
  set unknown(ExprUnknown value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasUnknown() => $_has(3);
  @$pb.TagNumber(4)
  void clearUnknown() => $_clearField(4);
  @$pb.TagNumber(4)
  ExprUnknown ensureUnknown() => $_ensure(3);

  @$pb.TagNumber(5)
  ExprNot get not => $_getN(4);
  @$pb.TagNumber(5)
  set not(ExprNot value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasNot() => $_has(4);
  @$pb.TagNumber(5)
  void clearNot() => $_clearField(5);
  @$pb.TagNumber(5)
  ExprNot ensureNot() => $_ensure(4);

  @$pb.TagNumber(6)
  ExprNegate get negate => $_getN(5);
  @$pb.TagNumber(6)
  set negate(ExprNegate value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasNegate() => $_has(5);
  @$pb.TagNumber(6)
  void clearNegate() => $_clearField(6);
  @$pb.TagNumber(6)
  ExprNegate ensureNegate() => $_ensure(5);

  @$pb.TagNumber(7)
  ExprEquals get equals => $_getN(6);
  @$pb.TagNumber(7)
  set equals(ExprEquals value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasEquals() => $_has(6);
  @$pb.TagNumber(7)
  void clearEquals() => $_clearField(7);
  @$pb.TagNumber(7)
  ExprEquals ensureEquals() => $_ensure(6);

  @$pb.TagNumber(8)
  ExprNotEquals get notEquals => $_getN(7);
  @$pb.TagNumber(8)
  set notEquals(ExprNotEquals value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasNotEquals() => $_has(7);
  @$pb.TagNumber(8)
  void clearNotEquals() => $_clearField(8);
  @$pb.TagNumber(8)
  ExprNotEquals ensureNotEquals() => $_ensure(7);

  @$pb.TagNumber(9)
  ExprIn get in_ => $_getN(8);
  @$pb.TagNumber(9)
  set in_(ExprIn value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasIn_() => $_has(8);
  @$pb.TagNumber(9)
  void clearIn_() => $_clearField(9);
  @$pb.TagNumber(9)
  ExprIn ensureIn_() => $_ensure(8);

  @$pb.TagNumber(10)
  ExprLessThan get lessThan => $_getN(9);
  @$pb.TagNumber(10)
  set lessThan(ExprLessThan value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasLessThan() => $_has(9);
  @$pb.TagNumber(10)
  void clearLessThan() => $_clearField(10);
  @$pb.TagNumber(10)
  ExprLessThan ensureLessThan() => $_ensure(9);

  @$pb.TagNumber(11)
  ExprLessThanOrEquals get lessThanOrEquals => $_getN(10);
  @$pb.TagNumber(11)
  set lessThanOrEquals(ExprLessThanOrEquals value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasLessThanOrEquals() => $_has(10);
  @$pb.TagNumber(11)
  void clearLessThanOrEquals() => $_clearField(11);
  @$pb.TagNumber(11)
  ExprLessThanOrEquals ensureLessThanOrEquals() => $_ensure(10);

  @$pb.TagNumber(12)
  ExprGreaterThan get greaterThan => $_getN(11);
  @$pb.TagNumber(12)
  set greaterThan(ExprGreaterThan value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasGreaterThan() => $_has(11);
  @$pb.TagNumber(12)
  void clearGreaterThan() => $_clearField(12);
  @$pb.TagNumber(12)
  ExprGreaterThan ensureGreaterThan() => $_ensure(11);

  @$pb.TagNumber(13)
  ExprGreaterThanOrEquals get greaterThanOrEquals => $_getN(12);
  @$pb.TagNumber(13)
  set greaterThanOrEquals(ExprGreaterThanOrEquals value) =>
      $_setField(13, value);
  @$pb.TagNumber(13)
  $core.bool hasGreaterThanOrEquals() => $_has(12);
  @$pb.TagNumber(13)
  void clearGreaterThanOrEquals() => $_clearField(13);
  @$pb.TagNumber(13)
  ExprGreaterThanOrEquals ensureGreaterThanOrEquals() => $_ensure(12);

  @$pb.TagNumber(14)
  ExprAnd get and => $_getN(13);
  @$pb.TagNumber(14)
  set and(ExprAnd value) => $_setField(14, value);
  @$pb.TagNumber(14)
  $core.bool hasAnd() => $_has(13);
  @$pb.TagNumber(14)
  void clearAnd() => $_clearField(14);
  @$pb.TagNumber(14)
  ExprAnd ensureAnd() => $_ensure(13);

  @$pb.TagNumber(15)
  ExprOr get or => $_getN(14);
  @$pb.TagNumber(15)
  set or(ExprOr value) => $_setField(15, value);
  @$pb.TagNumber(15)
  $core.bool hasOr() => $_has(14);
  @$pb.TagNumber(15)
  void clearOr() => $_clearField(15);
  @$pb.TagNumber(15)
  ExprOr ensureOr() => $_ensure(14);

  @$pb.TagNumber(16)
  ExprAdd get add => $_getN(15);
  @$pb.TagNumber(16)
  set add(ExprAdd value) => $_setField(16, value);
  @$pb.TagNumber(16)
  $core.bool hasAdd() => $_has(15);
  @$pb.TagNumber(16)
  void clearAdd() => $_clearField(16);
  @$pb.TagNumber(16)
  ExprAdd ensureAdd() => $_ensure(15);

  @$pb.TagNumber(17)
  ExprSubt get subtract => $_getN(16);
  @$pb.TagNumber(17)
  set subtract(ExprSubt value) => $_setField(17, value);
  @$pb.TagNumber(17)
  $core.bool hasSubtract() => $_has(16);
  @$pb.TagNumber(17)
  void clearSubtract() => $_clearField(17);
  @$pb.TagNumber(17)
  ExprSubt ensureSubtract() => $_ensure(16);

  @$pb.TagNumber(18)
  ExprMult get multiply => $_getN(17);
  @$pb.TagNumber(18)
  set multiply(ExprMult value) => $_setField(18, value);
  @$pb.TagNumber(18)
  $core.bool hasMultiply() => $_has(17);
  @$pb.TagNumber(18)
  void clearMultiply() => $_clearField(18);
  @$pb.TagNumber(18)
  ExprMult ensureMultiply() => $_ensure(17);

  @$pb.TagNumber(19)
  ExprContains get contains => $_getN(18);
  @$pb.TagNumber(19)
  set contains(ExprContains value) => $_setField(19, value);
  @$pb.TagNumber(19)
  $core.bool hasContains() => $_has(18);
  @$pb.TagNumber(19)
  void clearContains() => $_clearField(19);
  @$pb.TagNumber(19)
  ExprContains ensureContains() => $_ensure(18);

  @$pb.TagNumber(20)
  ExprContainsAll get containsAll => $_getN(19);
  @$pb.TagNumber(20)
  set containsAll(ExprContainsAll value) => $_setField(20, value);
  @$pb.TagNumber(20)
  $core.bool hasContainsAll() => $_has(19);
  @$pb.TagNumber(20)
  void clearContainsAll() => $_clearField(20);
  @$pb.TagNumber(20)
  ExprContainsAll ensureContainsAll() => $_ensure(19);

  @$pb.TagNumber(21)
  ExprContainsAny get containsAny => $_getN(20);
  @$pb.TagNumber(21)
  set containsAny(ExprContainsAny value) => $_setField(21, value);
  @$pb.TagNumber(21)
  $core.bool hasContainsAny() => $_has(20);
  @$pb.TagNumber(21)
  void clearContainsAny() => $_clearField(21);
  @$pb.TagNumber(21)
  ExprContainsAny ensureContainsAny() => $_ensure(20);

  @$pb.TagNumber(22)
  ExprGetAttribute get getAttribute => $_getN(21);
  @$pb.TagNumber(22)
  set getAttribute(ExprGetAttribute value) => $_setField(22, value);
  @$pb.TagNumber(22)
  $core.bool hasGetAttribute() => $_has(21);
  @$pb.TagNumber(22)
  void clearGetAttribute() => $_clearField(22);
  @$pb.TagNumber(22)
  ExprGetAttribute ensureGetAttribute() => $_ensure(21);

  @$pb.TagNumber(23)
  ExprHasAttribute get hasAttribute => $_getN(22);
  @$pb.TagNumber(23)
  set hasAttribute(ExprHasAttribute value) => $_setField(23, value);
  @$pb.TagNumber(23)
  $core.bool hasHasAttribute() => $_has(22);
  @$pb.TagNumber(23)
  void clearHasAttribute() => $_clearField(23);
  @$pb.TagNumber(23)
  ExprHasAttribute ensureHasAttribute() => $_ensure(22);

  @$pb.TagNumber(24)
  ExprLike get like => $_getN(23);
  @$pb.TagNumber(24)
  set like(ExprLike value) => $_setField(24, value);
  @$pb.TagNumber(24)
  $core.bool hasLike() => $_has(23);
  @$pb.TagNumber(24)
  void clearLike() => $_clearField(24);
  @$pb.TagNumber(24)
  ExprLike ensureLike() => $_ensure(23);

  @$pb.TagNumber(25)
  ExprIs get is_ => $_getN(24);
  @$pb.TagNumber(25)
  set is_(ExprIs value) => $_setField(25, value);
  @$pb.TagNumber(25)
  $core.bool hasIs_() => $_has(24);
  @$pb.TagNumber(25)
  void clearIs_() => $_clearField(25);
  @$pb.TagNumber(25)
  ExprIs ensureIs_() => $_ensure(24);

  @$pb.TagNumber(26)
  ExprIfThenElse get ifThenElse => $_getN(25);
  @$pb.TagNumber(26)
  set ifThenElse(ExprIfThenElse value) => $_setField(26, value);
  @$pb.TagNumber(26)
  $core.bool hasIfThenElse() => $_has(25);
  @$pb.TagNumber(26)
  void clearIfThenElse() => $_clearField(26);
  @$pb.TagNumber(26)
  ExprIfThenElse ensureIfThenElse() => $_ensure(25);

  @$pb.TagNumber(27)
  ExprSet get set => $_getN(26);
  @$pb.TagNumber(27)
  set set(ExprSet value) => $_setField(27, value);
  @$pb.TagNumber(27)
  $core.bool hasSet() => $_has(26);
  @$pb.TagNumber(27)
  void clearSet() => $_clearField(27);
  @$pb.TagNumber(27)
  ExprSet ensureSet() => $_ensure(26);

  @$pb.TagNumber(28)
  ExprRecord get record => $_getN(27);
  @$pb.TagNumber(28)
  set record(ExprRecord value) => $_setField(28, value);
  @$pb.TagNumber(28)
  $core.bool hasRecord() => $_has(27);
  @$pb.TagNumber(28)
  void clearRecord() => $_clearField(28);
  @$pb.TagNumber(28)
  ExprRecord ensureRecord() => $_ensure(27);

  @$pb.TagNumber(29)
  ExprExtensionCall get extensionCall => $_getN(28);
  @$pb.TagNumber(29)
  set extensionCall(ExprExtensionCall value) => $_setField(29, value);
  @$pb.TagNumber(29)
  $core.bool hasExtensionCall() => $_has(28);
  @$pb.TagNumber(29)
  void clearExtensionCall() => $_clearField(29);
  @$pb.TagNumber(29)
  ExprExtensionCall ensureExtensionCall() => $_ensure(28);
}

class ExprValue extends $pb.GeneratedMessage {
  factory ExprValue({
    $0.Value? value,
  }) {
    final result = create();
    if (value != null) result.value = value;
    return result;
  }

  ExprValue._();

  factory ExprValue.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ExprValue.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ExprValue',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'cedar.v3'),
      createEmptyInstance: create)
    ..aOM<$0.Value>(1, _omitFieldNames ? '' : 'value',
        subBuilder: $0.Value.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExprValue clone() => ExprValue()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExprValue copyWith(void Function(ExprValue) updates) =>
      super.copyWith((message) => updates(message as ExprValue)) as ExprValue;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ExprValue create() => ExprValue._();
  @$core.override
  ExprValue createEmptyInstance() => create();
  static $pb.PbList<ExprValue> createRepeated() => $pb.PbList<ExprValue>();
  @$core.pragma('dart2js:noInline')
  static ExprValue getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ExprValue>(create);
  static ExprValue? _defaultInstance;

  @$pb.TagNumber(1)
  $0.Value get value => $_getN(0);
  @$pb.TagNumber(1)
  set value($0.Value value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasValue() => $_has(0);
  @$pb.TagNumber(1)
  void clearValue() => $_clearField(1);
  @$pb.TagNumber(1)
  $0.Value ensureValue() => $_ensure(0);
}

class ExprVariable extends $pb.GeneratedMessage {
  factory ExprVariable({
    Variable? variable,
  }) {
    final result = create();
    if (variable != null) result.variable = variable;
    return result;
  }

  ExprVariable._();

  factory ExprVariable.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ExprVariable.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ExprVariable',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'cedar.v3'),
      createEmptyInstance: create)
    ..e<Variable>(1, _omitFieldNames ? '' : 'variable', $pb.PbFieldType.OE,
        defaultOrMaker: Variable.VARIABLE_UNSPECIFIED,
        valueOf: Variable.valueOf,
        enumValues: Variable.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExprVariable clone() => ExprVariable()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExprVariable copyWith(void Function(ExprVariable) updates) =>
      super.copyWith((message) => updates(message as ExprVariable))
          as ExprVariable;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ExprVariable create() => ExprVariable._();
  @$core.override
  ExprVariable createEmptyInstance() => create();
  static $pb.PbList<ExprVariable> createRepeated() =>
      $pb.PbList<ExprVariable>();
  @$core.pragma('dart2js:noInline')
  static ExprVariable getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ExprVariable>(create);
  static ExprVariable? _defaultInstance;

  @$pb.TagNumber(1)
  Variable get variable => $_getN(0);
  @$pb.TagNumber(1)
  set variable(Variable value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasVariable() => $_has(0);
  @$pb.TagNumber(1)
  void clearVariable() => $_clearField(1);
}

class ExprSlot extends $pb.GeneratedMessage {
  factory ExprSlot({
    SlotId? slotId,
  }) {
    final result = create();
    if (slotId != null) result.slotId = slotId;
    return result;
  }

  ExprSlot._();

  factory ExprSlot.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ExprSlot.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ExprSlot',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'cedar.v3'),
      createEmptyInstance: create)
    ..e<SlotId>(1, _omitFieldNames ? '' : 'slotId', $pb.PbFieldType.OE,
        defaultOrMaker: SlotId.SLOT_ID_UNSPECIFIED,
        valueOf: SlotId.valueOf,
        enumValues: SlotId.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExprSlot clone() => ExprSlot()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExprSlot copyWith(void Function(ExprSlot) updates) =>
      super.copyWith((message) => updates(message as ExprSlot)) as ExprSlot;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ExprSlot create() => ExprSlot._();
  @$core.override
  ExprSlot createEmptyInstance() => create();
  static $pb.PbList<ExprSlot> createRepeated() => $pb.PbList<ExprSlot>();
  @$core.pragma('dart2js:noInline')
  static ExprSlot getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ExprSlot>(create);
  static ExprSlot? _defaultInstance;

  @$pb.TagNumber(1)
  SlotId get slotId => $_getN(0);
  @$pb.TagNumber(1)
  set slotId(SlotId value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSlotId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSlotId() => $_clearField(1);
}

class ExprUnknown extends $pb.GeneratedMessage {
  factory ExprUnknown({
    $core.String? name,
  }) {
    final result = create();
    if (name != null) result.name = name;
    return result;
  }

  ExprUnknown._();

  factory ExprUnknown.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ExprUnknown.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ExprUnknown',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'cedar.v3'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'name')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExprUnknown clone() => ExprUnknown()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExprUnknown copyWith(void Function(ExprUnknown) updates) =>
      super.copyWith((message) => updates(message as ExprUnknown))
          as ExprUnknown;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ExprUnknown create() => ExprUnknown._();
  @$core.override
  ExprUnknown createEmptyInstance() => create();
  static $pb.PbList<ExprUnknown> createRepeated() => $pb.PbList<ExprUnknown>();
  @$core.pragma('dart2js:noInline')
  static ExprUnknown getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ExprUnknown>(create);
  static ExprUnknown? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => $_clearField(1);
}

class ExprNot extends $pb.GeneratedMessage {
  factory ExprNot({
    Expr? arg,
  }) {
    final result = create();
    if (arg != null) result.arg = arg;
    return result;
  }

  ExprNot._();

  factory ExprNot.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ExprNot.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ExprNot',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'cedar.v3'),
      createEmptyInstance: create)
    ..aOM<Expr>(1, _omitFieldNames ? '' : 'arg', subBuilder: Expr.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExprNot clone() => ExprNot()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExprNot copyWith(void Function(ExprNot) updates) =>
      super.copyWith((message) => updates(message as ExprNot)) as ExprNot;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ExprNot create() => ExprNot._();
  @$core.override
  ExprNot createEmptyInstance() => create();
  static $pb.PbList<ExprNot> createRepeated() => $pb.PbList<ExprNot>();
  @$core.pragma('dart2js:noInline')
  static ExprNot getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ExprNot>(create);
  static ExprNot? _defaultInstance;

  @$pb.TagNumber(1)
  Expr get arg => $_getN(0);
  @$pb.TagNumber(1)
  set arg(Expr value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasArg() => $_has(0);
  @$pb.TagNumber(1)
  void clearArg() => $_clearField(1);
  @$pb.TagNumber(1)
  Expr ensureArg() => $_ensure(0);
}

class ExprNegate extends $pb.GeneratedMessage {
  factory ExprNegate({
    Expr? arg,
  }) {
    final result = create();
    if (arg != null) result.arg = arg;
    return result;
  }

  ExprNegate._();

  factory ExprNegate.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ExprNegate.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ExprNegate',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'cedar.v3'),
      createEmptyInstance: create)
    ..aOM<Expr>(1, _omitFieldNames ? '' : 'arg', subBuilder: Expr.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExprNegate clone() => ExprNegate()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExprNegate copyWith(void Function(ExprNegate) updates) =>
      super.copyWith((message) => updates(message as ExprNegate)) as ExprNegate;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ExprNegate create() => ExprNegate._();
  @$core.override
  ExprNegate createEmptyInstance() => create();
  static $pb.PbList<ExprNegate> createRepeated() => $pb.PbList<ExprNegate>();
  @$core.pragma('dart2js:noInline')
  static ExprNegate getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ExprNegate>(create);
  static ExprNegate? _defaultInstance;

  @$pb.TagNumber(1)
  Expr get arg => $_getN(0);
  @$pb.TagNumber(1)
  set arg(Expr value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasArg() => $_has(0);
  @$pb.TagNumber(1)
  void clearArg() => $_clearField(1);
  @$pb.TagNumber(1)
  Expr ensureArg() => $_ensure(0);
}

class ExprEquals extends $pb.GeneratedMessage {
  factory ExprEquals({
    Expr? left,
    Expr? right,
  }) {
    final result = create();
    if (left != null) result.left = left;
    if (right != null) result.right = right;
    return result;
  }

  ExprEquals._();

  factory ExprEquals.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ExprEquals.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ExprEquals',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'cedar.v3'),
      createEmptyInstance: create)
    ..aOM<Expr>(1, _omitFieldNames ? '' : 'left', subBuilder: Expr.create)
    ..aOM<Expr>(2, _omitFieldNames ? '' : 'right', subBuilder: Expr.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExprEquals clone() => ExprEquals()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExprEquals copyWith(void Function(ExprEquals) updates) =>
      super.copyWith((message) => updates(message as ExprEquals)) as ExprEquals;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ExprEquals create() => ExprEquals._();
  @$core.override
  ExprEquals createEmptyInstance() => create();
  static $pb.PbList<ExprEquals> createRepeated() => $pb.PbList<ExprEquals>();
  @$core.pragma('dart2js:noInline')
  static ExprEquals getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ExprEquals>(create);
  static ExprEquals? _defaultInstance;

  @$pb.TagNumber(1)
  Expr get left => $_getN(0);
  @$pb.TagNumber(1)
  set left(Expr value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasLeft() => $_has(0);
  @$pb.TagNumber(1)
  void clearLeft() => $_clearField(1);
  @$pb.TagNumber(1)
  Expr ensureLeft() => $_ensure(0);

  @$pb.TagNumber(2)
  Expr get right => $_getN(1);
  @$pb.TagNumber(2)
  set right(Expr value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasRight() => $_has(1);
  @$pb.TagNumber(2)
  void clearRight() => $_clearField(2);
  @$pb.TagNumber(2)
  Expr ensureRight() => $_ensure(1);
}

class ExprNotEquals extends $pb.GeneratedMessage {
  factory ExprNotEquals({
    Expr? left,
    Expr? right,
  }) {
    final result = create();
    if (left != null) result.left = left;
    if (right != null) result.right = right;
    return result;
  }

  ExprNotEquals._();

  factory ExprNotEquals.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ExprNotEquals.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ExprNotEquals',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'cedar.v3'),
      createEmptyInstance: create)
    ..aOM<Expr>(1, _omitFieldNames ? '' : 'left', subBuilder: Expr.create)
    ..aOM<Expr>(2, _omitFieldNames ? '' : 'right', subBuilder: Expr.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExprNotEquals clone() => ExprNotEquals()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExprNotEquals copyWith(void Function(ExprNotEquals) updates) =>
      super.copyWith((message) => updates(message as ExprNotEquals))
          as ExprNotEquals;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ExprNotEquals create() => ExprNotEquals._();
  @$core.override
  ExprNotEquals createEmptyInstance() => create();
  static $pb.PbList<ExprNotEquals> createRepeated() =>
      $pb.PbList<ExprNotEquals>();
  @$core.pragma('dart2js:noInline')
  static ExprNotEquals getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ExprNotEquals>(create);
  static ExprNotEquals? _defaultInstance;

  @$pb.TagNumber(1)
  Expr get left => $_getN(0);
  @$pb.TagNumber(1)
  set left(Expr value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasLeft() => $_has(0);
  @$pb.TagNumber(1)
  void clearLeft() => $_clearField(1);
  @$pb.TagNumber(1)
  Expr ensureLeft() => $_ensure(0);

  @$pb.TagNumber(2)
  Expr get right => $_getN(1);
  @$pb.TagNumber(2)
  set right(Expr value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasRight() => $_has(1);
  @$pb.TagNumber(2)
  void clearRight() => $_clearField(2);
  @$pb.TagNumber(2)
  Expr ensureRight() => $_ensure(1);
}

class ExprIn extends $pb.GeneratedMessage {
  factory ExprIn({
    Expr? left,
    Expr? right,
  }) {
    final result = create();
    if (left != null) result.left = left;
    if (right != null) result.right = right;
    return result;
  }

  ExprIn._();

  factory ExprIn.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ExprIn.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ExprIn',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'cedar.v3'),
      createEmptyInstance: create)
    ..aOM<Expr>(1, _omitFieldNames ? '' : 'left', subBuilder: Expr.create)
    ..aOM<Expr>(2, _omitFieldNames ? '' : 'right', subBuilder: Expr.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExprIn clone() => ExprIn()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExprIn copyWith(void Function(ExprIn) updates) =>
      super.copyWith((message) => updates(message as ExprIn)) as ExprIn;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ExprIn create() => ExprIn._();
  @$core.override
  ExprIn createEmptyInstance() => create();
  static $pb.PbList<ExprIn> createRepeated() => $pb.PbList<ExprIn>();
  @$core.pragma('dart2js:noInline')
  static ExprIn getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ExprIn>(create);
  static ExprIn? _defaultInstance;

  @$pb.TagNumber(1)
  Expr get left => $_getN(0);
  @$pb.TagNumber(1)
  set left(Expr value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasLeft() => $_has(0);
  @$pb.TagNumber(1)
  void clearLeft() => $_clearField(1);
  @$pb.TagNumber(1)
  Expr ensureLeft() => $_ensure(0);

  @$pb.TagNumber(2)
  Expr get right => $_getN(1);
  @$pb.TagNumber(2)
  set right(Expr value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasRight() => $_has(1);
  @$pb.TagNumber(2)
  void clearRight() => $_clearField(2);
  @$pb.TagNumber(2)
  Expr ensureRight() => $_ensure(1);
}

class ExprLessThan extends $pb.GeneratedMessage {
  factory ExprLessThan({
    Expr? left,
    Expr? right,
  }) {
    final result = create();
    if (left != null) result.left = left;
    if (right != null) result.right = right;
    return result;
  }

  ExprLessThan._();

  factory ExprLessThan.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ExprLessThan.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ExprLessThan',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'cedar.v3'),
      createEmptyInstance: create)
    ..aOM<Expr>(1, _omitFieldNames ? '' : 'left', subBuilder: Expr.create)
    ..aOM<Expr>(2, _omitFieldNames ? '' : 'right', subBuilder: Expr.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExprLessThan clone() => ExprLessThan()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExprLessThan copyWith(void Function(ExprLessThan) updates) =>
      super.copyWith((message) => updates(message as ExprLessThan))
          as ExprLessThan;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ExprLessThan create() => ExprLessThan._();
  @$core.override
  ExprLessThan createEmptyInstance() => create();
  static $pb.PbList<ExprLessThan> createRepeated() =>
      $pb.PbList<ExprLessThan>();
  @$core.pragma('dart2js:noInline')
  static ExprLessThan getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ExprLessThan>(create);
  static ExprLessThan? _defaultInstance;

  @$pb.TagNumber(1)
  Expr get left => $_getN(0);
  @$pb.TagNumber(1)
  set left(Expr value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasLeft() => $_has(0);
  @$pb.TagNumber(1)
  void clearLeft() => $_clearField(1);
  @$pb.TagNumber(1)
  Expr ensureLeft() => $_ensure(0);

  @$pb.TagNumber(2)
  Expr get right => $_getN(1);
  @$pb.TagNumber(2)
  set right(Expr value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasRight() => $_has(1);
  @$pb.TagNumber(2)
  void clearRight() => $_clearField(2);
  @$pb.TagNumber(2)
  Expr ensureRight() => $_ensure(1);
}

class ExprLessThanOrEquals extends $pb.GeneratedMessage {
  factory ExprLessThanOrEquals({
    Expr? left,
    Expr? right,
  }) {
    final result = create();
    if (left != null) result.left = left;
    if (right != null) result.right = right;
    return result;
  }

  ExprLessThanOrEquals._();

  factory ExprLessThanOrEquals.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ExprLessThanOrEquals.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ExprLessThanOrEquals',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'cedar.v3'),
      createEmptyInstance: create)
    ..aOM<Expr>(1, _omitFieldNames ? '' : 'left', subBuilder: Expr.create)
    ..aOM<Expr>(2, _omitFieldNames ? '' : 'right', subBuilder: Expr.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExprLessThanOrEquals clone() =>
      ExprLessThanOrEquals()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExprLessThanOrEquals copyWith(void Function(ExprLessThanOrEquals) updates) =>
      super.copyWith((message) => updates(message as ExprLessThanOrEquals))
          as ExprLessThanOrEquals;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ExprLessThanOrEquals create() => ExprLessThanOrEquals._();
  @$core.override
  ExprLessThanOrEquals createEmptyInstance() => create();
  static $pb.PbList<ExprLessThanOrEquals> createRepeated() =>
      $pb.PbList<ExprLessThanOrEquals>();
  @$core.pragma('dart2js:noInline')
  static ExprLessThanOrEquals getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ExprLessThanOrEquals>(create);
  static ExprLessThanOrEquals? _defaultInstance;

  @$pb.TagNumber(1)
  Expr get left => $_getN(0);
  @$pb.TagNumber(1)
  set left(Expr value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasLeft() => $_has(0);
  @$pb.TagNumber(1)
  void clearLeft() => $_clearField(1);
  @$pb.TagNumber(1)
  Expr ensureLeft() => $_ensure(0);

  @$pb.TagNumber(2)
  Expr get right => $_getN(1);
  @$pb.TagNumber(2)
  set right(Expr value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasRight() => $_has(1);
  @$pb.TagNumber(2)
  void clearRight() => $_clearField(2);
  @$pb.TagNumber(2)
  Expr ensureRight() => $_ensure(1);
}

class ExprGreaterThan extends $pb.GeneratedMessage {
  factory ExprGreaterThan({
    Expr? left,
    Expr? right,
  }) {
    final result = create();
    if (left != null) result.left = left;
    if (right != null) result.right = right;
    return result;
  }

  ExprGreaterThan._();

  factory ExprGreaterThan.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ExprGreaterThan.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ExprGreaterThan',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'cedar.v3'),
      createEmptyInstance: create)
    ..aOM<Expr>(1, _omitFieldNames ? '' : 'left', subBuilder: Expr.create)
    ..aOM<Expr>(2, _omitFieldNames ? '' : 'right', subBuilder: Expr.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExprGreaterThan clone() => ExprGreaterThan()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExprGreaterThan copyWith(void Function(ExprGreaterThan) updates) =>
      super.copyWith((message) => updates(message as ExprGreaterThan))
          as ExprGreaterThan;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ExprGreaterThan create() => ExprGreaterThan._();
  @$core.override
  ExprGreaterThan createEmptyInstance() => create();
  static $pb.PbList<ExprGreaterThan> createRepeated() =>
      $pb.PbList<ExprGreaterThan>();
  @$core.pragma('dart2js:noInline')
  static ExprGreaterThan getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ExprGreaterThan>(create);
  static ExprGreaterThan? _defaultInstance;

  @$pb.TagNumber(1)
  Expr get left => $_getN(0);
  @$pb.TagNumber(1)
  set left(Expr value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasLeft() => $_has(0);
  @$pb.TagNumber(1)
  void clearLeft() => $_clearField(1);
  @$pb.TagNumber(1)
  Expr ensureLeft() => $_ensure(0);

  @$pb.TagNumber(2)
  Expr get right => $_getN(1);
  @$pb.TagNumber(2)
  set right(Expr value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasRight() => $_has(1);
  @$pb.TagNumber(2)
  void clearRight() => $_clearField(2);
  @$pb.TagNumber(2)
  Expr ensureRight() => $_ensure(1);
}

class ExprGreaterThanOrEquals extends $pb.GeneratedMessage {
  factory ExprGreaterThanOrEquals({
    Expr? left,
    Expr? right,
  }) {
    final result = create();
    if (left != null) result.left = left;
    if (right != null) result.right = right;
    return result;
  }

  ExprGreaterThanOrEquals._();

  factory ExprGreaterThanOrEquals.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ExprGreaterThanOrEquals.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ExprGreaterThanOrEquals',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'cedar.v3'),
      createEmptyInstance: create)
    ..aOM<Expr>(1, _omitFieldNames ? '' : 'left', subBuilder: Expr.create)
    ..aOM<Expr>(2, _omitFieldNames ? '' : 'right', subBuilder: Expr.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExprGreaterThanOrEquals clone() =>
      ExprGreaterThanOrEquals()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExprGreaterThanOrEquals copyWith(
          void Function(ExprGreaterThanOrEquals) updates) =>
      super.copyWith((message) => updates(message as ExprGreaterThanOrEquals))
          as ExprGreaterThanOrEquals;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ExprGreaterThanOrEquals create() => ExprGreaterThanOrEquals._();
  @$core.override
  ExprGreaterThanOrEquals createEmptyInstance() => create();
  static $pb.PbList<ExprGreaterThanOrEquals> createRepeated() =>
      $pb.PbList<ExprGreaterThanOrEquals>();
  @$core.pragma('dart2js:noInline')
  static ExprGreaterThanOrEquals getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ExprGreaterThanOrEquals>(create);
  static ExprGreaterThanOrEquals? _defaultInstance;

  @$pb.TagNumber(1)
  Expr get left => $_getN(0);
  @$pb.TagNumber(1)
  set left(Expr value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasLeft() => $_has(0);
  @$pb.TagNumber(1)
  void clearLeft() => $_clearField(1);
  @$pb.TagNumber(1)
  Expr ensureLeft() => $_ensure(0);

  @$pb.TagNumber(2)
  Expr get right => $_getN(1);
  @$pb.TagNumber(2)
  set right(Expr value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasRight() => $_has(1);
  @$pb.TagNumber(2)
  void clearRight() => $_clearField(2);
  @$pb.TagNumber(2)
  Expr ensureRight() => $_ensure(1);
}

class ExprAnd extends $pb.GeneratedMessage {
  factory ExprAnd({
    Expr? left,
    Expr? right,
  }) {
    final result = create();
    if (left != null) result.left = left;
    if (right != null) result.right = right;
    return result;
  }

  ExprAnd._();

  factory ExprAnd.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ExprAnd.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ExprAnd',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'cedar.v3'),
      createEmptyInstance: create)
    ..aOM<Expr>(1, _omitFieldNames ? '' : 'left', subBuilder: Expr.create)
    ..aOM<Expr>(2, _omitFieldNames ? '' : 'right', subBuilder: Expr.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExprAnd clone() => ExprAnd()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExprAnd copyWith(void Function(ExprAnd) updates) =>
      super.copyWith((message) => updates(message as ExprAnd)) as ExprAnd;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ExprAnd create() => ExprAnd._();
  @$core.override
  ExprAnd createEmptyInstance() => create();
  static $pb.PbList<ExprAnd> createRepeated() => $pb.PbList<ExprAnd>();
  @$core.pragma('dart2js:noInline')
  static ExprAnd getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ExprAnd>(create);
  static ExprAnd? _defaultInstance;

  @$pb.TagNumber(1)
  Expr get left => $_getN(0);
  @$pb.TagNumber(1)
  set left(Expr value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasLeft() => $_has(0);
  @$pb.TagNumber(1)
  void clearLeft() => $_clearField(1);
  @$pb.TagNumber(1)
  Expr ensureLeft() => $_ensure(0);

  @$pb.TagNumber(2)
  Expr get right => $_getN(1);
  @$pb.TagNumber(2)
  set right(Expr value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasRight() => $_has(1);
  @$pb.TagNumber(2)
  void clearRight() => $_clearField(2);
  @$pb.TagNumber(2)
  Expr ensureRight() => $_ensure(1);
}

class ExprOr extends $pb.GeneratedMessage {
  factory ExprOr({
    Expr? left,
    Expr? right,
  }) {
    final result = create();
    if (left != null) result.left = left;
    if (right != null) result.right = right;
    return result;
  }

  ExprOr._();

  factory ExprOr.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ExprOr.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ExprOr',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'cedar.v3'),
      createEmptyInstance: create)
    ..aOM<Expr>(1, _omitFieldNames ? '' : 'left', subBuilder: Expr.create)
    ..aOM<Expr>(2, _omitFieldNames ? '' : 'right', subBuilder: Expr.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExprOr clone() => ExprOr()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExprOr copyWith(void Function(ExprOr) updates) =>
      super.copyWith((message) => updates(message as ExprOr)) as ExprOr;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ExprOr create() => ExprOr._();
  @$core.override
  ExprOr createEmptyInstance() => create();
  static $pb.PbList<ExprOr> createRepeated() => $pb.PbList<ExprOr>();
  @$core.pragma('dart2js:noInline')
  static ExprOr getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ExprOr>(create);
  static ExprOr? _defaultInstance;

  @$pb.TagNumber(1)
  Expr get left => $_getN(0);
  @$pb.TagNumber(1)
  set left(Expr value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasLeft() => $_has(0);
  @$pb.TagNumber(1)
  void clearLeft() => $_clearField(1);
  @$pb.TagNumber(1)
  Expr ensureLeft() => $_ensure(0);

  @$pb.TagNumber(2)
  Expr get right => $_getN(1);
  @$pb.TagNumber(2)
  set right(Expr value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasRight() => $_has(1);
  @$pb.TagNumber(2)
  void clearRight() => $_clearField(2);
  @$pb.TagNumber(2)
  Expr ensureRight() => $_ensure(1);
}

class ExprAdd extends $pb.GeneratedMessage {
  factory ExprAdd({
    Expr? left,
    Expr? right,
  }) {
    final result = create();
    if (left != null) result.left = left;
    if (right != null) result.right = right;
    return result;
  }

  ExprAdd._();

  factory ExprAdd.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ExprAdd.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ExprAdd',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'cedar.v3'),
      createEmptyInstance: create)
    ..aOM<Expr>(1, _omitFieldNames ? '' : 'left', subBuilder: Expr.create)
    ..aOM<Expr>(2, _omitFieldNames ? '' : 'right', subBuilder: Expr.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExprAdd clone() => ExprAdd()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExprAdd copyWith(void Function(ExprAdd) updates) =>
      super.copyWith((message) => updates(message as ExprAdd)) as ExprAdd;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ExprAdd create() => ExprAdd._();
  @$core.override
  ExprAdd createEmptyInstance() => create();
  static $pb.PbList<ExprAdd> createRepeated() => $pb.PbList<ExprAdd>();
  @$core.pragma('dart2js:noInline')
  static ExprAdd getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ExprAdd>(create);
  static ExprAdd? _defaultInstance;

  @$pb.TagNumber(1)
  Expr get left => $_getN(0);
  @$pb.TagNumber(1)
  set left(Expr value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasLeft() => $_has(0);
  @$pb.TagNumber(1)
  void clearLeft() => $_clearField(1);
  @$pb.TagNumber(1)
  Expr ensureLeft() => $_ensure(0);

  @$pb.TagNumber(2)
  Expr get right => $_getN(1);
  @$pb.TagNumber(2)
  set right(Expr value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasRight() => $_has(1);
  @$pb.TagNumber(2)
  void clearRight() => $_clearField(2);
  @$pb.TagNumber(2)
  Expr ensureRight() => $_ensure(1);
}

class ExprSubt extends $pb.GeneratedMessage {
  factory ExprSubt({
    Expr? left,
    Expr? right,
  }) {
    final result = create();
    if (left != null) result.left = left;
    if (right != null) result.right = right;
    return result;
  }

  ExprSubt._();

  factory ExprSubt.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ExprSubt.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ExprSubt',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'cedar.v3'),
      createEmptyInstance: create)
    ..aOM<Expr>(1, _omitFieldNames ? '' : 'left', subBuilder: Expr.create)
    ..aOM<Expr>(2, _omitFieldNames ? '' : 'right', subBuilder: Expr.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExprSubt clone() => ExprSubt()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExprSubt copyWith(void Function(ExprSubt) updates) =>
      super.copyWith((message) => updates(message as ExprSubt)) as ExprSubt;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ExprSubt create() => ExprSubt._();
  @$core.override
  ExprSubt createEmptyInstance() => create();
  static $pb.PbList<ExprSubt> createRepeated() => $pb.PbList<ExprSubt>();
  @$core.pragma('dart2js:noInline')
  static ExprSubt getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ExprSubt>(create);
  static ExprSubt? _defaultInstance;

  @$pb.TagNumber(1)
  Expr get left => $_getN(0);
  @$pb.TagNumber(1)
  set left(Expr value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasLeft() => $_has(0);
  @$pb.TagNumber(1)
  void clearLeft() => $_clearField(1);
  @$pb.TagNumber(1)
  Expr ensureLeft() => $_ensure(0);

  @$pb.TagNumber(2)
  Expr get right => $_getN(1);
  @$pb.TagNumber(2)
  set right(Expr value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasRight() => $_has(1);
  @$pb.TagNumber(2)
  void clearRight() => $_clearField(2);
  @$pb.TagNumber(2)
  Expr ensureRight() => $_ensure(1);
}

class ExprMult extends $pb.GeneratedMessage {
  factory ExprMult({
    Expr? left,
    Expr? right,
  }) {
    final result = create();
    if (left != null) result.left = left;
    if (right != null) result.right = right;
    return result;
  }

  ExprMult._();

  factory ExprMult.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ExprMult.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ExprMult',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'cedar.v3'),
      createEmptyInstance: create)
    ..aOM<Expr>(1, _omitFieldNames ? '' : 'left', subBuilder: Expr.create)
    ..aOM<Expr>(2, _omitFieldNames ? '' : 'right', subBuilder: Expr.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExprMult clone() => ExprMult()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExprMult copyWith(void Function(ExprMult) updates) =>
      super.copyWith((message) => updates(message as ExprMult)) as ExprMult;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ExprMult create() => ExprMult._();
  @$core.override
  ExprMult createEmptyInstance() => create();
  static $pb.PbList<ExprMult> createRepeated() => $pb.PbList<ExprMult>();
  @$core.pragma('dart2js:noInline')
  static ExprMult getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ExprMult>(create);
  static ExprMult? _defaultInstance;

  @$pb.TagNumber(1)
  Expr get left => $_getN(0);
  @$pb.TagNumber(1)
  set left(Expr value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasLeft() => $_has(0);
  @$pb.TagNumber(1)
  void clearLeft() => $_clearField(1);
  @$pb.TagNumber(1)
  Expr ensureLeft() => $_ensure(0);

  @$pb.TagNumber(2)
  Expr get right => $_getN(1);
  @$pb.TagNumber(2)
  set right(Expr value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasRight() => $_has(1);
  @$pb.TagNumber(2)
  void clearRight() => $_clearField(2);
  @$pb.TagNumber(2)
  Expr ensureRight() => $_ensure(1);
}

class ExprContains extends $pb.GeneratedMessage {
  factory ExprContains({
    Expr? left,
    Expr? right,
  }) {
    final result = create();
    if (left != null) result.left = left;
    if (right != null) result.right = right;
    return result;
  }

  ExprContains._();

  factory ExprContains.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ExprContains.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ExprContains',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'cedar.v3'),
      createEmptyInstance: create)
    ..aOM<Expr>(1, _omitFieldNames ? '' : 'left', subBuilder: Expr.create)
    ..aOM<Expr>(2, _omitFieldNames ? '' : 'right', subBuilder: Expr.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExprContains clone() => ExprContains()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExprContains copyWith(void Function(ExprContains) updates) =>
      super.copyWith((message) => updates(message as ExprContains))
          as ExprContains;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ExprContains create() => ExprContains._();
  @$core.override
  ExprContains createEmptyInstance() => create();
  static $pb.PbList<ExprContains> createRepeated() =>
      $pb.PbList<ExprContains>();
  @$core.pragma('dart2js:noInline')
  static ExprContains getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ExprContains>(create);
  static ExprContains? _defaultInstance;

  @$pb.TagNumber(1)
  Expr get left => $_getN(0);
  @$pb.TagNumber(1)
  set left(Expr value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasLeft() => $_has(0);
  @$pb.TagNumber(1)
  void clearLeft() => $_clearField(1);
  @$pb.TagNumber(1)
  Expr ensureLeft() => $_ensure(0);

  @$pb.TagNumber(2)
  Expr get right => $_getN(1);
  @$pb.TagNumber(2)
  set right(Expr value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasRight() => $_has(1);
  @$pb.TagNumber(2)
  void clearRight() => $_clearField(2);
  @$pb.TagNumber(2)
  Expr ensureRight() => $_ensure(1);
}

class ExprContainsAll extends $pb.GeneratedMessage {
  factory ExprContainsAll({
    Expr? left,
    Expr? right,
  }) {
    final result = create();
    if (left != null) result.left = left;
    if (right != null) result.right = right;
    return result;
  }

  ExprContainsAll._();

  factory ExprContainsAll.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ExprContainsAll.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ExprContainsAll',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'cedar.v3'),
      createEmptyInstance: create)
    ..aOM<Expr>(1, _omitFieldNames ? '' : 'left', subBuilder: Expr.create)
    ..aOM<Expr>(2, _omitFieldNames ? '' : 'right', subBuilder: Expr.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExprContainsAll clone() => ExprContainsAll()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExprContainsAll copyWith(void Function(ExprContainsAll) updates) =>
      super.copyWith((message) => updates(message as ExprContainsAll))
          as ExprContainsAll;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ExprContainsAll create() => ExprContainsAll._();
  @$core.override
  ExprContainsAll createEmptyInstance() => create();
  static $pb.PbList<ExprContainsAll> createRepeated() =>
      $pb.PbList<ExprContainsAll>();
  @$core.pragma('dart2js:noInline')
  static ExprContainsAll getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ExprContainsAll>(create);
  static ExprContainsAll? _defaultInstance;

  @$pb.TagNumber(1)
  Expr get left => $_getN(0);
  @$pb.TagNumber(1)
  set left(Expr value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasLeft() => $_has(0);
  @$pb.TagNumber(1)
  void clearLeft() => $_clearField(1);
  @$pb.TagNumber(1)
  Expr ensureLeft() => $_ensure(0);

  @$pb.TagNumber(2)
  Expr get right => $_getN(1);
  @$pb.TagNumber(2)
  set right(Expr value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasRight() => $_has(1);
  @$pb.TagNumber(2)
  void clearRight() => $_clearField(2);
  @$pb.TagNumber(2)
  Expr ensureRight() => $_ensure(1);
}

class ExprContainsAny extends $pb.GeneratedMessage {
  factory ExprContainsAny({
    Expr? left,
    Expr? right,
  }) {
    final result = create();
    if (left != null) result.left = left;
    if (right != null) result.right = right;
    return result;
  }

  ExprContainsAny._();

  factory ExprContainsAny.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ExprContainsAny.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ExprContainsAny',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'cedar.v3'),
      createEmptyInstance: create)
    ..aOM<Expr>(1, _omitFieldNames ? '' : 'left', subBuilder: Expr.create)
    ..aOM<Expr>(2, _omitFieldNames ? '' : 'right', subBuilder: Expr.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExprContainsAny clone() => ExprContainsAny()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExprContainsAny copyWith(void Function(ExprContainsAny) updates) =>
      super.copyWith((message) => updates(message as ExprContainsAny))
          as ExprContainsAny;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ExprContainsAny create() => ExprContainsAny._();
  @$core.override
  ExprContainsAny createEmptyInstance() => create();
  static $pb.PbList<ExprContainsAny> createRepeated() =>
      $pb.PbList<ExprContainsAny>();
  @$core.pragma('dart2js:noInline')
  static ExprContainsAny getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ExprContainsAny>(create);
  static ExprContainsAny? _defaultInstance;

  @$pb.TagNumber(1)
  Expr get left => $_getN(0);
  @$pb.TagNumber(1)
  set left(Expr value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasLeft() => $_has(0);
  @$pb.TagNumber(1)
  void clearLeft() => $_clearField(1);
  @$pb.TagNumber(1)
  Expr ensureLeft() => $_ensure(0);

  @$pb.TagNumber(2)
  Expr get right => $_getN(1);
  @$pb.TagNumber(2)
  set right(Expr value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasRight() => $_has(1);
  @$pb.TagNumber(2)
  void clearRight() => $_clearField(2);
  @$pb.TagNumber(2)
  Expr ensureRight() => $_ensure(1);
}

class ExprGetAttribute extends $pb.GeneratedMessage {
  factory ExprGetAttribute({
    Expr? left,
    $core.String? attr,
  }) {
    final result = create();
    if (left != null) result.left = left;
    if (attr != null) result.attr = attr;
    return result;
  }

  ExprGetAttribute._();

  factory ExprGetAttribute.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ExprGetAttribute.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ExprGetAttribute',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'cedar.v3'),
      createEmptyInstance: create)
    ..aOM<Expr>(1, _omitFieldNames ? '' : 'left', subBuilder: Expr.create)
    ..aOS(2, _omitFieldNames ? '' : 'attr')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExprGetAttribute clone() => ExprGetAttribute()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExprGetAttribute copyWith(void Function(ExprGetAttribute) updates) =>
      super.copyWith((message) => updates(message as ExprGetAttribute))
          as ExprGetAttribute;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ExprGetAttribute create() => ExprGetAttribute._();
  @$core.override
  ExprGetAttribute createEmptyInstance() => create();
  static $pb.PbList<ExprGetAttribute> createRepeated() =>
      $pb.PbList<ExprGetAttribute>();
  @$core.pragma('dart2js:noInline')
  static ExprGetAttribute getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ExprGetAttribute>(create);
  static ExprGetAttribute? _defaultInstance;

  @$pb.TagNumber(1)
  Expr get left => $_getN(0);
  @$pb.TagNumber(1)
  set left(Expr value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasLeft() => $_has(0);
  @$pb.TagNumber(1)
  void clearLeft() => $_clearField(1);
  @$pb.TagNumber(1)
  Expr ensureLeft() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get attr => $_getSZ(1);
  @$pb.TagNumber(2)
  set attr($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAttr() => $_has(1);
  @$pb.TagNumber(2)
  void clearAttr() => $_clearField(2);
}

class ExprHasAttribute extends $pb.GeneratedMessage {
  factory ExprHasAttribute({
    Expr? left,
    $core.String? attr,
  }) {
    final result = create();
    if (left != null) result.left = left;
    if (attr != null) result.attr = attr;
    return result;
  }

  ExprHasAttribute._();

  factory ExprHasAttribute.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ExprHasAttribute.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ExprHasAttribute',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'cedar.v3'),
      createEmptyInstance: create)
    ..aOM<Expr>(1, _omitFieldNames ? '' : 'left', subBuilder: Expr.create)
    ..aOS(2, _omitFieldNames ? '' : 'attr')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExprHasAttribute clone() => ExprHasAttribute()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExprHasAttribute copyWith(void Function(ExprHasAttribute) updates) =>
      super.copyWith((message) => updates(message as ExprHasAttribute))
          as ExprHasAttribute;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ExprHasAttribute create() => ExprHasAttribute._();
  @$core.override
  ExprHasAttribute createEmptyInstance() => create();
  static $pb.PbList<ExprHasAttribute> createRepeated() =>
      $pb.PbList<ExprHasAttribute>();
  @$core.pragma('dart2js:noInline')
  static ExprHasAttribute getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ExprHasAttribute>(create);
  static ExprHasAttribute? _defaultInstance;

  @$pb.TagNumber(1)
  Expr get left => $_getN(0);
  @$pb.TagNumber(1)
  set left(Expr value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasLeft() => $_has(0);
  @$pb.TagNumber(1)
  void clearLeft() => $_clearField(1);
  @$pb.TagNumber(1)
  Expr ensureLeft() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get attr => $_getSZ(1);
  @$pb.TagNumber(2)
  set attr($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAttr() => $_has(1);
  @$pb.TagNumber(2)
  void clearAttr() => $_clearField(2);
}

class ExprLike extends $pb.GeneratedMessage {
  factory ExprLike({
    Expr? left,
    $core.String? pattern,
  }) {
    final result = create();
    if (left != null) result.left = left;
    if (pattern != null) result.pattern = pattern;
    return result;
  }

  ExprLike._();

  factory ExprLike.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ExprLike.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ExprLike',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'cedar.v3'),
      createEmptyInstance: create)
    ..aOM<Expr>(1, _omitFieldNames ? '' : 'left', subBuilder: Expr.create)
    ..aOS(2, _omitFieldNames ? '' : 'pattern')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExprLike clone() => ExprLike()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExprLike copyWith(void Function(ExprLike) updates) =>
      super.copyWith((message) => updates(message as ExprLike)) as ExprLike;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ExprLike create() => ExprLike._();
  @$core.override
  ExprLike createEmptyInstance() => create();
  static $pb.PbList<ExprLike> createRepeated() => $pb.PbList<ExprLike>();
  @$core.pragma('dart2js:noInline')
  static ExprLike getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ExprLike>(create);
  static ExprLike? _defaultInstance;

  @$pb.TagNumber(1)
  Expr get left => $_getN(0);
  @$pb.TagNumber(1)
  set left(Expr value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasLeft() => $_has(0);
  @$pb.TagNumber(1)
  void clearLeft() => $_clearField(1);
  @$pb.TagNumber(1)
  Expr ensureLeft() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get pattern => $_getSZ(1);
  @$pb.TagNumber(2)
  set pattern($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPattern() => $_has(1);
  @$pb.TagNumber(2)
  void clearPattern() => $_clearField(2);
}

class ExprIs extends $pb.GeneratedMessage {
  factory ExprIs({
    Expr? left,
    $core.String? entityType,
    Expr? in_,
  }) {
    final result = create();
    if (left != null) result.left = left;
    if (entityType != null) result.entityType = entityType;
    if (in_ != null) result.in_ = in_;
    return result;
  }

  ExprIs._();

  factory ExprIs.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ExprIs.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ExprIs',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'cedar.v3'),
      createEmptyInstance: create)
    ..aOM<Expr>(1, _omitFieldNames ? '' : 'left', subBuilder: Expr.create)
    ..aOS(2, _omitFieldNames ? '' : 'entityType')
    ..aOM<Expr>(3, _omitFieldNames ? '' : 'in', subBuilder: Expr.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExprIs clone() => ExprIs()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExprIs copyWith(void Function(ExprIs) updates) =>
      super.copyWith((message) => updates(message as ExprIs)) as ExprIs;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ExprIs create() => ExprIs._();
  @$core.override
  ExprIs createEmptyInstance() => create();
  static $pb.PbList<ExprIs> createRepeated() => $pb.PbList<ExprIs>();
  @$core.pragma('dart2js:noInline')
  static ExprIs getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ExprIs>(create);
  static ExprIs? _defaultInstance;

  @$pb.TagNumber(1)
  Expr get left => $_getN(0);
  @$pb.TagNumber(1)
  set left(Expr value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasLeft() => $_has(0);
  @$pb.TagNumber(1)
  void clearLeft() => $_clearField(1);
  @$pb.TagNumber(1)
  Expr ensureLeft() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get entityType => $_getSZ(1);
  @$pb.TagNumber(2)
  set entityType($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasEntityType() => $_has(1);
  @$pb.TagNumber(2)
  void clearEntityType() => $_clearField(2);

  @$pb.TagNumber(3)
  Expr get in_ => $_getN(2);
  @$pb.TagNumber(3)
  set in_(Expr value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasIn_() => $_has(2);
  @$pb.TagNumber(3)
  void clearIn_() => $_clearField(3);
  @$pb.TagNumber(3)
  Expr ensureIn_() => $_ensure(2);
}

class ExprIfThenElse extends $pb.GeneratedMessage {
  factory ExprIfThenElse({
    Expr? cond,
    Expr? then,
    Expr? otherwise,
  }) {
    final result = create();
    if (cond != null) result.cond = cond;
    if (then != null) result.then = then;
    if (otherwise != null) result.otherwise = otherwise;
    return result;
  }

  ExprIfThenElse._();

  factory ExprIfThenElse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ExprIfThenElse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ExprIfThenElse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'cedar.v3'),
      createEmptyInstance: create)
    ..aOM<Expr>(1, _omitFieldNames ? '' : 'cond', subBuilder: Expr.create)
    ..aOM<Expr>(2, _omitFieldNames ? '' : 'then', subBuilder: Expr.create)
    ..aOM<Expr>(3, _omitFieldNames ? '' : 'otherwise', subBuilder: Expr.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExprIfThenElse clone() => ExprIfThenElse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExprIfThenElse copyWith(void Function(ExprIfThenElse) updates) =>
      super.copyWith((message) => updates(message as ExprIfThenElse))
          as ExprIfThenElse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ExprIfThenElse create() => ExprIfThenElse._();
  @$core.override
  ExprIfThenElse createEmptyInstance() => create();
  static $pb.PbList<ExprIfThenElse> createRepeated() =>
      $pb.PbList<ExprIfThenElse>();
  @$core.pragma('dart2js:noInline')
  static ExprIfThenElse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ExprIfThenElse>(create);
  static ExprIfThenElse? _defaultInstance;

  @$pb.TagNumber(1)
  Expr get cond => $_getN(0);
  @$pb.TagNumber(1)
  set cond(Expr value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasCond() => $_has(0);
  @$pb.TagNumber(1)
  void clearCond() => $_clearField(1);
  @$pb.TagNumber(1)
  Expr ensureCond() => $_ensure(0);

  @$pb.TagNumber(2)
  Expr get then => $_getN(1);
  @$pb.TagNumber(2)
  set then(Expr value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasThen() => $_has(1);
  @$pb.TagNumber(2)
  void clearThen() => $_clearField(2);
  @$pb.TagNumber(2)
  Expr ensureThen() => $_ensure(1);

  @$pb.TagNumber(3)
  Expr get otherwise => $_getN(2);
  @$pb.TagNumber(3)
  set otherwise(Expr value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasOtherwise() => $_has(2);
  @$pb.TagNumber(3)
  void clearOtherwise() => $_clearField(3);
  @$pb.TagNumber(3)
  Expr ensureOtherwise() => $_ensure(2);
}

class ExprSet extends $pb.GeneratedMessage {
  factory ExprSet({
    $core.Iterable<Expr>? expressions,
  }) {
    final result = create();
    if (expressions != null) result.expressions.addAll(expressions);
    return result;
  }

  ExprSet._();

  factory ExprSet.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ExprSet.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ExprSet',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'cedar.v3'),
      createEmptyInstance: create)
    ..pc<Expr>(1, _omitFieldNames ? '' : 'expressions', $pb.PbFieldType.PM,
        subBuilder: Expr.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExprSet clone() => ExprSet()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExprSet copyWith(void Function(ExprSet) updates) =>
      super.copyWith((message) => updates(message as ExprSet)) as ExprSet;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ExprSet create() => ExprSet._();
  @$core.override
  ExprSet createEmptyInstance() => create();
  static $pb.PbList<ExprSet> createRepeated() => $pb.PbList<ExprSet>();
  @$core.pragma('dart2js:noInline')
  static ExprSet getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ExprSet>(create);
  static ExprSet? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Expr> get expressions => $_getList(0);
}

class ExprRecord extends $pb.GeneratedMessage {
  factory ExprRecord({
    $core.Iterable<$core.MapEntry<$core.String, Expr>>? attributes,
  }) {
    final result = create();
    if (attributes != null) result.attributes.addEntries(attributes);
    return result;
  }

  ExprRecord._();

  factory ExprRecord.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ExprRecord.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ExprRecord',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'cedar.v3'),
      createEmptyInstance: create)
    ..m<$core.String, Expr>(1, _omitFieldNames ? '' : 'attributes',
        entryClassName: 'ExprRecord.AttributesEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OM,
        valueCreator: Expr.create,
        valueDefaultOrMaker: Expr.getDefault,
        packageName: const $pb.PackageName('cedar.v3'))
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExprRecord clone() => ExprRecord()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExprRecord copyWith(void Function(ExprRecord) updates) =>
      super.copyWith((message) => updates(message as ExprRecord)) as ExprRecord;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ExprRecord create() => ExprRecord._();
  @$core.override
  ExprRecord createEmptyInstance() => create();
  static $pb.PbList<ExprRecord> createRepeated() => $pb.PbList<ExprRecord>();
  @$core.pragma('dart2js:noInline')
  static ExprRecord getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ExprRecord>(create);
  static ExprRecord? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbMap<$core.String, Expr> get attributes => $_getMap(0);
}

class ExprExtensionCall extends $pb.GeneratedMessage {
  factory ExprExtensionCall({
    $core.String? fn,
    $core.Iterable<Expr>? args,
  }) {
    final result = create();
    if (fn != null) result.fn = fn;
    if (args != null) result.args.addAll(args);
    return result;
  }

  ExprExtensionCall._();

  factory ExprExtensionCall.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ExprExtensionCall.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ExprExtensionCall',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'cedar.v3'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'fn')
    ..pc<Expr>(2, _omitFieldNames ? '' : 'args', $pb.PbFieldType.PM,
        subBuilder: Expr.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExprExtensionCall clone() => ExprExtensionCall()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExprExtensionCall copyWith(void Function(ExprExtensionCall) updates) =>
      super.copyWith((message) => updates(message as ExprExtensionCall))
          as ExprExtensionCall;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ExprExtensionCall create() => ExprExtensionCall._();
  @$core.override
  ExprExtensionCall createEmptyInstance() => create();
  static $pb.PbList<ExprExtensionCall> createRepeated() =>
      $pb.PbList<ExprExtensionCall>();
  @$core.pragma('dart2js:noInline')
  static ExprExtensionCall getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ExprExtensionCall>(create);
  static ExprExtensionCall? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get fn => $_getSZ(0);
  @$pb.TagNumber(1)
  set fn($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasFn() => $_has(0);
  @$pb.TagNumber(1)
  void clearFn() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<Expr> get args => $_getList(1);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
