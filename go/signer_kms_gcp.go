package corks

import (
	"bytes"
	"context"
	"errors"
	"fmt"

	kms "cloud.google.com/go/kms/apiv1"
	kmspb "cloud.google.com/go/kms/apiv1/kmspb"
)

// gcpKMSSignerClient captures the MacSign API required for Google Cloud KMS-backed signing.
type gcpKMSSignerClient interface {
	MacSign(ctx context.Context, req *kmspb.MacSignRequest) (*kmspb.MacSignResponse, error)
}

// GCPKMSSigner derives cork root keys using Google Cloud KMS HMAC keys.
type GCPKMSSigner struct {
	client    gcpKMSSignerClient
	keyName   string
	corkKeyID []byte
}

// NewGCPKMSSigner constructs a signer backed by Google Cloud KMS.
// keyName should be the full resource name of the HMAC key version.
func NewGCPKMSSigner(client gcpKMSSignerClient, keyName string, corkKeyID []byte) *GCPKMSSigner {
	return &GCPKMSSigner{
		client:    client,
		keyName:   keyName,
		corkKeyID: append([]byte(nil), corkKeyID...),
	}
}

// KeyID returns the cork key identifier associated with the KMS key.
func (s *GCPKMSSigner) KeyID() []byte {
	return append([]byte(nil), s.corkKeyID...)
}

// DeriveCorkRootKey requests Google Cloud KMS to compute the HMAC-based root key.
func (s *GCPKMSSigner) DeriveCorkRootKey(ctx context.Context, nonce, keyID []byte) ([]byte, error) {
	if s.client == nil {
		return nil, errors.New("gcp kms signer client nil")
	}
	if !bytes.Equal(s.corkKeyID, keyID) {
		return nil, ErrMismatchedKey
	}
	message := buildRootKeyMessage(nonce, keyID)
	resp, err := s.client.MacSign(ctx, &kmspb.MacSignRequest{
		Name: s.keyName,
		Data: message,
	})
	if err != nil {
		return nil, err
	}
	if len(resp.Mac) != tagSize {
		return nil, fmt.Errorf("%w: derived root key must be %d bytes", ErrInvalidCork, tagSize)
	}
	return append([]byte(nil), resp.Mac...), nil
}

// NewGCPKMSSignerClient constructs a real Google Cloud KMS client.
// Callers are responsible for closing the returned client when done.
func NewGCPKMSSignerClient(ctx context.Context) (*kms.KeyManagementClient, error) {
	return kms.NewKeyManagementClient(ctx)
}
