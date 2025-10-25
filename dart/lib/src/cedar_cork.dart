import 'dart:typed_data';

import 'package:cedar/ast.dart' as cedar;
import 'package:cedar/cedar.dart' as cedar_model;
import 'package:cedar/src/proto/cedar/v3/entity.pb.dart' as cedar_entity;
import 'package:cedar/src/proto/cedar/v3/entity_uid.pb.dart' as cedar_uid;
import 'package:cedar/src/proto/cedar/v3/expr.pb.dart' as cedar_expr;
import 'package:corks_cedar/src/crypto.dart';
import 'package:corks_cedar/src/proto.dart';
import 'package:meta/meta.dart';

import 'cork.dart';
import 'proto/corks/v1/cork.pb.dart' as corksv1;
import 'proto/google/protobuf/any.pb.dart' as anypb;

/// A [Cork] backed by Cedar.
extension type CedarCork(Cork _cork) implements Cork {
  /// Parses a base64-encoded [CedarCork].
  factory CedarCork.parse(String token) => CedarCork(Cork.parse(token));

  /// Decodes a binary-encoded [CedarCork].
  factory CedarCork.decode(Uint8List bytes) => CedarCork(Cork.decode(bytes));

  /// Creates a [CedarCork] from its protocol buffer representation.
  factory CedarCork.fromProto(corksv1.Cork proto) =>
      CedarCork(Cork.fromProto(proto));

  /// Creates a [CedarCork] from its JSON representation.
  factory CedarCork.fromJson(Map<String, Object?> json) =>
      CedarCork(Cork.fromJson(json));

  /// Creates a new [CedarCorkBuilder].
  static CedarCorkBuilder builder(Uint8List keyId) =>
      CedarCorkBuilder._(Cork.builder(keyId));

  static const int caveatVersion = 1;
  static const String caveatNamespace = 'celest.cedar';
  static const String caveatPredicate = 'expr';

  @redeclare
  cedar.EntityUid? get issuer => _decodeEntityUid(_cork.issuer);

  @redeclare
  cedar.EntityUid? get bearer => _decodeEntityUid(_cork.bearer);

  @redeclare
  cedar.EntityUid? get audience => _decodeEntityUid(_cork.audience);

  @redeclare
  cedar.Entity? get claims => _decodeEntity(_cork.claims);

  @redeclare
  List<cedar.Expr> get caveats {
    final expressions = <cedar.Expr>[];
    for (final caveat in _cork.caveats) {
      if (!caveat.hasFirstParty()) {
        continue;
      }
      final first = caveat.firstParty;
      if (first.namespace != caveatNamespace ||
          first.predicate != caveatPredicate) {
        continue;
      }
      if (!first.hasPayload()) {
        continue;
      }
      final expr = _decodeExpr(first.payload);
      if (expr != null) {
        expressions.add(expr);
      }
    }
    return expressions;
  }

  CedarCorkBuilder rebuild() => CedarCorkBuilder._(_cork.rebuild());
}

/// A builder for [Cork]s backed by Cedar.
extension type CedarCorkBuilder._(CorkBuilder _builder) implements CorkBuilder {
  factory CedarCorkBuilder.forKey(Uint8List keyId) =>
      CedarCorkBuilder._(CorkBuilder(keyId));

  @redeclare
  set issuer(cedar_model.EntityUid issuer) {
    _builder.issuer = issuer.toProto();
  }

  @redeclare
  set bearer(cedar_model.EntityUid bearer) {
    _builder.bearer = bearer.toProto();
  }

  @redeclare
  set audience(cedar_model.EntityUid? audience) {
    _builder.audience = audience?.toProto();
  }

  @redeclare
  set claims(cedar_model.Entity? claims) {
    _builder.claims = claims?.toProto();
  }

  @redeclare
  void addCaveat(cedar.Expr expression) {
    final payload = expression.toProto().packIntoAny();
    final id = secureRandomBytes(16);
    final caveat = corksv1.Caveat(
      caveatVersion: CedarCork.caveatVersion,
      caveatId: id,
      firstParty: corksv1.FirstPartyCaveat(
        namespace: CedarCork.caveatNamespace,
        predicate: CedarCork.caveatPredicate,
        payload: payload,
      ),
    );
    _builder.addCaveat(caveat);
  }
}

cedar_model.EntityUid? _decodeEntityUid(anypb.Any? any) {
  if (any == null || any.value.isEmpty) {
    return null;
  }
  final proto = cedar_uid.EntityUid()..mergeFromBuffer(any.value);
  return cedar_model.EntityUid.fromProto(proto);
}

cedar_model.Entity? _decodeEntity(anypb.Any? any) {
  if (any == null || any.value.isEmpty) {
    return null;
  }
  final proto = cedar_entity.Entity()..mergeFromBuffer(any.value);
  return cedar_model.Entity.fromProto(proto);
}

cedar.Expr? _decodeExpr(anypb.Any payload) {
  if (payload.value.isEmpty) {
    return null;
  }
  final proto = cedar_expr.Expr()..mergeFromBuffer(payload.value);
  return cedar.Expr.fromProto(proto);
}
