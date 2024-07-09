package corks

import (
	"bytes"
	"crypto/subtle"
	"errors"
	"fmt"

	corksv1 "github.com/celest-dev/corks/go/internal/proto/corks/v1"
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
type Cork corksv1.Cork

// Sign signs the cork using the given signer and returns a copy of the cork with
// the signature.
func (c *Cork) Sign(signer Signer) (*Cork, error) {
	signed := c.clone()
	signature, err := signed.sign(signer)
	if err != nil {
		return nil, err
	}
	signed.Signature = signature
	return signed, nil
}

// Verify verifies the cork using the given sealer.
func (c *Cork) Verify(signer Signer) error {
	expected := c.Signature
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

// Raw returns the underlying proto message.
func (c *Cork) Raw() *corksv1.Cork {
	return (*corksv1.Cork)(c)
}

// clone returns a deep copy of the cork.
func (c *Cork) clone() *Cork {
	copy := proto.Clone((*corksv1.Cork)(c)).(*corksv1.Cork)
	return (*Cork)(copy)
}

// sign signs the cork using the given signer and returns the signature.
func (c *Cork) sign(signer Signer) ([]byte, error) {
	if !bytes.Equal(signer.KeyID(), c.Id) {
		return nil, ErrMismatchedKey
	}

	defer signer.Reset()
	signer.Reset()

	_, err := signer.Write(c.Id)
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

	err = sign(c.Issuer)
	if err != nil {
		return nil, err
	}
	err = sign(c.Bearer)
	if err != nil {
		return nil, err
	}
	err = sign(c.Audience)
	if err != nil {
		return nil, err
	}
	err = sign(c.Claims)
	if err != nil {
		return nil, err
	}
	for _, caveat := range c.Caveats {
		err = sign(caveat)
		if err != nil {
			return nil, err
		}
	}

	return signer.Sum(nil), nil
}
