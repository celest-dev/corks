package corks

import (
	"context"
	"net"
	"testing"

	corksproto "github.com/celest-dev/corks/go/proto"
	corksv1 "github.com/celest-dev/corks/go/proto/corks/v1"
	"google.golang.org/protobuf/proto"
)

func TestEvaluateOrganizationScope(t *testing.T) {
	registry := NewRegistry()
	ctx := context.Background()

	caveat := mustFirstPartyCaveat(PredicateOrganizationScope, &corksv1.OrganizationScope{
		OrganizationId: "org-1",
		ProjectId:      "proj-1",
		EnvironmentId:  "env-1",
	})

	result := registry.Evaluate(ctx, caveat, EvaluationContext{
		Scope: ScopeContext{
			OrganizationID: "org-1",
			ProjectID:      "proj-1",
			EnvironmentID:  "env-1",
		},
	})
	if !result.Satisfied {
		t.Fatalf("expected success, got failure: %v", result.Reason)
	}

	missing := registry.Evaluate(ctx, caveat, EvaluationContext{})
	if missing.Satisfied {
		t.Fatalf("expected failure when context missing")
	}
	if missing.Reason == "" {
		t.Fatalf("expected failure reason when context missing")
	}

	mismatch := registry.Evaluate(ctx, caveat, EvaluationContext{
		Scope: ScopeContext{
			OrganizationID: "org-1",
			ProjectID:      "wrong",
			EnvironmentID:  "env-1",
		},
	})
	if mismatch.Satisfied {
		t.Fatalf("expected mismatch to fail")
	}
}

func TestEvaluateActionScope(t *testing.T) {
	registry := NewRegistry()
	ctx := context.Background()

	caveat := mustFirstPartyCaveat(PredicateActionScope, &corksv1.ActionScope{Actions: []string{"read", "write"}})

	allowed := registry.Evaluate(ctx, caveat, EvaluationContext{RequestedActions: []string{"read"}})
	if !allowed.Satisfied {
		t.Fatalf("expected action to be permitted: %v", allowed.Reason)
	}

	denied := registry.Evaluate(ctx, caveat, EvaluationContext{RequestedActions: []string{"delete"}})
	if denied.Satisfied {
		t.Fatalf("unexpected success for denied action")
	}

	missing := registry.Evaluate(ctx, caveat, EvaluationContext{})
	if missing.Satisfied {
		t.Fatalf("expected failure when requested actions missing")
	}

	emptyPayload := mustFirstPartyCaveat(PredicateActionScope, &corksv1.ActionScope{})
	invalid := registry.Evaluate(ctx, emptyPayload, EvaluationContext{RequestedActions: []string{"read"}})
	if invalid.Satisfied {
		t.Fatalf("expected empty payload to fail")
	}
}

func TestEvaluateIPBinding(t *testing.T) {
	registry := NewRegistry()
	ctx := context.Background()

	caveat := mustFirstPartyCaveat(PredicateIPBinding, &corksv1.IpBinding{
		Cidrs: []string{"10.0.0.0/8", "2001:db8::/32"},
	})

	ipv4 := registry.Evaluate(ctx, caveat, EvaluationContext{ClientIP: net.ParseIP("10.10.0.1")})
	if !ipv4.Satisfied {
		t.Fatalf("expected IPv4 address within CIDR: %v", ipv4.Reason)
	}

	ipv6 := registry.Evaluate(ctx, caveat, EvaluationContext{ClientIP: net.ParseIP("2001:db8::1")})
	if !ipv6.Satisfied {
		t.Fatalf("expected IPv6 address within CIDR: %v", ipv6.Reason)
	}

	denied := registry.Evaluate(ctx, caveat, EvaluationContext{ClientIP: net.ParseIP("192.168.0.1")})
	if denied.Satisfied {
		t.Fatalf("expected address outside CIDR to fail")
	}

	missing := registry.Evaluate(ctx, caveat, EvaluationContext{})
	if missing.Satisfied {
		t.Fatalf("expected missing client IP to fail")
	}

	invalid := mustFirstPartyCaveat(PredicateIPBinding, &corksv1.IpBinding{Cidrs: []string{"not-a-cidr"}})
	invalidResult := registry.Evaluate(ctx, invalid, EvaluationContext{ClientIP: net.ParseIP("10.0.0.1")})
	if invalidResult.Satisfied {
		t.Fatalf("expected invalid CIDR to fail")
	}
}

func TestEvaluateSessionState(t *testing.T) {
	registry := NewRegistry()
	ctx := context.Background()

	caveat := mustFirstPartyCaveat(PredicateSessionState, &corksv1.SessionState{
		SessionId: "sess-1",
		Version:   42,
	})

	success := registry.Evaluate(ctx, caveat, EvaluationContext{
		SessionVersions: map[string]uint64{"sess-1": 42},
	})
	if !success.Satisfied {
		t.Fatalf("expected matching session version: %v", success.Reason)
	}

	missing := registry.Evaluate(ctx, caveat, EvaluationContext{})
	if missing.Satisfied {
		t.Fatalf("expected missing session map to fail")
	}

	mismatch := registry.Evaluate(ctx, caveat, EvaluationContext{
		SessionVersions: map[string]uint64{"sess-1": 99},
	})
	if mismatch.Satisfied {
		t.Fatalf("expected mismatched version to fail")
	}
}

func TestEvaluateFailureModes(t *testing.T) {
	registry := NewRegistry()
	ctx := context.Background()

	if result := registry.Evaluate(ctx, nil, EvaluationContext{}); result.Satisfied {
		t.Fatalf("nil caveat should fail")
	}

	thirdParty := &corksv1.Caveat{
		CaveatVersion: 1,
		CaveatId:      []byte{0x1},
		Body:          &corksv1.Caveat_ThirdParty{ThirdParty: &corksv1.ThirdPartyCaveat{Location: "https://example.com"}},
	}
	if result := registry.Evaluate(ctx, thirdParty, EvaluationContext{}); result.Satisfied {
		t.Fatalf("third-party caveat should fail")
	}

	unknownNamespace := &corksv1.Caveat{
		CaveatVersion: 1,
		CaveatId:      []byte{0x2},
		Body: &corksv1.Caveat_FirstParty{FirstParty: &corksv1.FirstPartyCaveat{
			Namespace: "other.namespace",
			Predicate: PredicateActionScope,
		}},
	}
	if result := registry.Evaluate(ctx, unknownNamespace, EvaluationContext{}); result.Satisfied {
		t.Fatalf("unexpected namespace should fail")
	}

	unknownPredicate := &corksv1.Caveat{
		CaveatVersion: 1,
		CaveatId:      []byte{0x3},
		Body: &corksv1.Caveat_FirstParty{FirstParty: &corksv1.FirstPartyCaveat{
			Namespace: AuthNamespace,
			Predicate: "unknown",
		}},
	}
	if result := registry.Evaluate(ctx, unknownPredicate, EvaluationContext{}); result.Satisfied {
		t.Fatalf("unknown predicate should fail")
	}

	missingPayload := &corksv1.Caveat{
		CaveatVersion: 1,
		CaveatId:      []byte{0x4},
		Body: &corksv1.Caveat_FirstParty{FirstParty: &corksv1.FirstPartyCaveat{
			Namespace: AuthNamespace,
			Predicate: PredicateActionScope,
		}},
	}
	if result := registry.Evaluate(ctx, missingPayload, EvaluationContext{}); result.Satisfied {
		t.Fatalf("missing payload should fail")
	}
}

func mustFirstPartyCaveat(predicate string, payload proto.Message) *corksv1.Caveat {
	packed, err := corksproto.MarshalAny(payload)
	if err != nil {
		panic(err)
	}
	return &corksv1.Caveat{
		CaveatVersion: 1,
		CaveatId:      []byte{0x1},
		Body: &corksv1.Caveat_FirstParty{FirstParty: &corksv1.FirstPartyCaveat{
			Namespace: AuthNamespace,
			Predicate: predicate,
			Payload:   packed,
		}},
	}
}
