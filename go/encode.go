package corks

import (
	"encoding/base64"
	"errors"

	"google.golang.org/protobuf/proto"
)

var marshalOpts = proto.MarshalOptions{
	Deterministic: true,
}

// Marshal encodes the sealed cork into a binary format.
func (c *Cork) Marshal() ([]byte, error) {
	if len(c.TailSignature()) == 0 {
		return nil, ErrMissingSignature
	}
	return marshalOpts.Marshal(c.Proto())
}

// Encode encodes the sealed cork into a base64url (unpadded) string.
func (c *Cork) Encode() (string, error) {
	if len(c.TailSignature()) == 0 {
		return "", ErrMissingSignature
	}
	data, err := c.Marshal()
	if err != nil {
		return "", errors.Join(ErrInvalidCork, err)
	}
	return base64.RawURLEncoding.EncodeToString(data), nil
}
