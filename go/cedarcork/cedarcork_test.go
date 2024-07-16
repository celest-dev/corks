package cedarcork_test

import (
	"crypto/rand"
	"errors"
	"testing"

	corks "github.com/celest-dev/corks/go"
	"github.com/celest-dev/corks/go/cedar"
	"github.com/celest-dev/corks/go/cedarcork"
	"github.com/google/go-cmp/cmp"
	"github.com/stretchr/testify/require"
	"google.golang.org/protobuf/testing/protocmp"
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

	issuer := &cedar.EntityID{
		Type: "Organization",
		Id:   "acme-corp",
	}
	bearer := &cedar.EntityID{
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
					UID: bearer,
					Attrs: map[string]cedar.Value{
						"email": cedar.String("test@example.com"),
					},
				}
				caveat := &cedar.Policy{
					Effect: cedar.EffectForbid,
				}
				return cedarcork.NewBuilder(aId).
					Issuer(issuer).
					Bearer(bearer).
					Audience(audience).
					Claims(claims).
					Caveat(caveat).
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
			t.Run("sign/verify", func(t *testing.T) {
				require.ErrorIs(t, cork.Verify(signer), corks.ErrMissingSignature)

				signed, err := cork.Sign(signer)
				require.NoError(t, err)
				require.NoError(t, signed.Verify(signer))
				require.NoError(t, signed.Verify(corks.NewSigner(aId, aKey)))

				bSigner := corks.NewSigner(bId, bKey)
				require.ErrorIs(t, signed.Verify(bSigner), corks.ErrMismatchedKey)

				fakeASigner := corks.NewSigner(aId, bKey)
				require.ErrorIs(t, signed.Verify(fakeASigner), corks.ErrInvalidSignature)
			})

			t.Run("encode/decode", func(t *testing.T) {
				cork, err := cork.Sign(signer)
				require.NoError(t, err)

				encoded, err := cork.Encode()
				require.NoError(t, err)

				decoded, err := corks.Decode(encoded)
				require.NoError(t, err)

				if diff := cmp.Diff(decoded.Raw(), cork.Raw(), protocmp.Transform()); diff != "" {
					t.Errorf("decoded != encoded: %s", diff)
				}

				require.NoError(t, decoded.Verify(signer))
			})
		})
	}
}
