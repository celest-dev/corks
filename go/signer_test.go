package corks

import (
	"context"
	"testing"

	"github.com/stretchr/testify/require"
)

func TestInMemorySignerDeriveCorkRootKey(t *testing.T) {
	t.Helper()

	keyID := []byte("key-1")
	master := []byte{
		0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07,
		0x08, 0x09, 0x0A, 0x0B, 0x0C, 0x0D, 0x0E, 0x0F,
		0x10, 0x11, 0x12, 0x13, 0x14, 0x15, 0x16, 0x17,
		0x18, 0x19, 0x1A, 0x1B, 0x1C, 0x1D, 0x1E, 0x1F,
	}
	nonce := []byte{
		0xFF, 0xEE, 0xDD, 0xCC, 0xBB, 0xAA, 0x99, 0x88,
		0x77, 0x66, 0x55, 0x44, 0x33, 0x22, 0x11, 0x00,
		0x01, 0x23, 0x45, 0x67, 0x89, 0xAB, 0xCD, 0xEF,
	}

	signer := NewInMemorySigner(keyID, master)
	derived, err := signer.DeriveCorkRootKey(context.Background(), nonce, keyID)
	require.NoError(t, err)
	require.Len(t, derived, tagSize)
	require.NotSame(t, &derived[0], &signer.masterKey[0])

	_, err = signer.DeriveCorkRootKey(context.Background(), nonce, []byte("other"))
	require.ErrorIs(t, err, ErrMismatchedKey)
}

func TestMockSignerInvokesCallback(t *testing.T) {
	t.Helper()

	keyID := []byte("mock")
	nonce := make([]byte, nonceSize)

	derived := make([]byte, tagSize)

	var capturedNonce []byte
	mock := NewMockSigner(keyID, func(ctx context.Context, n, k []byte) ([]byte, error) {
		capturedNonce = append([]byte(nil), n...)
		require.NotSame(t, &n[0], &nonce[0])
		require.Equal(t, keyID, k)
		return derived, nil
	})

	result, err := mock.DeriveCorkRootKey(context.Background(), nonce, keyID)
	require.NoError(t, err)
	require.Equal(t, derived, result)
	require.Equal(t, nonce, capturedNonce)
}
