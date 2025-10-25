package corks

import (
	"context"
	"encoding/base64"
	"encoding/json"
	"errors"
	"os"
	"path/filepath"
	"testing"
	"time"

	"github.com/google/go-cmp/cmp"
	"google.golang.org/protobuf/encoding/protojson"

	cedarv3 "github.com/celest-dev/corks/go/proto/cedar/v3"
)

const (
	crossLanguageFixture = "../testdata/celest_cork_vectors.json"
)

func TestConformanceVectorsFixture(t *testing.T) {
	actual := readFixtureMap(t)
	expected := buildExpectedVectors(t)

	if diff := cmp.Diff(expected, actual); diff != "" {
		serialized, err := json.MarshalIndent(expected, "", "  ")
		if err != nil {
			t.Fatalf("marshal expected vectors: %v", err)
		}
		t.Fatalf("conformance fixture out of date; regenerate using go implementation. diff (-want +got):\n%s\nSuggested content:\n%s", diff, string(serialized))
	}
}

func TestConformanceVectors(t *testing.T) {
	fixture := readFixture(t)

	signers := make(map[string]Signer)
	ctx := context.Background()

	for name, signer := range fixture.Signers {
		keyID, err := base64.StdEncoding.DecodeString(signer.KeyID)
		if err != nil {
			t.Fatalf("decode signer %s key id: %v", name, err)
		}
		masterKey, err := base64.StdEncoding.DecodeString(signer.MasterKey)
		if err != nil {
			t.Fatalf("decode signer %s master key: %v", name, err)
		}
		signers[name] = NewSigner(keyID, masterKey)
	}

	marshalOpts := protojson.MarshalOptions{}

	for _, vector := range fixture.Vectors {
		vector := vector
		t.Run(vector.Name, func(t *testing.T) {
			signer, ok := signers[vector.Signer]
			if !ok {
				t.Fatalf("signer %s not found", vector.Signer)
			}

			decoded, err := Decode(vector.Token)
			if err != nil {
				t.Fatalf("decode token: %v", err)
			}

			actualSig := base64.StdEncoding.EncodeToString(decoded.TailSignature())
			if actualSig != vector.TailSignature.Actual {
				t.Fatalf("tail signature mismatch: got %s want %s", actualSig, vector.TailSignature.Actual)
			}

			expectedSigBytes, err := computeTailSignature(ctx, decoded.Proto(), signer)
			if err != nil {
				t.Fatalf("compute tail signature: %v", err)
			}
			expectedSig := base64.StdEncoding.EncodeToString(expectedSigBytes)
			if expectedSig != vector.TailSignature.Expected {
				t.Fatalf("expected signature mismatch: got %s want %s", expectedSig, vector.TailSignature.Expected)
			}

			err = decoded.Verify(ctx, signer)
			if vector.Expect.SignatureValid {
				if err != nil {
					t.Fatalf("verify failed: %v", err)
				}
			} else {
				if !errors.Is(err, ErrInvalidSignature) {
					t.Fatalf("verify: expected ErrInvalidSignature, got %v", err)
				}
			}

			protoJSON, err := marshalOpts.Marshal(decoded.Proto())
			if err != nil {
				t.Fatalf("marshal proto: %v", err)
			}

			var protoMap map[string]any
			if err := json.Unmarshal(protoJSON, &protoMap); err != nil {
				t.Fatalf("unmarshal marshalled proto: %v", err)
			}

			var expectedProto map[string]any
			if err := json.Unmarshal(vector.Proto, &expectedProto); err != nil {
				t.Fatalf("unmarshal expected proto: %v", err)
			}

			if diff := cmp.Diff(expectedProto, protoMap); diff != "" {
				t.Fatalf("proto mismatch (-want +got):\n%s", diff)
			}
		})
	}
}

func buildExpectedVectors(t testing.TB) map[string]any {
	t.Helper()

	const signerName = "default"
	keyID := sequentialBytes(16, 0)
	masterKey := sequentialBytes(32, 16)
	nonce := sequentialBytes(24, 0)

	builder := NewBuilder(keyID).
		Nonce(nonce).
		Issuer(&cedarv3.EntityUid{Type: "User", Id: "issuer-alice"}).
		Bearer(&cedarv3.EntityUid{Type: "User", Id: "bearer-bob"}).
		Audience(&cedarv3.EntityUid{Type: "Service", Id: "celest-cloud"}).
		IssuedAt(time.Date(2024, 1, 1, 0, 0, 0, 0, time.UTC)).
		NotAfter(time.Date(2024, 1, 1, 1, 0, 0, 0, time.UTC))

	unsigned, err := builder.Build()
	if err != nil {
		t.Fatalf("build cork: %v", err)
	}

	signer := NewSigner(keyID, masterKey)
	signed, err := unsigned.Sign(context.Background(), signer)
	if err != nil {
		t.Fatalf("sign cork: %v", err)
	}

	tampered := signed.clone()
	mutated := append([]byte(nil), tampered.proto.TailSignature...)
	mutated[0] ^= 0xFF
	tampered.proto.TailSignature = mutated

	encodeVector := func(name, description string, cork *Cork, expectedSig []byte, signatureValid bool) map[string]any {
		token, err := cork.Encode()
		if err != nil {
			t.Fatalf("encode cork: %v", err)
		}

		protoJSON, err := protojson.Marshal(cork.Proto())
		if err != nil {
			t.Fatalf("marshal proto: %v", err)
		}
		var protoMap map[string]any
		if err := json.Unmarshal(protoJSON, &protoMap); err != nil {
			t.Fatalf("unmarshal proto json: %v", err)
		}

		return map[string]any{
			"name":        name,
			"description": description,
			"signer":      signerName,
			"token":       token,
			"tailSignature": map[string]any{
				"actual":   base64.StdEncoding.EncodeToString(cork.TailSignature()),
				"expected": base64.StdEncoding.EncodeToString(expectedSig),
			},
			"expect": map[string]any{
				"signatureValid": signatureValid,
			},
			"proto": protoMap,
		}
	}

	vectors := []map[string]any{
		encodeVector(
			"basic_valid",
			"Deterministic cork signed with the default key.",
			signed,
			signed.TailSignature(),
			true,
		),
		encodeVector(
			"signature_tampered",
			"Tail signature first byte flipped to invalidate token.",
			tampered,
			signed.TailSignature(),
			false,
		),
	}

	fixture := map[string]any{
		"version": 1,
		"signers": map[string]any{
			signerName: map[string]any{
				"keyId":     base64.StdEncoding.EncodeToString(keyID),
				"masterKey": base64.StdEncoding.EncodeToString(masterKey),
			},
		},
		"vectors": vectors,
	}

	serialized, err := json.Marshal(fixture)
	if err != nil {
		t.Fatalf("marshal expected fixture: %v", err)
	}

	var normalized map[string]any
	if err := json.Unmarshal(serialized, &normalized); err != nil {
		t.Fatalf("normalize expected fixture: %v", err)
	}

	return normalized
}

func readFixture(t testing.TB) fixtureFile {
	t.Helper()

	path := filepath.Clean(crossLanguageFixture)
	data, err := os.ReadFile(path)
	if err != nil {
		t.Fatalf("read fixture %s: %v", path, err)
	}

	var normalized fixtureFile
	if err := json.Unmarshal(data, &normalized); err != nil {
		t.Fatalf("unmarshal fixture %s: %v", path, err)
	}

	return normalized
}

func readFixtureMap(t testing.TB) map[string]any {
	t.Helper()

	path := filepath.Clean(crossLanguageFixture)
	data, err := os.ReadFile(path)
	if err != nil {
		t.Fatalf("read fixture %s: %v", path, err)
	}

	var normalized map[string]any
	if err := json.Unmarshal(data, &normalized); err != nil {
		t.Fatalf("unmarshal fixture %s: %v", path, err)
	}

	return normalized
}

func sequentialBytes(length int, offset byte) []byte {
	buf := make([]byte, length)
	for i := range buf {
		buf[i] = byte(int(offset) + i)
	}
	return buf
}

type fixtureFile struct {
	Version int `json:"version"`
	Signers map[string]struct {
		KeyID     string `json:"keyId"`
		MasterKey string `json:"masterKey"`
	} `json:"signers"`
	Vectors []struct {
		Name          string `json:"name"`
		Description   string `json:"description"`
		Signer        string `json:"signer"`
		Token         string `json:"token"`
		TailSignature struct {
			Actual   string `json:"actual"`
			Expected string `json:"expected"`
		} `json:"tailSignature"`
		Expect struct {
			SignatureValid bool `json:"signatureValid"`
		} `json:"expect"`
		Proto json.RawMessage `json:"proto"`
	} `json:"vectors"`
}
