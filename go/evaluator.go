package corks

import (
	"context"
	"fmt"
	"net"
	"strings"

	corksv1 "github.com/celest-dev/corks/go/proto/corks/v1"
	"google.golang.org/protobuf/proto"
	"google.golang.org/protobuf/types/known/anypb"
)

// AuthNamespace identifies the canonical namespace for Celest first-party caveats.
const AuthNamespace = defaultCaveatNamespace

// Canonical first-party predicates supported by the registry.
const (
	PredicateOrganizationScope = organizationScopePredicate
	PredicateActionScope       = actionScopePredicate
	PredicateIPBinding         = ipBindingPredicate
	PredicateSessionState      = sessionStatePredicate
)

// ScopeContext describes the tenant hierarchy associated with the request being
// authorised.
type ScopeContext struct {
	OrganizationID string
	ProjectID      string
	EnvironmentID  string
}

// EvaluationContext captures the request metadata required to evaluate the
// canonical caveats.
type EvaluationContext struct {
	Scope            ScopeContext
	RequestedActions []string
	ClientIP         net.IP
	SessionVersions  map[string]uint64
}

// EvaluationResult records whether a caveat was satisfied along with an
// optional failure reason.
type EvaluationResult struct {
	Satisfied bool
	Reason    string
}

type evaluationFunc func(context.Context, *corksv1.Caveat, *corksv1.FirstPartyCaveat, EvaluationContext) EvaluationResult

// Registry evaluates first-party caveats against the supplied context.
type Registry struct {
	namespace string
	evals     map[string]evaluationFunc
}

// NewRegistry returns a registry populated with the canonical Celest evaluators.
func NewRegistry() *Registry {
	r := &Registry{
		namespace: AuthNamespace,
		evals:     make(map[string]evaluationFunc),
	}
	r.Register(PredicateOrganizationScope, evaluateOrganizationScope)
	r.Register(PredicateActionScope, evaluateActionScope)
	r.Register(PredicateIPBinding, evaluateIPBinding)
	r.Register(PredicateSessionState, evaluateSessionState)
	return r
}

// Register installs a predicate evaluator. Existing registrations are rejected
// to avoid accidental shadowing.
func (r *Registry) Register(predicate string, eval evaluationFunc) {
	if predicate == "" {
		panic("caveat predicate must not be empty")
	}
	if eval == nil {
		panic("caveat evaluator must not be nil")
	}
	if _, exists := r.evals[predicate]; exists {
		panic(fmt.Sprintf("caveat evaluator already registered for %q", predicate))
	}
	r.evals[predicate] = eval
}

// Evaluate executes the registered evaluator for the provided caveat.
// Unknown namespaces, predicates, or malformed payloads fail closed.
func (r *Registry) Evaluate(ctx context.Context, caveat *corksv1.Caveat, input EvaluationContext) EvaluationResult {
	if caveat == nil {
		return failure("caveat is nil")
	}
	first := caveat.GetFirstParty()
	if first == nil {
		return failure("caveat is not first-party")
	}
	if first.Namespace != r.namespace {
		return failure(fmt.Sprintf("unsupported namespace %q", first.Namespace))
	}
	eval, ok := r.evals[first.Predicate]
	if !ok {
		return failure(fmt.Sprintf("unknown predicate %q", first.Predicate))
	}
	if first.Payload == nil {
		return failure("caveat payload is missing")
	}
	return eval(ctx, caveat, first, input)
}

func evaluateOrganizationScope(_ context.Context, _ *corksv1.Caveat, first *corksv1.FirstPartyCaveat, input EvaluationContext) EvaluationResult {
	payload := new(corksv1.OrganizationScope)
	if err := unpack(first.Payload, payload); err != nil {
		return failure(err.Error())
	}

	if id := strings.TrimSpace(payload.GetOrganizationId()); id != "" {
		if input.Scope.OrganizationID == "" {
			return failure("missing organization context")
		}
		if id != input.Scope.OrganizationID {
			return failure(fmt.Sprintf("organization mismatch: expected %q", id))
		}
	}
	if id := strings.TrimSpace(payload.GetProjectId()); id != "" {
		if input.Scope.ProjectID == "" {
			return failure("missing project context")
		}
		if id != input.Scope.ProjectID {
			return failure(fmt.Sprintf("project mismatch: expected %q", id))
		}
	}
	if id := strings.TrimSpace(payload.GetEnvironmentId()); id != "" {
		if input.Scope.EnvironmentID == "" {
			return failure("missing environment context")
		}
		if id != input.Scope.EnvironmentID {
			return failure(fmt.Sprintf("environment mismatch: expected %q", id))
		}
	}
	return success()
}

func evaluateActionScope(_ context.Context, _ *corksv1.Caveat, first *corksv1.FirstPartyCaveat, input EvaluationContext) EvaluationResult {
	payload := new(corksv1.ActionScope)
	if err := unpack(first.Payload, payload); err != nil {
		return failure(err.Error())
	}
	if len(payload.GetActions()) == 0 {
		return failure("action scope payload is empty")
	}
	if len(input.RequestedActions) == 0 {
		return failure("requested actions not provided")
	}
	allowed := make(map[string]struct{}, len(payload.Actions))
	for _, action := range payload.Actions {
		action = strings.TrimSpace(action)
		if action == "" {
			return failure("action scope payload contains an empty value")
		}
		allowed[action] = struct{}{}
	}
	for _, action := range input.RequestedActions {
		action = strings.TrimSpace(action)
		if action == "" {
			return failure("requested actions contain an empty value")
		}
		if _, ok := allowed[action]; !ok {
			return failure(fmt.Sprintf("action %q is not permitted", action))
		}
	}
	return success()
}

func evaluateIPBinding(_ context.Context, _ *corksv1.Caveat, first *corksv1.FirstPartyCaveat, input EvaluationContext) EvaluationResult {
	payload := new(corksv1.IpBinding)
	if err := unpack(first.Payload, payload); err != nil {
		return failure(err.Error())
	}
	if len(payload.GetCidrs()) == 0 {
		return failure("ip binding payload is empty")
	}
	ip := input.ClientIP
	if ip == nil {
		return failure("client IP missing from evaluation context")
	}
	ip = append(net.IP(nil), ip...)
	matched := false
	for _, cidr := range payload.Cidrs {
		cidr = strings.TrimSpace(cidr)
		if cidr == "" {
			return failure("ip binding contains an empty CIDR")
		}
		_, network, err := net.ParseCIDR(cidr)
		if err != nil {
			return failure(fmt.Sprintf("invalid CIDR %q", cidr))
		}
		if network.Contains(ip) {
			matched = true
			break
		}
	}
	if !matched {
		return failure("client IP not permitted")
	}
	return success()
}

func evaluateSessionState(_ context.Context, _ *corksv1.Caveat, first *corksv1.FirstPartyCaveat, input EvaluationContext) EvaluationResult {
	payload := new(corksv1.SessionState)
	if err := unpack(first.Payload, payload); err != nil {
		return failure(err.Error())
	}
	sessionID := strings.TrimSpace(payload.GetSessionId())
	if sessionID == "" {
		return failure("session state payload missing session_id")
	}
	if input.SessionVersions == nil {
		return failure("session state versions not provided")
	}
	expected, ok := input.SessionVersions[sessionID]
	if !ok {
		return failure(fmt.Sprintf("session %q not found", sessionID))
	}
	if expected != payload.GetVersion() {
		return failure(fmt.Sprintf(
			"session version mismatch: expected %d",
			expected,
		))
	}
	return success()
}

func unpack(payload *anypb.Any, into proto.Message) error {
	if payload == nil || len(payload.GetValue()) == 0 {
		return fmt.Errorf("caveat payload is missing")
	}
	if err := payload.UnmarshalTo(into); err != nil {
		return fmt.Errorf("failed to decode payload: %w", err)
	}
	return nil
}

func success() EvaluationResult {
	return EvaluationResult{Satisfied: true}
}

func failure(reason string) EvaluationResult {
	if reason == "" {
		reason = "caveat evaluation failed"
	}
	return EvaluationResult{Satisfied: false, Reason: reason}
}
