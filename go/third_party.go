package corks

import (
	"crypto/rand"
	"crypto/sha256"
	"fmt"
	"io"

	corksv1 "github.com/celest-dev/corks/go/proto/corks/v1"
	"golang.org/x/crypto/chacha20poly1305"
	"golang.org/x/crypto/hkdf"
)

// ThirdPartyTicketEncrypter encrypts the caveat root key for delivery to the
// third-party discharge service.
type ThirdPartyTicketEncrypter func(caveatID, caveatRootKey []byte) ([]byte, error)

// ThirdPartyCaveatOptions control how the builder appends a third-party caveat.
type ThirdPartyCaveatOptions struct {
	Location       string
	Tag            []byte
	Salt           []byte
	CaveatID       []byte
	ChallengeNonce []byte
	EncryptTicket  ThirdPartyTicketEncrypter
}

// AppendThirdPartyCaveat derives a caveat root key, encrypts the ticket and
// challenge payloads, and appends a third-party caveat to the builder.
func (b *Builder) AppendThirdPartyCaveat(opts *ThirdPartyCaveatOptions) (*Builder, error) {
	if opts == nil {
		return nil, fmt.Errorf("%w: third-party options are nil", ErrInvalidCork)
	}
	if opts.Location == "" {
		return nil, fmt.Errorf("%w: third-party location is required", ErrInvalidCork)
	}
	if len(opts.Tag) != tagSize {
		return nil, fmt.Errorf("%w: attenuation tag must be %d bytes", ErrInvalidCork, tagSize)
	}
	if opts.EncryptTicket == nil {
		return nil, fmt.Errorf("%w: third-party ticket encryptor not provided", ErrInvalidCork)
	}

	caveatID := append([]byte(nil), opts.CaveatID...)
	if len(caveatID) == 0 {
		caveatID = make([]byte, defaultCaveatIdentifierByteCount)
		if _, err := rand.Read(caveatID); err != nil {
			return nil, fmt.Errorf("%w: failed generating caveat id: %w", ErrInvalidCork, err)
		}
	}

	salt := append([]byte(nil), opts.Salt...)

	derived, err := deriveCaveatRootKey(opts.Tag, caveatID, salt, tagSize)
	if err != nil {
		return nil, err
	}

	ticket, err := opts.EncryptTicket(append([]byte(nil), caveatID...), append([]byte(nil), derived...))
	if err != nil {
		return nil, err
	}
	if len(ticket) == 0 {
		return nil, fmt.Errorf("%w: encrypted ticket must not be empty", ErrInvalidCork)
	}

	var nonce []byte
	if len(opts.ChallengeNonce) > 0 {
		nonce = append([]byte(nil), opts.ChallengeNonce...)
	}

	challenge, err := encryptChallenge(opts.Tag, caveatID, salt, derived, nonce)
	if err != nil {
		return nil, err
	}

	thirdParty := &corksv1.ThirdPartyCaveat{
		Location:  opts.Location,
		Ticket:    append([]byte(nil), ticket...),
		Challenge: append([]byte(nil), challenge...),
	}
	if len(salt) > 0 {
		thirdParty.Salt = append([]byte(nil), salt...)
	}

	cav := &corksv1.Caveat{
		CaveatVersion: defaultCaveatVersion,
		CaveatId:      append([]byte(nil), caveatID...),
		Body: &corksv1.Caveat_ThirdParty{
			ThirdParty: thirdParty,
		},
	}

	b.caveats = append(b.caveats, cav)
	return b, nil
}

func deriveCaveatRootKey(tag, caveatID, salt []byte, length int) ([]byte, error) {
	if len(tag) != tagSize {
		return nil, fmt.Errorf("%w: attenuation tag must be %d bytes", ErrInvalidCork, tagSize)
	}
	if length <= 0 || length > sha256.Size {
		return nil, fmt.Errorf("%w: derived key length must be between 1 and %d", ErrInvalidCork, sha256.Size)
	}

	info := buildAssociatedData(caveatID, salt)
	reader := hkdf.New(sha256.New, tag, nil, info)

	key := make([]byte, length)
	if _, err := io.ReadFull(reader, key); err != nil {
		return nil, fmt.Errorf("%w: failed to derive caveat key: %w", ErrInvalidCork, err)
	}
	return key, nil
}

func encryptChallenge(tag, caveatID, salt, derivedKey, nonce []byte) ([]byte, error) {
	if len(tag) != tagSize {
		return nil, fmt.Errorf("%w: attenuation tag must be %d bytes", ErrInvalidCork, tagSize)
	}
	if len(derivedKey) != tagSize {
		return nil, fmt.Errorf("%w: derived key must be %d bytes", ErrInvalidCork, tagSize)
	}

	aead, err := chacha20poly1305.New(tag)
	if err != nil {
		return nil, fmt.Errorf("%w: failed to initialise challenge cipher: %w", ErrInvalidCork, err)
	}

	useNonce := append([]byte(nil), nonce...)
	if len(useNonce) == 0 {
		useNonce = make([]byte, aead.NonceSize())
		if _, err := rand.Read(useNonce); err != nil {
			return nil, fmt.Errorf("%w: failed to generate challenge nonce: %w", ErrInvalidCork, err)
		}
	} else if len(useNonce) != aead.NonceSize() {
		return nil, fmt.Errorf("%w: challenge nonce must be %d bytes", ErrInvalidCork, aead.NonceSize())
	}

	associatedData := buildAssociatedData(caveatID, salt)
	cipherText := aead.Seal(nil, useNonce, derivedKey, associatedData)
	combined := make([]byte, len(useNonce)+len(cipherText))
	copy(combined, useNonce)
	copy(combined[len(useNonce):], cipherText)
	return combined, nil
}

func decryptChallenge(tag, caveatID, salt, payload []byte) ([]byte, error) {
	if len(tag) != tagSize {
		return nil, fmt.Errorf("%w: attenuation tag must be %d bytes", ErrInvalidCork, tagSize)
	}

	aead, err := chacha20poly1305.New(tag)
	if err != nil {
		return nil, fmt.Errorf("%w: failed to initialise challenge cipher: %w", ErrInvalidCork, err)
	}

	nonceSize := aead.NonceSize()
	minPayload := nonceSize + chacha20poly1305.Overhead
	if len(payload) <= minPayload {
		return nil, fmt.Errorf("%w: challenge payload too short", ErrInvalidCork)
	}

	nonce := payload[:nonceSize]
	cipherText := payload[nonceSize:]

	associatedData := buildAssociatedData(caveatID, salt)
	plain, err := aead.Open(nil, nonce, cipherText, associatedData)
	if err != nil {
		return nil, fmt.Errorf("%w: failed to decrypt challenge: %w", ErrInvalidCork, err)
	}
	return plain, nil
}

func buildAssociatedData(caveatID, salt []byte) []byte {
	data := append([]byte(nil), caveatID...)
	if len(salt) > 0 {
		data = append(data, salt...)
	}
	return data
}
