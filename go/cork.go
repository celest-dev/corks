package corks

import (
	"bytes"
	"context"
	"crypto/hmac"
	"crypto/sha256"
	"crypto/subtle"
	"encoding/binary"
	"errors"
	"fmt"
	"time"

	corksv1 "github.com/celest-dev/corks/go/proto/celest/corks/v1"
	"google.golang.org/protobuf/proto"
	"google.golang.org/protobuf/types/known/anypb"
)

var (
	// ErrInvalidCork is returned when a cork is invalid or corrupted and cannot
	// be processed.
	ErrInvalidCork = errors.New("invalid cork")

	// ErrInvalidSignature is returned when a cork's signature is invalid.
	ErrInvalidSignature = errors.New("invalid signature")

	// ErrMissingSignature is returned when a cork is missing a tail signature.
	ErrMissingSignature = fmt.Errorf("%w: missing tail signature", ErrInvalidCork)

	// ErrMismatchedKey is returned when a signer's key ID does not match the cork key ID.
	ErrMismatchedKey = errors.New("key ID does not match cork")
)

const (
	macContext      = "celest:cork:v1"
	rootContext     = "celest/cork/v1"
	uint32FieldSize = 4
	uint64FieldSize = 8
)

var deterministicMarshal = proto.MarshalOptions{Deterministic: true}

// A cork is a bearer token that can be used to make claims about an entity for
// the purpose of authorization and authentication.
type Cork struct {
	proto *corksv1.Cork
}

// Version returns the protocol version for the cork.
func (c *Cork) Version() uint32 {
	return c.proto.GetVersion()
}

// Nonce returns the nonce associated with this cork.
func (c *Cork) Nonce() []byte {
	return c.proto.GetNonce()
}

// KeyID returns the signing key identifier.
func (c *Cork) KeyID() []byte {
	return c.proto.GetKeyId()
}

// Issuer returns the issuer of the cork.
func (c *Cork) Issuer() *anypb.Any {
	return c.proto.GetIssuer()
}

// Bearer returns the bearer of the cork.
func (c *Cork) Bearer() *anypb.Any {
	return c.proto.GetBearer()
}

// Audience returns the audience of the cork.
func (c *Cork) Audience() *anypb.Any {
	return c.proto.GetAudience()
}

// Claims returns the claims of the cork.
func (c *Cork) Claims() *anypb.Any {
	return c.proto.GetClaims()
}

// Caveats returns the caveats of the cork.
func (c *Cork) Caveats() []*corksv1.Caveat {
	return c.proto.GetCaveats()
}

// TailSignature returns the final chained MAC tag for the cork.
func (c *Cork) TailSignature() []byte {
	return c.proto.GetTailSignature()
}

// IssuedAt returns the issuance timestamp in milliseconds since the epoch.
func (c *Cork) IssuedAt() uint64 {
	return c.proto.GetIssuedAt()
}

// NotAfter returns the expiry timestamp in milliseconds since the epoch, if set.
func (c *Cork) NotAfter() uint64 {
	return c.proto.GetNotAfter()
}

// Sign signs the cork using the given signer and returns a copy of the cork with
// the tail signature populated.
func (c *Cork) Sign(ctx context.Context, signer Signer) (*Cork, error) {
	signed := c.clone()
	signature, err := computeTailSignature(ctx, signed.proto, signer)
	if err != nil {
		return nil, err
	}
	signed.proto.TailSignature = signature
	return signed, nil
}

// Verify recomputes the tail signature with the provided signer.
func (c *Cork) Verify(ctx context.Context, signer Signer) error {
	expected := c.proto.GetTailSignature()
	if len(expected) == 0 {
		return ErrMissingSignature
	}
	actual, err := computeTailSignature(ctx, c.proto, signer)
	if err != nil {
		return err
	}
	if subtle.ConstantTimeCompare(expected, actual) == 0 {
		return fmt.Errorf("%w: expected %x, got %x", ErrInvalidSignature, expected, actual)
	}
	return nil
}

// Proto returns the underlying proto message.
func (c *Cork) Proto() *corksv1.Cork {
	return c.proto
}

// Rebuild returns a new builder with the cork's metadata.
func (c *Cork) Rebuild() *Builder {
	b := NewBuilder(c.proto.GetKeyId()).
		Version(c.proto.GetVersion()).
		Nonce(c.proto.GetNonce())

	if issuer := c.proto.GetIssuer(); issuer != nil {
		b.Issuer(issuer)
	}
	if bearer := c.proto.GetBearer(); bearer != nil {
		b.Bearer(bearer)
	}
	if audience := c.proto.GetAudience(); audience != nil {
		b.Audience(audience)
	}
	if claims := c.proto.GetClaims(); claims != nil {
		b.Claims(claims)
	}

	b.IssuedAt(time.UnixMilli(int64(c.proto.GetIssuedAt())))
	if c.proto.GetNotAfter() != 0 {
		b.NotAfter(time.UnixMilli(int64(c.proto.GetNotAfter())))
	}
	for _, caveat := range c.proto.GetCaveats() {
		b.Caveat(caveat)
	}
	return b
}

// clone returns a deep copy of the cork.
func (c *Cork) clone() *Cork {
	copy := proto.Clone(c.proto).(*corksv1.Cork)
	return &Cork{copy}
}

func computeTailSignature(ctx context.Context, c *corksv1.Cork, signer Signer) ([]byte, error) {
	if signer == nil {
		return nil, fmt.Errorf("%w: signer is nil", ErrInvalidCork)
	}
	if c.GetVersion() == 0 {
		return nil, fmt.Errorf("%w: cork version not set", ErrInvalidCork)
	}
	if len(c.GetNonce()) != nonceSize {
		return nil, fmt.Errorf("%w: nonce must be %d bytes", ErrInvalidCork, nonceSize)
	}
	if len(c.GetKeyId()) == 0 {
		return nil, fmt.Errorf("%w: key_id missing", ErrInvalidCork)
	}
	signerKeyID := signer.KeyID()
	if !bytes.Equal(c.GetKeyId(), signerKeyID) {
		return nil, ErrMismatchedKey
	}
	rootKey, err := signer.DeriveCorkRootKey(ctx, c.GetNonce(), c.GetKeyId())
	if err != nil {
		return nil, err
	}
	if len(rootKey) != tagSize {
		return nil, fmt.Errorf("%w: derived root key must be %d bytes", ErrInvalidCork, tagSize)
	}
	tag := hmacSha256(rootKey, []byte(macContext))

	// Version
	buf := make([]byte, uint32FieldSize)
	binary.BigEndian.PutUint32(buf, c.GetVersion())
	tag = hmacSha256(tag, buf)

	// Nonce and key identifier
	tag = hmacSha256(tag, c.GetNonce())
	tag = hmacSha256(tag, c.GetKeyId())

	// Issuer, bearer, audience, claims
	tag, err = hashAny(tag, c.GetIssuer())
	if err != nil {
		return nil, err
	}
	tag, err = hashAny(tag, c.GetBearer())
	if err != nil {
		return nil, err
	}
	tag, err = hashAny(tag, c.GetAudience())
	if err != nil {
		return nil, err
	}
	tag, err = hashAny(tag, c.GetClaims())
	if err != nil {
		return nil, err
	}

	// Caveats
	for _, caveat := range c.GetCaveats() {
		encoded, err := deterministicMarshal.Marshal(caveat)
		if err != nil {
			return nil, fmt.Errorf("%w: failed to marshal caveat: %w", ErrInvalidCork, err)
		}
		tag = hmacSha256(tag, encoded)
	}

	// Issued/expiry metadata
	buf = make([]byte, uint64FieldSize)
	binary.BigEndian.PutUint64(buf, c.GetIssuedAt())
	tag = hmacSha256(tag, buf)
	binary.BigEndian.PutUint64(buf, c.GetNotAfter())
	tag = hmacSha256(tag, buf)

	return tag, nil
}

func hmacSha256(key, data []byte) []byte {
	h := hmac.New(sha256.New, key)
	h.Write(data)
	return h.Sum(nil)
}

func hashAny(tag []byte, msg *anypb.Any) ([]byte, error) {
	if msg == nil {
		return tag, nil
	}
	encoded, err := deterministicMarshal.Marshal(msg)
	if err != nil {
		return nil, fmt.Errorf("%w: failed to marshal any: %w", ErrInvalidCork, err)
	}
	return hmacSha256(tag, encoded), nil
}
