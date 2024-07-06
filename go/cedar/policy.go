package cedar

import (
	cedarexpr "github.com/celest-dev/corks/go/cedar/expr"
	cedarv3 "github.com/celest-dev/corks/go/internal/proto/cedar/v3"
)

type Policy struct {
	Id          string             `json:"id,omitempty"`
	Effect      PolicyEffect       `json:"effect"`
	Principal   *PolicyPrincipal   `json:"principal,omitempty"`
	Action      *PolicyAction      `json:"action,omitempty"`
	Resource    *PolicyResource    `json:"resource,omitempty"`
	Conditions  []*PolicyCondition `json:"conditions,omitempty"`
	Annotations map[string]string  `json:"annotations,omitempty"`
}

func (p *Policy) Raw() *cedarv3.Policy {
	var id *string
	if p.Id != "" {
		id = &p.Id
	}
	principal := p.Principal.Raw()
	action := p.Action.Raw()
	resource := p.Resource.Raw()
	conditions := make([]*cedarv3.PolicyCondition, len(p.Conditions))
	for i, c := range p.Conditions {
		conditions[i] = c.Raw()
	}
	return &cedarv3.Policy{
		Id:          id,
		Effect:      p.Effect.Raw(),
		Principal:   principal,
		Action:      action,
		Resource:    resource,
		Conditions:  conditions,
		Annotations: p.Annotations,
	}
}

type PolicyEffect int32

const (
	EffectPermit PolicyEffect = 1
	EffectForbid PolicyEffect = 2
)

func (e PolicyEffect) Raw() cedarv3.PolicyEffect {
	return cedarv3.PolicyEffect(e)
}

func (e PolicyEffect) String() string {
	switch e {
	case EffectPermit:
		return "permit"
	case EffectForbid:
		return "forbid"
	default:
		return "unknown"
	}
}

type PolicyPrincipal struct {
	Op         PolicyOp  `json:"op"`
	Entity     *EntityId `json:"entity,omitempty"`
	EntityType string    `json:"entity_type,omitempty"`
}

func (p *PolicyPrincipal) Raw() *cedarv3.PolicyPrincipal {
	if p == nil {
		return nil
	}
	policy := &cedarv3.PolicyPrincipal{
		Op:     p.Op.Raw(),
		Entity: p.Entity.Raw(),
	}
	if p.EntityType != "" {
		policy.EntityType = &p.EntityType
	}
	return policy
}

type PolicyAction struct {
	Op       PolicyOp    `json:"op"`
	Entity   *EntityId   `json:"entity,omitempty"`
	Entities []*EntityId `json:"entities,omitempty"`
}

func (a *PolicyAction) Raw() *cedarv3.PolicyAction {
	if a == nil {
		return nil
	}
	action := &cedarv3.PolicyAction{
		Op: a.Op.Raw(),
	}
	if a.Entity != nil {
		action.Entity = a.Entity.Raw()
	}
	if len(a.Entities) > 0 {
		entities := make([]*cedarv3.EntityId, len(a.Entities))
		for i, e := range a.Entities {
			entities[i] = e.Raw()
		}
		action.Entities = entities
	}
	return action
}

type PolicyResource struct {
	Op         PolicyOp  `json:"op"`
	Entity     *EntityId `json:"entity,omitempty"`
	EntityType string    `json:"entity_type,omitempty"`
}

func (r *PolicyResource) Raw() *cedarv3.PolicyResource {
	if r == nil {
		return nil
	}
	resource := &cedarv3.PolicyResource{
		Op: r.Op.Raw(),
	}
	if r.Entity != nil {
		resource.Entity = r.Entity.Raw()
	}
	if r.EntityType != "" {
		resource.EntityType = &r.EntityType
	}
	return resource
}

type PolicyCondition struct {
	Kind PolicyConditionKind `json:"kind"`
	Body *cedarexpr.Expr     `json:"body,omitempty"`
}

func (c *PolicyCondition) Raw() *cedarv3.PolicyCondition {
	if c == nil {
		return nil
	}
	return &cedarv3.PolicyCondition{
		Kind: c.Kind.Raw(),
		Body: c.Body,
	}
}

type PolicyOp int32

const (
	OpAll    PolicyOp = 1
	OpEquals PolicyOp = 2
	OpIn     PolicyOp = 3
	OpIs     PolicyOp = 4
)

func (o PolicyOp) Raw() cedarv3.PolicyOp {
	return cedarv3.PolicyOp(o)
}

func (o PolicyOp) String() string {
	switch o {
	case OpAll:
		return "All"
	case OpEquals:
		return "=="
	case OpIn:
		return "in"
	case OpIs:
		return "is"
	default:
		return "unknown"
	}
}

type PolicyConditionKind int32

const (
	ConditionKindWhen   PolicyConditionKind = 1
	ConditionKindUnless PolicyConditionKind = 2
)

func (k PolicyConditionKind) Raw() cedarv3.PolicyConditionKind {
	return cedarv3.PolicyConditionKind(k)
}

func (k PolicyConditionKind) String() string {
	switch k {
	case ConditionKindWhen:
		return "when"
	case ConditionKindUnless:
		return "unless"
	default:
		return "unknown"
	}
}
