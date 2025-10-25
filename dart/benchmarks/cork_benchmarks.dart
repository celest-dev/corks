import 'dart:typed_data';

import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:corks_cedar/src/cork.dart';
import 'package:corks_cedar/src/crypto.dart';
import 'package:corks_cedar/src/proto.dart';
import 'package:corks_cedar/src/proto/cedar/v3/entity_uid.pb.dart' as cedar;
import 'package:corks_cedar/src/proto/cedar/v3/value.pb.dart' as cedar_value;
import 'package:corks_cedar/src/proto/corks/v1/cork.pb.dart' as corksv1;
import 'package:corks_cedar/src/proto/google/protobuf/wrappers.pb.dart'
    as wrappers;
import 'package:corks_cedar/src/signer.dart';
import 'package:cryptography/cryptography.dart';

final _fixtures = _BenchmarkFixtures();
Object? _sink;

@pragma('vm:never-inline')
@pragma('dart2js:noInline')
void _consume(Object? value) {
  _sink = value;
  if (identical(_sink, Object())) {
    throw StateError('unreachable');
  }
}

Future<void> main() async {
  final results = await runCorkBenchmarks();
  results.forEach(
    (name, micros) => print('$name(RunTime): ${micros.toStringAsFixed(8)} us.'),
  );
}

Future<Map<String, double>> runCorkBenchmarks() async {
  await _fixtures.initialize();

  final syncBenchmarks = <BenchmarkBase>[DeriveCaveatRootKeyBenchmark()];

  final asyncBenchmarks = <AsyncBenchmarkBase>[
    ComputeTailSignatureBenchmark(),
    SignCorkBenchmark(),
    VerifyCorkBenchmark(),
    EncryptChallengeBenchmark(),
    DecryptChallengeBenchmark(),
  ];

  final results = <String, double>{};
  for (final bench in syncBenchmarks) {
    results[bench.name] = bench.measure();
  }
  for (final bench in asyncBenchmarks) {
    results[bench.name] = await bench.measure();
  }
  return results;
}

class ComputeTailSignatureBenchmark extends AsyncBenchmarkBase {
  ComputeTailSignatureBenchmark() : super('crypto.computeTailSignature');

  late corksv1.Cork _message;

  @override
  Future<void> setup() async {
    _message = _fixtures.baseMessage;
  }

  @override
  Future<void> run() async {
    final tag = await computeTailSignature(_message, _fixtures.signer);
    _consume(tag);
  }
}

class SignCorkBenchmark extends AsyncBenchmarkBase {
  SignCorkBenchmark() : super('cork.sign');

  late Cork _cork;

  @override
  Future<void> setup() async {
    _cork = _fixtures.unsignedCork;
  }

  @override
  Future<void> run() async {
    final signed = await _cork.sign(_fixtures.signer);
    _consume(signed.tailSignature);
  }
}

class VerifyCorkBenchmark extends AsyncBenchmarkBase {
  VerifyCorkBenchmark() : super('cork.verify');

  late Cork _cork;

  @override
  Future<void> setup() async {
    _cork = _fixtures.signedCork;
  }

  @override
  Future<void> run() async {
    await _cork.verify(_fixtures.signer);
    _consume(_cork.version);
  }
}

class DeriveCaveatRootKeyBenchmark extends BenchmarkBase {
  DeriveCaveatRootKeyBenchmark() : super('crypto.deriveCaveatRootKey');

  late Uint8List _tag;
  late Uint8List _caveatId;
  late Uint8List _salt;

  @override
  void setup() {
    _tag = _fixtures.tailSignature;
    _caveatId = _fixtures.caveatId;
    _salt = _fixtures.salt;
  }

  @override
  void run() {
    final derived = deriveCaveatRootKey(
      tag: _tag,
      caveatId: _caveatId,
      salt: _salt,
    );
    _consume(derived);
  }
}

class EncryptChallengeBenchmark extends AsyncBenchmarkBase {
  EncryptChallengeBenchmark() : super('crypto.encryptChallenge');

  late Uint8List _nonce;

  @override
  Future<void> setup() async {
    _nonce = _fixtures.challengeNonce;
  }

  @override
  Future<void> run() async {
    final challenge = await encryptChallenge(
      tag: _fixtures.tailSignature,
      caveatId: _fixtures.caveatId,
      salt: _fixtures.salt,
      derivedKey: _fixtures.derivedKey,
      nonce: _nonce,
    );
    _consume(challenge);
  }
}

class DecryptChallengeBenchmark extends AsyncBenchmarkBase {
  DecryptChallengeBenchmark() : super('crypto.decryptChallenge');

  @override
  Future<void> run() async {
    final plain = await decryptChallenge(
      tag: _fixtures.tailSignature,
      caveatId: _fixtures.caveatId,
      salt: _fixtures.salt,
      challenge: _fixtures.challenge,
    );
    _consume(plain);
  }
}

class _BenchmarkFixtures {
  bool _initialized = false;
  late Uint8List keyId;
  late Uint8List masterKey;
  late Signer signer;
  late Cork unsignedCork;
  late corksv1.Cork baseMessage;
  late Cork signedCork;
  late Uint8List tailSignature;
  late Uint8List caveatId;
  late Uint8List salt;
  late Uint8List derivedKey;
  late Uint8List challengeNonce;
  late Uint8List challenge;

  Future<void> initialize() async {
    if (_initialized) {
      return;
    }
    keyId = Uint8List.fromList(List<int>.generate(16, (index) => index));
    masterKey = Uint8List.fromList(
      List<int>.generate(32, (index) => index ^ 0x5a),
    );
    signer = Signer(keyId, masterKey);

    final builder =
        CorkBuilder(keyId)
          ..nonce = Uint8List.fromList(
            List<int>.generate(nonceSize, (index) => index),
          )
          ..issuer =
              (cedar.EntityUid()
                    ..type = 'Service'
                    ..id = 'celest-cloud')
                  .packIntoAny()
          ..bearer =
              (cedar.EntityUid()
                    ..type = 'Session'
                    ..id = 'sess-123')
                  .packIntoAny()
          ..claims =
              (cedar_value.Value()
                    ..string = (wrappers.StringValue()..value = 'alpha'))
                  .packIntoAny()
          ..notAfter = DateTime.utc(2030, 1, 1);

    final scope =
        cedar_value.Value()
          ..string = (wrappers.StringValue()..value = 'org:123');
    builder.addCaveat(
      corksv1.Caveat(
        caveatVersion: 1,
        caveatId: Uint8List.fromList(
          List<int>.generate(16, (index) => index + 1),
        ),
        firstParty: corksv1.FirstPartyCaveat(
          namespace: 'celest.auth',
          predicate: 'organization_scope',
          payload: scope.packIntoAny(),
        ),
      ),
    );

    unsignedCork = builder.build();
    baseMessage = unsignedCork.toProto();

    signedCork = await unsignedCork.sign(signer);
    tailSignature = signedCork.tailSignature;

    caveatId = Uint8List.fromList(
      List<int>.generate(16, (index) => 16 - index),
    );
    salt = Uint8List.fromList(
      List<int>.generate(8, (index) => index * 3 & 0xff),
    );

    derivedKey = deriveCaveatRootKey(
      tag: tailSignature,
      caveatId: caveatId,
      salt: salt,
    );

    final cipherNonceLength = Chacha20.poly1305Aead().nonceLength;
    challengeNonce = Uint8List.fromList(
      List<int>.generate(cipherNonceLength, (index) => index + 7),
    );

    challenge = await encryptChallenge(
      tag: tailSignature,
      caveatId: caveatId,
      salt: salt,
      derivedKey: derivedKey,
      nonce: challengeNonce,
    );
    _initialized = true;
  }
}
