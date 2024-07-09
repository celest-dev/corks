package cedar

import cedarv3 "github.com/celest-dev/corks/go/internal/proto/cedar/v3"

type EntityId cedarv3.EntityId

func (e *EntityId) Raw() *cedarv3.EntityId {
	if e == nil {
		return nil
	}
	return (*cedarv3.EntityId)(e)
}

type Entity struct {
	Uid     *EntityId        `json:"uid"`
	Parents []*EntityId      `json:"parents"`
	Attrs   map[string]Value `json:"attributes"`
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
		Uid:        e.Uid.Raw(),
		Parents:    parents,
		Attributes: attrs,
	}
}
