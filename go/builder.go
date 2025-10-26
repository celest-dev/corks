package corks

import (
	"crypto/rand"
	"fmt"
	"strings"
	"time"

	corksproto "github.com/celest-dev/corks/go/proto"
	corksv1 "github.com/celest-dev/corks/go/proto/celest/corks/v1"
	"google.golang.org/protobuf/proto"
)

const (
	// currentVersion identifies the protocol version implemented by this package.
	currentVersion uint32 = 1

	// nonceSize is the number of random bytes attached to each cork.
	nonceSize = 24
)

// Builder constructs unsigned corks that conform to the v1 specification.
//
// The builder owns a working copy of the cork metadata prior to signing. The
// output of Build never carries a tail signature; callers must invoke Sign on
// the resulting cork before encoding or distributing it.
type Builder struct {
	version                  uint32
	nonce                    []byte
	keyID                    []byte
	issuer                   proto.Message
	bearer                   proto.Message
	audience                 proto.Message
	claims                   proto.Message
	caveats                  []*corksv1.Caveat
	issuedAt                 uint64
	notAfter                 *uint64
	defaultExpiry            *corksv1.Expiry
	defaultOrganizationScope *corksv1.OrganizationScope
	defaultActionScope       *corksv1.ActionScope
}

// NewBuilder initialises a builder with a generated nonce and the supplied key
// identifier. The issued-at timestamp defaults to the current time so that
// freshly minted corks are immediately valid.
func NewBuilder(keyID []byte) *Builder {
	b := &Builder{
		version:  currentVersion,
		keyID:    append([]byte(nil), keyID...),
		issuedAt: uint64(time.Now().UnixMilli()),
	}
	if len(b.keyID) == 0 {
		b.keyID = nil
	}
	b.nonce = make([]byte, nonceSize)
	if _, err := rand.Read(b.nonce); err != nil {
		panic("failed to generate cork nonce")
	}
	return b
}

// Version overrides the cork protocol version.
func (b *Builder) Version(version uint32) *Builder {
	b.version = version
	return b
}

// Nonce overrides the randomly generated nonce. The caller is responsible for
// ensuring uniqueness.
func (b *Builder) Nonce(nonce []byte) *Builder {
	b.nonce = append([]byte(nil), nonce...)
	return b
}

// KeyID overrides the signing key identifier associated with the cork.
func (b *Builder) KeyID(keyID []byte) *Builder {
	b.keyID = append([]byte(nil), keyID...)
	return b
}

// Issuer sets the issuer entity payload.
func (b *Builder) Issuer(issuer proto.Message) *Builder {
	b.issuer = issuer
	return b
}

// Bearer sets the principal that will present the cork.
func (b *Builder) Bearer(bearer proto.Message) *Builder {
	b.bearer = bearer
	return b
}

// Audience sets the intended recipient of the cork.
func (b *Builder) Audience(audience proto.Message) *Builder {
	b.audience = audience
	return b
}

// Claims sets structured claims carried by the cork.
func (b *Builder) Claims(claims proto.Message) *Builder {
	b.claims = claims
	return b
}

// Caveat appends a fully constructed caveat to the cork.
func (b *Builder) Caveat(caveat *corksv1.Caveat) *Builder {
	if caveat != nil {
		b.caveats = append(b.caveats, proto.Clone(caveat).(*corksv1.Caveat))
	}
	return b
}

// IssuedAt records the issuance timestamp for the cork.
func (b *Builder) IssuedAt(issuedAt time.Time) *Builder {
	b.issuedAt = uint64(issuedAt.UnixMilli())
	return b
}

// NotAfter sets the expiry timestamp for the cork. Passing the zero time
// clears any previously configured expiry.
func (b *Builder) NotAfter(notAfter time.Time) *Builder {
	if notAfter.IsZero() {
		b.notAfter = nil
		return b
	}
	value := uint64(notAfter.UnixMilli())
	b.notAfter = &value
	return b
}

// DefaultExpiry adds the standard Celest expiry caveat and synchronizes the
// cork metadata with the provided timestamp.
func (b *Builder) DefaultExpiry(notAfter time.Time) *Builder {
	if notAfter.IsZero() {
		b.notAfter = nil
		b.defaultExpiry = nil
		return b
	}

	value := uint64(notAfter.UTC().UnixMilli())
	b.notAfter = &value
	b.defaultExpiry = &corksv1.Expiry{NotAfter: value}
	return b
}

// DefaultOrganizationScope adds the default organization scope caveat. Passing
// nil clears the previously configured scope.
func (b *Builder) DefaultOrganizationScope(scope *corksv1.OrganizationScope) *Builder {
	if scope == nil {
		b.defaultOrganizationScope = nil
		return b
	}
	b.defaultOrganizationScope = proto.Clone(scope).(*corksv1.OrganizationScope)
	return b
}

// DefaultActionScope adds the default action scope caveat. An empty slice
// clears the previously configured scope.
func (b *Builder) DefaultActionScope(actions []string) *Builder {
	if len(actions) == 0 {
		b.defaultActionScope = nil
		return b
	}
	cloned := append([]string(nil), actions...)
	b.defaultActionScope = &corksv1.ActionScope{Actions: cloned}
	return b
}

func (b *Builder) appendFirstPartyCaveat(predicate string, payload proto.Message) (*Builder, error) {
	cav, err := buildFirstPartyCaveat(defaultCaveatNamespace, predicate, payload)
	if err != nil {
		return nil, err
	}
	b.caveats = append(b.caveats, cav)
	return b, nil
}

// AppendExpiryCaveat attenuates the cork with the provided expiry predicate.
func (b *Builder) AppendExpiryCaveat(notAfter time.Time) (*Builder, error) {
	if notAfter.IsZero() {
		return nil, fmt.Errorf("%w: expiry not_after must be set", ErrInvalidCork)
	}
	payload := &corksv1.Expiry{NotAfter: uint64(notAfter.UTC().UnixMilli())}
	return b.appendFirstPartyCaveat(expiryPredicate, payload)
}

// AppendOrganizationScopeCaveat adds a first-party organization scope predicate.
func (b *Builder) AppendOrganizationScopeCaveat(scope *corksv1.OrganizationScope) (*Builder, error) {
	if scope == nil {
		return nil, fmt.Errorf("%w: organization scope payload is nil", ErrInvalidCork)
	}
	clone := proto.Clone(scope).(*corksv1.OrganizationScope)
	return b.appendFirstPartyCaveat(organizationScopePredicate, clone)
}

// AppendActionScopeCaveat adds an action whitelist predicate to the cork.
func (b *Builder) AppendActionScopeCaveat(actions []string) (*Builder, error) {
	if len(actions) == 0 {
		return nil, fmt.Errorf("%w: action scope requires at least one action", ErrInvalidCork)
	}
	clone := append([]string(nil), actions...)
	payload := &corksv1.ActionScope{Actions: clone}
	return b.appendFirstPartyCaveat(actionScopePredicate, payload)
}

// AppendIPBindingCaveat binds the cork to one or more CIDR ranges.
func (b *Builder) AppendIPBindingCaveat(cidrs []string) (*Builder, error) {
	if len(cidrs) == 0 {
		return nil, fmt.Errorf("%w: ip binding requires at least one CIDR", ErrInvalidCork)
	}
	clone := append([]string(nil), cidrs...)
	payload := &corksv1.IpBinding{Cidrs: clone}
	return b.appendFirstPartyCaveat(ipBindingPredicate, payload)
}

// AppendSessionStateCaveat records the session identifier/version for revocation.
func (b *Builder) AppendSessionStateCaveat(state *corksv1.SessionState) (*Builder, error) {
	if state == nil {
		return nil, fmt.Errorf("%w: session state payload is nil", ErrInvalidCork)
	}
	if state.GetSessionId() == "" {
		return nil, fmt.Errorf("%w: session state requires session_id", ErrInvalidCork)
	}
	clone := proto.Clone(state).(*corksv1.SessionState)
	return b.appendFirstPartyCaveat(sessionStatePredicate, clone)
}

// Validate checks that the builder contains the required fields prior to
// signing.
func (b *Builder) Validate() error {
	caveats, err := b.caveatsWithDefaults()
	if err != nil {
		return err
	}
	return b.validateWithCaveats(caveats)
}

func (b *Builder) validateWithCaveats(caveats []*corksv1.Caveat) error {
	missing := make([]string, 0, 4)
	if b.version == 0 {
		missing = append(missing, "version")
	}
	if len(b.nonce) != nonceSize {
		missing = append(missing, "nonce")
	}
	if len(b.keyID) == 0 {
		missing = append(missing, "key_id")
	}
	if b.issuer == nil {
		missing = append(missing, "issuer")
	}
	if b.bearer == nil {
		missing = append(missing, "bearer")
	}
	if b.issuedAt == 0 {
		missing = append(missing, "issued_at")
	}
	if len(missing) > 0 {
		return fmt.Errorf("%w: missing %s", ErrInvalidCork, strings.Join(missing, ", "))
	}
	for i, cav := range caveats {
		if cav == nil {
			return fmt.Errorf("%w: caveat %d is nil", ErrInvalidCork, i)
		}
		if cav.CaveatVersion == 0 {
			return fmt.Errorf("%w: caveat %d missing version", ErrInvalidCork, i)
		}
		if len(cav.CaveatId) == 0 {
			return fmt.Errorf("%w: caveat %d missing id", ErrInvalidCork, i)
		}
		if cav.GetFirstParty() == nil && cav.GetThirdParty() == nil {
			return fmt.Errorf("%w: caveat %d missing body", ErrInvalidCork, i)
		}
		if third := cav.GetThirdParty(); third != nil {
			if third.GetLocation() == "" {
				return fmt.Errorf("%w: caveat %d missing third-party location", ErrInvalidCork, i)
			}
			if len(third.GetTicket()) == 0 {
				return fmt.Errorf("%w: caveat %d missing third-party ticket", ErrInvalidCork, i)
			}
			if len(third.GetChallenge()) == 0 {
				return fmt.Errorf("%w: caveat %d missing third-party challenge", ErrInvalidCork, i)
			}
		}
	}
	return nil
}

func (b *Builder) caveatsWithDefaults() ([]*corksv1.Caveat, error) {
	defaults, err := b.buildDefaultCaveats()
	if err != nil {
		return nil, err
	}
	result := make([]*corksv1.Caveat, 0, len(defaults)+len(b.caveats))
	result = append(result, defaults...)
	for _, cav := range b.caveats {
		if cav == nil {
			result = append(result, nil)
			continue
		}
		clone := proto.Clone(cav).(*corksv1.Caveat)
		result = append(result, clone)
	}
	return result, nil
}

func (b *Builder) buildDefaultCaveats() ([]*corksv1.Caveat, error) {
	defaults := make([]*corksv1.Caveat, 0, 3)

	if b.defaultExpiry != nil {
		payload := proto.Clone(b.defaultExpiry).(*corksv1.Expiry)
		cav, err := buildFirstPartyCaveat(defaultCaveatNamespace, expiryPredicate, payload)
		if err != nil {
			return nil, err
		}
		defaults = append(defaults, cav)
	}
	if b.defaultOrganizationScope != nil {
		scope := proto.Clone(b.defaultOrganizationScope).(*corksv1.OrganizationScope)
		cav, err := buildFirstPartyCaveat(defaultCaveatNamespace, organizationScopePredicate, scope)
		if err != nil {
			return nil, err
		}
		defaults = append(defaults, cav)
	}
	if b.defaultActionScope != nil {
		actions := proto.Clone(b.defaultActionScope).(*corksv1.ActionScope)
		cav, err := buildFirstPartyCaveat(defaultCaveatNamespace, actionScopePredicate, actions)
		if err != nil {
			return nil, err
		}
		defaults = append(defaults, cav)
	}

	return defaults, nil
}

const (
	defaultCaveatNamespace           = "celest.auth"
	expiryPredicate                  = "expiry"
	organizationScopePredicate       = "organization_scope"
	actionScopePredicate             = "actions"
	ipBindingPredicate               = "ip_binding"
	sessionStatePredicate            = "session_state"
	defaultCaveatIdentifierByteCount = 16
)

func buildFirstPartyCaveat(namespace, predicate string, payload proto.Message) (*corksv1.Caveat, error) {
	packed, err := corksproto.MarshalAny(payload)
	if err != nil {
		return nil, fmt.Errorf("%w: failed to marshal caveat payload: %w", ErrInvalidCork, err)
	}
	identifier := make([]byte, defaultCaveatIdentifierByteCount)
	if _, err := rand.Read(identifier); err != nil {
		return nil, fmt.Errorf("%w: failed to generate caveat id: %w", ErrInvalidCork, err)
	}

	return &corksv1.Caveat{
		CaveatVersion: defaultCaveatVersion,
		CaveatId:      identifier,
		Body: &corksv1.Caveat_FirstParty{
			FirstParty: &corksv1.FirstPartyCaveat{
				Namespace: namespace,
				Predicate: predicate,
				Payload:   packed,
			},
		},
	}, nil
}

const defaultCaveatVersion = 1

// Build validates and returns an unsigned cork instance.
func (b *Builder) Build() (*Cork, error) {
	caveats, err := b.caveatsWithDefaults()
	if err != nil {
		return nil, err
	}
	if err := b.validateWithCaveats(caveats); err != nil {
		return nil, err
	}

	issuer, err := corksproto.MarshalAny(b.issuer)
	if err != nil {
		return nil, err
	}
	bearer, err := corksproto.MarshalAny(b.bearer)
	if err != nil {
		return nil, err
	}
	audience, err := corksproto.MarshalAny(b.audience)
	if err != nil {
		return nil, err
	}
	claims, err := corksproto.MarshalAny(b.claims)
	if err != nil {
		return nil, err
	}

	c := &corksv1.Cork{
		Version:  b.version,
		Nonce:    append([]byte(nil), b.nonce...),
		KeyId:    append([]byte(nil), b.keyID...),
		Issuer:   issuer,
		Bearer:   bearer,
		Audience: audience,
		Claims:   claims,
		IssuedAt: b.issuedAt,
	}
	if b.notAfter != nil {
		c.NotAfter = *b.notAfter
	}
	if len(caveats) > 0 {
		c.Caveats = append([]*corksv1.Caveat(nil), caveats...)
	}

	return &Cork{proto: c}, nil
}
