package corks

import (
	"context"
	"errors"
	"testing"

	kmspb "cloud.google.com/go/kms/apiv1/kmspb"
	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/service/kms"
	"github.com/aws/aws-sdk-go-v2/service/kms/types"
	"github.com/stretchr/testify/require"
)

type mockAWSKMSClient struct {
	input  *kms.GenerateMacInput
	output *kms.GenerateMacOutput
	err    error
}

func (m *mockAWSKMSClient) GenerateMac(ctx context.Context, in *kms.GenerateMacInput, optFns ...func(*kms.Options)) (*kms.GenerateMacOutput, error) {
	m.input = in
	return m.output, m.err
}

func TestAWSKMSSigner(t *testing.T) {
	keyID := []byte("cork-key")
	mac := make([]byte, tagSize)
	mock := &mockAWSKMSClient{
		output: &kms.GenerateMacOutput{Mac: mac},
	}
	signer := NewAWSKMSSigner(mock, "arn:aws:kms:us-west-2:123:key/abc", keyID)
	nonce := make([]byte, nonceSize)

	derived, err := signer.DeriveCorkRootKey(context.Background(), nonce, keyID)
	require.NoError(t, err)
	require.Equal(t, mac, derived)
	require.NotNil(t, mock.input)
	require.Equal(t, types.MacAlgorithmSpecHmacSha256, mock.input.MacAlgorithm)
	require.Equal(t, "arn:aws:kms:us-west-2:123:key/abc", aws.ToString(mock.input.KeyId))
	message := buildRootKeyMessage(nonce, keyID)
	require.Equal(t, message, mock.input.Message)

	// mismatched key
	_, err = signer.DeriveCorkRootKey(context.Background(), nonce, []byte("other"))
	require.ErrorIs(t, err, ErrMismatchedKey)

	// short MAC
	mock.output = &kms.GenerateMacOutput{Mac: make([]byte, 8)}
	_, err = signer.DeriveCorkRootKey(context.Background(), nonce, keyID)
	require.ErrorIs(t, err, ErrInvalidCork)

	// propagated error
	mock.err = errors.New("kms failure")
	_, err = signer.DeriveCorkRootKey(context.Background(), nonce, keyID)
	require.ErrorIs(t, err, mock.err)
}

type mockGCPKMSClient struct {
	request  *kmspb.MacSignRequest
	response *kmspb.MacSignResponse
	err      error
}

func (m *mockGCPKMSClient) MacSign(ctx context.Context, req *kmspb.MacSignRequest) (*kmspb.MacSignResponse, error) {
	m.request = req
	return m.response, m.err
}

func TestGCPKMSSigner(t *testing.T) {
	keyID := []byte("cork-key")
	mac := make([]byte, tagSize)
	mock := &mockGCPKMSClient{
		response: &kmspb.MacSignResponse{Mac: mac},
	}
	signer := NewGCPKMSSigner(mock, "projects/p/locations/l/keyRings/r/cryptoKeys/k/cryptoKeyVersions/1", keyID)
	nonce := make([]byte, nonceSize)

	derived, err := signer.DeriveCorkRootKey(context.Background(), nonce, keyID)
	require.NoError(t, err)
	require.Equal(t, mac, derived)
	require.NotNil(t, mock.request)
	require.Equal(t, signer.keyName, mock.request.Name)
	require.Equal(t, buildRootKeyMessage(nonce, keyID), mock.request.Data)

	// mismatched key
	_, err = signer.DeriveCorkRootKey(context.Background(), nonce, []byte("other"))
	require.ErrorIs(t, err, ErrMismatchedKey)

	// short MAC
	mock.response = &kmspb.MacSignResponse{Mac: make([]byte, 8)}
	_, err = signer.DeriveCorkRootKey(context.Background(), nonce, keyID)
	require.ErrorIs(t, err, ErrInvalidCork)

	// propagated error
	mock.err = errors.New("mac sign failure")
	_, err = signer.DeriveCorkRootKey(context.Background(), nonce, keyID)
	require.ErrorIs(t, err, mock.err)
}
