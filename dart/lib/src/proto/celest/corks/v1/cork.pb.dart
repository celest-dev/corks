// This is a generated file - do not edit.
//
// Generated from celest/corks/v1/cork.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import '../../../google/protobuf/any.pb.dart' as $0;
import '../../../google/protobuf/struct.pb.dart' as $1;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

/// Cork captures the metadata and chained MAC tail for a Celest authorization
/// token.
///
/// All fields participate in the HMAC chain as detailed in Spec §5.
class Cork extends $pb.GeneratedMessage {
  factory Cork({
    $core.int? version,
    $core.List<$core.int>? nonce,
    $core.List<$core.int>? keyId,
    $0.Any? issuer,
    $0.Any? bearer,
    $0.Any? audience,
    $0.Any? claims,
    $core.Iterable<Caveat>? caveats,
    $core.List<$core.int>? tailSignature,
    $fixnum.Int64? issuedAt,
    $fixnum.Int64? notAfter,
  }) {
    final result = create();
    if (version != null) result.version = version;
    if (nonce != null) result.nonce = nonce;
    if (keyId != null) result.keyId = keyId;
    if (issuer != null) result.issuer = issuer;
    if (bearer != null) result.bearer = bearer;
    if (audience != null) result.audience = audience;
    if (claims != null) result.claims = claims;
    if (caveats != null) result.caveats.addAll(caveats);
    if (tailSignature != null) result.tailSignature = tailSignature;
    if (issuedAt != null) result.issuedAt = issuedAt;
    if (notAfter != null) result.notAfter = notAfter;
    return result;
  }

  Cork._();

  factory Cork.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Cork.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Cork',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'celest.corks.v1'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'version', fieldType: $pb.PbFieldType.OU3)
    ..a<$core.List<$core.int>>(
        2, _omitFieldNames ? '' : 'nonce', $pb.PbFieldType.OY)
    ..a<$core.List<$core.int>>(
        3, _omitFieldNames ? '' : 'keyId', $pb.PbFieldType.OY)
    ..aOM<$0.Any>(4, _omitFieldNames ? '' : 'issuer', subBuilder: $0.Any.create)
    ..aOM<$0.Any>(5, _omitFieldNames ? '' : 'bearer', subBuilder: $0.Any.create)
    ..aOM<$0.Any>(6, _omitFieldNames ? '' : 'audience',
        subBuilder: $0.Any.create)
    ..aOM<$0.Any>(7, _omitFieldNames ? '' : 'claims', subBuilder: $0.Any.create)
    ..pPM<Caveat>(8, _omitFieldNames ? '' : 'caveats',
        subBuilder: Caveat.create)
    ..a<$core.List<$core.int>>(
        9, _omitFieldNames ? '' : 'tailSignature', $pb.PbFieldType.OY)
    ..a<$fixnum.Int64>(
        10, _omitFieldNames ? '' : 'issuedAt', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(
        11, _omitFieldNames ? '' : 'notAfter', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Cork clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Cork copyWith(void Function(Cork) updates) =>
      super.copyWith((message) => updates(message as Cork)) as Cork;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Cork create() => Cork._();
  @$core.override
  Cork createEmptyInstance() => create();
  static $pb.PbList<Cork> createRepeated() => $pb.PbList<Cork>();
  @$core.pragma('dart2js:noInline')
  static Cork getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Cork>(create);
  static Cork? _defaultInstance;

  /// Protocol version for future upgrades.
  @$pb.TagNumber(1)
  $core.int get version => $_getIZ(0);
  @$pb.TagNumber(1)
  set version($core.int value) => $_setUnsignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasVersion() => $_has(0);
  @$pb.TagNumber(1)
  void clearVersion() => $_clearField(1);

  /// 192-bit nonce used to derive the per-cork root key.
  @$pb.TagNumber(2)
  $core.List<$core.int> get nonce => $_getN(1);
  @$pb.TagNumber(2)
  set nonce($core.List<$core.int> value) => $_setBytes(1, value);
  @$pb.TagNumber(2)
  $core.bool hasNonce() => $_has(1);
  @$pb.TagNumber(2)
  void clearNonce() => $_clearField(2);

  /// Identifier for the signing key; must point to a rotating master key.
  @$pb.TagNumber(3)
  $core.List<$core.int> get keyId => $_getN(2);
  @$pb.TagNumber(3)
  set keyId($core.List<$core.int> value) => $_setBytes(2, value);
  @$pb.TagNumber(3)
  $core.bool hasKeyId() => $_has(2);
  @$pb.TagNumber(3)
  void clearKeyId() => $_clearField(3);

  /// Issuer entity (usually Celest::Service).  Stored as packed Cedar EntityUid.
  @$pb.TagNumber(4)
  $0.Any get issuer => $_getN(3);
  @$pb.TagNumber(4)
  set issuer($0.Any value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasIssuer() => $_has(3);
  @$pb.TagNumber(4)
  void clearIssuer() => $_clearField(4);
  @$pb.TagNumber(4)
  $0.Any ensureIssuer() => $_ensure(3);

  /// Bearer entity representing the principal authorized to act.
  @$pb.TagNumber(5)
  $0.Any get bearer => $_getN(4);
  @$pb.TagNumber(5)
  set bearer($0.Any value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasBearer() => $_has(4);
  @$pb.TagNumber(5)
  void clearBearer() => $_clearField(5);
  @$pb.TagNumber(5)
  $0.Any ensureBearer() => $_ensure(4);

  /// Optional audience the cork is scoped to (e.g. downstream service).
  @$pb.TagNumber(6)
  $0.Any get audience => $_getN(5);
  @$pb.TagNumber(6)
  set audience($0.Any value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasAudience() => $_has(5);
  @$pb.TagNumber(6)
  void clearAudience() => $_clearField(6);
  @$pb.TagNumber(6)
  $0.Any ensureAudience() => $_ensure(5);

  /// Optional structured claims (session context, device hints, etc.).
  @$pb.TagNumber(7)
  $0.Any get claims => $_getN(6);
  @$pb.TagNumber(7)
  set claims($0.Any value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasClaims() => $_has(6);
  @$pb.TagNumber(7)
  void clearClaims() => $_clearField(7);
  @$pb.TagNumber(7)
  $0.Any ensureClaims() => $_ensure(6);

  /// Ordered caveat list evaluated during verification.
  @$pb.TagNumber(8)
  $pb.PbList<Caveat> get caveats => $_getList(7);

  /// Final MAC produced by the chained signature algorithm.
  @$pb.TagNumber(9)
  $core.List<$core.int> get tailSignature => $_getN(8);
  @$pb.TagNumber(9)
  set tailSignature($core.List<$core.int> value) => $_setBytes(8, value);
  @$pb.TagNumber(9)
  $core.bool hasTailSignature() => $_has(8);
  @$pb.TagNumber(9)
  void clearTailSignature() => $_clearField(9);

  /// Millisecond epoch when the cork was minted.
  @$pb.TagNumber(10)
  $fixnum.Int64 get issuedAt => $_getI64(9);
  @$pb.TagNumber(10)
  set issuedAt($fixnum.Int64 value) => $_setInt64(9, value);
  @$pb.TagNumber(10)
  $core.bool hasIssuedAt() => $_has(9);
  @$pb.TagNumber(10)
  void clearIssuedAt() => $_clearField(10);

  /// Optional expiry timestamp; omit for non-expiring corks (discouraged).
  @$pb.TagNumber(11)
  $fixnum.Int64 get notAfter => $_getI64(10);
  @$pb.TagNumber(11)
  set notAfter($fixnum.Int64 value) => $_setInt64(10, value);
  @$pb.TagNumber(11)
  $core.bool hasNotAfter() => $_has(10);
  @$pb.TagNumber(11)
  void clearNotAfter() => $_clearField(11);
}

enum Caveat_Body { firstParty, thirdParty, notSet }

/// Caveat restricts how a cork may be used. Placement order matters because the
/// chained MAC is sensitive to the sequence of caveats.
class Caveat extends $pb.GeneratedMessage {
  factory Caveat({
    $core.int? caveatVersion,
    $core.List<$core.int>? caveatId,
    FirstPartyCaveat? firstParty,
    ThirdPartyCaveat? thirdParty,
  }) {
    final result = create();
    if (caveatVersion != null) result.caveatVersion = caveatVersion;
    if (caveatId != null) result.caveatId = caveatId;
    if (firstParty != null) result.firstParty = firstParty;
    if (thirdParty != null) result.thirdParty = thirdParty;
    return result;
  }

  Caveat._();

  factory Caveat.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Caveat.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, Caveat_Body> _Caveat_BodyByTag = {
    3: Caveat_Body.firstParty,
    4: Caveat_Body.thirdParty,
    0: Caveat_Body.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Caveat',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'celest.corks.v1'),
      createEmptyInstance: create)
    ..oo(0, [3, 4])
    ..aI(1, _omitFieldNames ? '' : 'caveatVersion',
        fieldType: $pb.PbFieldType.OU3)
    ..a<$core.List<$core.int>>(
        2, _omitFieldNames ? '' : 'caveatId', $pb.PbFieldType.OY)
    ..aOM<FirstPartyCaveat>(3, _omitFieldNames ? '' : 'firstParty',
        subBuilder: FirstPartyCaveat.create)
    ..aOM<ThirdPartyCaveat>(4, _omitFieldNames ? '' : 'thirdParty',
        subBuilder: ThirdPartyCaveat.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Caveat clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Caveat copyWith(void Function(Caveat) updates) =>
      super.copyWith((message) => updates(message as Caveat)) as Caveat;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Caveat create() => Caveat._();
  @$core.override
  Caveat createEmptyInstance() => create();
  static $pb.PbList<Caveat> createRepeated() => $pb.PbList<Caveat>();
  @$core.pragma('dart2js:noInline')
  static Caveat getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Caveat>(create);
  static Caveat? _defaultInstance;

  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  Caveat_Body whichBody() => _Caveat_BodyByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  void clearBody() => $_clearField($_whichOneof(0));

  /// Version of the caveat wire format.
  @$pb.TagNumber(1)
  $core.int get caveatVersion => $_getIZ(0);
  @$pb.TagNumber(1)
  set caveatVersion($core.int value) => $_setUnsignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCaveatVersion() => $_has(0);
  @$pb.TagNumber(1)
  void clearCaveatVersion() => $_clearField(1);

  /// Unique identifier so that discharges can reference the originating caveat.
  @$pb.TagNumber(2)
  $core.List<$core.int> get caveatId => $_getN(1);
  @$pb.TagNumber(2)
  set caveatId($core.List<$core.int> value) => $_setBytes(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCaveatId() => $_has(1);
  @$pb.TagNumber(2)
  void clearCaveatId() => $_clearField(2);

  /// First-party caveats are evaluated directly by Celest verifiers.
  @$pb.TagNumber(3)
  FirstPartyCaveat get firstParty => $_getN(2);
  @$pb.TagNumber(3)
  set firstParty(FirstPartyCaveat value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasFirstParty() => $_has(2);
  @$pb.TagNumber(3)
  void clearFirstParty() => $_clearField(3);
  @$pb.TagNumber(3)
  FirstPartyCaveat ensureFirstParty() => $_ensure(2);

  /// Third-party caveats require an external discharge.
  @$pb.TagNumber(4)
  ThirdPartyCaveat get thirdParty => $_getN(3);
  @$pb.TagNumber(4)
  set thirdParty(ThirdPartyCaveat value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasThirdParty() => $_has(3);
  @$pb.TagNumber(4)
  void clearThirdParty() => $_clearField(4);
  @$pb.TagNumber(4)
  ThirdPartyCaveat ensureThirdParty() => $_ensure(3);
}

/// FirstPartyCaveat encodes predicates evaluated inside the verifier.
class FirstPartyCaveat extends $pb.GeneratedMessage {
  factory FirstPartyCaveat({
    $core.String? namespace,
    $core.String? predicate,
    $0.Any? payload,
  }) {
    final result = create();
    if (namespace != null) result.namespace = namespace;
    if (predicate != null) result.predicate = predicate;
    if (payload != null) result.payload = payload;
    return result;
  }

  FirstPartyCaveat._();

  factory FirstPartyCaveat.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory FirstPartyCaveat.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FirstPartyCaveat',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'celest.corks.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'namespace')
    ..aOS(2, _omitFieldNames ? '' : 'predicate')
    ..aOM<$0.Any>(3, _omitFieldNames ? '' : 'payload',
        subBuilder: $0.Any.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FirstPartyCaveat clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FirstPartyCaveat copyWith(void Function(FirstPartyCaveat) updates) =>
      super.copyWith((message) => updates(message as FirstPartyCaveat))
          as FirstPartyCaveat;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FirstPartyCaveat create() => FirstPartyCaveat._();
  @$core.override
  FirstPartyCaveat createEmptyInstance() => create();
  static $pb.PbList<FirstPartyCaveat> createRepeated() =>
      $pb.PbList<FirstPartyCaveat>();
  @$core.pragma('dart2js:noInline')
  static FirstPartyCaveat getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<FirstPartyCaveat>(create);
  static FirstPartyCaveat? _defaultInstance;

  /// Namespace to avoid predicate collisions (e.g. "celest.auth").
  @$pb.TagNumber(1)
  $core.String get namespace => $_getSZ(0);
  @$pb.TagNumber(1)
  set namespace($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasNamespace() => $_has(0);
  @$pb.TagNumber(1)
  void clearNamespace() => $_clearField(1);

  /// Predicate identifier registered in the caveat registry (Spec §9).
  @$pb.TagNumber(2)
  $core.String get predicate => $_getSZ(1);
  @$pb.TagNumber(2)
  set predicate($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPredicate() => $_has(1);
  @$pb.TagNumber(2)
  void clearPredicate() => $_clearField(2);

  /// Deterministically packed payload containing predicate inputs.
  @$pb.TagNumber(3)
  $0.Any get payload => $_getN(2);
  @$pb.TagNumber(3)
  set payload($0.Any value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasPayload() => $_has(2);
  @$pb.TagNumber(3)
  void clearPayload() => $_clearField(3);
  @$pb.TagNumber(3)
  $0.Any ensurePayload() => $_ensure(2);
}

/// ThirdPartyCaveat delegates checks to an external discharge service.
class ThirdPartyCaveat extends $pb.GeneratedMessage {
  factory ThirdPartyCaveat({
    $core.String? location,
    $core.List<$core.int>? ticket,
    $core.List<$core.int>? challenge,
    $core.List<$core.int>? salt,
  }) {
    final result = create();
    if (location != null) result.location = location;
    if (ticket != null) result.ticket = ticket;
    if (challenge != null) result.challenge = challenge;
    if (salt != null) result.salt = salt;
    return result;
  }

  ThirdPartyCaveat._();

  factory ThirdPartyCaveat.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ThirdPartyCaveat.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ThirdPartyCaveat',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'celest.corks.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'location')
    ..a<$core.List<$core.int>>(
        2, _omitFieldNames ? '' : 'ticket', $pb.PbFieldType.OY)
    ..a<$core.List<$core.int>>(
        3, _omitFieldNames ? '' : 'challenge', $pb.PbFieldType.OY)
    ..a<$core.List<$core.int>>(
        4, _omitFieldNames ? '' : 'salt', $pb.PbFieldType.OY)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ThirdPartyCaveat clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ThirdPartyCaveat copyWith(void Function(ThirdPartyCaveat) updates) =>
      super.copyWith((message) => updates(message as ThirdPartyCaveat))
          as ThirdPartyCaveat;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ThirdPartyCaveat create() => ThirdPartyCaveat._();
  @$core.override
  ThirdPartyCaveat createEmptyInstance() => create();
  static $pb.PbList<ThirdPartyCaveat> createRepeated() =>
      $pb.PbList<ThirdPartyCaveat>();
  @$core.pragma('dart2js:noInline')
  static ThirdPartyCaveat getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ThirdPartyCaveat>(create);
  static ThirdPartyCaveat? _defaultInstance;

  /// Logical or physical location of the discharge service.
  @$pb.TagNumber(1)
  $core.String get location => $_getSZ(0);
  @$pb.TagNumber(1)
  set location($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasLocation() => $_has(0);
  @$pb.TagNumber(1)
  void clearLocation() => $_clearField(1);

  /// Ciphertext delivered to the third party so it can mint a discharge.
  @$pb.TagNumber(2)
  $core.List<$core.int> get ticket => $_getN(1);
  @$pb.TagNumber(2)
  set ticket($core.List<$core.int> value) => $_setBytes(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTicket() => $_has(1);
  @$pb.TagNumber(2)
  void clearTicket() => $_clearField(2);

  /// AEAD payload consumed by the verifier to recover the caveat root key.
  @$pb.TagNumber(3)
  $core.List<$core.int> get challenge => $_getN(2);
  @$pb.TagNumber(3)
  set challenge($core.List<$core.int> value) => $_setBytes(2, value);
  @$pb.TagNumber(3)
  $core.bool hasChallenge() => $_has(2);
  @$pb.TagNumber(3)
  void clearChallenge() => $_clearField(3);

  /// Optional salt for HKDF derivations when computing third-party keys.
  @$pb.TagNumber(4)
  $core.List<$core.int> get salt => $_getN(3);
  @$pb.TagNumber(4)
  set salt($core.List<$core.int> value) => $_setBytes(3, value);
  @$pb.TagNumber(4)
  $core.bool hasSalt() => $_has(3);
  @$pb.TagNumber(4)
  void clearSalt() => $_clearField(4);
}

/// ThirdPartyTicket envelopes the derived keys and context needed to issue
/// a discharge. Implementations are free to define their own serialization,
/// but the shared-secret helpers in the SDK rely on this structure.
class ThirdPartyTicket extends $pb.GeneratedMessage {
  factory ThirdPartyTicket({
    $core.List<$core.int>? caveatId,
    $core.List<$core.int>? caveatRootKey,
    $1.Struct? metadata,
    $fixnum.Int64? notAfter,
  }) {
    final result = create();
    if (caveatId != null) result.caveatId = caveatId;
    if (caveatRootKey != null) result.caveatRootKey = caveatRootKey;
    if (metadata != null) result.metadata = metadata;
    if (notAfter != null) result.notAfter = notAfter;
    return result;
  }

  ThirdPartyTicket._();

  factory ThirdPartyTicket.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ThirdPartyTicket.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ThirdPartyTicket',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'celest.corks.v1'),
      createEmptyInstance: create)
    ..a<$core.List<$core.int>>(
        1, _omitFieldNames ? '' : 'caveatId', $pb.PbFieldType.OY)
    ..a<$core.List<$core.int>>(
        2, _omitFieldNames ? '' : 'caveatRootKey', $pb.PbFieldType.OY)
    ..aOM<$1.Struct>(3, _omitFieldNames ? '' : 'metadata',
        subBuilder: $1.Struct.create)
    ..a<$fixnum.Int64>(
        4, _omitFieldNames ? '' : 'notAfter', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ThirdPartyTicket clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ThirdPartyTicket copyWith(void Function(ThirdPartyTicket) updates) =>
      super.copyWith((message) => updates(message as ThirdPartyTicket))
          as ThirdPartyTicket;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ThirdPartyTicket create() => ThirdPartyTicket._();
  @$core.override
  ThirdPartyTicket createEmptyInstance() => create();
  static $pb.PbList<ThirdPartyTicket> createRepeated() =>
      $pb.PbList<ThirdPartyTicket>();
  @$core.pragma('dart2js:noInline')
  static ThirdPartyTicket getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ThirdPartyTicket>(create);
  static ThirdPartyTicket? _defaultInstance;

  /// Identifier for the originating caveat.
  @$pb.TagNumber(1)
  $core.List<$core.int> get caveatId => $_getN(0);
  @$pb.TagNumber(1)
  set caveatId($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCaveatId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCaveatId() => $_clearField(1);

  /// Derived caveat root key shared with the verifier.
  @$pb.TagNumber(2)
  $core.List<$core.int> get caveatRootKey => $_getN(1);
  @$pb.TagNumber(2)
  set caveatRootKey($core.List<$core.int> value) => $_setBytes(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCaveatRootKey() => $_has(1);
  @$pb.TagNumber(2)
  void clearCaveatRootKey() => $_clearField(2);

  /// Optional context provided by the attenuator (for example request claims).
  @$pb.TagNumber(3)
  $1.Struct get metadata => $_getN(2);
  @$pb.TagNumber(3)
  set metadata($1.Struct value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasMetadata() => $_has(2);
  @$pb.TagNumber(3)
  void clearMetadata() => $_clearField(3);
  @$pb.TagNumber(3)
  $1.Struct ensureMetadata() => $_ensure(2);

  /// Optional expiry propagated to the discharge builder.
  @$pb.TagNumber(4)
  $fixnum.Int64 get notAfter => $_getI64(3);
  @$pb.TagNumber(4)
  set notAfter($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasNotAfter() => $_has(3);
  @$pb.TagNumber(4)
  void clearNotAfter() => $_clearField(4);
}

/// Discharge fulfils a third-party caveat and may add additional caveats.
class Discharge extends $pb.GeneratedMessage {
  factory Discharge({
    $core.int? version,
    $core.List<$core.int>? nonce,
    $core.List<$core.int>? keyId,
    $core.List<$core.int>? parentCaveatId,
    $0.Any? issuer,
    $core.Iterable<Caveat>? caveats,
    $core.List<$core.int>? tailSignature,
    $fixnum.Int64? issuedAt,
    $fixnum.Int64? notAfter,
  }) {
    final result = create();
    if (version != null) result.version = version;
    if (nonce != null) result.nonce = nonce;
    if (keyId != null) result.keyId = keyId;
    if (parentCaveatId != null) result.parentCaveatId = parentCaveatId;
    if (issuer != null) result.issuer = issuer;
    if (caveats != null) result.caveats.addAll(caveats);
    if (tailSignature != null) result.tailSignature = tailSignature;
    if (issuedAt != null) result.issuedAt = issuedAt;
    if (notAfter != null) result.notAfter = notAfter;
    return result;
  }

  Discharge._();

  factory Discharge.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Discharge.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Discharge',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'celest.corks.v1'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'version', fieldType: $pb.PbFieldType.OU3)
    ..a<$core.List<$core.int>>(
        2, _omitFieldNames ? '' : 'nonce', $pb.PbFieldType.OY)
    ..a<$core.List<$core.int>>(
        3, _omitFieldNames ? '' : 'keyId', $pb.PbFieldType.OY)
    ..a<$core.List<$core.int>>(
        4, _omitFieldNames ? '' : 'parentCaveatId', $pb.PbFieldType.OY)
    ..aOM<$0.Any>(5, _omitFieldNames ? '' : 'issuer', subBuilder: $0.Any.create)
    ..pPM<Caveat>(6, _omitFieldNames ? '' : 'caveats',
        subBuilder: Caveat.create)
    ..a<$core.List<$core.int>>(
        7, _omitFieldNames ? '' : 'tailSignature', $pb.PbFieldType.OY)
    ..a<$fixnum.Int64>(
        8, _omitFieldNames ? '' : 'issuedAt', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(
        9, _omitFieldNames ? '' : 'notAfter', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Discharge clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Discharge copyWith(void Function(Discharge) updates) =>
      super.copyWith((message) => updates(message as Discharge)) as Discharge;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Discharge create() => Discharge._();
  @$core.override
  Discharge createEmptyInstance() => create();
  static $pb.PbList<Discharge> createRepeated() => $pb.PbList<Discharge>();
  @$core.pragma('dart2js:noInline')
  static Discharge getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Discharge>(create);
  static Discharge? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get version => $_getIZ(0);
  @$pb.TagNumber(1)
  set version($core.int value) => $_setUnsignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasVersion() => $_has(0);
  @$pb.TagNumber(1)
  void clearVersion() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get nonce => $_getN(1);
  @$pb.TagNumber(2)
  set nonce($core.List<$core.int> value) => $_setBytes(1, value);
  @$pb.TagNumber(2)
  $core.bool hasNonce() => $_has(1);
  @$pb.TagNumber(2)
  void clearNonce() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.List<$core.int> get keyId => $_getN(2);
  @$pb.TagNumber(3)
  set keyId($core.List<$core.int> value) => $_setBytes(2, value);
  @$pb.TagNumber(3)
  $core.bool hasKeyId() => $_has(2);
  @$pb.TagNumber(3)
  void clearKeyId() => $_clearField(3);

  /// Links back to Caveat.caveat_id so the verifier can pair discharge + caveat.
  @$pb.TagNumber(4)
  $core.List<$core.int> get parentCaveatId => $_getN(3);
  @$pb.TagNumber(4)
  set parentCaveatId($core.List<$core.int> value) => $_setBytes(3, value);
  @$pb.TagNumber(4)
  $core.bool hasParentCaveatId() => $_has(3);
  @$pb.TagNumber(4)
  void clearParentCaveatId() => $_clearField(4);

  /// Third-party issuer information for auditability.
  @$pb.TagNumber(5)
  $0.Any get issuer => $_getN(4);
  @$pb.TagNumber(5)
  set issuer($0.Any value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasIssuer() => $_has(4);
  @$pb.TagNumber(5)
  void clearIssuer() => $_clearField(5);
  @$pb.TagNumber(5)
  $0.Any ensureIssuer() => $_ensure(4);

  /// Additional attenuation applied by the third party.
  @$pb.TagNumber(6)
  $pb.PbList<Caveat> get caveats => $_getList(5);

  /// Discharge MAC produced using the caveat root key.
  @$pb.TagNumber(7)
  $core.List<$core.int> get tailSignature => $_getN(6);
  @$pb.TagNumber(7)
  set tailSignature($core.List<$core.int> value) => $_setBytes(6, value);
  @$pb.TagNumber(7)
  $core.bool hasTailSignature() => $_has(6);
  @$pb.TagNumber(7)
  void clearTailSignature() => $_clearField(7);

  @$pb.TagNumber(8)
  $fixnum.Int64 get issuedAt => $_getI64(7);
  @$pb.TagNumber(8)
  set issuedAt($fixnum.Int64 value) => $_setInt64(7, value);
  @$pb.TagNumber(8)
  $core.bool hasIssuedAt() => $_has(7);
  @$pb.TagNumber(8)
  void clearIssuedAt() => $_clearField(8);

  @$pb.TagNumber(9)
  $fixnum.Int64 get notAfter => $_getI64(8);
  @$pb.TagNumber(9)
  set notAfter($fixnum.Int64 value) => $_setInt64(8, value);
  @$pb.TagNumber(9)
  $core.bool hasNotAfter() => $_has(8);
  @$pb.TagNumber(9)
  void clearNotAfter() => $_clearField(9);
}

/// Expiry constrains the latest time a cork may be used.
class Expiry extends $pb.GeneratedMessage {
  factory Expiry({
    $fixnum.Int64? notAfter,
  }) {
    final result = create();
    if (notAfter != null) result.notAfter = notAfter;
    return result;
  }

  Expiry._();

  factory Expiry.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Expiry.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Expiry',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'celest.corks.v1'),
      createEmptyInstance: create)
    ..a<$fixnum.Int64>(
        1, _omitFieldNames ? '' : 'notAfter', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Expiry clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Expiry copyWith(void Function(Expiry) updates) =>
      super.copyWith((message) => updates(message as Expiry)) as Expiry;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Expiry create() => Expiry._();
  @$core.override
  Expiry createEmptyInstance() => create();
  static $pb.PbList<Expiry> createRepeated() => $pb.PbList<Expiry>();
  @$core.pragma('dart2js:noInline')
  static Expiry getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Expiry>(create);
  static Expiry? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get notAfter => $_getI64(0);
  @$pb.TagNumber(1)
  set notAfter($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasNotAfter() => $_has(0);
  @$pb.TagNumber(1)
  void clearNotAfter() => $_clearField(1);
}

/// OrganizationScope encodes Celest tenant hierarchy context.
class OrganizationScope extends $pb.GeneratedMessage {
  factory OrganizationScope({
    $core.String? organizationId,
    $core.String? projectId,
    $core.String? environmentId,
  }) {
    final result = create();
    if (organizationId != null) result.organizationId = organizationId;
    if (projectId != null) result.projectId = projectId;
    if (environmentId != null) result.environmentId = environmentId;
    return result;
  }

  OrganizationScope._();

  factory OrganizationScope.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory OrganizationScope.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OrganizationScope',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'celest.corks.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'organizationId')
    ..aOS(2, _omitFieldNames ? '' : 'projectId')
    ..aOS(3, _omitFieldNames ? '' : 'environmentId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OrganizationScope clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OrganizationScope copyWith(void Function(OrganizationScope) updates) =>
      super.copyWith((message) => updates(message as OrganizationScope))
          as OrganizationScope;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static OrganizationScope create() => OrganizationScope._();
  @$core.override
  OrganizationScope createEmptyInstance() => create();
  static $pb.PbList<OrganizationScope> createRepeated() =>
      $pb.PbList<OrganizationScope>();
  @$core.pragma('dart2js:noInline')
  static OrganizationScope getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OrganizationScope>(create);
  static OrganizationScope? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get organizationId => $_getSZ(0);
  @$pb.TagNumber(1)
  set organizationId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasOrganizationId() => $_has(0);
  @$pb.TagNumber(1)
  void clearOrganizationId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get projectId => $_getSZ(1);
  @$pb.TagNumber(2)
  set projectId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasProjectId() => $_has(1);
  @$pb.TagNumber(2)
  void clearProjectId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get environmentId => $_getSZ(2);
  @$pb.TagNumber(3)
  set environmentId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasEnvironmentId() => $_has(2);
  @$pb.TagNumber(3)
  void clearEnvironmentId() => $_clearField(3);
}

/// ActionScope enumerates allowed actions for the cork.
class ActionScope extends $pb.GeneratedMessage {
  factory ActionScope({
    $core.Iterable<$core.String>? actions,
  }) {
    final result = create();
    if (actions != null) result.actions.addAll(actions);
    return result;
  }

  ActionScope._();

  factory ActionScope.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ActionScope.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ActionScope',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'celest.corks.v1'),
      createEmptyInstance: create)
    ..pPS(1, _omitFieldNames ? '' : 'actions')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ActionScope clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ActionScope copyWith(void Function(ActionScope) updates) =>
      super.copyWith((message) => updates(message as ActionScope))
          as ActionScope;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ActionScope create() => ActionScope._();
  @$core.override
  ActionScope createEmptyInstance() => create();
  static $pb.PbList<ActionScope> createRepeated() => $pb.PbList<ActionScope>();
  @$core.pragma('dart2js:noInline')
  static ActionScope getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ActionScope>(create);
  static ActionScope? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$core.String> get actions => $_getList(0);
}

/// IpBinding limits usage to specific CIDR ranges.
class IpBinding extends $pb.GeneratedMessage {
  factory IpBinding({
    $core.Iterable<$core.String>? cidrs,
  }) {
    final result = create();
    if (cidrs != null) result.cidrs.addAll(cidrs);
    return result;
  }

  IpBinding._();

  factory IpBinding.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory IpBinding.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'IpBinding',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'celest.corks.v1'),
      createEmptyInstance: create)
    ..pPS(1, _omitFieldNames ? '' : 'cidrs')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IpBinding clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IpBinding copyWith(void Function(IpBinding) updates) =>
      super.copyWith((message) => updates(message as IpBinding)) as IpBinding;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static IpBinding create() => IpBinding._();
  @$core.override
  IpBinding createEmptyInstance() => create();
  static $pb.PbList<IpBinding> createRepeated() => $pb.PbList<IpBinding>();
  @$core.pragma('dart2js:noInline')
  static IpBinding getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<IpBinding>(create);
  static IpBinding? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$core.String> get cidrs => $_getList(0);
}

/// SessionState encodes versioning information for revocation.
class SessionState extends $pb.GeneratedMessage {
  factory SessionState({
    $core.String? sessionId,
    $fixnum.Int64? version,
  }) {
    final result = create();
    if (sessionId != null) result.sessionId = sessionId;
    if (version != null) result.version = version;
    return result;
  }

  SessionState._();

  factory SessionState.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SessionState.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SessionState',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'celest.corks.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'sessionId')
    ..a<$fixnum.Int64>(2, _omitFieldNames ? '' : 'version', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SessionState clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SessionState copyWith(void Function(SessionState) updates) =>
      super.copyWith((message) => updates(message as SessionState))
          as SessionState;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SessionState create() => SessionState._();
  @$core.override
  SessionState createEmptyInstance() => create();
  static $pb.PbList<SessionState> createRepeated() =>
      $pb.PbList<SessionState>();
  @$core.pragma('dart2js:noInline')
  static SessionState getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SessionState>(create);
  static SessionState? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get sessionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set sessionId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSessionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSessionId() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get version => $_getI64(1);
  @$pb.TagNumber(2)
  set version($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasVersion() => $_has(1);
  @$pb.TagNumber(2)
  void clearVersion() => $_clearField(2);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
