package cedarcork_test

import (
	"context"
	"crypto/rand"
	"errors"
	"testing"
	"time"

	corks "github.com/celest-dev/corks/go"
	"github.com/celest-dev/corks/go/cedar"
	cedarexpr "github.com/celest-dev/corks/go/cedar/expr"
	"github.com/celest-dev/corks/go/cedarcork"
	cedarv3 "github.com/celest-dev/corks/go/proto/cedar/v3"
	"github.com/google/go-cmp/cmp"
	"github.com/stretchr/testify/require"
	"google.golang.org/protobuf/testing/protocmp"
	"google.golang.org/protobuf/types/known/wrapperspb"
)

func newSecretKey() []byte {
	key := make([]byte, 32)
	_, err := rand.Read(key)
	if err != nil {
		panic(err)
	}
	return key
}

func TestBuildAndVerify(t *testing.T) {
	aId := []byte("a")
	aKey := newSecretKey()

	bId := []byte("b")
	bKey := newSecretKey()

	issuer := &cedar.EntityUid{
		Type: "Organization",
		Id:   "acme-corp",
	}
	bearer := &cedar.EntityUid{
		Type: "User",
		Id:   "alice",
	}

	tt := []struct {
		name        string
		build       func() (*cedarcork.Cork, error)
		expectError error
	}{
		{
			name: "empty",
			build: func() (*cedarcork.Cork, error) {
				return cedarcork.NewBuilder(aId).Build()
			},
			expectError: corks.ErrInvalidCork,
		},
		{
			name: "missing issuer",
			build: func() (*cedarcork.Cork, error) {
				return cedarcork.NewBuilder(aId).
					Bearer(bearer).
					Build()
			},
			expectError: corks.ErrInvalidCork,
		},
		{
			name: "missing bearer",
			build: func() (*cedarcork.Cork, error) {
				return cedarcork.NewBuilder(aId).
					Issuer(issuer).
					Build()
			},
			expectError: corks.ErrInvalidCork,
		},
		{
			name: "valid minimal",
			build: func() (*cedarcork.Cork, error) {
				return cedarcork.NewBuilder(aId).
					Bearer(bearer).
					Issuer(issuer).
					Build()
			},
		},
		{
			name: "valid full",
			build: func() (*cedarcork.Cork, error) {
				audience := issuer
				claims := &cedar.Entity{
					Uid: bearer.Proto(),
					Attributes: map[string]*cedarv3.Value{
						"email": {
							Value: &cedarv3.Value_String_{
								String_: wrapperspb.String("test@example.com"),
							},
						},
					},
				}
				caveat := &cedarexpr.Expr{
					Expr: &cedarv3.Expr_Value{
						Value: &cedarv3.ExprValue{
							Value: &cedarv3.Value{
								Value: &cedarv3.Value_Bool{
									Bool: wrapperspb.Bool(true),
								},
							},
						},
					},
				}
				return cedarcork.NewBuilder(aId).
					Issuer(issuer).
					Bearer(bearer).
					Audience(audience).
					Claims(claims).
					Caveat(caveat).
					NotAfter(time.Now().Add(time.Hour)).
					Build()
			},
		},
	}

	for _, tc := range tt {
		t.Run(tc.name, func(t *testing.T) {
			cork, err := tc.build()
			if tc.expectError != nil {
				require.Error(t, err)
				require.True(t, errors.Is(err, tc.expectError))
				return
			}
			require.NoError(t, err)

			signer := corks.NewSigner(aId, aKey)
			ctx := context.Background()
			t.Run("sign/verify", func(t *testing.T) {
				require.ErrorIs(t, cork.Verify(ctx, signer), corks.ErrMissingSignature)

				signed, err := cork.Sign(ctx, signer)
				require.NoError(t, err)
				require.NotEmpty(t, signed.TailSignature())
				require.NoError(t, signed.Verify(ctx, signer))
				require.NoError(t, signed.Verify(ctx, corks.NewSigner(aId, aKey)))

				bSigner := corks.NewSigner(bId, bKey)
				require.ErrorIs(t, signed.Verify(ctx, bSigner), corks.ErrMismatchedKey)

				fakeASigner := corks.NewSigner(aId, bKey)
				require.ErrorIs(t, signed.Verify(ctx, fakeASigner), corks.ErrInvalidSignature)
			})

			t.Run("encode/decode", func(t *testing.T) {
				signed, err := cork.Sign(ctx, signer)
				require.NoError(t, err)

				encoded, err := signed.Encode()
				require.NoError(t, err)

				decoded, err := corks.Decode(encoded)
				require.NoError(t, err)

				if diff := cmp.Diff(decoded.Proto(), signed.Proto(), protocmp.Transform()); diff != "" {
					t.Errorf("decoded != encoded: %s", diff)
				}

				require.NoError(t, decoded.Verify(ctx, signer))
			})
		})
	}
}
