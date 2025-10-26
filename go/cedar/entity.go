package cedar

import (
	"fmt"

	cedarv4 "github.com/celest-dev/corks/go/proto/cedar/v4"
)

type EntityUid cedarv4.EntityUid

func NewEntityID(typ, id string) *EntityUid {
	return &EntityUid{
		Type: typ,
		Id:   id,
	}
}

func (e *EntityUid) Proto() *cedarv4.EntityUid {
	if e == nil {
		return nil
	}
	return (*cedarv4.EntityUid)(e)
}

func (e *EntityUid) String() string {
	return fmt.Sprintf("%s::%q", e.Type, e.Id)
}

type Entity cedarv4.Entity

func (e *Entity) Proto() *cedarv4.Entity {
	return (*cedarv4.Entity)(e)
}
