# Corks

Corks are authorization tokens which are based off Google's
[Macaroons](https://research.google/pubs/macaroons-cookies-with-contextual-caveats-for-decentralized-authorization-in-the-cloud/)
paper. They are bearer tokens which identify the entity possessing them while
providing a mechanism for embedding further restrictions via
[Cedar](https://www.cedarpolicy.com/en) policy caveats.

This package ships the reference Dart implementation used throughout Celest.
In addition to the runtime APIs, it provides a CLI that helps developers inspect
tokens, print caveat chains, and simulate verification flows locally.

## Getting Started

```sh
dart pub get
```

The primary APIs live under `lib/src`. See `lib/src/cork.dart` for the main
token model and `lib/src/discharge.dart` for third-party discharge support. The
`example/third_party_discharge` directory demonstrates end-to-end attenuation.

## CLI Usage

The CLI is packaged as an executable named `corks`. You can run it directly via
`dart` or add it to your path with `dart pub global activate`.

```sh
dart run corks_cedar:corks --help
```

### Inspect tokens

Parse a base64-encoded cork or discharge and print its metadata, caveats, and
timestamps. You can pass a token inline or read it from a file (use `-` for
stdin).

```sh
dart run corks_cedar:corks inspect --token "$CORK_TOKEN"

dart run corks_cedar:corks inspect --file path/to/token.txt --json
```

Flags:

- `--token` / `-t`: base64 token value.
- `--file` / `-f`: file containing the token (mutually exclusive with `--token`).
- `--json`: emit structured JSON instead of a human-readable summary.

### Verify signatures and discharges

Recompute a cork's chained MAC using the provided key material and optionally
verify third-party discharges. Supply discharges either inline or from files.

```sh
dart run corks_cedar:corks verify \
	--token "$CORK_TOKEN" \
	--key-id "$(cat key_id.hex)" \
	--master-key "$(cat master_key.hex)" \
	--discharge "$DISCHARGE_TOKEN"
```

Flags:

- `--token` / `-t`: base64 cork token (or `--file`).
- `--key-id`: signing key identifier (hex by default).
- `--master-key`: master key bytes (hex by default).
- `--encoding`: `hex` (default) or `base64` for key inputs.
- `--discharge`: one or more base64 discharge tokens fulfilling third-party
	caveats.
- `--discharge-file`: path(s) containing discharge tokens.

The command prints `Signature: valid` when the chained MAC matches and reports
missing or invalid discharges for each caveat ID. When the cork has no
third-party caveats, it short-circuits and notes that no discharges were needed.

## Development

To run the test suite (including the CLI integration tests):

```sh
dart test
```

Regenerate protobuf bindings with:

```sh
make protos
```