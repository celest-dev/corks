package cedarcork

import (
	"crypto/rand"
	"errors"
	"fmt"
	"time"

	corks "github.com/celest-dev/corks/go"
	"github.com/celest-dev/corks/go/cedar"
	cedarexpr "github.com/celest-dev/corks/go/cedar/expr"
	cedarv4 "github.com/celest-dev/corks/go/proto/cedar/v4"
	corksv1 "github.com/celest-dev/corks/go/proto/celest/corks/v1"
	"google.golang.org/protobuf/types/known/anypb"
)

const (
	cedarNamespace              = "celest.cedar"
	cedarPredicate              = "expr"
	defaultCaveatVersion uint32 = 1
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
	entityId := new(cedarv4.EntityUid)
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
	entityId := new(cedarv4.EntityUid)
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
	entityId := new(cedarv4.EntityUid)
	err := audience.UnmarshalTo(entityId)
	if err != nil {
		return nil
	}
	return (*cedar.EntityUid)(entityId)
}

func (c *Cork) Claims() *cedarv4.Entity {
	if c == nil {
		return nil
	}
	claims := c.Cork.Claims()
	if claims == nil {
		return nil
	}
	entity := new(cedarv4.Entity)
	err := claims.UnmarshalTo(entity)
	if err != nil {
		return nil
	}
	return entity
}

func (c *Cork) Caveats() []*cedarv4.Expr {
	if c == nil {
		return nil
	}
	var expressions []*cedarv4.Expr
	for _, caveat := range c.Cork.Caveats() {
		first := caveat.GetFirstParty()
		if first == nil || first.Namespace != cedarNamespace || first.Predicate != cedarPredicate {
			continue
		}
		if first.Payload == nil {
			continue
		}
		expression := new(cedarv4.Expr)
		if err := first.Payload.UnmarshalTo(expression); err != nil {
			return nil
		}
		expressions = append(expressions, expression)
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

// NewBuilder creates a new cork builder with the given key identifier.
func NewBuilder(keyID []byte) *builder {
	return &builder{Builder: corks.NewBuilder(keyID)}
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
	payload, err := anypb.New(caveat.Proto())
	if err != nil {
		b.errors = append(b.errors, err)
		return b
	}
	id := make([]byte, 16)
	if _, err := rand.Read(id); err != nil {
		b.errors = append(b.errors, err)
		return b
	}
	protoCaveat := &corksv1.Caveat{
		CaveatVersion: defaultCaveatVersion,
		CaveatId:      id,
		Body: &corksv1.Caveat_FirstParty{
			FirstParty: &corksv1.FirstPartyCaveat{
				Namespace: cedarNamespace,
				Predicate: cedarPredicate,
				Payload:   payload,
			},
		},
	}
	b.Builder.Caveat(protoCaveat)
	return b
}

// NotAfter sets the expiry on the underlying cork builder.
func (b *builder) NotAfter(notAfter time.Time) *builder {
	b.Builder.NotAfter(notAfter)
	return b
}

// IssuedAt allows tests to override the issuance timestamp.
func (b *builder) IssuedAt(issuedAt time.Time) *builder {
	b.Builder.IssuedAt(issuedAt)
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
