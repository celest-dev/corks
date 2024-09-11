package cedar

import (
	"fmt"

	cedarv3 "github.com/celest-dev/corks/go/proto/cedar/v3"
)

type EntityUid cedarv3.EntityUid

func NewEntityID(typ, id string) *EntityUid {
	return &EntityUid{
		Type: typ,
		Id:   id,
	}
}

func (e *EntityUid) Proto() *cedarv3.EntityUid {
	if e == nil {
		return nil
	}
	return (*cedarv3.EntityUid)(e)
}

func (e *EntityUid) String() string {
	return fmt.Sprintf("%s::%q", e.Type, e.Id)
}

type Entity cedarv3.Entity

func (e *Entity) Proto() *cedarv3.Entity {
	return (*cedarv3.Entity)(e)
}
