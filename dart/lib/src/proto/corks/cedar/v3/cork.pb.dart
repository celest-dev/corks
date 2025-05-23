//
//  Generated code. Do not modify.
//  source: corks/cedar/v3/cork.proto
//
// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import '../../../cedar/v3/entity.pb.dart' as $3;
import '../../../cedar/v3/entity_uid.pb.dart' as $0;
import '../../../cedar/v3/expr.pb.dart' as $4;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

/// A bearer token that can be used to make claims about an entity for the purpose
/// of authorization and authentication w/ Cedar.
class CedarCork extends $pb.GeneratedMessage {
  factory CedarCork({
    $core.List<$core.int>? id,
    $0.EntityUid? issuer,
    $0.EntityUid? bearer,
    $0.EntityUid? audience,
    $3.Entity? claims,
    $core.Iterable<$4.Expr>? caveats,
    $core.List<$core.int>? signature,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    if (issuer != null) {
      $result.issuer = issuer;
    }
    if (bearer != null) {
      $result.bearer = bearer;
    }
    if (audience != null) {
      $result.audience = audience;
    }
    if (claims != null) {
      $result.claims = claims;
    }
    if (caveats != null) {
      $result.caveats.addAll(caveats);
    }
    if (signature != null) {
      $result.signature = signature;
    }
    return $result;
  }
  CedarCork._() : super();
  factory CedarCork.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory CedarCork.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

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
    ..aOM<$3.Entity>(5, _omitFieldNames ? '' : 'claims',
        subBuilder: $3.Entity.create)
    ..pc<$4.Expr>(6, _omitFieldNames ? '' : 'caveats', $pb.PbFieldType.PM,
        subBuilder: $4.Expr.create)
    ..a<$core.List<$core.int>>(
        999, _omitFieldNames ? '' : 'signature', $pb.PbFieldType.OY)
    ..hasRequiredFields = false;

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  CedarCork clone() => CedarCork()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  CedarCork copyWith(void Function(CedarCork) updates) =>
      super.copyWith((message) => updates(message as CedarCork)) as CedarCork;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CedarCork create() => CedarCork._();
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
  set id($core.List<$core.int> v) {
    $_setBytes(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  /// The issuing authority of the cork.
  @$pb.TagNumber(2)
  $0.EntityUid get issuer => $_getN(1);
  @$pb.TagNumber(2)
  set issuer($0.EntityUid v) {
    $_setField(2, v);
  }

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
  set bearer($0.EntityUid v) {
    $_setField(3, v);
  }

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
  set audience($0.EntityUid v) {
    $_setField(4, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasAudience() => $_has(3);
  @$pb.TagNumber(4)
  void clearAudience() => $_clearField(4);
  @$pb.TagNumber(4)
  $0.EntityUid ensureAudience() => $_ensure(3);

  /// Claims made about the [bearer] of the cork.
  @$pb.TagNumber(5)
  $3.Entity get claims => $_getN(4);
  @$pb.TagNumber(5)
  set claims($3.Entity v) {
    $_setField(5, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasClaims() => $_has(4);
  @$pb.TagNumber(5)
  void clearClaims() => $_clearField(5);
  @$pb.TagNumber(5)
  $3.Entity ensureClaims() => $_ensure(4);

  ///  The caveats to this cork's validity and usage.
  ///
  ///  Caveats are structured conditions which must be met for the cork to be considered
  ///  valid and for its claims to be considered true.
  ///
  ///  Effectively, these form the body of a `forbid unless` policy AND'd together.
  @$pb.TagNumber(6)
  $pb.PbList<$4.Expr> get caveats => $_getList(5);

  /// The final signature of the cork.
  @$pb.TagNumber(999)
  $core.List<$core.int> get signature => $_getN(6);
  @$pb.TagNumber(999)
  set signature($core.List<$core.int> v) {
    $_setBytes(6, v);
  }

  @$pb.TagNumber(999)
  $core.bool hasSignature() => $_has(6);
  @$pb.TagNumber(999)
  void clearSignature() => $_clearField(999);
}

const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
