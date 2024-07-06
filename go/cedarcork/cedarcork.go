package cedarcork

import (
	"errors"
	"fmt"

	corks "github.com/celest-dev/corks/go"
	"github.com/celest-dev/corks/go/cedar"
)

type builder struct {
	*corks.Builder
	errors []error
}

// NewBuilder creates a new cork builder with the given ID.
func NewBuilder(id []byte) *builder {
	return &builder{Builder: corks.NewBuilder(id)}
}

// Issuer sets the issuer of the cork.
func (b *builder) Issuer(issuer *cedar.EntityId) *builder {
	b.Builder.Issuer(issuer.Raw())
	return b
}

// Bearer sets the bearer of the cork.
func (b *builder) Bearer(bearer *cedar.EntityId) *builder {
	b.Builder.Bearer(bearer.Raw())
	return b
}

// Audience sets the audience of the cork.
func (b *builder) Audience(audience *cedar.EntityId) *builder {
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
