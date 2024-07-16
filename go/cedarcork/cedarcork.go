package cedarcork

import (
	"errors"
	"fmt"

	corks "github.com/celest-dev/corks/go"
	"github.com/celest-dev/corks/go/cedar"
	cedarv3 "github.com/celest-dev/corks/go/internal/proto/cedar/v3"
)

type Cork struct {
	*corks.Cork
}

func (c *Cork) Issuer() *cedar.EntityID {
	if c == nil {
		return nil
	}
	issuer := c.Cork.Issuer()
	if issuer == nil {
		return nil
	}
	entityId := new(cedarv3.EntityId)
	err := issuer.UnmarshalTo(entityId)
	if err != nil {
		return nil
	}
	return (*cedar.EntityID)(entityId)
}

func (c *Cork) Bearer() *cedar.EntityID {
	if c == nil {
		return nil
	}
	bearer := c.Cork.Bearer()
	if bearer == nil {
		return nil
	}
	entityId := new(cedarv3.EntityId)
	err := bearer.UnmarshalTo(entityId)
	if err != nil {
		return nil
	}
	return (*cedar.EntityID)(entityId)
}

func (c *Cork) Audience() *cedar.EntityID {
	if c == nil {
		return nil
	}
	audience := c.Cork.Audience()
	if audience == nil {
		return nil
	}
	entityId := new(cedarv3.EntityId)
	err := audience.UnmarshalTo(entityId)
	if err != nil {
		return nil
	}
	return (*cedar.EntityID)(entityId)
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

func (c *Cork) Caveats() []*cedarv3.Policy {
	if c == nil {
		return nil
	}
	caveats := c.Cork.Caveats()
	policies := make([]*cedarv3.Policy, len(caveats))
	for i, caveat := range caveats {
		policy := new(cedarv3.Policy)
		err := caveat.UnmarshalTo(policy)
		if err != nil {
			return nil
		}
		policies[i] = policy
	}
	return policies
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
func (b *builder) Issuer(issuer *cedar.EntityID) *builder {
	b.Builder.Issuer(issuer.Raw())
	return b
}

// Bearer sets the bearer of the cork.
func (b *builder) Bearer(bearer *cedar.EntityID) *builder {
	b.Builder.Bearer(bearer.Raw())
	return b
}

// Audience sets the audience of the cork.
func (b *builder) Audience(audience *cedar.EntityID) *builder {
	b.Builder.Audience(audience.Raw())
	return b
}

// Claims sets the claims of the cork.
func (b *builder) Claims(claims *cedar.Entity) *builder {
	b.Builder.Claims(claims.Raw())
	return b
}

// Caveat adds a caveat to the cork.
func (b *builder) Caveat(caveat *cedar.Policy) *builder {
	if caveat.Effect != cedar.EffectForbid {
		b.errors = append(b.errors, errors.New("only forbid policies are allowed"))
	} else {
		b.Builder.Caveat(caveat.Raw())
	}
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
