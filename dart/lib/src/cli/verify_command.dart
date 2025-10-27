import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:args/command_runner.dart';
import 'package:corks_cedar/src/cork.dart';
import 'package:corks_cedar/src/crypto.dart';
import 'package:corks_cedar/src/discharge.dart';
import 'package:corks_cedar/src/exceptions.dart';
import 'package:corks_cedar/src/proto/celest/corks/v1/cork.pb.dart' as corksv1;
import 'package:corks_cedar/src/proto/google/protobuf/any.pb.dart' as anypb;
import 'package:corks_cedar/src/signer.dart';

import 'utils.dart';

class VerifyCommand extends Command<int> {
  VerifyCommand(this._stdout, this._stderr) {
    argParser
      ..addOption('token', abbr: 't', help: 'Base64-encoded cork to verify.')
      ..addOption(
        'file',
        abbr: 'f',
        help: 'Path to a file containing the cork; use "-" for stdin.',
      )
      ..addOption(
        'key-id',
        help: 'Signing key identifier (hex or base64, see --encoding).',
        valueHelp: 'hex-string',
      )
      ..addOption(
        'master-key',
        help: 'Master key material (hex or base64, see --encoding).',
        valueHelp: 'hex-string',
      )
      ..addOption(
        'encoding',
        allowed: const ['hex', 'base64'],
        defaultsTo: 'hex',
        help: 'Encoding used for --key-id and --master-key (default: hex).',
      )
      ..addMultiOption(
        'discharge',
        help: 'Base64 discharge token fulfilling a third-party caveat.',
        valueHelp: 'token',
      )
      ..addMultiOption(
        'discharge-file',
        help: 'Path to a file containing a discharge token.',
        valueHelp: 'path',
      );
  }

  final StringSink _stdout;
  final StringSink _stderr;

  @override
  String get name => 'verify';

  @override
  String get description =>
      'Recompute cork signatures and simulate verification with discharges.';

  @override
  Future<int> run() async {
    try {
      final args = argResults!;
      final token = await readToken(
        args,
        tokenOption: 'token',
        fileOption: 'file',
      );
      if (token.isEmpty) {
        throw UsageException('Token payload was empty.', usage);
      }

      final keyIdRaw = args['key-id'] as String?;
      final masterKeyRaw = args['master-key'] as String?;
      if (keyIdRaw == null || keyIdRaw.trim().isEmpty) {
        throw UsageException('Provide --key-id.', usage);
      }
      if (masterKeyRaw == null || masterKeyRaw.trim().isEmpty) {
        throw UsageException('Provide --master-key.', usage);
      }

      final encoding = args['encoding'] as String? ?? 'hex';
      late Uint8List keyId;
      late Uint8List masterKey;
      try {
        keyId = decodeKey(keyIdRaw, encoding: encoding);
        masterKey = decodeKey(masterKeyRaw, encoding: encoding);
      } on FormatException catch (error) {
        _stderr.writeln('Failed to decode key material: ${error.message}');
        return 1;
      }

      final dischargesFromArgs =
          args['discharge'] as List<String>? ?? const <String>[];
      final dischargeFiles =
          args['discharge-file'] as List<String>? ?? const <String>[];

      late Map<String, Discharge> discharges;
      try {
        final fileTokens = await readDischargeFiles(dischargeFiles);
        final combined = <String>[...dischargesFromArgs, ...fileTokens];
        discharges = parseDischarges(combined);
      } on UsageException {
        rethrow;
      } on InvalidCorkException catch (error) {
        _stderr.writeln('Failed to parse discharge: ${error.message}');
        return 1;
      }

      final signer = Signer(keyId, masterKey);
      late Cork cork;
      try {
        cork = Cork.parse(token);
      } on InvalidCorkException catch (error) {
        _stderr.writeln('Failed to parse cork: ${error.message}');
        return 1;
      }

      try {
        await cork.verify(signer);
        _stdout.writeln('Signature: valid');
      } on MissingSignatureError {
        _stderr.writeln('Cork is missing a tail signature.');
        return 1;
      } on InvalidSignatureException catch (error) {
        _stderr.writeln('Signature verification failed: $error');
        return 1;
      } on InvalidCorkException catch (error) {
        _stderr.writeln('Invalid cork: ${error.message}');
        return 1;
      }

      final thirdPartyResult = await _verifyThirdPartyCaveats(
        cork,
        signer,
        discharges,
      );

      if (!thirdPartyResult.hasThirdParty) {
        _stdout.writeln('Third-party caveats: none');
        if (thirdPartyResult.unusedDischarges.isNotEmpty) {
          _stderr.writeln(
            'Warning: unused discharges provided for caveat IDs: '
            '${thirdPartyResult.unusedDischarges.join(', ')}',
          );
        }
        return 0;
      }

      _stdout.writeln(
        'Third-party caveats: '
        '${thirdPartyResult.verifiedCount}/${thirdPartyResult.totalCaveats} verified',
      );

      if (thirdPartyResult.missingCaveats.isNotEmpty) {
        _stderr.writeln(
          'Missing discharges for caveat IDs: '
          '${thirdPartyResult.missingCaveats.join(', ')}',
        );
      }
      if (thirdPartyResult.invalidDischarges.isNotEmpty) {
        for (final message in thirdPartyResult.invalidDischarges) {
          _stderr.writeln('Discharge verification failed: $message');
        }
      }
      if (thirdPartyResult.unusedDischarges.isNotEmpty) {
        _stderr.writeln(
          'Warning: unused discharges provided for caveat IDs: '
          '${thirdPartyResult.unusedDischarges.join(', ')}',
        );
      }

      if (thirdPartyResult.isSuccessful) {
        return 0;
      }
      return 1;
    } on UsageException {
      rethrow;
    } on Exception catch (error) {
      _stderr.writeln('Error: $error');
      return 1;
    }
  }

  Future<_ThirdPartyVerificationResult> _verifyThirdPartyCaveats(
    Cork cork,
    Signer signer,
    Map<String, Discharge> providedDischarges,
  ) async {
    final proto = cork.toProto();
    final thirdPartyCaveats = proto.caveats.where((c) => c.hasThirdParty());
    final total = thirdPartyCaveats.length;
    if (total == 0) {
      return _ThirdPartyVerificationResult.empty(providedDischarges.keys);
    }

    final initialTag = await _initialTag(proto, signer);
    var tag = initialTag;

    final available = Map<String, Discharge>.from(providedDischarges);
    final missing = <String>[];
    final invalid = <String>[];
    final used = <String>{};
    var verified = 0;

    for (final caveat in proto.caveats) {
      final preTag = tag;
      if (caveat.hasThirdParty()) {
        final caveatId = Uint8List.fromList(caveat.caveatId);
        final caveatKey = bytesToBase64(caveatId);
        final discharge = available[caveatKey];
        if (discharge == null) {
          missing.add(caveatKey);
        } else {
          used.add(caveatKey);
          if (!bytesEqual(discharge.parentCaveatId, caveatId)) {
            invalid.add('$caveatKey (parent mismatch)');
          } else {
            final salt =
                caveat.thirdParty.hasSalt() && caveat.thirdParty.salt.isNotEmpty
                ? Uint8List.fromList(caveat.thirdParty.salt)
                : null;
            try {
              final derived = deriveCaveatRootKey(
                tag: preTag,
                caveatId: caveatId,
                salt: salt,
              );
              final challengeKey = await decryptChallenge(
                tag: preTag,
                caveatId: caveatId,
                salt: salt,
                challenge: Uint8List.fromList(caveat.thirdParty.challenge),
              );
              if (!bytesEqual(derived, challengeKey)) {
                invalid.add('$caveatKey (challenge mismatch)');
              } else {
                try {
                  discharge.verify(caveatRootKey: derived);
                  verified++;
                } on InvalidSignatureException catch (error) {
                  invalid.add('$caveatKey ($error)');
                } on MissingSignatureError {
                  invalid.add('$caveatKey (missing discharge signature)');
                } on InvalidCorkException catch (error) {
                  invalid.add('$caveatKey (${error.message})');
                }
              }
            } on InvalidCorkException catch (error) {
              invalid.add('$caveatKey (${error.message})');
            }
          }
        }
      }

      final encoded = caveat.writeToBuffer();
      tag = hmacSha256(tag, encoded);
    }

    final unused = available.keys
        .where((key) => !used.contains(key))
        .toList(growable: false);

    return _ThirdPartyVerificationResult(
      totalCaveats: total,
      verifiedCount: verified,
      missingCaveats: missing,
      invalidDischarges: invalid,
      unusedDischarges: unused,
    );
  }

  Future<Uint8List> _initialTag(corksv1.Cork proto, Signer signer) async {
    final rootKey = await signer.deriveCorkRootKey(
      nonce: Uint8List.fromList(proto.nonce),
      keyId: Uint8List.fromList(proto.keyId),
    );
    var tag = hmacSha256(rootKey, utf8.encode(macContext));
    tag = hmacSha256(tag, encodeUint32(proto.version));
    tag = hmacSha256(tag, Uint8List.fromList(proto.nonce));
    tag = hmacSha256(tag, Uint8List.fromList(proto.keyId));
    tag = _hashAny(tag, proto.hasIssuer() ? proto.issuer : null);
    tag = _hashAny(tag, proto.hasBearer() ? proto.bearer : null);
    tag = _hashAny(tag, proto.hasAudience() ? proto.audience : null);
    tag = _hashAny(tag, proto.hasClaims() ? proto.claims : null);
    return tag;
  }

  Uint8List _hashAny(Uint8List tag, anypb.Any? message) {
    if (message == null || message.value.isEmpty) {
      return tag;
    }
    return hmacSha256(tag, Uint8List.fromList(message.writeToBuffer()));
  }
}

class _ThirdPartyVerificationResult {
  const _ThirdPartyVerificationResult({
    required this.totalCaveats,
    required this.verifiedCount,
    required this.missingCaveats,
    required this.invalidDischarges,
    required this.unusedDischarges,
  });

  factory _ThirdPartyVerificationResult.empty(Iterable<String> unused) =>
      _ThirdPartyVerificationResult(
        totalCaveats: 0,
        verifiedCount: 0,
        missingCaveats: const <String>[],
        invalidDischarges: const <String>[],
        unusedDischarges: List<String>.from(unused),
      );

  final int totalCaveats;
  final int verifiedCount;
  final List<String> missingCaveats;
  final List<String> invalidDischarges;
  final List<String> unusedDischarges;

  bool get hasThirdParty => totalCaveats > 0;

  bool get isSuccessful => missingCaveats.isEmpty && invalidDischarges.isEmpty;
}
