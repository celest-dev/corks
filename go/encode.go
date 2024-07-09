package corks

import (
	"encoding/base64"
	"errors"

	corksv1 "github.com/celest-dev/corks/go/internal/proto/corks/v1"
	"google.golang.org/protobuf/proto"
)

var marshalOpts = proto.MarshalOptions{
	Deterministic: true,
}

// Marshal encodes the sealed cork into a binary format.
func (c *Cork) Marshal() ([]byte, error) {
	if c.Signature == nil {
		return nil, ErrMissingSignature
	}
	return marshalOpts.Marshal((*corksv1.Cork)(c))
}

// Encode encodes the sealed cork into a base64url-encoded string.
func (c *Cork) Encode() (string, error) {
	if c.Signature == nil {
		return "", ErrMissingSignature
	}
	data, err := c.Marshal()
	if err != nil {
		return "", errors.Join(ErrInvalidCork, err)
	}
	return base64.URLEncoding.EncodeToString(data), nil
}
