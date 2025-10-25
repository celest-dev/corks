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

func TestBuilderDefaultCaveats(t *testing.T) {
	t.Helper()

	keyID := []byte("default-caveat-key")
	builder := NewBuilder(keyID)
	builder.Issuer(wrapperspb.String("celest::issuer"))
	builder.Bearer(wrapperspb.String("celest::bearer"))

	notAfter := time.Date(2024, time.December, 1, 12, 0, 0, 0, time.UTC)
	builder.DefaultExpiry(notAfter)

	orgScope := &corksv1.OrganizationScope{
		OrganizationId: "org-123",
		ProjectId:      "proj-abc",
		EnvironmentId:  "env-main",
	}
	builder.DefaultOrganizationScope(orgScope)

	actions := []string{"read", "write"}
	builder.DefaultActionScope(actions)

	// Mutate inputs after registration to confirm defensive copying.
	orgScope.OrganizationId = "changed"
	actions[0] = "changed"

	manual := firstPartyCaveat(t,
		mustDecodeHex(t, "00112233445566778899aabbccddeeff"),
		"celest.auth",
		"allow_all",
		wrapperspb.Bool(true),
	)
	builder.Caveat(manual)

	cork, err := builder.Build()
	require.NoError(t, err)
	corkProto := cork.Proto()
	require.Equal(t, uint64(notAfter.UnixMilli()), corkProto.GetNotAfter())

	require.Len(t, corkProto.GetCaveats(), 4)

	expiry := corkProto.GetCaveats()[0]
	require.NotNil(t, expiry.GetFirstParty())
	require.Equal(t, "celest.auth", expiry.GetFirstParty().GetNamespace())
	require.Equal(t, "expiry", expiry.GetFirstParty().GetPredicate())

	expiryPayload := &corksv1.Expiry{}
	require.NoError(t, expiry.GetFirstParty().GetPayload().UnmarshalTo(expiryPayload))
	require.Equal(t, corkProto.GetNotAfter(), expiryPayload.GetNotAfter())

	org := corkProto.GetCaveats()[1]
	require.Equal(t, "organization_scope", org.GetFirstParty().GetPredicate())
	orgPayload := &corksv1.OrganizationScope{}
	require.NoError(t, org.GetFirstParty().GetPayload().UnmarshalTo(orgPayload))
	require.Equal(t, "org-123", orgPayload.GetOrganizationId())
	require.Equal(t, "proj-abc", orgPayload.GetProjectId())
	require.Equal(t, "env-main", orgPayload.GetEnvironmentId())

	action := corkProto.GetCaveats()[2]
	require.Equal(t, "actions", action.GetFirstParty().GetPredicate())
	actionPayload := &corksv1.ActionScope{}
	require.NoError(t, action.GetFirstParty().GetPayload().UnmarshalTo(actionPayload))
	require.Equal(t, []string{"read", "write"}, actionPayload.GetActions())

	added := corkProto.GetCaveats()[3]
	require.True(t, proto.Equal(added, manual))
}

func TestBuilderClearsDefaultCaveats(t *testing.T) {
	t.Helper()

	builder := NewBuilder([]byte("clear-defaults"))
	builder.Issuer(wrapperspb.String("celest::issuer"))
	builder.Bearer(wrapperspb.String("celest::bearer"))

	builder.DefaultExpiry(time.Now())
	builder.DefaultOrganizationScope(&corksv1.OrganizationScope{OrganizationId: "tenant"})
	builder.DefaultActionScope([]string{"read"})

	builder.DefaultExpiry(time.Time{})
	builder.DefaultOrganizationScope(nil)
	builder.DefaultActionScope(nil)

	cork, err := builder.Build()
	require.NoError(t, err)
	require.Empty(t, cork.Proto().GetCaveats())
	require.Zero(t, cork.Proto().GetNotAfter())
}

func TestBuilderAppendFirstPartyCaveatHelpers(t *testing.T) {
	t.Helper()

	builder := NewBuilder([]byte("first-party-helpers"))
	builder.Issuer(wrapperspb.String("celest::issuer"))
	builder.Bearer(wrapperspb.String("celest::bearer"))

	_, err := builder.AppendExpiryCaveat(time.Time{})
	require.ErrorContains(t, err, "expiry")

	expiryAt := time.Date(2025, time.July, 1, 12, 0, 0, 0, time.UTC)
	builder, err = builder.AppendExpiryCaveat(expiryAt)
	require.NoError(t, err)

	scope := &corksv1.OrganizationScope{OrganizationId: "org-123", ProjectId: "proj-abc"}
	builder, err = builder.AppendOrganizationScopeCaveat(scope)
	require.NoError(t, err)

	actions := []string{"read", "write"}
	builder, err = builder.AppendActionScopeCaveat(actions)
	require.NoError(t, err)

	builder, err = builder.AppendIPBindingCaveat([]string{"10.0.0.0/8", "192.168.0.0/16"})
	require.NoError(t, err)

	sessionState := &corksv1.SessionState{SessionId: "sess-123", Version: 3}
	builder, err = builder.AppendSessionStateCaveat(sessionState)
	require.NoError(t, err)

	// Mutating the original inputs should not affect stored payloads.
	scope.OrganizationId = "mutated"
	actions[0] = "mutated"
	sessionState.Version = 9

	_, err = builder.AppendActionScopeCaveat(nil)
	require.ErrorContains(t, err, "action scope")
	_, err = builder.AppendIPBindingCaveat(nil)
	require.ErrorContains(t, err, "ip binding")
	_, err = builder.AppendSessionStateCaveat(&corksv1.SessionState{})
	require.ErrorContains(t, err, "session_id")

	cork, err := builder.Build()
	require.NoError(t, err)
	proto := cork.Proto()
	require.Len(t, proto.GetCaveats(), 5)
	// Expiry
	expiry := proto.GetCaveats()[0]
	require.Equal(t, "expiry", expiry.GetFirstParty().GetPredicate())
	expiryPayload := &corksv1.Expiry{}
	require.NoError(t, expiry.GetFirstParty().GetPayload().UnmarshalTo(expiryPayload))
	require.Equal(t, uint64(expiryAt.UnixMilli()), expiryPayload.GetNotAfter())
	// Organization scope
	org := proto.GetCaveats()[1]
	require.Equal(t, "organization_scope", org.GetFirstParty().GetPredicate())
	orgPayload := &corksv1.OrganizationScope{}
	require.NoError(t, org.GetFirstParty().GetPayload().UnmarshalTo(orgPayload))
	require.Equal(t, "org-123", orgPayload.GetOrganizationId())
	require.Equal(t, "proj-abc", orgPayload.GetProjectId())
	// Actions
	action := proto.GetCaveats()[2]
	require.Equal(t, "actions", action.GetFirstParty().GetPredicate())
	actionPayload := &corksv1.ActionScope{}
	require.NoError(t, action.GetFirstParty().GetPayload().UnmarshalTo(actionPayload))
	require.Equal(t, []string{"read", "write"}, actionPayload.GetActions())
	// IP binding
	ip := proto.GetCaveats()[3]
	require.Equal(t, "ip_binding", ip.GetFirstParty().GetPredicate())
	ipPayload := &corksv1.IpBinding{}
	require.NoError(t, ip.GetFirstParty().GetPayload().UnmarshalTo(ipPayload))
	require.ElementsMatch(t, []string{"10.0.0.0/8", "192.168.0.0/16"}, ipPayload.GetCidrs())
	// Session state
	session := proto.GetCaveats()[4]
	require.Equal(t, "session_state", session.GetFirstParty().GetPredicate())
	sessionPayload := &corksv1.SessionState{}
	require.NoError(t, session.GetFirstParty().GetPayload().UnmarshalTo(sessionPayload))
	require.Equal(t, "sess-123", sessionPayload.GetSessionId())
	require.Equal(t, uint64(3), sessionPayload.GetVersion())
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
