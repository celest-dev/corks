//
//  Generated code. Do not modify.
//  source: corks/v1/cork.proto
//
// @dart = 3.3

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
    {
      '1': 'issuer',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Any',
      '10': 'issuer'
    },
    {
      '1': 'bearer',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Any',
      '10': 'bearer'
    },
    {
      '1': 'audience',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Any',
      '9': 0,
      '10': 'audience',
      '17': true
    },
    {
      '1': 'claims',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Any',
      '9': 1,
      '10': 'claims',
      '17': true
    },
    {
      '1': 'caveats',
      '3': 6,
      '4': 3,
      '5': 11,
      '6': '.google.protobuf.Any',
      '10': 'caveats'
    },
    {'1': 'signature', '3': 999, '4': 1, '5': 12, '10': 'signature'},
  ],
  '8': [
    {'1': '_audience'},
    {'1': '_claims'},
  ],
};

/// Descriptor for `Cork`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List corkDescriptor = $convert.base64Decode(
    'CgRDb3JrEg4KAmlkGAEgASgMUgJpZBIsCgZpc3N1ZXIYAiABKAsyFC5nb29nbGUucHJvdG9idW'
    'YuQW55UgZpc3N1ZXISLAoGYmVhcmVyGAMgASgLMhQuZ29vZ2xlLnByb3RvYnVmLkFueVIGYmVh'
    'cmVyEjUKCGF1ZGllbmNlGAQgASgLMhQuZ29vZ2xlLnByb3RvYnVmLkFueUgAUghhdWRpZW5jZY'
    'gBARIxCgZjbGFpbXMYBSABKAsyFC5nb29nbGUucHJvdG9idWYuQW55SAFSBmNsYWltc4gBARIu'
    'CgdjYXZlYXRzGAYgAygLMhQuZ29vZ2xlLnByb3RvYnVmLkFueVIHY2F2ZWF0cxIdCglzaWduYX'
    'R1cmUY5wcgASgMUglzaWduYXR1cmVCCwoJX2F1ZGllbmNlQgkKB19jbGFpbXM=');
