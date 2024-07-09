//
//  Generated code. Do not modify.
//  source: cedar/v3/cork.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use corkDescriptor instead')
const Cork$json = {
  '1': 'Cork',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 12, '10': 'id'},
    {'1': 'issuer', '3': 2, '4': 1, '5': 11, '6': '.cedar.v3.EntityId', '10': 'issuer'},
    {'1': 'bearer', '3': 3, '4': 1, '5': 11, '6': '.cedar.v3.EntityId', '10': 'bearer'},
    {'1': 'audience', '3': 4, '4': 1, '5': 11, '6': '.cedar.v3.EntityId', '9': 0, '10': 'audience', '17': true},
    {'1': 'claims', '3': 5, '4': 1, '5': 11, '6': '.cedar.v3.Entity', '9': 1, '10': 'claims', '17': true},
    {'1': 'caveats', '3': 6, '4': 3, '5': 11, '6': '.cedar.v3.Caveat', '10': 'caveats'},
  ],
  '8': [
    {'1': '_audience'},
    {'1': '_claims'},
  ],
};

/// Descriptor for `Cork`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List corkDescriptor = $convert.base64Decode(
    'CgRDb3JrEg4KAmlkGAEgASgMUgJpZBIqCgZpc3N1ZXIYAiABKAsyEi5jZWRhci52My5FbnRpdH'
    'lJZFIGaXNzdWVyEioKBmJlYXJlchgDIAEoCzISLmNlZGFyLnYzLkVudGl0eUlkUgZiZWFyZXIS'
    'MwoIYXVkaWVuY2UYBCABKAsyEi5jZWRhci52My5FbnRpdHlJZEgAUghhdWRpZW5jZYgBARItCg'
    'ZjbGFpbXMYBSABKAsyEC5jZWRhci52My5FbnRpdHlIAVIGY2xhaW1ziAEBEioKB2NhdmVhdHMY'
    'BiADKAsyEC5jZWRhci52My5DYXZlYXRSB2NhdmVhdHNCCwoJX2F1ZGllbmNlQgkKB19jbGFpbX'
    'M=');

@$core.Deprecated('Use caveatDescriptor instead')
const Caveat$json = {
  '1': 'Caveat',
  '2': [
    {'1': 'policy_id', '3': 1, '4': 1, '5': 9, '9': 0, '10': 'policyId'},
    {'1': 'policy', '3': 2, '4': 1, '5': 11, '6': '.cedar.v3.Policy', '9': 0, '10': 'policy'},
  ],
  '8': [
    {'1': 'caveat'},
  ],
};

/// Descriptor for `Caveat`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List caveatDescriptor = $convert.base64Decode(
    'CgZDYXZlYXQSHQoJcG9saWN5X2lkGAEgASgJSABSCHBvbGljeUlkEioKBnBvbGljeRgCIAEoCz'
    'IQLmNlZGFyLnYzLlBvbGljeUgAUgZwb2xpY3lCCAoGY2F2ZWF0');

