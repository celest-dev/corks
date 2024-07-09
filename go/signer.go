package corks

import (
	"crypto/hmac"
	"crypto/sha256"
	"hash"
)

type Signer interface {
	// KeyID returns the ID of the signing key.
	KeyID() []byte

	hash.Hash
}

type hmacSigner struct {
	keyID []byte
	hmac  hash.Hash
}

// New creates a new HMAC signer with the given key ID and secret key.
func NewSigner(keyID []byte, secretKey []byte) *hmacSigner {
	return &hmacSigner{
		keyID: keyID,
		hmac:  hmac.New(sha256.New, secretKey),
	}
}

var _ Signer = (*hmacSigner)(nil)

func (s *hmacSigner) KeyID() []byte {
	return s.keyID
}

func (s *hmacSigner) Write(data []byte) (n int, err error) {
	n, err = s.hmac.Write(data)
	if err != nil {
		return
	}
	_ = s.hmac.Sum(nil)
	s.hmac.Reset()
	return
}

func (s *hmacSigner) Sum(b []byte) []byte {
	return s.hmac.Sum(b)
}

func (s *hmacSigner) Reset() {
	s.hmac.Reset()
}

func (s *hmacSigner) Size() int {
	return s.hmac.Size()
}

func (s *hmacSigner) BlockSize() int {
	return s.hmac.BlockSize()
}
