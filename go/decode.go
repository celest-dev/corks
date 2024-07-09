package corks

import (
	"encoding/base64"
	"errors"

	corksv1 "github.com/celest-dev/corks/go/internal/proto/corks/v1"
	"google.golang.org/protobuf/proto"
)

var unmarshalOpts = proto.UnmarshalOptions{
	DiscardUnknown: true,
}

// Unmarshal decodes the cork from the given encoded data.
func (s *Cork) UnmarshalFrom(encoded []byte) error {
	return unmarshalOpts.Unmarshal(encoded, (*corksv1.Cork)(s))
}

// Decode decodes a cork from a base64url-encoded string.
func (s *Cork) DecodeFrom(encoded string) error {
	data, err := base64.URLEncoding.DecodeString(encoded)
	if err != nil {
		return errors.Join(ErrInvalidCork, err)
	}
	return s.UnmarshalFrom(data)
}

// Decode decodes a cork from a base64url-encoded token.
func Decode(token string) (*Cork, error) {
	var cork Cork
	err := cork.DecodeFrom(token)
	if err != nil {
		return nil, err
	}
	return &cork, nil
}
