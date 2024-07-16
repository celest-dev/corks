package cedar

import (
	"fmt"

	cedarv3 "github.com/celest-dev/corks/go/internal/proto/cedar/v3"
)

type EntityID cedarv3.EntityId

func NewEntityID(typ, id string) *EntityID {
	return &EntityID{
		Type: typ,
		Id:   id,
	}
}

func (e *EntityID) Raw() *cedarv3.EntityId {
	if e == nil {
		return nil
	}
	return (*cedarv3.EntityId)(e)
}

func (e *EntityID) String() string {
	return fmt.Sprintf("%s::%q", e.Type, e.Id)
}

type Entity struct {
	UID     *EntityID        `json:"uid"`
	Parents []*EntityID      `json:"parents,omitempty"`
	Attrs   map[string]Value `json:"attrs"`
}

func (e *Entity) Raw() *cedarv3.Entity {
	parents := make([]*cedarv3.EntityId, len(e.Parents))
	for i, p := range e.Parents {
		parents[i] = p.Raw()
	}
	attrs := make(map[string]*cedarv3.Value, len(e.Attrs))
	for k, v := range e.Attrs {
		attrs[k] = v.RawValue()
	}
	return &cedarv3.Entity{
		Uid:        e.UID.Raw(),
		Parents:    parents,
		Attributes: attrs,
	}
}
