package cedar

import (
	cedarexpr "github.com/celest-dev/corks/go/cedar/expr"
	cedarv3 "github.com/celest-dev/corks/go/proto/cedar/v3"
)

type Policy struct {
	ID          string             `json:"id,omitempty"`
	Effect      PolicyEffect       `json:"effect"`
	Principal   *PolicyPrincipal   `json:"principal,omitempty"`
	Action      *PolicyAction      `json:"action,omitempty"`
	Resource    *PolicyResource    `json:"resource,omitempty"`
	Conditions  []*PolicyCondition `json:"conditions,omitempty"`
	Annotations map[string]string  `json:"annotations,omitempty"`
}

func (p *Policy) Raw() *cedarv3.Policy {
	var id *string
	if p.ID != "" {
		id = &p.ID
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

type PolicyEffect string

const (
	EffectPermit PolicyEffect = "permit"
	EffectForbid PolicyEffect = "forbid"
)

func (e PolicyEffect) Raw() cedarv3.PolicyEffect {
	switch e {
	case EffectPermit:
		return cedarv3.PolicyEffect_POLICY_EFFECT_PERMIT
	case EffectForbid:
		return cedarv3.PolicyEffect_POLICY_EFFECT_FORBID
	default:
		return cedarv3.PolicyEffect_POLICY_EFFECT_UNSPECIFIED
	}
}

func (e PolicyEffect) String() string {
	return string(e)
}

type PolicyPrincipal struct {
	Op         PolicyOp  `json:"op"`
	Entity     *EntityID `json:"entity,omitempty"`
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
	Entity   *EntityID   `json:"entity,omitempty"`
	Entities []*EntityID `json:"entities,omitempty"`
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
	Entity     *EntityID `json:"entity,omitempty"`
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
		Body: c.Body.Raw(),
	}
}

type PolicyOp string

const (
	OpAll    PolicyOp = "All"
	OpEquals PolicyOp = "=="
	OpIn     PolicyOp = "in"
	OpIs     PolicyOp = "is"
)

func (o PolicyOp) Raw() cedarv3.PolicyOp {
	switch o {
	case OpAll:
		return cedarv3.PolicyOp_POLICY_OP_ALL
	case OpEquals:
		return cedarv3.PolicyOp_POLICY_OP_EQUALS
	case OpIn:
		return cedarv3.PolicyOp_POLICY_OP_IN
	case OpIs:
		return cedarv3.PolicyOp_POLICY_OP_IS
	default:
		return cedarv3.PolicyOp_POLICY_OP_UNSPECIFIED
	}
}

func (o PolicyOp) String() string {
	return string(o)
}

type PolicyConditionKind string

const (
	ConditionKindWhen   PolicyConditionKind = "when"
	ConditionKindUnless PolicyConditionKind = "unless"
)

func (k PolicyConditionKind) Raw() cedarv3.PolicyConditionKind {
	switch k {
	case ConditionKindWhen:
		return cedarv3.PolicyConditionKind_POLICY_CONDITION_KIND_WHEN
	case ConditionKindUnless:
		return cedarv3.PolicyConditionKind_POLICY_CONDITION_KIND_UNLESS
	default:
		return cedarv3.PolicyConditionKind_POLICY_CONDITION_KIND_UNSPECIFIED
	}
}

func (k PolicyConditionKind) String() string {
	return string(k)
}
