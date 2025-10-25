// This is a generated file - do not edit.
//
// Generated from corks/v1/cork.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use corkDescriptor instead')
const Cork$json = {
  '1': 'Cork',
  '2': [
    {'1': 'version', '3': 1, '4': 1, '5': 13, '10': 'version'},
    {'1': 'nonce', '3': 2, '4': 1, '5': 12, '10': 'nonce'},
    {'1': 'key_id', '3': 3, '4': 1, '5': 12, '10': 'keyId'},
    {
      '1': 'issuer',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Any',
      '10': 'issuer'
    },
    {
      '1': 'bearer',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Any',
      '10': 'bearer'
    },
    {
      '1': 'audience',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Any',
      '10': 'audience'
    },
    {
      '1': 'claims',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Any',
      '10': 'claims'
    },
    {
      '1': 'caveats',
      '3': 8,
      '4': 3,
      '5': 11,
      '6': '.celest.corks.v1.Caveat',
      '10': 'caveats'
    },
    {'1': 'tail_signature', '3': 9, '4': 1, '5': 12, '10': 'tailSignature'},
    {'1': 'issued_at', '3': 10, '4': 1, '5': 4, '10': 'issuedAt'},
    {'1': 'not_after', '3': 11, '4': 1, '5': 4, '10': 'notAfter'},
  ],
};

/// Descriptor for `Cork`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List corkDescriptor = $convert.base64Decode(
    'CgRDb3JrEhgKB3ZlcnNpb24YASABKA1SB3ZlcnNpb24SFAoFbm9uY2UYAiABKAxSBW5vbmNlEh'
    'UKBmtleV9pZBgDIAEoDFIFa2V5SWQSLAoGaXNzdWVyGAQgASgLMhQuZ29vZ2xlLnByb3RvYnVm'
    'LkFueVIGaXNzdWVyEiwKBmJlYXJlchgFIAEoCzIULmdvb2dsZS5wcm90b2J1Zi5BbnlSBmJlYX'
    'JlchIwCghhdWRpZW5jZRgGIAEoCzIULmdvb2dsZS5wcm90b2J1Zi5BbnlSCGF1ZGllbmNlEiwK'
    'BmNsYWltcxgHIAEoCzIULmdvb2dsZS5wcm90b2J1Zi5BbnlSBmNsYWltcxIxCgdjYXZlYXRzGA'
    'ggAygLMhcuY2VsZXN0LmNvcmtzLnYxLkNhdmVhdFIHY2F2ZWF0cxIlCg50YWlsX3NpZ25hdHVy'
    'ZRgJIAEoDFINdGFpbFNpZ25hdHVyZRIbCglpc3N1ZWRfYXQYCiABKARSCGlzc3VlZEF0EhsKCW'
    '5vdF9hZnRlchgLIAEoBFIIbm90QWZ0ZXI=');

@$core.Deprecated('Use caveatDescriptor instead')
const Caveat$json = {
  '1': 'Caveat',
  '2': [
    {'1': 'caveat_version', '3': 1, '4': 1, '5': 13, '10': 'caveatVersion'},
    {'1': 'caveat_id', '3': 2, '4': 1, '5': 12, '10': 'caveatId'},
    {
      '1': 'first_party',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.celest.corks.v1.FirstPartyCaveat',
      '9': 0,
      '10': 'firstParty'
    },
    {
      '1': 'third_party',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.celest.corks.v1.ThirdPartyCaveat',
      '9': 0,
      '10': 'thirdParty'
    },
  ],
  '8': [
    {'1': 'body'},
  ],
};

/// Descriptor for `Caveat`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List caveatDescriptor = $convert.base64Decode(
    'CgZDYXZlYXQSJQoOY2F2ZWF0X3ZlcnNpb24YASABKA1SDWNhdmVhdFZlcnNpb24SGwoJY2F2ZW'
    'F0X2lkGAIgASgMUghjYXZlYXRJZBJECgtmaXJzdF9wYXJ0eRgDIAEoCzIhLmNlbGVzdC5jb3Jr'
    'cy52MS5GaXJzdFBhcnR5Q2F2ZWF0SABSCmZpcnN0UGFydHkSRAoLdGhpcmRfcGFydHkYBCABKA'
    'syIS5jZWxlc3QuY29ya3MudjEuVGhpcmRQYXJ0eUNhdmVhdEgAUgp0aGlyZFBhcnR5QgYKBGJv'
    'ZHk=');

@$core.Deprecated('Use firstPartyCaveatDescriptor instead')
const FirstPartyCaveat$json = {
  '1': 'FirstPartyCaveat',
  '2': [
    {'1': 'namespace', '3': 1, '4': 1, '5': 9, '10': 'namespace'},
    {'1': 'predicate', '3': 2, '4': 1, '5': 9, '10': 'predicate'},
    {
      '1': 'payload',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Any',
      '10': 'payload'
    },
  ],
};

/// Descriptor for `FirstPartyCaveat`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List firstPartyCaveatDescriptor = $convert.base64Decode(
    'ChBGaXJzdFBhcnR5Q2F2ZWF0EhwKCW5hbWVzcGFjZRgBIAEoCVIJbmFtZXNwYWNlEhwKCXByZW'
    'RpY2F0ZRgCIAEoCVIJcHJlZGljYXRlEi4KB3BheWxvYWQYAyABKAsyFC5nb29nbGUucHJvdG9i'
    'dWYuQW55UgdwYXlsb2Fk');

@$core.Deprecated('Use thirdPartyCaveatDescriptor instead')
const ThirdPartyCaveat$json = {
  '1': 'ThirdPartyCaveat',
  '2': [
    {'1': 'location', '3': 1, '4': 1, '5': 9, '10': 'location'},
    {'1': 'ticket', '3': 2, '4': 1, '5': 12, '10': 'ticket'},
    {'1': 'challenge', '3': 3, '4': 1, '5': 12, '10': 'challenge'},
    {'1': 'salt', '3': 4, '4': 1, '5': 12, '10': 'salt'},
  ],
};

/// Descriptor for `ThirdPartyCaveat`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List thirdPartyCaveatDescriptor = $convert.base64Decode(
    'ChBUaGlyZFBhcnR5Q2F2ZWF0EhoKCGxvY2F0aW9uGAEgASgJUghsb2NhdGlvbhIWCgZ0aWNrZX'
    'QYAiABKAxSBnRpY2tldBIcCgljaGFsbGVuZ2UYAyABKAxSCWNoYWxsZW5nZRISCgRzYWx0GAQg'
    'ASgMUgRzYWx0');

@$core.Deprecated('Use dischargeDescriptor instead')
const Discharge$json = {
  '1': 'Discharge',
  '2': [
    {'1': 'version', '3': 1, '4': 1, '5': 13, '10': 'version'},
    {'1': 'nonce', '3': 2, '4': 1, '5': 12, '10': 'nonce'},
    {'1': 'key_id', '3': 3, '4': 1, '5': 12, '10': 'keyId'},
    {'1': 'parent_caveat_id', '3': 4, '4': 1, '5': 12, '10': 'parentCaveatId'},
    {
      '1': 'issuer',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Any',
      '10': 'issuer'
    },
    {
      '1': 'caveats',
      '3': 6,
      '4': 3,
      '5': 11,
      '6': '.celest.corks.v1.Caveat',
      '10': 'caveats'
    },
    {'1': 'tail_signature', '3': 7, '4': 1, '5': 12, '10': 'tailSignature'},
    {'1': 'issued_at', '3': 8, '4': 1, '5': 4, '10': 'issuedAt'},
    {'1': 'not_after', '3': 9, '4': 1, '5': 4, '10': 'notAfter'},
  ],
};

/// Descriptor for `Discharge`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List dischargeDescriptor = $convert.base64Decode(
    'CglEaXNjaGFyZ2USGAoHdmVyc2lvbhgBIAEoDVIHdmVyc2lvbhIUCgVub25jZRgCIAEoDFIFbm'
    '9uY2USFQoGa2V5X2lkGAMgASgMUgVrZXlJZBIoChBwYXJlbnRfY2F2ZWF0X2lkGAQgASgMUg5w'
    'YXJlbnRDYXZlYXRJZBIsCgZpc3N1ZXIYBSABKAsyFC5nb29nbGUucHJvdG9idWYuQW55UgZpc3'
    'N1ZXISMQoHY2F2ZWF0cxgGIAMoCzIXLmNlbGVzdC5jb3Jrcy52MS5DYXZlYXRSB2NhdmVhdHMS'
    'JQoOdGFpbF9zaWduYXR1cmUYByABKAxSDXRhaWxTaWduYXR1cmUSGwoJaXNzdWVkX2F0GAggAS'
    'gEUghpc3N1ZWRBdBIbCglub3RfYWZ0ZXIYCSABKARSCG5vdEFmdGVy');

@$core.Deprecated('Use expiryDescriptor instead')
const Expiry$json = {
  '1': 'Expiry',
  '2': [
    {'1': 'not_after', '3': 1, '4': 1, '5': 4, '10': 'notAfter'},
  ],
};

/// Descriptor for `Expiry`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List expiryDescriptor = $convert
    .base64Decode('CgZFeHBpcnkSGwoJbm90X2FmdGVyGAEgASgEUghub3RBZnRlcg==');

@$core.Deprecated('Use organizationScopeDescriptor instead')
const OrganizationScope$json = {
  '1': 'OrganizationScope',
  '2': [
    {'1': 'organization_id', '3': 1, '4': 1, '5': 9, '10': 'organizationId'},
    {'1': 'project_id', '3': 2, '4': 1, '5': 9, '10': 'projectId'},
    {'1': 'environment_id', '3': 3, '4': 1, '5': 9, '10': 'environmentId'},
  ],
};

/// Descriptor for `OrganizationScope`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List organizationScopeDescriptor = $convert.base64Decode(
    'ChFPcmdhbml6YXRpb25TY29wZRInCg9vcmdhbml6YXRpb25faWQYASABKAlSDm9yZ2FuaXphdG'
    'lvbklkEh0KCnByb2plY3RfaWQYAiABKAlSCXByb2plY3RJZBIlCg5lbnZpcm9ubWVudF9pZBgD'
    'IAEoCVINZW52aXJvbm1lbnRJZA==');

@$core.Deprecated('Use actionScopeDescriptor instead')
const ActionScope$json = {
  '1': 'ActionScope',
  '2': [
    {'1': 'actions', '3': 1, '4': 3, '5': 9, '10': 'actions'},
  ],
};

/// Descriptor for `ActionScope`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List actionScopeDescriptor = $convert
    .base64Decode('CgtBY3Rpb25TY29wZRIYCgdhY3Rpb25zGAEgAygJUgdhY3Rpb25z');

@$core.Deprecated('Use ipBindingDescriptor instead')
const IpBinding$json = {
  '1': 'IpBinding',
  '2': [
    {'1': 'cidrs', '3': 1, '4': 3, '5': 9, '10': 'cidrs'},
  ],
};

/// Descriptor for `IpBinding`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List ipBindingDescriptor =
    $convert.base64Decode('CglJcEJpbmRpbmcSFAoFY2lkcnMYASADKAlSBWNpZHJz');

@$core.Deprecated('Use sessionStateDescriptor instead')
const SessionState$json = {
  '1': 'SessionState',
  '2': [
    {'1': 'session_id', '3': 1, '4': 1, '5': 9, '10': 'sessionId'},
    {'1': 'version', '3': 2, '4': 1, '5': 4, '10': 'version'},
  ],
};

/// Descriptor for `SessionState`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sessionStateDescriptor = $convert.base64Decode(
    'CgxTZXNzaW9uU3RhdGUSHQoKc2Vzc2lvbl9pZBgBIAEoCVIJc2Vzc2lvbklkEhgKB3ZlcnNpb2'
    '4YAiABKARSB3ZlcnNpb24=');
