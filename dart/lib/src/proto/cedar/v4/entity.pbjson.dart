// This is a generated file - do not edit.
//
// Generated from cedar/v4/entity.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use entityDescriptor instead')
const Entity$json = {
  '1': 'Entity',
  '2': [
    {
      '1': 'uid',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.cedar.v4.EntityUid',
      '10': 'uid'
    },
    {
      '1': 'parents',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.cedar.v4.EntityUid',
      '10': 'parents'
    },
    {
      '1': 'attributes',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.cedar.v4.Entity.AttributesEntry',
      '10': 'attributes'
    },
    {
      '1': 'tags',
      '3': 4,
      '4': 3,
      '5': 11,
      '6': '.cedar.v4.Entity.TagsEntry',
      '10': 'tags'
    },
  ],
  '3': [Entity_AttributesEntry$json, Entity_TagsEntry$json],
};

@$core.Deprecated('Use entityDescriptor instead')
const Entity_AttributesEntry$json = {
  '1': 'AttributesEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {
      '1': 'value',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.cedar.v4.Value',
      '10': 'value'
    },
  ],
  '7': {'7': true},
};

@$core.Deprecated('Use entityDescriptor instead')
const Entity_TagsEntry$json = {
  '1': 'TagsEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {
      '1': 'value',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.cedar.v4.Value',
      '10': 'value'
    },
  ],
  '7': {'7': true},
};

/// Descriptor for `Entity`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List entityDescriptor = $convert.base64Decode(
    'CgZFbnRpdHkSJQoDdWlkGAEgASgLMhMuY2VkYXIudjQuRW50aXR5VWlkUgN1aWQSLQoHcGFyZW'
    '50cxgCIAMoCzITLmNlZGFyLnY0LkVudGl0eVVpZFIHcGFyZW50cxJACgphdHRyaWJ1dGVzGAMg'
    'AygLMiAuY2VkYXIudjQuRW50aXR5LkF0dHJpYnV0ZXNFbnRyeVIKYXR0cmlidXRlcxIuCgR0YW'
    'dzGAQgAygLMhouY2VkYXIudjQuRW50aXR5LlRhZ3NFbnRyeVIEdGFncxpOCg9BdHRyaWJ1dGVz'
    'RW50cnkSEAoDa2V5GAEgASgJUgNrZXkSJQoFdmFsdWUYAiABKAsyDy5jZWRhci52NC5WYWx1ZV'
    'IFdmFsdWU6AjgBGkgKCVRhZ3NFbnRyeRIQCgNrZXkYASABKAlSA2tleRIlCgV2YWx1ZRgCIAEo'
    'CzIPLmNlZGFyLnY0LlZhbHVlUgV2YWx1ZToCOAE=');
