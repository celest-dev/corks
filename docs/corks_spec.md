# Celest Cork Specification

## 1. Introduction
Celest corks are composable authorization credentials inspired by macaroons ([Birgisson et al. 2014](theory.stanford.edu_~ataly_Papers_macaroons.pdf.2025-10-24T14_39_32.467Z.md)) and informed by Fly.io’s production deployment ([Ptacek 2024](fly.io_blog_macaroons-escalated-quickly_.2025-10-24T14_39_07.425Z.md), [`superfly/macaroon`](macaroon)). Corks enable multi-tenant access control across Celest Cloud services by allowing tokens to be attenuated and delegated while carrying structured caveats that encode organizational context. This specification replaces prior implementations under `packages/corks`.

## 2. Goals
- **Composable attenuation.** Holders MUST be able to add caveats without access to issuer secrets.
- **Multi-tenant safety.** Tokens MUST encode Celest organizational scoping (organization → project → environment) to prevent cross-tenant bleed.
- **Third-party federation.** The design MUST support external discharge services (SSO, audit, risk engines).
- **Language parity.** A single canonical format MUST interoperate across Dart, Go, and future SDKs.
- **Operational tractability.** Verification MUST be separable from signing and cacheable for scale.

## 3. Terminology
- **Cork:** A Celest macaroon credential.
- **Issuer:** Service minting the cork (typically Celest Cloud Auth).
- **Bearer:** Principal authorized to act (user/session/automation agent).
- **Audience:** Optional service expected to receive the cork.
- **Caveat:** Predicate restricting the cork. First-party caveats are evaluated by the verifier; third-party caveats require a discharge macaroon from the referenced service.
- **Discharge:** A macaroon fulfilling a third-party caveat.
- **Root key:** Per-cork secret derived from the issuer’s master key.

## 4. Data Model
Corks use canonical protobuf v3 serialization with deterministic encoding. Symbols below use `proto3` syntax.

```proto
syntax = "proto3";
package celest.corks.v1;

import "google/protobuf/any.proto";

message Cork {
  uint32 version = 1;                     // MUST be 1 for this spec.
  bytes nonce = 2;                        // 24-byte random nonce.
  bytes key_id = 3;                       // References signing key; not equal to nonce.
  google.protobuf.Any issuer = 4;         // Celest::EntityUid (Cedar proto).
  google.protobuf.Any bearer = 5;         // Celest::EntityUid (principal).
  google.protobuf.Any audience = 6;       // Optional.
  google.protobuf.Any claims = 7;         // Optional entity metadata (e.g., session attrs).
  repeated Caveat caveats = 8;            // Ordered caveats applied during verification.
  bytes tail_signature = 9;               // Final chained MAC tag.
  uint64 issued_at = 10;                  // Unix epoch ms.
  uint64 not_after = 11;                  // Optional expiry.
}

message Caveat {
  uint32 caveat_version = 1;              // MUST be 1.
  bytes caveat_id = 2;                    // Unique per caveat.
  oneof body {
    FirstPartyCaveat first_party = 3;
    ThirdPartyCaveat third_party = 4;
  }
}

message FirstPartyCaveat {
  string namespace = 1;                   // e.g., "celest.auth".
  string predicate = 2;                   // Identifier for evaluator.
  google.protobuf.Any payload = 3;        // Structured data, deterministic encoding.
}

message ThirdPartyCaveat {
  string location = 1;                    // Discharge service base URL or identifier.
  bytes ticket = 2;                       // AEAD ciphertext delivered to third party.
  bytes challenge = 3;                    // AEAD ciphertext consumed by verifier.
  bytes salt = 4;                         // Optional, for key derivation tweaks.
}

message Discharge {
  uint32 version = 1;                     // MUST match Cork.version.
  bytes nonce = 2;
  bytes key_id = 3;
  bytes parent_caveat_id = 4;             // Links to originating caveat.
  google.protobuf.Any issuer = 5;         // Third-party issuer.
  repeated Caveat caveats = 6;            // Additional attenuation.
  bytes tail_signature = 7;
  uint64 issued_at = 8;
  uint64 not_after = 9;
}
```

### Encoding
- Wire format MUST be deterministic protobuf (set E deterministic serialization in all libraries).
- Transport encoding for HTTP and storage MUST be base64url (unpadded) of the serialized bytes.

## 5. Cryptographic Primitives
- Master keys MUST be 256-bit secrets held by the signing authority.
- Per-cork root key: `rk = HMAC-SHA256(master_key, nonce || key_id || "celest/cork/v1")`.
- Chained signatures follow Birgisson et al.: `tag_0 = HMAC(rk, "celest:cork:v1")`; each field (issuer, bearer, audience, claims, metadata, caveats) is added via `tag_{i+1} = HMAC(tag_i, encode(field_i))`. `tail_signature = tag_final`.
- Third-party caveat encryption MUST use AEAD (ChaCha20-Poly1305) with the current tag as key: `challenge = AEAD_Seal(tag_i, derived_key, caveat_id || salt, metadata)`.
- Tickets to third parties MUST be encrypted with keys known only to the third party (e.g., via shared secret or KMS).
- Signatures MUST be constant-time compared during verification.

## 6. Key Management and Services
- Signing services MUST isolate master keys; verification services MUST call an HTTP API (or gRPC) that accepts serialized corks and returns verification decisions plus derived context.
- `key_id` MUST reference a rotating key managed via KMS/HSM. Corks with unknown `key_id` MUST be rejected.
- Nonces MUST be unique per cork; recommend 192 bits from CSPRNG.

## 7. Token Lifecycle
### 7.1 Minting
1. Generate nonce and choose signing key.
2. Populate issuer (typically `Celest::Service`), bearer (e.g., `Celest::Session::session-id`), claims (session context) and default caveats:
   - `celest.auth.expiry` (not_after).
   - `celest.auth.organization_scope` (organization/project/environment path).
   - `celest.auth.actions` (allowed action set).
3. Compute chained tag with empty caveat list.
4. Return serialized cork.

### 7.2 Attenuation (First Party)
- Any holder MAY append first-party caveats by:
  1. Parsing the cork.
  2. Recomputing chained tags using the existing `tail_signature` as the new root key.
  3. Appending the new caveat and updating `tail_signature`.
- No master key access is required.

### 7.3 Third-Party Caveats
- To add a third-party caveat, the attenuator MUST:
  1. Derive ephemeral caveat root key `crk = HKDF(tag_i, caveat_id || salt)`.
  2. Encrypt a ticket for the third party using its public parameters.
  3. Encrypt a challenge (containing `crk`) for the verifier with `tag_i` as AEAD key.
  4. Append caveat and update signature as in first-party attenuation.

### 7.4 Discharge Acquisition
- Holder sends `ticket` to third-party service, receives discharge macaroon.
- Discharge MUST reference `parent_caveat_id` and be attenuable using the same chained MAC scheme.
- Discharges MUST accompany cork during authorization; verification without required discharges MUST fail.

## 8. Verification Algorithm
Given cork `C`, discharges `D`:
1. Validate `C.version == 1`, `tail_signature` present, `key_id` recognized, `issued_at` ≤ now ≤ `not_after` (if set).
2. Recompute chained tags:
   - Derive root key via master key.
   - Iterate fields in order; for each caveat:
     - If first-party: evaluate via registered predicate handler. Failure is fatal.
     - If third-party:
       1. Locate discharge with matching `parent_caveat_id`; verify discharge signature recursively.
       2. Decrypt challenge using current tag to recover `crk`.
       3. Use `crk` as root key when verifying discharge.
       4. Evaluate discharge caveats (first- and third-party) recursively.
3. Confirm final recomputed tag equals `tail_signature`.
4. Optionally emit evaluation context (organization path, action scopes) for downstream policy checks.

## 9. Caveat Registry and Evaluation
Celest MUST publish a registry mapping `(namespace, predicate)` to handler logic with canonical payload schemas. Initial set:
- `celest.auth.expiry` — payload: `{ "not_after": uint64 }`.
- `celest.auth.organization_scope` — payload: `Celest::OrganizationScope` proto containing organization/project/environment IDs.
- `celest.auth.action_scope` — payload: permitted `Celest::Action` enums.
- `celest.auth.ip_binding` — payload: CIDR set.
- `celest.auth.session_state` — payload: session version for revocation.

Handlers MUST be pure functions returning boolean allowed/denied. Unknown predicates MUST fail closed.

## 10. Multi-Tenant Integration
- Corks MUST encode tenant context at issuance via the organization scope caveat.
- Cloud Hub MUST propagate tenant identifiers into gRPC metadata so downstream services can author argument-specific caveats (e.g., resource path).
- Migration plan (per `celest_cedar_multitenant_review.md`): automated backfill ensures each legacy project receives an organization container and tokens reissued with proper scopes.

## 11. Multi-Language Support
- The protobuf schema above is canonical; code generation MUST occur via `buf` with strict versioning.
- Libraries MUST implement deterministic serialization, chained MAC, AEAD routines, and caveat evaluation identically. Provide:
  - Shared test vectors (JSON + base64url tokens, expected tags, evaluation outcomes).
  - Reference implementation (Go) and first-party SDKs (Dart, TypeScript) built from the spec.
- A conformance tester MUST load fixtures and assert parity across languages.

## 12. Security Considerations
- Master keys MUST never leave HSM/KMS. Only signing service holds master; verification services request derived keys via secure channel or use remote signing API.
- Nonce reuse compromises security; implementation MUST enforce uniqueness.
- Third-party caveats rely on high-entropy `crk`; AEAD misuse MUST be prevented by unique nonces per encryption.
- Logging MUST redact caveat payloads that may contain secrets.
- Revocation strategy: short-lived corks (≤1h) plus `session_state` caveats referencing revocation lists.

## 13. Operational Guidance
- **Verification API:** `POST /v1/corks:verify` accepts cork + discharges, returns status, resolved tenant identifiers, and evaluator trace IDs.
- **Caching:** Successful verifications MAY be cached keyed by `tail_signature` for ≤ token lifetime.
- **Observability:** Emit metrics for caveat evaluation failures, third-party discharge latencies, and tenant scope mismatches.
- **Rotation:** Keys and caveat registries MUST support versioning; clients MUST accept multiple `key_id` values during rotation windows.

## 14. Extensibility
- `version` fields allow future protocol revisions.
- Additional caveat namespaces MUST be documented and registered.
- A public-key variant MAY be introduced (per Birgisson et al. Section V-H) without breaking changes by introducing `signature_type` metadata.

## 15. References
1. Birgisson, A. et al. *Macaroons: Cookies with Contextual Caveats for Decentralized Authorization in the Cloud*. NDSS 2014.
2. Ptacek, T. *Macaroons Escalated Quickly*. Fly.io Blog, 2024.
3. `superfly/macaroon` GitHub repository (accessed 2025-10-24).
