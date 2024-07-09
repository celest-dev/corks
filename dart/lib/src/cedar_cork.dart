import 'dart:collection';
import 'dart:typed_data';

import 'package:cedar/cedar.dart' as cedar;
import 'package:corks_cedar/corks_cedar.dart';
import 'package:corks_cedar/corks_proto.dart' as proto;
import 'package:corks_cedar/src/interop/proto_interop.dart';
import 'package:meta/meta.dart';

/// A builder for [Cork]s backed by Cedar.
extension type CedarCorkBuilder(CorkBuilder _builder) implements CorkBuilder {
  @redeclare
  set issuer(cedar.CedarEntityId issuer) {
    _builder.issuer = issuer.toProto();
  }

  @redeclare
  set bearer(cedar.CedarEntityId bearer) {
    _builder.bearer = bearer.toProto();
  }

  @redeclare
  set audience(cedar.CedarEntityId audience) {
    _builder.audience = audience.toProto();
  }

  @redeclare
  set claims(cedar.CedarEntity claims) {
    _builder.claims = claims.toProto();
  }

  @redeclare
  void addCaveat(cedar.CedarPolicy policy) {
    if (policy.effect != cedar.CedarPolicyEffect.forbid) {
      throw ArgumentError('Only forbid policies are allowed as caveats.');
    }
    _builder.addCaveat(policy.toProto());
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
  cedar.CedarEntityId get issuer =>
      proto.EntityId().unpackAny(_cork.issuer).fromProto();

  @redeclare
  cedar.CedarEntityId get bearer =>
      proto.EntityId().unpackAny(_cork.bearer).fromProto();

  @redeclare
  cedar.CedarEntityId? get audience {
    if (_cork.audience case final audience?) {
      return proto.EntityId().unpackAny(audience).fromProto();
    }
    return null;
  }

  @redeclare
  cedar.CedarEntity? get claims {
    if (_cork.claims case final claims?) {
      return proto.Entity().unpackAny(claims).fromProto();
    }
    return null;
  }

  @redeclare
  List<cedar.CedarPolicy> get caveats => UnmodifiableListView([
        for (final caveat in _cork.caveats)
          proto.Policy().unpackAny(caveat).fromProto(),
      ]);
}
