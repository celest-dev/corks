//
//  Generated code. Do not modify.
//  source: cedar/v3/cork.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'entity.pb.dart' as $4;
import 'entity_id.pb.dart' as $0;
import 'policy.pb.dart' as $5;

/// A bearer token that can be used to make claims about an entity for the purpose
/// of authorization and authentication w/ Cedar.
class Cork extends $pb.GeneratedMessage {
  factory Cork({
    $core.List<$core.int>? id,
    $0.EntityId? issuer,
    $0.EntityId? bearer,
    $0.EntityId? audience,
    $4.Entity? claims,
    $core.Iterable<Caveat>? caveats,
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
    return $result;
  }
  Cork._() : super();
  factory Cork.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Cork.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Cork', package: const $pb.PackageName(_omitMessageNames ? '' : 'cedar.v3'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'id', $pb.PbFieldType.OY)
    ..aOM<$0.EntityId>(2, _omitFieldNames ? '' : 'issuer', subBuilder: $0.EntityId.create)
    ..aOM<$0.EntityId>(3, _omitFieldNames ? '' : 'bearer', subBuilder: $0.EntityId.create)
    ..aOM<$0.EntityId>(4, _omitFieldNames ? '' : 'audience', subBuilder: $0.EntityId.create)
    ..aOM<$4.Entity>(5, _omitFieldNames ? '' : 'claims', subBuilder: $4.Entity.create)
    ..pc<Caveat>(6, _omitFieldNames ? '' : 'caveats', $pb.PbFieldType.PM, subBuilder: Caveat.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Cork clone() => Cork()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Cork copyWith(void Function(Cork) updates) => super.copyWith((message) => updates(message as Cork)) as Cork;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Cork create() => Cork._();
  Cork createEmptyInstance() => create();
  static $pb.PbList<Cork> createRepeated() => $pb.PbList<Cork>();
  @$core.pragma('dart2js:noInline')
  static Cork getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Cork>(create);
  static Cork? _defaultInstance;

  /// The unique identifier of the cork.
  @$pb.TagNumber(1)
  $core.List<$core.int> get id => $_getN(0);
  @$pb.TagNumber(1)
  set id($core.List<$core.int> v) { $_setBytes(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  /// The issuing authority of the cork.
  @$pb.TagNumber(2)
  $0.EntityId get issuer => $_getN(1);
  @$pb.TagNumber(2)
  set issuer($0.EntityId v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasIssuer() => $_has(1);
  @$pb.TagNumber(2)
  void clearIssuer() => clearField(2);
  @$pb.TagNumber(2)
  $0.EntityId ensureIssuer() => $_ensure(1);

  /// The bearer of the cork, about which [claims] can be made.
  @$pb.TagNumber(3)
  $0.EntityId get bearer => $_getN(2);
  @$pb.TagNumber(3)
  set bearer($0.EntityId v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasBearer() => $_has(2);
  @$pb.TagNumber(3)
  void clearBearer() => clearField(3);
  @$pb.TagNumber(3)
  $0.EntityId ensureBearer() => $_ensure(2);

  /// The intended audience of the cork.
  @$pb.TagNumber(4)
  $0.EntityId get audience => $_getN(3);
  @$pb.TagNumber(4)
  set audience($0.EntityId v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasAudience() => $_has(3);
  @$pb.TagNumber(4)
  void clearAudience() => clearField(4);
  @$pb.TagNumber(4)
  $0.EntityId ensureAudience() => $_ensure(3);

  /// Claims made about the [bearer] of the cork.
  @$pb.TagNumber(5)
  $4.Entity get claims => $_getN(4);
  @$pb.TagNumber(5)
  set claims($4.Entity v) { setField(5, v); }
  @$pb.TagNumber(5)
  $core.bool hasClaims() => $_has(4);
  @$pb.TagNumber(5)
  void clearClaims() => clearField(5);
  @$pb.TagNumber(5)
  $4.Entity ensureClaims() => $_ensure(4);

  /// The caveats to this cork's validity and usage.
  @$pb.TagNumber(6)
  $core.List<Caveat> get caveats => $_getList(5);
}

enum Caveat_Caveat {
  policyId, 
  policy, 
  notSet
}

/// A structured condition which must be met for the cork to be considered valid
/// and for its claims to be considered true.
class Caveat extends $pb.GeneratedMessage {
  factory Caveat({
    $core.String? policyId,
    $5.Policy? policy,
  }) {
    final $result = create();
    if (policyId != null) {
      $result.policyId = policyId;
    }
    if (policy != null) {
      $result.policy = policy;
    }
    return $result;
  }
  Caveat._() : super();
  factory Caveat.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Caveat.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static const $core.Map<$core.int, Caveat_Caveat> _Caveat_CaveatByTag = {
    1 : Caveat_Caveat.policyId,
    2 : Caveat_Caveat.policy,
    0 : Caveat_Caveat.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Caveat', package: const $pb.PackageName(_omitMessageNames ? '' : 'cedar.v3'), createEmptyInstance: create)
    ..oo(0, [1, 2])
    ..aOS(1, _omitFieldNames ? '' : 'policyId')
    ..aOM<$5.Policy>(2, _omitFieldNames ? '' : 'policy', subBuilder: $5.Policy.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Caveat clone() => Caveat()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Caveat copyWith(void Function(Caveat) updates) => super.copyWith((message) => updates(message as Caveat)) as Caveat;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Caveat create() => Caveat._();
  Caveat createEmptyInstance() => create();
  static $pb.PbList<Caveat> createRepeated() => $pb.PbList<Caveat>();
  @$core.pragma('dart2js:noInline')
  static Caveat getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Caveat>(create);
  static Caveat? _defaultInstance;

  Caveat_Caveat whichCaveat() => _Caveat_CaveatByTag[$_whichOneof(0)]!;
  void clearCaveat() => clearField($_whichOneof(0));

  /// An identifier for a policy restricting the cork's usage.
  @$pb.TagNumber(1)
  $core.String get policyId => $_getSZ(0);
  @$pb.TagNumber(1)
  set policyId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasPolicyId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPolicyId() => clearField(1);

  /// An embedded policy restricting the cork's usage.
  @$pb.TagNumber(2)
  $5.Policy get policy => $_getN(1);
  @$pb.TagNumber(2)
  set policy($5.Policy v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasPolicy() => $_has(1);
  @$pb.TagNumber(2)
  void clearPolicy() => clearField(2);
  @$pb.TagNumber(2)
  $5.Policy ensurePolicy() => $_ensure(1);
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
