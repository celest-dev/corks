package cedarcork

import (
	"errors"
	"fmt"

	corks "github.com/celest-dev/corks/go"
	"github.com/celest-dev/corks/go/cedar"
	cedarexpr "github.com/celest-dev/corks/go/cedar/expr"
	cedarv3 "github.com/celest-dev/corks/go/proto/cedar/v3"
)

type Cork struct {
	*corks.Cork
}

func (c *Cork) Issuer() *cedar.EntityUid {
	if c == nil {
		return nil
	}
	issuer := c.Cork.Issuer()
	if issuer == nil {
		return nil
	}
	entityId := new(cedarv3.EntityUid)
	err := issuer.UnmarshalTo(entityId)
	if err != nil {
		return nil
	}
	return (*cedar.EntityUid)(entityId)
}

func (c *Cork) Bearer() *cedar.EntityUid {
	if c == nil {
		return nil
	}
	bearer := c.Cork.Bearer()
	if bearer == nil {
		return nil
	}
	entityId := new(cedarv3.EntityUid)
	err := bearer.UnmarshalTo(entityId)
	if err != nil {
		return nil
	}
	return (*cedar.EntityUid)(entityId)
}

func (c *Cork) Audience() *cedar.EntityUid {
	if c == nil {
		return nil
	}
	audience := c.Cork.Audience()
	if audience == nil {
		return nil
	}
	entityId := new(cedarv3.EntityUid)
	err := audience.UnmarshalTo(entityId)
	if err != nil {
		return nil
	}
	return (*cedar.EntityUid)(entityId)
}

func (c *Cork) Claims() *cedarv3.Entity {
	if c == nil {
		return nil
	}
	claims := c.Cork.Claims()
	if claims == nil {
		return nil
	}
	entity := new(cedarv3.Entity)
	err := claims.UnmarshalTo(entity)
	if err != nil {
		return nil
	}
	return entity
}

func (c *Cork) Caveats() []*cedarv3.Expr {
	if c == nil {
		return nil
	}
	caveats := c.Cork.Caveats()
	expressions := make([]*cedarv3.Expr, len(caveats))
	for i, caveat := range caveats {
		expression := new(cedarv3.Expr)
		err := caveat.UnmarshalTo(expression)
		if err != nil {
			return nil
		}
		expressions[i] = expression
	}
	return expressions
}

// Rebuild returns a new builder with the cork's data.
func (c *Cork) Rebuild() *builder {
	b := &builder{Builder: c.Cork.Rebuild()}
	return b
}

type builder struct {
	*corks.Builder
	errors []error
}

// NewBuilder creates a new cork builder with the given ID.
func NewBuilder(id []byte) *builder {
	return &builder{Builder: corks.NewBuilder(id)}
}

// Issuer sets the issuer of the cork.
func (b *builder) Issuer(issuer *cedar.EntityUid) *builder {
	b.Builder.Issuer(issuer.Proto())
	return b
}

// Bearer sets the bearer of the cork.
func (b *builder) Bearer(bearer *cedar.EntityUid) *builder {
	b.Builder.Bearer(bearer.Proto())
	return b
}

// Audience sets the audience of the cork.
func (b *builder) Audience(audience *cedar.EntityUid) *builder {
	b.Builder.Audience(audience.Proto())
	return b
}

// Claims sets the claims of the cork.
func (b *builder) Claims(claims *cedar.Entity) *builder {
	b.Builder.Claims(claims.Proto())
	return b
}

// Caveat adds a caveat to the cork.
func (b *builder) Caveat(caveat *cedarexpr.Expr) *builder {
	if caveat == nil {
		b.errors = append(b.errors, fmt.Errorf("%w: caveat is nil", corks.ErrInvalidCork))
		return b
	}
	b.Builder.Caveat(caveat.Proto())
	return b
}

// Validate validates a cork before signing.
//
// A cork is valid if all required fields are present and all fields are valid.
func (b *builder) Validate() error {
	if err := b.Builder.Validate(); err != nil {
		return err
	}
	if len(b.errors) > 0 {
		return fmt.Errorf("%w: %v", corks.ErrInvalidCork, errors.Join(b.errors...))
	}
	return nil
}

// Build builds and validates the cork for signing.
func (b *builder) Build() (*Cork, error) {
	cork, err := b.Builder.Build()
	if err != nil {
		return nil, err
	}
	return &Cork{cork}, nil
}
