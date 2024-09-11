import 'dart:collection';
import 'dart:typed_data';

import 'package:cedar/ast.dart' as cedar;
import 'package:cedar/cedar.dart' as cedar;
import 'package:cedar/src/proto/cedar/v3/entity.pb.dart' as proto;
import 'package:cedar/src/proto/cedar/v3/entity_uid.pb.dart' as proto;
import 'package:cedar/src/proto/cedar/v3/expr.pb.dart' as proto;
import 'package:corks_cedar/corks_cedar.dart';
import 'package:corks_cedar/corks_proto.dart' as proto;
import 'package:meta/meta.dart';

/// A builder for [Cork]s backed by Cedar.
extension type CedarCorkBuilder(CorkBuilder _builder) implements CorkBuilder {
  @redeclare
  set issuer(cedar.EntityUid issuer) {
    _builder.issuer = issuer.toProto();
  }

  @redeclare
  set bearer(cedar.EntityUid bearer) {
    _builder.bearer = bearer.toProto();
  }

  @redeclare
  set audience(cedar.EntityUid audience) {
    _builder.audience = audience.toProto();
  }

  @redeclare
  set claims(cedar.Entity claims) {
    _builder.claims = claims.toProto();
  }

  @redeclare
  void addCaveat(cedar.Expr caveat) {
    _builder.addCaveat(caveat.toProto());
  }
}

/// A [Cork] backed by Cedar.
extension type CedarCork(Cork _cork) implements Cork {
  /// Parses a base64-encoded [CedarCork].
  factory CedarCork.parse(String token) => CedarCork(Cork.parse(token));

  /// Decodes a binary-encoded [CedarCork].
  factory CedarCork.decode(Uint8List bytes) => CedarCork(Cork.decode(bytes));

  /// Creates a [CedarCork] from its protocol buffer representation.
  factory CedarCork.fromProto(proto.Cork proto) =>
      CedarCork(Cork.fromProto(proto));

  /// Creates a new [CedarCorkBuilder].
  ///
  /// If [id] is not provided, a random nonce will be generated.
  static CedarCorkBuilder builder([Uint8List? id]) =>
      CedarCorkBuilder(Cork.builder(id));

  @redeclare
  cedar.EntityUid get issuer =>
      cedar.EntityUid.fromProto(proto.EntityUid().unpackAny(_cork.issuer));

  @redeclare
  cedar.EntityUid get bearer =>
      cedar.EntityUid.fromProto(proto.EntityUid().unpackAny(_cork.bearer));

  @redeclare
  cedar.EntityUid? get audience {
    if (_cork.audience case final audience?) {
      return cedar.EntityUid.fromProto(proto.EntityUid().unpackAny(audience));
    }
    return null;
  }

  @redeclare
  cedar.Entity? get claims {
    if (_cork.claims case final claims?) {
      return cedar.Entity.fromProto(proto.Entity().unpackAny(claims));
    }
    return null;
  }

  @redeclare
  List<cedar.Expr> get caveats => UnmodifiableListView([
        for (final caveat in _cork.caveats)
          cedar.Expr.fromProto(proto.Expr().unpackAny(caveat)),
      ]);
}
