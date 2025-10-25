package corks

import (
	"crypto/rand"
	"fmt"
	"strings"
	"time"

	corksproto "github.com/celest-dev/corks/go/proto"
	corksv1 "github.com/celest-dev/corks/go/proto/corks/v1"
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
	version  uint32
	nonce    []byte
	keyID    []byte
	issuer   proto.Message
	bearer   proto.Message
	audience proto.Message
	claims   proto.Message
	caveats  []*corksv1.Caveat
	issuedAt uint64
	notAfter *uint64
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

// Validate checks that the builder contains the required fields prior to
// signing.
func (b *Builder) Validate() error {
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
	for i, cav := range b.caveats {
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
	}
	return nil
}

// Build validates and returns an unsigned cork instance.
func (b *Builder) Build() (*Cork, error) {
	if err := b.Validate(); err != nil {
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

	protoCaveats := make([]*corksv1.Caveat, len(b.caveats))
	for i, caveat := range b.caveats {
		protoCaveats[i] = proto.Clone(caveat).(*corksv1.Caveat)
	}

	c := &corksv1.Cork{
		Version:  b.version,
		Nonce:    append([]byte(nil), b.nonce...),
		KeyId:    append([]byte(nil), b.keyID...),
		Issuer:   issuer,
		Bearer:   bearer,
		Audience: audience,
		Claims:   claims,
		Caveats:  protoCaveats,
		IssuedAt: b.issuedAt,
	}
	if b.notAfter != nil {
		c.NotAfter = *b.notAfter
	}

	return &Cork{proto: c}, nil
}
