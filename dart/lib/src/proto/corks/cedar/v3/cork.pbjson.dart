//
//  Generated code. Do not modify.
//  source: corks/cedar/v3/cork.proto
//
// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use cedarCorkDescriptor instead')
const CedarCork$json = {
  '1': 'CedarCork',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 12, '10': 'id'},
    {
      '1': 'issuer',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.cedar.v3.EntityUid',
      '10': 'issuer'
    },
    {
      '1': 'bearer',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.cedar.v3.EntityUid',
      '10': 'bearer'
    },
    {
      '1': 'audience',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.cedar.v3.EntityUid',
      '9': 0,
      '10': 'audience',
      '17': true
    },
    {
      '1': 'claims',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.cedar.v3.Entity',
      '9': 1,
      '10': 'claims',
      '17': true
    },
    {
      '1': 'caveats',
      '3': 6,
      '4': 3,
      '5': 11,
      '6': '.cedar.v3.Expr',
      '10': 'caveats'
    },
    {'1': 'signature', '3': 999, '4': 1, '5': 12, '10': 'signature'},
  ],
  '8': [
    {'1': '_audience'},
    {'1': '_claims'},
  ],
};

/// Descriptor for `CedarCork`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cedarCorkDescriptor = $convert.base64Decode(
    'CglDZWRhckNvcmsSDgoCaWQYASABKAxSAmlkEisKBmlzc3VlchgCIAEoCzITLmNlZGFyLnYzLk'
    'VudGl0eVVpZFIGaXNzdWVyEisKBmJlYXJlchgDIAEoCzITLmNlZGFyLnYzLkVudGl0eVVpZFIG'
    'YmVhcmVyEjQKCGF1ZGllbmNlGAQgASgLMhMuY2VkYXIudjMuRW50aXR5VWlkSABSCGF1ZGllbm'
    'NliAEBEi0KBmNsYWltcxgFIAEoCzIQLmNlZGFyLnYzLkVudGl0eUgBUgZjbGFpbXOIAQESKAoH'
    'Y2F2ZWF0cxgGIAMoCzIOLmNlZGFyLnYzLkV4cHJSB2NhdmVhdHMSHQoJc2lnbmF0dXJlGOcHIA'
    'EoDFIJc2lnbmF0dXJlQgsKCV9hdWRpZW5jZUIJCgdfY2xhaW1z');
