package corks

import (
	"bytes"
	"crypto/subtle"
	"errors"
	"fmt"

	corksv1 "github.com/celest-dev/corks/go/proto/corks/v1"
	"google.golang.org/protobuf/proto"
	"google.golang.org/protobuf/types/known/anypb"
)

var (
	// ErrInvalidCork is returned when a cork is invalid or corrupted and cannot
	// be processed.
	ErrInvalidCork = errors.New("invalid cork")

	// ErrInvalidSignature is returned when a cork's signature is invalid.
	ErrInvalidSignature = errors.New("invalid signature")

	// ErrMissingSignature is returned when a cork is missing a signature.
	ErrMissingSignature = fmt.Errorf("%w: missing signature", ErrInvalidCork)

	// ErrMismatchedKey is returned when a signer's key ID does not match the cork ID.
	ErrMismatchedKey = errors.New("key ID does not match cork ID")
)

// A cork is a bearer token that can be used to make claims about an entity for the purpose
// of authorization and authentication.
type Cork struct {
	proto *corksv1.Cork
}

// ID returns the ID of the cork.
func (c *Cork) ID() []byte {
	return c.proto.Id
}

// Issuer returns the issuer of the cork.
func (c *Cork) Issuer() *anypb.Any {
	return c.proto.Issuer
}

// Bearer returns the bearer of the cork.
func (c *Cork) Bearer() *anypb.Any {
	return c.proto.Bearer
}

// Audience returns the audience of the cork.
func (c *Cork) Audience() *anypb.Any {
	return c.proto.Audience
}

// Claims returns the claims of the cork.
func (c *Cork) Claims() *anypb.Any {
	return c.proto.Claims
}

// Caveats returns the caveats of the cork.
func (c *Cork) Caveats() []*anypb.Any {
	return c.proto.Caveats
}

// Signature returns the signature of the cork.
func (c *Cork) Signature() []byte {
	return c.proto.Signature
}

// Sign signs the cork using the given signer and returns a copy of the cork with
// the signature.
func (c *Cork) Sign(signer Signer) (*Cork, error) {
	signed := c.clone()
	signature, err := signed.sign(signer)
	if err != nil {
		return nil, err
	}
	signed.proto.Signature = signature
	return signed, nil
}

// Verify verifies the cork using the given sealer.
func (c *Cork) Verify(signer Signer) error {
	expected := c.proto.Signature
	if len(expected) == 0 {
		return ErrMissingSignature
	}
	actual, err := c.sign(signer)
	if err != nil {
		return err
	}
	if subtle.ConstantTimeCompare(expected, actual) == 0 {
		return fmt.Errorf("%w: expected \"%x\", got \"%x\"", ErrInvalidSignature, expected, actual)
	}
	return nil
}

// Proto returns the underlying proto message.
func (c *Cork) Proto() *corksv1.Cork {
	return c.proto
}

// Rebuild returns a new builder with the cork's data.
func (c *Cork) Rebuild() *Builder {
	b := &Builder{id: c.proto.Id}
	b.
		Issuer(c.proto.Issuer).
		Bearer(c.proto.Bearer).
		Audience(c.proto.Audience).
		Claims(c.proto.Claims)
	for _, caveat := range c.proto.Caveats {
		b.Caveat(caveat)
	}
	return b
}

// clone returns a deep copy of the cork.
func (c *Cork) clone() *Cork {
	copy := proto.Clone(c.proto).(*corksv1.Cork)
	return &Cork{copy}
}

// sign signs the cork using the given signer and returns the signature.
func (c *Cork) sign(signer Signer) ([]byte, error) {
	if !bytes.Equal(signer.KeyID(), c.proto.Id) {
		return nil, ErrMismatchedKey
	}

	defer signer.Reset()
	signer.Reset()

	_, err := signer.Write(c.proto.Id)
	if err != nil {
		return nil, err
	}

	sign := func(m *anypb.Any) (err error) {
		if m == nil {
			return nil
		}
		block := bytes.NewBuffer([]byte(m.TypeUrl))
		block.Write(m.Value)
		_, err = signer.Write(block.Bytes())
		return
	}

	err = sign(c.proto.Issuer)
	if err != nil {
		return nil, err
	}
	err = sign(c.proto.Bearer)
	if err != nil {
		return nil, err
	}
	err = sign(c.proto.Audience)
	if err != nil {
		return nil, err
	}
	err = sign(c.proto.Claims)
	if err != nil {
		return nil, err
	}
	for _, caveat := range c.proto.Caveats {
		err = sign(caveat)
		if err != nil {
			return nil, err
		}
	}

	return signer.Sum(nil), nil
}
