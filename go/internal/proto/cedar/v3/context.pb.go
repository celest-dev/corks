// Code generated by protoc-gen-go. DO NOT EDIT.
// versions:
// 	protoc-gen-go v1.34.2
// 	protoc        (unknown)
// source: cedar/v3/context.proto

package cedarv3

import (
	protoreflect "google.golang.org/protobuf/reflect/protoreflect"
	protoimpl "google.golang.org/protobuf/runtime/protoimpl"
	reflect "reflect"
	sync "sync"
)

const (
	// Verify that this generated code is sufficiently up-to-date.
	_ = protoimpl.EnforceVersion(20 - protoimpl.MinVersion)
	// Verify that runtime/protoimpl is sufficiently up-to-date.
	_ = protoimpl.EnforceVersion(protoimpl.MaxVersion - 20)
)

type Context struct {
	state         protoimpl.MessageState
	sizeCache     protoimpl.SizeCache
	unknownFields protoimpl.UnknownFields

	Values map[string]*Value `protobuf:"bytes,1,rep,name=values,proto3" json:"values,omitempty" protobuf_key:"bytes,1,opt,name=key,proto3" protobuf_val:"bytes,2,opt,name=value,proto3"`
}

func (x *Context) Reset() {
	*x = Context{}
	if protoimpl.UnsafeEnabled {
		mi := &file_cedar_v3_context_proto_msgTypes[0]
		ms := protoimpl.X.MessageStateOf(protoimpl.Pointer(x))
		ms.StoreMessageInfo(mi)
	}
}

func (x *Context) String() string {
	return protoimpl.X.MessageStringOf(x)
}

func (*Context) ProtoMessage() {}

func (x *Context) ProtoReflect() protoreflect.Message {
	mi := &file_cedar_v3_context_proto_msgTypes[0]
	if protoimpl.UnsafeEnabled && x != nil {
		ms := protoimpl.X.MessageStateOf(protoimpl.Pointer(x))
		if ms.LoadMessageInfo() == nil {
			ms.StoreMessageInfo(mi)
		}
		return ms
	}
	return mi.MessageOf(x)
}

// Deprecated: Use Context.ProtoReflect.Descriptor instead.
func (*Context) Descriptor() ([]byte, []int) {
	return file_cedar_v3_context_proto_rawDescGZIP(), []int{0}
}

func (x *Context) GetValues() map[string]*Value {
	if x != nil {
		return x.Values
	}
	return nil
}

var File_cedar_v3_context_proto protoreflect.FileDescriptor

var file_cedar_v3_context_proto_rawDesc = []byte{
	0x0a, 0x16, 0x63, 0x65, 0x64, 0x61, 0x72, 0x2f, 0x76, 0x33, 0x2f, 0x63, 0x6f, 0x6e, 0x74, 0x65,
	0x78, 0x74, 0x2e, 0x70, 0x72, 0x6f, 0x74, 0x6f, 0x12, 0x08, 0x63, 0x65, 0x64, 0x61, 0x72, 0x2e,
	0x76, 0x33, 0x1a, 0x14, 0x63, 0x65, 0x64, 0x61, 0x72, 0x2f, 0x76, 0x33, 0x2f, 0x76, 0x61, 0x6c,
	0x75, 0x65, 0x2e, 0x70, 0x72, 0x6f, 0x74, 0x6f, 0x22, 0x8c, 0x01, 0x0a, 0x07, 0x43, 0x6f, 0x6e,
	0x74, 0x65, 0x78, 0x74, 0x12, 0x35, 0x0a, 0x06, 0x76, 0x61, 0x6c, 0x75, 0x65, 0x73, 0x18, 0x01,
	0x20, 0x03, 0x28, 0x0b, 0x32, 0x1d, 0x2e, 0x63, 0x65, 0x64, 0x61, 0x72, 0x2e, 0x76, 0x33, 0x2e,
	0x43, 0x6f, 0x6e, 0x74, 0x65, 0x78, 0x74, 0x2e, 0x56, 0x61, 0x6c, 0x75, 0x65, 0x73, 0x45, 0x6e,
	0x74, 0x72, 0x79, 0x52, 0x06, 0x76, 0x61, 0x6c, 0x75, 0x65, 0x73, 0x1a, 0x4a, 0x0a, 0x0b, 0x56,
	0x61, 0x6c, 0x75, 0x65, 0x73, 0x45, 0x6e, 0x74, 0x72, 0x79, 0x12, 0x10, 0x0a, 0x03, 0x6b, 0x65,
	0x79, 0x18, 0x01, 0x20, 0x01, 0x28, 0x09, 0x52, 0x03, 0x6b, 0x65, 0x79, 0x12, 0x25, 0x0a, 0x05,
	0x76, 0x61, 0x6c, 0x75, 0x65, 0x18, 0x02, 0x20, 0x01, 0x28, 0x0b, 0x32, 0x0f, 0x2e, 0x63, 0x65,
	0x64, 0x61, 0x72, 0x2e, 0x76, 0x33, 0x2e, 0x56, 0x61, 0x6c, 0x75, 0x65, 0x52, 0x05, 0x76, 0x61,
	0x6c, 0x75, 0x65, 0x3a, 0x02, 0x38, 0x01, 0x42, 0x9d, 0x01, 0x0a, 0x0c, 0x63, 0x6f, 0x6d, 0x2e,
	0x63, 0x65, 0x64, 0x61, 0x72, 0x2e, 0x76, 0x33, 0x42, 0x0c, 0x43, 0x6f, 0x6e, 0x74, 0x65, 0x78,
	0x74, 0x50, 0x72, 0x6f, 0x74, 0x6f, 0x50, 0x01, 0x5a, 0x3e, 0x67, 0x69, 0x74, 0x68, 0x75, 0x62,
	0x2e, 0x63, 0x6f, 0x6d, 0x2f, 0x63, 0x65, 0x6c, 0x65, 0x73, 0x74, 0x2d, 0x64, 0x65, 0x76, 0x2f,
	0x63, 0x6f, 0x72, 0x6b, 0x73, 0x2f, 0x67, 0x6f, 0x2f, 0x69, 0x6e, 0x74, 0x65, 0x72, 0x6e, 0x61,
	0x6c, 0x2f, 0x70, 0x72, 0x6f, 0x74, 0x6f, 0x2f, 0x63, 0x65, 0x64, 0x61, 0x72, 0x2f, 0x76, 0x33,
	0x3b, 0x63, 0x65, 0x64, 0x61, 0x72, 0x76, 0x33, 0xa2, 0x02, 0x03, 0x43, 0x58, 0x58, 0xaa, 0x02,
	0x08, 0x43, 0x65, 0x64, 0x61, 0x72, 0x2e, 0x56, 0x33, 0xca, 0x02, 0x08, 0x43, 0x65, 0x64, 0x61,
	0x72, 0x5c, 0x56, 0x33, 0xe2, 0x02, 0x14, 0x43, 0x65, 0x64, 0x61, 0x72, 0x5c, 0x56, 0x33, 0x5c,
	0x47, 0x50, 0x42, 0x4d, 0x65, 0x74, 0x61, 0x64, 0x61, 0x74, 0x61, 0xea, 0x02, 0x09, 0x43, 0x65,
	0x64, 0x61, 0x72, 0x3a, 0x3a, 0x56, 0x33, 0x62, 0x06, 0x70, 0x72, 0x6f, 0x74, 0x6f, 0x33,
}

var (
	file_cedar_v3_context_proto_rawDescOnce sync.Once
	file_cedar_v3_context_proto_rawDescData = file_cedar_v3_context_proto_rawDesc
)

func file_cedar_v3_context_proto_rawDescGZIP() []byte {
	file_cedar_v3_context_proto_rawDescOnce.Do(func() {
		file_cedar_v3_context_proto_rawDescData = protoimpl.X.CompressGZIP(file_cedar_v3_context_proto_rawDescData)
	})
	return file_cedar_v3_context_proto_rawDescData
}

var file_cedar_v3_context_proto_msgTypes = make([]protoimpl.MessageInfo, 2)
var file_cedar_v3_context_proto_goTypes = []any{
	(*Context)(nil), // 0: cedar.v3.Context
	nil,             // 1: cedar.v3.Context.ValuesEntry
	(*Value)(nil),   // 2: cedar.v3.Value
}
var file_cedar_v3_context_proto_depIdxs = []int32{
	1, // 0: cedar.v3.Context.values:type_name -> cedar.v3.Context.ValuesEntry
	2, // 1: cedar.v3.Context.ValuesEntry.value:type_name -> cedar.v3.Value
	2, // [2:2] is the sub-list for method output_type
	2, // [2:2] is the sub-list for method input_type
	2, // [2:2] is the sub-list for extension type_name
	2, // [2:2] is the sub-list for extension extendee
	0, // [0:2] is the sub-list for field type_name
}

func init() { file_cedar_v3_context_proto_init() }
func file_cedar_v3_context_proto_init() {
	if File_cedar_v3_context_proto != nil {
		return
	}
	file_cedar_v3_value_proto_init()
	if !protoimpl.UnsafeEnabled {
		file_cedar_v3_context_proto_msgTypes[0].Exporter = func(v any, i int) any {
			switch v := v.(*Context); i {
			case 0:
				return &v.state
			case 1:
				return &v.sizeCache
			case 2:
				return &v.unknownFields
			default:
				return nil
			}
		}
	}
	type x struct{}
	out := protoimpl.TypeBuilder{
		File: protoimpl.DescBuilder{
			GoPackagePath: reflect.TypeOf(x{}).PkgPath(),
			RawDescriptor: file_cedar_v3_context_proto_rawDesc,
			NumEnums:      0,
			NumMessages:   2,
			NumExtensions: 0,
			NumServices:   0,
		},
		GoTypes:           file_cedar_v3_context_proto_goTypes,
		DependencyIndexes: file_cedar_v3_context_proto_depIdxs,
		MessageInfos:      file_cedar_v3_context_proto_msgTypes,
	}.Build()
	File_cedar_v3_context_proto = out.File
	file_cedar_v3_context_proto_rawDesc = nil
	file_cedar_v3_context_proto_goTypes = nil
	file_cedar_v3_context_proto_depIdxs = nil
}
