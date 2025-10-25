package corks

import (
	"encoding/base64"
	"errors"

	corksv1 "github.com/celest-dev/corks/go/proto/corks/v1"
	"google.golang.org/protobuf/proto"
)

var unmarshalOpts = proto.UnmarshalOptions{
	DiscardUnknown: true,
}

// Unmarshal decodes the cork from the given encoded data.
func (s *Cork) UnmarshalFrom(encoded []byte) error {
	var cork corksv1.Cork
	if err := unmarshalOpts.Unmarshal(encoded, &cork); err != nil {
		return errors.Join(ErrInvalidCork, err)
	}
	s.proto = &cork
	return nil
}

// DecodeFrom decodes a cork from a base64url-encoded string.
func (s *Cork) DecodeFrom(encoded string) error {
	data, err := base64.RawURLEncoding.DecodeString(encoded)
	if err != nil {
		return errors.Join(ErrInvalidCork, err)
	}
	return s.UnmarshalFrom(data)
}

// Decode decodes a cork from a base64url-encoded token.
func Decode(token string) (*Cork, error) {
	var cork Cork
	if err := cork.DecodeFrom(token); err != nil {
		return nil, err
	}
	return &cork, nil
}
