// Code generated by protoc-gen-go. DO NOT EDIT.
// versions:
// 	protoc-gen-go v1.34.2
// 	protoc        (unknown)
// source: cedar/v3/cork.proto

package cedarv3

import (
	protoreflect "google.golang.org/protobuf/reflect/protoreflect"
	protoimpl "google.golang.org/protobuf/runtime/protoimpl"
	_ "google.golang.org/protobuf/types/known/anypb"
	reflect "reflect"
	sync "sync"
)

const (
	// Verify that this generated code is sufficiently up-to-date.
	_ = protoimpl.EnforceVersion(20 - protoimpl.MinVersion)
	// Verify that runtime/protoimpl is sufficiently up-to-date.
	_ = protoimpl.EnforceVersion(protoimpl.MaxVersion - 20)
)

// A bearer token that can be used to make claims about an entity for the purpose
// of authorization and authentication w/ Cedar.
type Cork struct {
	state         protoimpl.MessageState
	sizeCache     protoimpl.SizeCache
	unknownFields protoimpl.UnknownFields

	// The unique identifier of the cork.
	Id []byte `protobuf:"bytes,1,opt,name=id,proto3" json:"id,omitempty"`
	// The issuing authority of the cork.
	Issuer *EntityId `protobuf:"bytes,2,opt,name=issuer,proto3" json:"issuer,omitempty"`
	// The bearer of the cork, about which [claims] can be made.
	Bearer *EntityId `protobuf:"bytes,3,opt,name=bearer,proto3" json:"bearer,omitempty"`
	// The intended audience of the cork.
	Audience *EntityId `protobuf:"bytes,4,opt,name=audience,proto3,oneof" json:"audience,omitempty"`
	// Claims made about the [bearer] of the cork.
	Claims *Entity `protobuf:"bytes,5,opt,name=claims,proto3,oneof" json:"claims,omitempty"`
	// The caveats to this cork's validity and usage.
	//
	// Caveats are structured conditions which must be met for the cork to be considered
	// valid and for its claims to be considered true.
	//
	// Effectively, these form the body of a `forbid unless` policy AND'd together.
	Caveats []*Expr `protobuf:"bytes,6,rep,name=caveats,proto3" json:"caveats,omitempty"`
	// The final signature of the cork.
	Signature []byte `protobuf:"bytes,999,opt,name=signature,proto3" json:"signature,omitempty"`
}

func (x *Cork) Reset() {
	*x = Cork{}
	if protoimpl.UnsafeEnabled {
		mi := &file_cedar_v3_cork_proto_msgTypes[0]
		ms := protoimpl.X.MessageStateOf(protoimpl.Pointer(x))
		ms.StoreMessageInfo(mi)
	}
}

func (x *Cork) String() string {
	return protoimpl.X.MessageStringOf(x)
}

func (*Cork) ProtoMessage() {}

func (x *Cork) ProtoReflect() protoreflect.Message {
	mi := &file_cedar_v3_cork_proto_msgTypes[0]
	if protoimpl.UnsafeEnabled && x != nil {
		ms := protoimpl.X.MessageStateOf(protoimpl.Pointer(x))
		if ms.LoadMessageInfo() == nil {
			ms.StoreMessageInfo(mi)
		}
		return ms
	}
	return mi.MessageOf(x)
}

// Deprecated: Use Cork.ProtoReflect.Descriptor instead.
func (*Cork) Descriptor() ([]byte, []int) {
	return file_cedar_v3_cork_proto_rawDescGZIP(), []int{0}
}

func (x *Cork) GetId() []byte {
	if x != nil {
		return x.Id
	}
	return nil
}

func (x *Cork) GetIssuer() *EntityId {
	if x != nil {
		return x.Issuer
	}
	return nil
}

func (x *Cork) GetBearer() *EntityId {
	if x != nil {
		return x.Bearer
	}
	return nil
}

func (x *Cork) GetAudience() *EntityId {
	if x != nil {
		return x.Audience
	}
	return nil
}

func (x *Cork) GetClaims() *Entity {
	if x != nil {
		return x.Claims
	}
	return nil
}

func (x *Cork) GetCaveats() []*Expr {
	if x != nil {
		return x.Caveats
	}
	return nil
}

func (x *Cork) GetSignature() []byte {
	if x != nil {
		return x.Signature
	}
	return nil
}

var File_cedar_v3_cork_proto protoreflect.FileDescriptor

var file_cedar_v3_cork_proto_rawDesc = []byte{
	0x0a, 0x13, 0x63, 0x65, 0x64, 0x61, 0x72, 0x2f, 0x76, 0x33, 0x2f, 0x63, 0x6f, 0x72, 0x6b, 0x2e,
	0x70, 0x72, 0x6f, 0x74, 0x6f, 0x12, 0x08, 0x63, 0x65, 0x64, 0x61, 0x72, 0x2e, 0x76, 0x33, 0x1a,
	0x15, 0x63, 0x65, 0x64, 0x61, 0x72, 0x2f, 0x76, 0x33, 0x2f, 0x65, 0x6e, 0x74, 0x69, 0x74, 0x79,
	0x2e, 0x70, 0x72, 0x6f, 0x74, 0x6f, 0x1a, 0x18, 0x63, 0x65, 0x64, 0x61, 0x72, 0x2f, 0x76, 0x33,
	0x2f, 0x65, 0x6e, 0x74, 0x69, 0x74, 0x79, 0x5f, 0x69, 0x64, 0x2e, 0x70, 0x72, 0x6f, 0x74, 0x6f,
	0x1a, 0x13, 0x63, 0x65, 0x64, 0x61, 0x72, 0x2f, 0x76, 0x33, 0x2f, 0x65, 0x78, 0x70, 0x72, 0x2e,
	0x70, 0x72, 0x6f, 0x74, 0x6f, 0x1a, 0x19, 0x67, 0x6f, 0x6f, 0x67, 0x6c, 0x65, 0x2f, 0x70, 0x72,
	0x6f, 0x74, 0x6f, 0x62, 0x75, 0x66, 0x2f, 0x61, 0x6e, 0x79, 0x2e, 0x70, 0x72, 0x6f, 0x74, 0x6f,
	0x22, 0xb3, 0x02, 0x0a, 0x04, 0x43, 0x6f, 0x72, 0x6b, 0x12, 0x0e, 0x0a, 0x02, 0x69, 0x64, 0x18,
	0x01, 0x20, 0x01, 0x28, 0x0c, 0x52, 0x02, 0x69, 0x64, 0x12, 0x2a, 0x0a, 0x06, 0x69, 0x73, 0x73,
	0x75, 0x65, 0x72, 0x18, 0x02, 0x20, 0x01, 0x28, 0x0b, 0x32, 0x12, 0x2e, 0x63, 0x65, 0x64, 0x61,
	0x72, 0x2e, 0x76, 0x33, 0x2e, 0x45, 0x6e, 0x74, 0x69, 0x74, 0x79, 0x49, 0x64, 0x52, 0x06, 0x69,
	0x73, 0x73, 0x75, 0x65, 0x72, 0x12, 0x2a, 0x0a, 0x06, 0x62, 0x65, 0x61, 0x72, 0x65, 0x72, 0x18,
	0x03, 0x20, 0x01, 0x28, 0x0b, 0x32, 0x12, 0x2e, 0x63, 0x65, 0x64, 0x61, 0x72, 0x2e, 0x76, 0x33,
	0x2e, 0x45, 0x6e, 0x74, 0x69, 0x74, 0x79, 0x49, 0x64, 0x52, 0x06, 0x62, 0x65, 0x61, 0x72, 0x65,
	0x72, 0x12, 0x33, 0x0a, 0x08, 0x61, 0x75, 0x64, 0x69, 0x65, 0x6e, 0x63, 0x65, 0x18, 0x04, 0x20,
	0x01, 0x28, 0x0b, 0x32, 0x12, 0x2e, 0x63, 0x65, 0x64, 0x61, 0x72, 0x2e, 0x76, 0x33, 0x2e, 0x45,
	0x6e, 0x74, 0x69, 0x74, 0x79, 0x49, 0x64, 0x48, 0x00, 0x52, 0x08, 0x61, 0x75, 0x64, 0x69, 0x65,
	0x6e, 0x63, 0x65, 0x88, 0x01, 0x01, 0x12, 0x2d, 0x0a, 0x06, 0x63, 0x6c, 0x61, 0x69, 0x6d, 0x73,
	0x18, 0x05, 0x20, 0x01, 0x28, 0x0b, 0x32, 0x10, 0x2e, 0x63, 0x65, 0x64, 0x61, 0x72, 0x2e, 0x76,
	0x33, 0x2e, 0x45, 0x6e, 0x74, 0x69, 0x74, 0x79, 0x48, 0x01, 0x52, 0x06, 0x63, 0x6c, 0x61, 0x69,
	0x6d, 0x73, 0x88, 0x01, 0x01, 0x12, 0x28, 0x0a, 0x07, 0x63, 0x61, 0x76, 0x65, 0x61, 0x74, 0x73,
	0x18, 0x06, 0x20, 0x03, 0x28, 0x0b, 0x32, 0x0e, 0x2e, 0x63, 0x65, 0x64, 0x61, 0x72, 0x2e, 0x76,
	0x33, 0x2e, 0x45, 0x78, 0x70, 0x72, 0x52, 0x07, 0x63, 0x61, 0x76, 0x65, 0x61, 0x74, 0x73, 0x12,
	0x1d, 0x0a, 0x09, 0x73, 0x69, 0x67, 0x6e, 0x61, 0x74, 0x75, 0x72, 0x65, 0x18, 0xe7, 0x07, 0x20,
	0x01, 0x28, 0x0c, 0x52, 0x09, 0x73, 0x69, 0x67, 0x6e, 0x61, 0x74, 0x75, 0x72, 0x65, 0x42, 0x0b,
	0x0a, 0x09, 0x5f, 0x61, 0x75, 0x64, 0x69, 0x65, 0x6e, 0x63, 0x65, 0x42, 0x09, 0x0a, 0x07, 0x5f,
	0x63, 0x6c, 0x61, 0x69, 0x6d, 0x73, 0x42, 0x91, 0x01, 0x0a, 0x0c, 0x63, 0x6f, 0x6d, 0x2e, 0x63,
	0x65, 0x64, 0x61, 0x72, 0x2e, 0x76, 0x33, 0x42, 0x09, 0x43, 0x6f, 0x72, 0x6b, 0x50, 0x72, 0x6f,
	0x74, 0x6f, 0x50, 0x01, 0x5a, 0x35, 0x67, 0x69, 0x74, 0x68, 0x75, 0x62, 0x2e, 0x63, 0x6f, 0x6d,
	0x2f, 0x63, 0x65, 0x6c, 0x65, 0x73, 0x74, 0x2d, 0x64, 0x65, 0x76, 0x2f, 0x63, 0x6f, 0x72, 0x6b,
	0x73, 0x2f, 0x67, 0x6f, 0x2f, 0x70, 0x72, 0x6f, 0x74, 0x6f, 0x2f, 0x63, 0x65, 0x64, 0x61, 0x72,
	0x2f, 0x76, 0x33, 0x3b, 0x63, 0x65, 0x64, 0x61, 0x72, 0x76, 0x33, 0xa2, 0x02, 0x03, 0x43, 0x58,
	0x58, 0xaa, 0x02, 0x08, 0x43, 0x65, 0x64, 0x61, 0x72, 0x2e, 0x56, 0x33, 0xca, 0x02, 0x08, 0x43,
	0x65, 0x64, 0x61, 0x72, 0x5c, 0x56, 0x33, 0xe2, 0x02, 0x14, 0x43, 0x65, 0x64, 0x61, 0x72, 0x5c,
	0x56, 0x33, 0x5c, 0x47, 0x50, 0x42, 0x4d, 0x65, 0x74, 0x61, 0x64, 0x61, 0x74, 0x61, 0xea, 0x02,
	0x09, 0x43, 0x65, 0x64, 0x61, 0x72, 0x3a, 0x3a, 0x56, 0x33, 0x62, 0x06, 0x70, 0x72, 0x6f, 0x74,
	0x6f, 0x33,
}

var (
	file_cedar_v3_cork_proto_rawDescOnce sync.Once
	file_cedar_v3_cork_proto_rawDescData = file_cedar_v3_cork_proto_rawDesc
)

func file_cedar_v3_cork_proto_rawDescGZIP() []byte {
	file_cedar_v3_cork_proto_rawDescOnce.Do(func() {
		file_cedar_v3_cork_proto_rawDescData = protoimpl.X.CompressGZIP(file_cedar_v3_cork_proto_rawDescData)
	})
	return file_cedar_v3_cork_proto_rawDescData
}

var file_cedar_v3_cork_proto_msgTypes = make([]protoimpl.MessageInfo, 1)
var file_cedar_v3_cork_proto_goTypes = []any{
	(*Cork)(nil),     // 0: cedar.v3.Cork
	(*EntityId)(nil), // 1: cedar.v3.EntityId
	(*Entity)(nil),   // 2: cedar.v3.Entity
	(*Expr)(nil),     // 3: cedar.v3.Expr
}
var file_cedar_v3_cork_proto_depIdxs = []int32{
	1, // 0: cedar.v3.Cork.issuer:type_name -> cedar.v3.EntityId
	1, // 1: cedar.v3.Cork.bearer:type_name -> cedar.v3.EntityId
	1, // 2: cedar.v3.Cork.audience:type_name -> cedar.v3.EntityId
	2, // 3: cedar.v3.Cork.claims:type_name -> cedar.v3.Entity
	3, // 4: cedar.v3.Cork.caveats:type_name -> cedar.v3.Expr
	5, // [5:5] is the sub-list for method output_type
	5, // [5:5] is the sub-list for method input_type
	5, // [5:5] is the sub-list for extension type_name
	5, // [5:5] is the sub-list for extension extendee
	0, // [0:5] is the sub-list for field type_name
}

func init() { file_cedar_v3_cork_proto_init() }
func file_cedar_v3_cork_proto_init() {
	if File_cedar_v3_cork_proto != nil {
		return
	}
	file_cedar_v3_entity_proto_init()
	file_cedar_v3_entity_id_proto_init()
	file_cedar_v3_expr_proto_init()
	if !protoimpl.UnsafeEnabled {
		file_cedar_v3_cork_proto_msgTypes[0].Exporter = func(v any, i int) any {
			switch v := v.(*Cork); i {
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
	file_cedar_v3_cork_proto_msgTypes[0].OneofWrappers = []any{}
	type x struct{}
	out := protoimpl.TypeBuilder{
		File: protoimpl.DescBuilder{
			GoPackagePath: reflect.TypeOf(x{}).PkgPath(),
			RawDescriptor: file_cedar_v3_cork_proto_rawDesc,
			NumEnums:      0,
			NumMessages:   1,
			NumExtensions: 0,
			NumServices:   0,
		},
		GoTypes:           file_cedar_v3_cork_proto_goTypes,
		DependencyIndexes: file_cedar_v3_cork_proto_depIdxs,
		MessageInfos:      file_cedar_v3_cork_proto_msgTypes,
	}.Build()
	File_cedar_v3_cork_proto = out.File
	file_cedar_v3_cork_proto_rawDesc = nil
	file_cedar_v3_cork_proto_goTypes = nil
	file_cedar_v3_cork_proto_depIdxs = nil
}
