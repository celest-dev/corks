package corks

import (
	"context"
	"encoding/binary"
	"encoding/hex"
	"errors"
	"testing"
	"time"

	corksproto "github.com/celest-dev/corks/go/proto"
	corksv1 "github.com/celest-dev/corks/go/proto/corks/v1"
	"github.com/stretchr/testify/require"
	"google.golang.org/protobuf/proto"
	"google.golang.org/protobuf/types/known/anypb"
	"google.golang.org/protobuf/types/known/wrapperspb"
)

func TestCorkTailSignatureMatchesSpecification(t *testing.T) {
	t.Helper()

	keyID := []byte("cork-key-0001")
	masterKey := mustDecodeHex(t, "00112233445566778899aabbccddeeff00112233445566778899aabbccddeeff")

	builder := NewBuilder(keyID)
	builder.Nonce(mustDecodeHex(t, "000102030405060708090a0b0c0d0e0f1011121314151617"))
	builder.Issuer(wrapperspb.String("celest::issuer/auth"))
	builder.Bearer(wrapperspb.String("celest::principal/alice"))
	builder.Audience(wrapperspb.String("celest::service/hub"))
	builder.Claims(wrapperspb.String("session:abc123"))
	builder.IssuedAt(time.Unix(1_700_000_000, 0))
	builder.NotAfter(time.Unix(1_700_000_000+3600, 0))
	builder.Caveat(firstPartyCaveat(t,
		mustDecodeHex(t, "0a0b0c0d0e0f10111213141516171819"),
		"celest.auth",
		"allow_all",
		wrapperspb.Bool(true),
	))

	cork, err := builder.Build()
	require.NoError(t, err)

	signer := NewSigner(keyID, masterKey)
	ctx := context.Background()
	signed, err := cork.Sign(ctx, signer)
	require.NoError(t, err)
	require.NotEmpty(t, signed.TailSignature())

	expected := computeSpecTailSignature(t, signed.Proto(), masterKey)
	require.Equal(t, expected, signed.TailSignature())

	token, err := signed.Encode()
	require.NoError(t, err)
	require.NotContains(t, token, "=")

	decoded, err := Decode(token)
	require.NoError(t, err)
	require.True(t, proto.Equal(decoded.Proto(), signed.Proto()))

	tampered := signed.clone()
	tamperedAudience, err := corksproto.MarshalAny(wrapperspb.String("celest::service/analytics"))
	require.NoError(t, err)
	tampered.proto.Audience = tamperedAudience
	require.ErrorIs(t, tampered.Verify(ctx, signer), ErrInvalidSignature)

	wrongKeySigner := NewSigner([]byte("cork-key-0002"), masterKey)
	require.ErrorIs(t, signed.Verify(ctx, wrongKeySigner), ErrMismatchedKey)
}

func TestBuilderValidation(t *testing.T) {
	builder := NewBuilder(nil)
	builder.Nonce(mustDecodeHex(t, "ffffffffffffffffffffffffffffffffffffffffffffffff"))
	builder.Issuer(wrapperspb.String("celest::issuer"))
	builder.Bearer(wrapperspb.String("celest::principal"))

	err := builder.Validate()
	require.ErrorContains(t, err, "key_id")

	builder.KeyID([]byte("validation-key"))
	builder.Caveat(&corksv1.Caveat{})
	err = builder.Validate()
	require.ErrorContains(t, err, "caveat 0 missing version")

	builder = NewBuilder([]byte("validation-key"))
	builder.Nonce(mustDecodeHex(t, "0102030405060708090a0b0c0d0e0f101112131415161718"))
	builder.Issuer(wrapperspb.String("celest::issuer"))
	builder.Bearer(wrapperspb.String("celest::principal"))
	builder.Caveat(firstPartyCaveat(t,
		mustDecodeHex(t, "ffffffffffffffffffffffffffffffff"),
		"celest.auth",
		"allow_all",
		wrapperspb.Bool(true),
	))
	builder.NotAfter(time.Time{})

	_, err = builder.Build()
	require.NoError(t, err)
}

func TestCorkSignPropagatesDerivationFailures(t *testing.T) {
	keyID := []byte("ctx-key")
	issuer := wrapperspb.String("celest::issuer")
	bearer := wrapperspb.String("celest::principal")

	ctx := context.Background()
	builder := NewBuilder(keyID)
	builder.Issuer(issuer)
	builder.Bearer(bearer)

	cork, err := builder.Build()
	require.NoError(t, err)

	boom := errors.New("derive boom")
	failingSigner := NewMockSigner(keyID, func(context.Context, []byte, []byte) ([]byte, error) {
		return nil, boom
	})

	_, err = cork.Sign(ctx, failingSigner)
	require.ErrorIs(t, err, boom)

	shortKeySigner := NewMockSigner(keyID, func(context.Context, []byte, []byte) ([]byte, error) {
		return make([]byte, 16), nil
	})

	_, err = cork.Sign(ctx, shortKeySigner)
	require.ErrorIs(t, err, ErrInvalidCork)
	require.ErrorContains(t, err, "derived root key must be")
}

func firstPartyCaveat(t *testing.T, id []byte, namespace, predicate string, payload proto.Message) *corksv1.Caveat {
	t.Helper()

	anyPayload, err := anypb.New(payload)
	require.NoError(t, err)

	return &corksv1.Caveat{
		CaveatVersion: 1,
		CaveatId:      append([]byte(nil), id...),
		Body: &corksv1.Caveat_FirstParty{
			FirstParty: &corksv1.FirstPartyCaveat{
				Namespace: namespace,
				Predicate: predicate,
				Payload:   anyPayload,
			},
		},
	}
}

func computeSpecTailSignature(t *testing.T, c *corksv1.Cork, masterKey []byte) []byte {
	t.Helper()

	rootKey := deriveLocalRootKey(masterKey, c.GetNonce(), c.GetKeyId())
	tag := hmacSha256(rootKey, []byte(macContext))

	tag = hmacSha256(tag, encodeUint32(c.GetVersion()))
	tag = hmacSha256(tag, c.GetNonce())
	tag = hmacSha256(tag, c.GetKeyId())

	var err error
	tag, err = hashAny(tag, c.GetIssuer())
	require.NoError(t, err)
	tag, err = hashAny(tag, c.GetBearer())
	require.NoError(t, err)
	tag, err = hashAny(tag, c.GetAudience())
	require.NoError(t, err)
	tag, err = hashAny(tag, c.GetClaims())
	require.NoError(t, err)

	for _, caveat := range c.GetCaveats() {
		encoded, marshalErr := deterministicMarshal.Marshal(caveat)
		require.NoError(t, marshalErr)
		tag = hmacSha256(tag, encoded)
	}

	tag = hmacSha256(tag, encodeUint64(c.GetIssuedAt()))
	tag = hmacSha256(tag, encodeUint64(c.GetNotAfter()))

	return tag
}

func encodeUint32(value uint32) []byte {
	buf := make([]byte, uint32FieldSize)
	binary.BigEndian.PutUint32(buf, value)
	return buf
}

func encodeUint64(value uint64) []byte {
	buf := make([]byte, uint64FieldSize)
	binary.BigEndian.PutUint64(buf, value)
	return buf
}

func mustDecodeHex(t *testing.T, s string) []byte {
	t.Helper()

	b, err := hex.DecodeString(s)
	require.NoError(t, err)
	return b
}
