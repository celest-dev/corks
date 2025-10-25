// This is a generated file - do not edit.
//
// Generated from corks/cedar/v3/cork.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import '../../../cedar/v3/entity.pb.dart' as $1;
import '../../../cedar/v3/entity_uid.pb.dart' as $0;
import '../../../cedar/v3/expr.pb.dart' as $2;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

/// A bearer token that can be used to make claims about an entity for the purpose
/// of authorization and authentication w/ Cedar.
class CedarCork extends $pb.GeneratedMessage {
  factory CedarCork({
    $core.List<$core.int>? id,
    $0.EntityUid? issuer,
    $0.EntityUid? bearer,
    $0.EntityUid? audience,
    $1.Entity? claims,
    $core.Iterable<$2.Expr>? caveats,
    $core.List<$core.int>? signature,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (issuer != null) result.issuer = issuer;
    if (bearer != null) result.bearer = bearer;
    if (audience != null) result.audience = audience;
    if (claims != null) result.claims = claims;
    if (caveats != null) result.caveats.addAll(caveats);
    if (signature != null) result.signature = signature;
    return result;
  }

  CedarCork._();

  factory CedarCork.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CedarCork.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CedarCork',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'corks.cedar.v3'),
      createEmptyInstance: create)
    ..a<$core.List<$core.int>>(
        1, _omitFieldNames ? '' : 'id', $pb.PbFieldType.OY)
    ..aOM<$0.EntityUid>(2, _omitFieldNames ? '' : 'issuer',
        subBuilder: $0.EntityUid.create)
    ..aOM<$0.EntityUid>(3, _omitFieldNames ? '' : 'bearer',
        subBuilder: $0.EntityUid.create)
    ..aOM<$0.EntityUid>(4, _omitFieldNames ? '' : 'audience',
        subBuilder: $0.EntityUid.create)
    ..aOM<$1.Entity>(5, _omitFieldNames ? '' : 'claims',
        subBuilder: $1.Entity.create)
    ..pc<$2.Expr>(6, _omitFieldNames ? '' : 'caveats', $pb.PbFieldType.PM,
        subBuilder: $2.Expr.create)
    ..a<$core.List<$core.int>>(
        999, _omitFieldNames ? '' : 'signature', $pb.PbFieldType.OY)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CedarCork clone() => CedarCork()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CedarCork copyWith(void Function(CedarCork) updates) =>
      super.copyWith((message) => updates(message as CedarCork)) as CedarCork;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CedarCork create() => CedarCork._();
  @$core.override
  CedarCork createEmptyInstance() => create();
  static $pb.PbList<CedarCork> createRepeated() => $pb.PbList<CedarCork>();
  @$core.pragma('dart2js:noInline')
  static CedarCork getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CedarCork>(create);
  static CedarCork? _defaultInstance;

  /// The unique identifier of the cork.
  @$pb.TagNumber(1)
  $core.List<$core.int> get id => $_getN(0);
  @$pb.TagNumber(1)
  set id($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  /// The issuing authority of the cork.
  @$pb.TagNumber(2)
  $0.EntityUid get issuer => $_getN(1);
  @$pb.TagNumber(2)
  set issuer($0.EntityUid value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasIssuer() => $_has(1);
  @$pb.TagNumber(2)
  void clearIssuer() => $_clearField(2);
  @$pb.TagNumber(2)
  $0.EntityUid ensureIssuer() => $_ensure(1);

  /// The bearer of the cork, about which [claims] can be made.
  @$pb.TagNumber(3)
  $0.EntityUid get bearer => $_getN(2);
  @$pb.TagNumber(3)
  set bearer($0.EntityUid value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasBearer() => $_has(2);
  @$pb.TagNumber(3)
  void clearBearer() => $_clearField(3);
  @$pb.TagNumber(3)
  $0.EntityUid ensureBearer() => $_ensure(2);

  /// The intended audience of the cork.
  @$pb.TagNumber(4)
  $0.EntityUid get audience => $_getN(3);
  @$pb.TagNumber(4)
  set audience($0.EntityUid value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasAudience() => $_has(3);
  @$pb.TagNumber(4)
  void clearAudience() => $_clearField(4);
  @$pb.TagNumber(4)
  $0.EntityUid ensureAudience() => $_ensure(3);

  /// Claims made about the [bearer] of the cork.
  @$pb.TagNumber(5)
  $1.Entity get claims => $_getN(4);
  @$pb.TagNumber(5)
  set claims($1.Entity value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasClaims() => $_has(4);
  @$pb.TagNumber(5)
  void clearClaims() => $_clearField(5);
  @$pb.TagNumber(5)
  $1.Entity ensureClaims() => $_ensure(4);

  /// The caveats to this cork's validity and usage.
  ///
  /// Caveats are structured conditions which must be met for the cork to be considered
  /// valid and for its claims to be considered true.
  ///
  /// Effectively, these form the body of a `forbid unless` policy AND'd together.
  @$pb.TagNumber(6)
  $pb.PbList<$2.Expr> get caveats => $_getList(5);

  /// The final signature of the cork.
  @$pb.TagNumber(999)
  $core.List<$core.int> get signature => $_getN(6);
  @$pb.TagNumber(999)
  set signature($core.List<$core.int> value) => $_setBytes(6, value);
  @$pb.TagNumber(999)
  $core.bool hasSignature() => $_has(6);
  @$pb.TagNumber(999)
  void clearSignature() => $_clearField(999);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
