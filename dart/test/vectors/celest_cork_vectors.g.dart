// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'celest_cork_vectors.dart';

// **************************************************************************
// JsonLiteralGenerator
// **************************************************************************

final _$celestCorkVectorsJsonLiteral = {
  'version': 1,
  'signers': {
    'default': {
      'keyId': 'AAECAwQFBgcICQoLDA0ODw==',
      'masterKey': 'EBESExQVFhcYGRobHB0eHyAhIiMkJSYnKCkqKywtLi8=',
    },
  },
  'vectors': [
    {
      'name': 'basic_valid',
      'description': 'Deterministic cork signed with the default key.',
      'signer': 'default',
      'token':
          'CAESGAABAgMEBQYHCAkKCwwNDg8QERITFBUWFxoQAAECAwQFBgcICQoLDA0ODyI-CiZ0eXBlLmdvb2dsZWFwaXMuY29tL2NlZGFyLnYzLkVudGl0eVVpZBIUCgRVc2VyEgxpc3N1ZXItYWxpY2UqPAomdHlwZS5nb29nbGVhcGlzLmNvbS9jZWRhci52My5FbnRpdHlVaWQSEgoEVXNlchIKYmVhcmVyLWJvYjJBCiZ0eXBlLmdvb2dsZWFwaXMuY29tL2NlZGFyLnYzLkVudGl0eVVpZBIXCgdTZXJ2aWNlEgxjZWxlc3QtY2xvdWRKIFV5whrSfrc8kYWAteDQQQgHbudpkLmuIcdBHcM5LxcVUIDox5LMMViAxaOUzDE',
      'tailSignature': {
        'actual': 'VXnCGtJ+tzyRhYC14NBBCAdu52mQua4hx0EdwzkvFxU=',
        'expected': 'VXnCGtJ+tzyRhYC14NBBCAdu52mQua4hx0EdwzkvFxU=',
      },
      'expect': {'signatureValid': true},
      'proto': {
        'version': 1,
        'nonce': 'AAECAwQFBgcICQoLDA0ODxAREhMUFRYX',
        'keyId': 'AAECAwQFBgcICQoLDA0ODw==',
        'issuer': {
          'type': 'User',
          'id': 'issuer-alice',
          '@type': 'type.googleapis.com/cedar.v3.EntityUid',
        },
        'bearer': {
          'type': 'User',
          'id': 'bearer-bob',
          '@type': 'type.googleapis.com/cedar.v3.EntityUid',
        },
        'audience': {
          'type': 'Service',
          'id': 'celest-cloud',
          '@type': 'type.googleapis.com/cedar.v3.EntityUid',
        },
        'tailSignature': 'VXnCGtJ+tzyRhYC14NBBCAdu52mQua4hx0EdwzkvFxU=',
        'issuedAt': '1704067200000',
        'notAfter': '1704070800000',
      },
    },
    {
      'name': 'signature_tampered',
      'description': 'Tail signature first byte flipped to invalidate token.',
      'signer': 'default',
      'token':
          'CAESGAABAgMEBQYHCAkKCwwNDg8QERITFBUWFxoQAAECAwQFBgcICQoLDA0ODyI-CiZ0eXBlLmdvb2dsZWFwaXMuY29tL2NlZGFyLnYzLkVudGl0eVVpZBIUCgRVc2VyEgxpc3N1ZXItYWxpY2UqPAomdHlwZS5nb29nbGVhcGlzLmNvbS9jZWRhci52My5FbnRpdHlVaWQSEgoEVXNlchIKYmVhcmVyLWJvYjJBCiZ0eXBlLmdvb2dsZWFwaXMuY29tL2NlZGFyLnYzLkVudGl0eVVpZBIXCgdTZXJ2aWNlEgxjZWxlc3QtY2xvdWRKIKp5whrSfrc8kYWAteDQQQgHbudpkLmuIcdBHcM5LxcVUIDox5LMMViAxaOUzDE',
      'tailSignature': {
        'actual': 'qnnCGtJ+tzyRhYC14NBBCAdu52mQua4hx0EdwzkvFxU=',
        'expected': 'VXnCGtJ+tzyRhYC14NBBCAdu52mQua4hx0EdwzkvFxU=',
      },
      'expect': {'signatureValid': false},
      'proto': {
        'version': 1,
        'nonce': 'AAECAwQFBgcICQoLDA0ODxAREhMUFRYX',
        'keyId': 'AAECAwQFBgcICQoLDA0ODw==',
        'issuer': {
          'type': 'User',
          'id': 'issuer-alice',
          '@type': 'type.googleapis.com/cedar.v3.EntityUid',
        },
        'bearer': {
          'type': 'User',
          'id': 'bearer-bob',
          '@type': 'type.googleapis.com/cedar.v3.EntityUid',
        },
        'audience': {
          'type': 'Service',
          'id': 'celest-cloud',
          '@type': 'type.googleapis.com/cedar.v3.EntityUid',
        },
        'tailSignature': 'qnnCGtJ+tzyRhYC14NBBCAdu52mQua4hx0EdwzkvFxU=',
        'issuedAt': '1704067200000',
        'notAfter': '1704070800000',
      },
    },
  ],
};
