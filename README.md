# Corks

Corks are authorization tokens which are based off Google's [Macaroons](https://research.google/pubs/macaroons-cookies-with-contextual-caveats-for-decentralized-authorization-in-the-cloud/) paper. They are bearer tokens which identify the entity possessing them, while providing a mechanism for embedding further restrictions via [Cedar](https://www.cedarpolicy.com/en) policy caveats.

## Examples

The Dart package ships with a runnable demo in
`dart/example/third_party_discharge/`. It spins up a mock third-party
discharge service alongside a client that exercises the
`SharedSecretTicketCodec` and `ThirdPartyDischargeClient` helpers. From the
repository root run:

```sh
cd dart/example/third_party_discharge
dart pub get
dart run bin/server.dart    # in one shell
dart run bin/client.dart sso
```

Use `dart run bin/client.dart audit` to see the audit webhook variant, or
`dart run bin/client.dart both` to request discharges for both caveats in a
single cork.

## Development

Corks use Protobuf for serialization and deserialization of bearers and caveats. The proto definitions are located in the [proto](./proto) directory and the [Buf](https://buf.build) toolchain is used to generate Dart code from the Protobuf files.

To generate the Dart code, install Buf then run the following command:

```sh
$ make protos
```
