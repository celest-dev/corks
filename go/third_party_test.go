package corks

import (
	"bytes"
	"crypto/sha256"
	"errors"
	"io"
	"testing"

	"github.com/stretchr/testify/require"
	"golang.org/x/crypto/chacha20poly1305"
	"golang.org/x/crypto/hkdf"
	"google.golang.org/protobuf/types/known/wrapperspb"
)

func TestDeriveCaveatRootKeyMatchesHKDF(t *testing.T) {
	t.Helper()

	tag := bytes.Repeat([]byte{0x11}, tagSize)
	caveatID := []byte{0x00, 0x11, 0x22, 0x33, 0x44, 0x55, 0x66, 0x77, 0x88, 0x99, 0xaa, 0xbb}
	salt := []byte{0x0a, 0x0b, 0x0c, 0x0d}

	derived, err := deriveCaveatRootKey(tag, caveatID, salt, 16)
	require.NoError(t, err)

	reference := make([]byte, 16)
	reader := hkdf.New(sha256.New, tag, nil, buildAssociatedData(caveatID, salt))
	_, err = io.ReadFull(reader, reference)
	require.NoError(t, err)
	require.Equal(t, reference, derived)
}

func TestDeriveCaveatRootKeyValidatesInput(t *testing.T) {
	t.Helper()

	_, err := deriveCaveatRootKey(make([]byte, tagSize-1), []byte{1}, nil, tagSize)
	require.ErrorContains(t, err, "attenuation tag must be")

	_, err = deriveCaveatRootKey(make([]byte, tagSize), []byte{1}, nil, sha256.Size+1)
	require.ErrorContains(t, err, "derived key length must be between")
}

func TestEncryptChallengeRoundTrip(t *testing.T) {
	t.Helper()

	tag := bytes.Repeat([]byte{0x21}, tagSize)
	caveatID := bytes.Repeat([]byte{0xAB}, defaultCaveatIdentifierByteCount)
	salt := []byte{0x01, 0x02, 0x03}
	derived := bytes.Repeat([]byte{0x7f}, tagSize)
	nonce := bytes.Repeat([]byte{0x05}, chacha20poly1305.NonceSize)

	payload, err := encryptChallenge(tag, caveatID, salt, derived, nonce)
	require.NoError(t, err)
	require.Len(t, payload, len(nonce)+len(derived)+chacha20poly1305.Overhead)

	plain, err := decryptChallenge(tag, caveatID, salt, payload)
	require.NoError(t, err)
	require.Equal(t, derived, plain)
}

func TestEncryptChallengeValidatesInputs(t *testing.T) {
	t.Helper()

	tag := bytes.Repeat([]byte{0x01}, tagSize)
	caveatID := []byte{0x01, 0x02, 0x03}
	derived := bytes.Repeat([]byte{0x08}, tagSize)
	nonce := bytes.Repeat([]byte{0x09}, chacha20poly1305.NonceSize)

	_, err := encryptChallenge(tag[:len(tag)-1], caveatID, nil, derived, nonce)
	require.ErrorContains(t, err, "attenuation tag must be")

	_, err = encryptChallenge(tag, caveatID, nil, derived[:len(derived)-1], nonce)
	require.ErrorContains(t, err, "derived key must be")

	_, err = encryptChallenge(tag, caveatID, nil, derived, append(nonce, 0xFF))
	require.ErrorContains(t, err, "challenge nonce must be")
}

func TestDecryptChallengeValidatesInputs(t *testing.T) {
	t.Helper()

	tag := bytes.Repeat([]byte{0x01}, tagSize)
	caveatID := []byte{0xAA}

	_, err := decryptChallenge(tag[:len(tag)-1], caveatID, nil, []byte{0x01})
	require.ErrorContains(t, err, "attenuation tag must be")

	nonceSize := chacha20poly1305.NonceSize
	_, err = decryptChallenge(tag, caveatID, nil, bytes.Repeat([]byte{0x01}, nonceSize+chacha20poly1305.Overhead-1))
	require.ErrorContains(t, err, "challenge payload too short")
}

func TestAppendThirdPartyCaveat(t *testing.T) {
	t.Helper()

	builder := NewBuilder([]byte("third-party-success"))
	builder.Issuer(wrapperspb.String("celest::issuer"))
	builder.Bearer(wrapperspb.String("celest::bearer"))

	tag := bytes.Repeat([]byte{0xAB}, tagSize)
	salt := []byte{0x10, 0x11, 0x12}
	nonce := bytes.Repeat([]byte{0x22}, chacha20poly1305.NonceSize)

	var capturedID []byte
	var capturedKey []byte
	encryptTicket := func(id, key []byte) ([]byte, error) {
		capturedID = append([]byte(nil), id...)
		capturedKey = append([]byte(nil), key...)
		return append([]byte("ticket:"), key...), nil
	}

	opts := &ThirdPartyCaveatOptions{
		Location:       "https://discharge.celest.dev",
		Tag:            append([]byte(nil), tag...),
		Salt:           append([]byte(nil), salt...),
		ChallengeNonce: append([]byte(nil), nonce...),
		EncryptTicket:  encryptTicket,
	}

	returned, err := builder.AppendThirdPartyCaveat(opts)
	require.NoError(t, err)
	require.Equal(t, builder, returned)
	require.Len(t, capturedID, defaultCaveatIdentifierByteCount)

	expectedDerived, err := deriveCaveatRootKey(tag, capturedID, salt, tagSize)
	require.NoError(t, err)
	require.Equal(t, expectedDerived, capturedKey)

	cork, err := builder.Build()
	require.NoError(t, err)
	proto := cork.Proto()
	require.Len(t, proto.GetCaveats(), 1)

	cav := proto.GetCaveats()[0]
	require.Equal(t, capturedID, cav.GetCaveatId())
	third := cav.GetThirdParty()
	require.NotNil(t, third)
	require.Equal(t, opts.Location, third.GetLocation())
	require.Equal(t, append([]byte("ticket:"), expectedDerived...), third.GetTicket())
	require.Equal(t, salt, third.GetSalt())
	require.True(t, bytes.HasPrefix(third.GetChallenge(), nonce))

	recovered, err := decryptChallenge(tag, capturedID, salt, third.GetChallenge())
	require.NoError(t, err)
	require.Equal(t, expectedDerived, recovered)
}

func TestAppendThirdPartyCaveatValidatesOptions(t *testing.T) {
	t.Helper()

	newBuilder := func() *Builder {
		b := NewBuilder([]byte("third-party-validation"))
		b.Issuer(wrapperspb.String("celest::issuer"))
		b.Bearer(wrapperspb.String("celest::bearer"))
		return b
	}

	makeOpts := func() *ThirdPartyCaveatOptions {
		return &ThirdPartyCaveatOptions{
			Location:       "https://service",
			Tag:            bytes.Repeat([]byte{0x01}, tagSize),
			CaveatID:       bytes.Repeat([]byte{0x02}, defaultCaveatIdentifierByteCount),
			ChallengeNonce: bytes.Repeat([]byte{0x03}, chacha20poly1305.NonceSize),
			EncryptTicket: func(_, _ []byte) ([]byte, error) {
				return []byte("ticket"), nil
			},
		}
	}

	_, err := newBuilder().AppendThirdPartyCaveat(nil)
	require.ErrorContains(t, err, "third-party options are nil")

	missingLocation := makeOpts()
	missingLocation.Location = ""
	_, err = newBuilder().AppendThirdPartyCaveat(missingLocation)
	require.ErrorContains(t, err, "location")

	badTag := makeOpts()
	badTag.Tag = []byte{0x01}
	_, err = newBuilder().AppendThirdPartyCaveat(badTag)
	require.ErrorContains(t, err, "attenuation tag must be")

	nilEncryptor := makeOpts()
	nilEncryptor.EncryptTicket = nil
	_, err = newBuilder().AppendThirdPartyCaveat(nilEncryptor)
	require.ErrorContains(t, err, "ticket encryptor not provided")

	encryptError := makeOpts()
	encryptError.EncryptTicket = func(_, _ []byte) ([]byte, error) {
		return nil, errors.New("boom")
	}
	_, err = newBuilder().AppendThirdPartyCaveat(encryptError)
	require.ErrorContains(t, err, "boom")

	emptyTicket := makeOpts()
	emptyTicket.EncryptTicket = func(_, _ []byte) ([]byte, error) {
		return nil, nil
	}
	_, err = newBuilder().AppendThirdPartyCaveat(emptyTicket)
	require.ErrorContains(t, err, "encrypted ticket must not be empty")

	badNonce := makeOpts()
	badNonce.ChallengeNonce = bytes.Repeat([]byte{0x04}, chacha20poly1305.NonceSize+1)
	_, err = newBuilder().AppendThirdPartyCaveat(badNonce)
	require.ErrorContains(t, err, "challenge nonce must be")
}
