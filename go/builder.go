package corks

import (
	"crypto/rand"
	"crypto/sha256"
	"fmt"
	"strings"

	corksproto "github.com/celest-dev/corks/go/internal/proto"
	"google.golang.org/protobuf/proto"
	"google.golang.org/protobuf/types/known/anypb"
)

// Builder is a builder for corks.
type Builder struct {
	// Id is the unique identifier of the cork.
	id []byte

	// issuer is the entity that issued the cork.
	issuer proto.Message

	// bearer is the entity that the cork is issued to.
	bearer proto.Message

	// audience is the entity that the cork is intended for.
	audience proto.Message

	// claims are the claims made by the cork.
	claims proto.Message

	// caveats are the caveats on the cork's usage and validity.
	caveats []proto.Message
}

// NewBuilder creates a new cork builder.
//
// The ID should be unique and not reused for different corks and must
// identify the key which will be used to sign the cork.
//
// If an ID is not provided, a random ID will be generated.
func NewBuilder(id []byte) *Builder {
	if len(id) == 0 {
		const hashLen = sha256.BlockSize
		var id [hashLen]byte
		n, err := rand.Read(id[:])
		if err != nil || n != hashLen {
			panic("failed to generate random ID")
		}
		return &Builder{id: id[:]}
	}
	return &Builder{id: id}
}

// Issuer sets the issuer of the cork.
func (b *Builder) Issuer(issuer proto.Message) *Builder {
	b.issuer = issuer
	return b
}

// Bearer sets the bearer of the cork.
func (b *Builder) Bearer(bearer proto.Message) *Builder {
	b.bearer = bearer
	return b
}

// Audience sets the audience of the cork.
func (b *Builder) Audience(audience proto.Message) *Builder {
	b.audience = audience
	return b
}

// Claims sets the claims of the cork.
func (b *Builder) Claims(claims proto.Message) *Builder {
	b.claims = claims
	return b
}

// Caveat adds a caveat to the cork.
func (b *Builder) Caveat(caveat proto.Message) *Builder {
	b.caveats = append(b.caveats, caveat)
	return b
}

// Validate validates a cork before signing.
//
// A cork is valid if all required fields are present and all fields are valid.
func (b *Builder) Validate() error {
	missing := make([]string, 0, 3)
	if len(b.id) == 0 {
		missing = append(missing, "ID")
	}
	if b.issuer == nil {
		missing = append(missing, "issuer")
	}
	if b.bearer == nil {
		missing = append(missing, "bearer")
	}
	if len(missing) > 0 {
		return fmt.Errorf("%w: missing %s", ErrInvalidCork, strings.Join(missing, ", "))
	}
	return nil
}

// Build builds and validates the cork for signing.
func (c *Builder) Build() (*Cork, error) {
	err := c.Validate()
	if err != nil {
		return nil, err
	}

	id := make([]byte, len(c.id))
	copy(id, c.id)

	issuer, err := corksproto.MarshalAny(c.issuer)
	if err != nil {
		return nil, err
	}
	bearer, err := corksproto.MarshalAny(c.bearer)
	if err != nil {
		return nil, err
	}
	audience, err := corksproto.MarshalAny(c.audience)
	if err != nil {
		return nil, err
	}
	claims, err := corksproto.MarshalAny(c.claims)
	if err != nil {
		return nil, err
	}
	caveats := make([]*anypb.Any, 0, len(c.caveats))
	for _, caveat := range c.caveats {
		caveat, err := corksproto.MarshalAny(caveat)
		if err != nil {
			return nil, err
		}
		if caveat != nil {
			caveats = append(caveats, caveat)
		}
	}
	return &Cork{
		Id:       id,
		Issuer:   issuer,
		Bearer:   bearer,
		Audience: audience,
		Claims:   claims,
		Caveats:  caveats,
	}, nil
}
