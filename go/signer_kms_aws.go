package corks

import (
	"bytes"
	"context"
	"errors"
	"fmt"

	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/service/kms"
	"github.com/aws/aws-sdk-go-v2/service/kms/types"
)

// awsKMSSignerClient captures the GenerateMac operation required for AWS KMS-backed signing.
type awsKMSSignerClient interface {
	GenerateMac(ctx context.Context, params *kms.GenerateMacInput, optFns ...func(*kms.Options)) (*kms.GenerateMacOutput, error)
}

// AWSKMSSigner derives cork root keys by delegating HMAC-SHA256 computation to AWS KMS.
type AWSKMSSigner struct {
	client    awsKMSSignerClient
	keyARN    string
	corkKeyID []byte
}

// NewAWSKMSSigner constructs a signer backed by AWS KMS. keyARN identifies the KMS HMAC key.
// corkKeyID is the identifier embedded in corks (commonly a shorter alias).
func NewAWSKMSSigner(client awsKMSSignerClient, keyARN string, corkKeyID []byte) *AWSKMSSigner {
	return &AWSKMSSigner{
		client:    client,
		keyARN:    keyARN,
		corkKeyID: append([]byte(nil), corkKeyID...),
	}
}

// KeyID returns the cork key identifier associated with the AWS KMS key.
func (s *AWSKMSSigner) KeyID() []byte {
	return append([]byte(nil), s.corkKeyID...)
}

// DeriveCorkRootKey requests AWS KMS to compute HMAC-SHA256(master_key, nonce || keyID || context).
func (s *AWSKMSSigner) DeriveCorkRootKey(ctx context.Context, nonce, keyID []byte) ([]byte, error) {
	if s.client == nil {
		return nil, errors.New("aws kms signer client nil")
	}
	if !bytes.Equal(s.corkKeyID, keyID) {
		return nil, ErrMismatchedKey
	}
	message := buildRootKeyMessage(nonce, keyID)
	out, err := s.client.GenerateMac(ctx, &kms.GenerateMacInput{
		KeyId:        aws.String(s.keyARN),
		MacAlgorithm: types.MacAlgorithmSpecHmacSha256,
		Message:      message,
	})
	if err != nil {
		return nil, err
	}
	if len(out.Mac) != tagSize {
		return nil, fmt.Errorf("%w: derived root key must be %d bytes", ErrInvalidCork, tagSize)
	}
	return append([]byte(nil), out.Mac...), nil
}
