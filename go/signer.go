package corks

import (
	"bytes"
	"context"
	"crypto/hmac"
	"crypto/sha256"
	"errors"
)

const tagSize = sha256.Size

// Signer derives per-cork root keys without exposing master key material.
//
// Implementations may store master keys in-process or delegate derivation to
// remote key managers (e.g., KMS/HSM). Returned byte slices MUST be defensive
// copies.
type Signer interface {
	KeyID() []byte
	DeriveCorkRootKey(ctx context.Context, nonce, keyID []byte) ([]byte, error)
}

// InMemorySigner keeps the master key in memory. Intended for tests and local
// development.
type InMemorySigner struct {
	keyID     []byte
	masterKey []byte
}

// NewSigner is kept for backwards compatibility. Prefer NewInMemorySigner.
func NewSigner(keyID, masterKey []byte) *InMemorySigner {
	return NewInMemorySigner(keyID, masterKey)
}

// NewInMemorySigner constructs an in-memory signer with defensive copies of the
// secret material.
func NewInMemorySigner(keyID, masterKey []byte) *InMemorySigner {
	return &InMemorySigner{
		keyID:     append([]byte(nil), keyID...),
		masterKey: append([]byte(nil), masterKey...),
	}
}

// KeyID returns a copy of the signer key identifier.
func (s *InMemorySigner) KeyID() []byte {
	return append([]byte(nil), s.keyID...)
}

// DeriveCorkRootKey derives the per-cork root key using the in-memory master
// key. Returns ErrMismatchedKey if the caller-supplied key identifier does not
// match the signer's own key.
func (s *InMemorySigner) DeriveCorkRootKey(_ context.Context, nonce, keyID []byte) ([]byte, error) {
	if !bytes.Equal(s.keyID, keyID) {
		return nil, ErrMismatchedKey
	}
	derived := deriveLocalRootKey(s.masterKey, nonce, keyID)
	return append([]byte(nil), derived...), nil
}

// MockSigner delegates root-key derivation to the provided callback. Useful for
// exercising remote KMS integrations in tests without requiring the real
// service.
type MockSigner struct {
	keyID  []byte
	derive func(ctx context.Context, nonce, keyID []byte) ([]byte, error)
}

// NewMockSigner constructs a mock signer that forwards derivation to deriveFn.
func NewMockSigner(keyID []byte, deriveFn func(context.Context, []byte, []byte) ([]byte, error)) *MockSigner {
	return &MockSigner{
		keyID:  append([]byte(nil), keyID...),
		derive: deriveFn,
	}
}

// KeyID returns the key identifier for the mock signer.
func (s *MockSigner) KeyID() []byte {
	return append([]byte(nil), s.keyID...)
}

// DeriveCorkRootKey forwards derivation to the injected callback with defensive
// copies.
func (s *MockSigner) DeriveCorkRootKey(ctx context.Context, nonce, keyID []byte) ([]byte, error) {
	if s.derive == nil {
		return nil, errors.New("mock signer derive function not set")
	}
	return s.derive(ctx, append([]byte(nil), nonce...), append([]byte(nil), keyID...))
}

func deriveLocalRootKey(masterKey, nonce, keyID []byte) []byte {
	h := hmac.New(sha256.New, masterKey)
	h.Write(buildRootKeyMessage(nonce, keyID))
	return h.Sum(nil)
}

func buildRootKeyMessage(nonce, keyID []byte) []byte {
	msg := make([]byte, len(nonce)+len(keyID)+len(rootContext))
	copy(msg, nonce)
	copy(msg[len(nonce):], keyID)
	copy(msg[len(nonce)+len(keyID):], []byte(rootContext))
	return msg
}
