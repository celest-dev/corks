package proto

import (
	"google.golang.org/protobuf/proto"
	"google.golang.org/protobuf/types/known/anypb"
)

var marshalOpts = proto.MarshalOptions{
	Deterministic: true,
}

// MarshalAny encodes the message as an Any.
func MarshalAny(m proto.Message) (*anypb.Any, error) {
	if m == nil {
		return nil, nil
	}
	if any, ok := m.(*anypb.Any); ok {
		return any, nil
	}
	any := new(anypb.Any)
	err := anypb.MarshalFrom(any, m, marshalOpts)
	if err != nil {
		return nil, err
	}
	return any, nil
}
