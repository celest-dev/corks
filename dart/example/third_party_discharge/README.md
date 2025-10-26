# Third-Party Discharge Example

This example demonstrates how a Celest service can delegate third-party
caveats to external systems. Two mock integrations are provided:

* **SSO provider** – validates session metadata and issues a discharge with a
  `celest.auth/session_state` caveat.
* **Audit webhook** – records an access event and issues a discharge that
  encodes custom predicates.

## Prerequisites

* Dart SDK 3.8 or newer

## Running the demo

Install dependencies:

```sh
cd dart/example/third_party_discharge
dart pub get
```

Start the third-party service:

```sh
dart run bin/server.dart
```

In a separate shell, request a discharge for the SSO integration:

```sh
cd dart/example/third_party_discharge
dart run bin/client.dart sso
```

Run the audit flow to see custom caveats emitted by the webhook service:

```sh
dart run bin/client.dart audit
```

Each command prints the verified discharge identifiers. The server logs every
request it receives, letting you observe the incoming metadata and ticket
attributes—highlighting how the helper classes in `corks_cedar` manage
tickets, metadata, and caching.
