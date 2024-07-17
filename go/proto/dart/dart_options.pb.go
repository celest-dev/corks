// Experimental options controlling Dart code generation.

// Code generated by protoc-gen-go. DO NOT EDIT.
// versions:
// 	protoc-gen-go v1.34.2
// 	protoc        (unknown)
// source: dart/dart_options.proto

package dart

import (
	protoreflect "google.golang.org/protobuf/reflect/protoreflect"
	protoimpl "google.golang.org/protobuf/runtime/protoimpl"
	descriptorpb "google.golang.org/protobuf/types/descriptorpb"
	_ "google.golang.org/protobuf/types/pluginpb"
	reflect "reflect"
	sync "sync"
)

const (
	// Verify that this generated code is sufficiently up-to-date.
	_ = protoimpl.EnforceVersion(20 - protoimpl.MinVersion)
	// Verify that runtime/protoimpl is sufficiently up-to-date.
	_ = protoimpl.EnforceVersion(protoimpl.MaxVersion - 20)
)

// A mixin that can be used in the 'with' clause of the generated Dart class
// for a proto message.
type DartMixin struct {
	state         protoimpl.MessageState
	sizeCache     protoimpl.SizeCache
	unknownFields protoimpl.UnknownFields

	// The name of the mixin class.
	Name *string `protobuf:"bytes,1,opt,name=name" json:"name,omitempty"`
	// A URI pointing to the Dart library that defines the mixin.
	// The generated Dart code will use this in an import statement.
	ImportFrom *string `protobuf:"bytes,2,opt,name=import_from,json=importFrom" json:"import_from,omitempty"`
	// The name of another mixin to be applied ahead of this one.
	// The generated class for the message will inherit from all mixins
	// in the parent chain.
	Parent *string `protobuf:"bytes,3,opt,name=parent" json:"parent,omitempty"`
}

func (x *DartMixin) Reset() {
	*x = DartMixin{}
	if protoimpl.UnsafeEnabled {
		mi := &file_dart_dart_options_proto_msgTypes[0]
		ms := protoimpl.X.MessageStateOf(protoimpl.Pointer(x))
		ms.StoreMessageInfo(mi)
	}
}

func (x *DartMixin) String() string {
	return protoimpl.X.MessageStringOf(x)
}

func (*DartMixin) ProtoMessage() {}

func (x *DartMixin) ProtoReflect() protoreflect.Message {
	mi := &file_dart_dart_options_proto_msgTypes[0]
	if protoimpl.UnsafeEnabled && x != nil {
		ms := protoimpl.X.MessageStateOf(protoimpl.Pointer(x))
		if ms.LoadMessageInfo() == nil {
			ms.StoreMessageInfo(mi)
		}
		return ms
	}
	return mi.MessageOf(x)
}

// Deprecated: Use DartMixin.ProtoReflect.Descriptor instead.
func (*DartMixin) Descriptor() ([]byte, []int) {
	return file_dart_dart_options_proto_rawDescGZIP(), []int{0}
}

func (x *DartMixin) GetName() string {
	if x != nil && x.Name != nil {
		return *x.Name
	}
	return ""
}

func (x *DartMixin) GetImportFrom() string {
	if x != nil && x.ImportFrom != nil {
		return *x.ImportFrom
	}
	return ""
}

func (x *DartMixin) GetParent() string {
	if x != nil && x.Parent != nil {
		return *x.Parent
	}
	return ""
}

// Defines additional Dart imports to be used with messages in this file.
type Imports struct {
	state         protoimpl.MessageState
	sizeCache     protoimpl.SizeCache
	unknownFields protoimpl.UnknownFields

	// Mixins to be used on messages in this file.
	// These mixins are in addition to internally defined mixins (e.g PbMapMixin)
	// and may override them.
	//
	// Warning: mixins are experimental. The protoc Dart plugin doesn't check
	// for name conflicts between mixin class members and generated class members,
	// so the generated code may contain errors. Therefore, running dartanalyzer
	// on the generated file is a good idea.
	Mixins []*DartMixin `protobuf:"bytes,1,rep,name=mixins" json:"mixins,omitempty"`
}

func (x *Imports) Reset() {
	*x = Imports{}
	if protoimpl.UnsafeEnabled {
		mi := &file_dart_dart_options_proto_msgTypes[1]
		ms := protoimpl.X.MessageStateOf(protoimpl.Pointer(x))
		ms.StoreMessageInfo(mi)
	}
}

func (x *Imports) String() string {
	return protoimpl.X.MessageStringOf(x)
}

func (*Imports) ProtoMessage() {}

func (x *Imports) ProtoReflect() protoreflect.Message {
	mi := &file_dart_dart_options_proto_msgTypes[1]
	if protoimpl.UnsafeEnabled && x != nil {
		ms := protoimpl.X.MessageStateOf(protoimpl.Pointer(x))
		if ms.LoadMessageInfo() == nil {
			ms.StoreMessageInfo(mi)
		}
		return ms
	}
	return mi.MessageOf(x)
}

// Deprecated: Use Imports.ProtoReflect.Descriptor instead.
func (*Imports) Descriptor() ([]byte, []int) {
	return file_dart_dart_options_proto_rawDescGZIP(), []int{1}
}

func (x *Imports) GetMixins() []*DartMixin {
	if x != nil {
		return x.Mixins
	}
	return nil
}

var file_dart_dart_options_proto_extTypes = []protoimpl.ExtensionInfo{
	{
		ExtendedType:  (*descriptorpb.FileOptions)(nil),
		ExtensionType: (*Imports)(nil),
		Field:         28125061,
		Name:          "dart_options.imports",
		Tag:           "bytes,28125061,opt,name=imports",
		Filename:      "dart/dart_options.proto",
	},
	{
		ExtendedType:  (*descriptorpb.FileOptions)(nil),
		ExtensionType: (*string)(nil),
		Field:         96128839,
		Name:          "dart_options.default_mixin",
		Tag:           "bytes,96128839,opt,name=default_mixin",
		Filename:      "dart/dart_options.proto",
	},
	{
		ExtendedType:  (*descriptorpb.MessageOptions)(nil),
		ExtensionType: (*string)(nil),
		Field:         96128839,
		Name:          "dart_options.mixin",
		Tag:           "bytes,96128839,opt,name=mixin",
		Filename:      "dart/dart_options.proto",
	},
	{
		ExtendedType:  (*descriptorpb.FieldOptions)(nil),
		ExtensionType: (*bool)(nil),
		Field:         28205290,
		Name:          "dart_options.override_getter",
		Tag:           "varint,28205290,opt,name=override_getter",
		Filename:      "dart/dart_options.proto",
	},
	{
		ExtendedType:  (*descriptorpb.FieldOptions)(nil),
		ExtensionType: (*bool)(nil),
		Field:         28937366,
		Name:          "dart_options.override_setter",
		Tag:           "varint,28937366,opt,name=override_setter",
		Filename:      "dart/dart_options.proto",
	},
	{
		ExtendedType:  (*descriptorpb.FieldOptions)(nil),
		ExtensionType: (*bool)(nil),
		Field:         28937461,
		Name:          "dart_options.override_has_method",
		Tag:           "varint,28937461,opt,name=override_has_method",
		Filename:      "dart/dart_options.proto",
	},
	{
		ExtendedType:  (*descriptorpb.FieldOptions)(nil),
		ExtensionType: (*bool)(nil),
		Field:         28907907,
		Name:          "dart_options.override_clear_method",
		Tag:           "varint,28907907,opt,name=override_clear_method",
		Filename:      "dart/dart_options.proto",
	},
	{
		ExtendedType:  (*descriptorpb.FieldOptions)(nil),
		ExtensionType: (*string)(nil),
		Field:         28700919,
		Name:          "dart_options.dart_name",
		Tag:           "bytes,28700919,opt,name=dart_name",
		Filename:      "dart/dart_options.proto",
	},
}

// Extension fields to descriptorpb.FileOptions.
var (
	// optional dart_options.Imports imports = 28125061;
	E_Imports = &file_dart_dart_options_proto_extTypes[0]
	// Applies the named mixin to all messages in this file.
	// (May be overridden by the "mixin" option on a message.)
	// For now, "PbMapMixin" is the only available mixin.
	//
	// optional string default_mixin = 96128839;
	E_DefaultMixin = &file_dart_dart_options_proto_extTypes[1]
)

// Extension fields to descriptorpb.MessageOptions.
var (
	// Applies the named mixin.
	// For now, "PbMapMixin" is the only available mixin.
	// The empty string can be used to turn off mixins for this message.
	//
	// optional string mixin = 96128839;
	E_Mixin = &file_dart_dart_options_proto_extTypes[2]
)

// Extension fields to descriptorpb.FieldOptions.
var (
	// Adds @override annotation to the field's getter (for use with mixins).
	//
	// optional bool override_getter = 28205290;
	E_OverrideGetter = &file_dart_dart_options_proto_extTypes[3]
	// Adds @override annotation to the field's setter (for use with mixins).
	//
	// optional bool override_setter = 28937366;
	E_OverrideSetter = &file_dart_dart_options_proto_extTypes[4]
	// Adds @override annotation to the field's hasX() method (for use with
	// mixins).
	//
	// optional bool override_has_method = 28937461;
	E_OverrideHasMethod = &file_dart_dart_options_proto_extTypes[5]
	// Adds @override annotation to the field's clearX() method (for use with
	// mixins).
	//
	// optional bool override_clear_method = 28907907;
	E_OverrideClearMethod = &file_dart_dart_options_proto_extTypes[6]
	// Uses the given name for getters, setters and as suffixes for has/clear
	// methods in the generated Dart file. Should be lowerCamelCase.
	//
	// optional string dart_name = 28700919;
	E_DartName = &file_dart_dart_options_proto_extTypes[7]
)

var File_dart_dart_options_proto protoreflect.FileDescriptor

var file_dart_dart_options_proto_rawDesc = []byte{
	0x0a, 0x17, 0x64, 0x61, 0x72, 0x74, 0x2f, 0x64, 0x61, 0x72, 0x74, 0x5f, 0x6f, 0x70, 0x74, 0x69,
	0x6f, 0x6e, 0x73, 0x2e, 0x70, 0x72, 0x6f, 0x74, 0x6f, 0x12, 0x0c, 0x64, 0x61, 0x72, 0x74, 0x5f,
	0x6f, 0x70, 0x74, 0x69, 0x6f, 0x6e, 0x73, 0x1a, 0x20, 0x67, 0x6f, 0x6f, 0x67, 0x6c, 0x65, 0x2f,
	0x70, 0x72, 0x6f, 0x74, 0x6f, 0x62, 0x75, 0x66, 0x2f, 0x64, 0x65, 0x73, 0x63, 0x72, 0x69, 0x70,
	0x74, 0x6f, 0x72, 0x2e, 0x70, 0x72, 0x6f, 0x74, 0x6f, 0x1a, 0x25, 0x67, 0x6f, 0x6f, 0x67, 0x6c,
	0x65, 0x2f, 0x70, 0x72, 0x6f, 0x74, 0x6f, 0x62, 0x75, 0x66, 0x2f, 0x63, 0x6f, 0x6d, 0x70, 0x69,
	0x6c, 0x65, 0x72, 0x2f, 0x70, 0x6c, 0x75, 0x67, 0x69, 0x6e, 0x2e, 0x70, 0x72, 0x6f, 0x74, 0x6f,
	0x22, 0x58, 0x0a, 0x09, 0x44, 0x61, 0x72, 0x74, 0x4d, 0x69, 0x78, 0x69, 0x6e, 0x12, 0x12, 0x0a,
	0x04, 0x6e, 0x61, 0x6d, 0x65, 0x18, 0x01, 0x20, 0x01, 0x28, 0x09, 0x52, 0x04, 0x6e, 0x61, 0x6d,
	0x65, 0x12, 0x1f, 0x0a, 0x0b, 0x69, 0x6d, 0x70, 0x6f, 0x72, 0x74, 0x5f, 0x66, 0x72, 0x6f, 0x6d,
	0x18, 0x02, 0x20, 0x01, 0x28, 0x09, 0x52, 0x0a, 0x69, 0x6d, 0x70, 0x6f, 0x72, 0x74, 0x46, 0x72,
	0x6f, 0x6d, 0x12, 0x16, 0x0a, 0x06, 0x70, 0x61, 0x72, 0x65, 0x6e, 0x74, 0x18, 0x03, 0x20, 0x01,
	0x28, 0x09, 0x52, 0x06, 0x70, 0x61, 0x72, 0x65, 0x6e, 0x74, 0x22, 0x3a, 0x0a, 0x07, 0x49, 0x6d,
	0x70, 0x6f, 0x72, 0x74, 0x73, 0x12, 0x2f, 0x0a, 0x06, 0x6d, 0x69, 0x78, 0x69, 0x6e, 0x73, 0x18,
	0x01, 0x20, 0x03, 0x28, 0x0b, 0x32, 0x17, 0x2e, 0x64, 0x61, 0x72, 0x74, 0x5f, 0x6f, 0x70, 0x74,
	0x69, 0x6f, 0x6e, 0x73, 0x2e, 0x44, 0x61, 0x72, 0x74, 0x4d, 0x69, 0x78, 0x69, 0x6e, 0x52, 0x06,
	0x6d, 0x69, 0x78, 0x69, 0x6e, 0x73, 0x3a, 0x50, 0x0a, 0x07, 0x69, 0x6d, 0x70, 0x6f, 0x72, 0x74,
	0x73, 0x12, 0x1c, 0x2e, 0x67, 0x6f, 0x6f, 0x67, 0x6c, 0x65, 0x2e, 0x70, 0x72, 0x6f, 0x74, 0x6f,
	0x62, 0x75, 0x66, 0x2e, 0x46, 0x69, 0x6c, 0x65, 0x4f, 0x70, 0x74, 0x69, 0x6f, 0x6e, 0x73, 0x18,
	0x85, 0xcf, 0xb4, 0x0d, 0x20, 0x01, 0x28, 0x0b, 0x32, 0x15, 0x2e, 0x64, 0x61, 0x72, 0x74, 0x5f,
	0x6f, 0x70, 0x74, 0x69, 0x6f, 0x6e, 0x73, 0x2e, 0x49, 0x6d, 0x70, 0x6f, 0x72, 0x74, 0x73, 0x52,
	0x07, 0x69, 0x6d, 0x70, 0x6f, 0x72, 0x74, 0x73, 0x3a, 0x44, 0x0a, 0x0d, 0x64, 0x65, 0x66, 0x61,
	0x75, 0x6c, 0x74, 0x5f, 0x6d, 0x69, 0x78, 0x69, 0x6e, 0x12, 0x1c, 0x2e, 0x67, 0x6f, 0x6f, 0x67,
	0x6c, 0x65, 0x2e, 0x70, 0x72, 0x6f, 0x74, 0x6f, 0x62, 0x75, 0x66, 0x2e, 0x46, 0x69, 0x6c, 0x65,
	0x4f, 0x70, 0x74, 0x69, 0x6f, 0x6e, 0x73, 0x18, 0xc7, 0x9e, 0xeb, 0x2d, 0x20, 0x01, 0x28, 0x09,
	0x52, 0x0c, 0x64, 0x65, 0x66, 0x61, 0x75, 0x6c, 0x74, 0x4d, 0x69, 0x78, 0x69, 0x6e, 0x3a, 0x38,
	0x0a, 0x05, 0x6d, 0x69, 0x78, 0x69, 0x6e, 0x12, 0x1f, 0x2e, 0x67, 0x6f, 0x6f, 0x67, 0x6c, 0x65,
	0x2e, 0x70, 0x72, 0x6f, 0x74, 0x6f, 0x62, 0x75, 0x66, 0x2e, 0x4d, 0x65, 0x73, 0x73, 0x61, 0x67,
	0x65, 0x4f, 0x70, 0x74, 0x69, 0x6f, 0x6e, 0x73, 0x18, 0xc7, 0x9e, 0xeb, 0x2d, 0x20, 0x01, 0x28,
	0x09, 0x52, 0x05, 0x6d, 0x69, 0x78, 0x69, 0x6e, 0x3a, 0x49, 0x0a, 0x0f, 0x6f, 0x76, 0x65, 0x72,
	0x72, 0x69, 0x64, 0x65, 0x5f, 0x67, 0x65, 0x74, 0x74, 0x65, 0x72, 0x12, 0x1d, 0x2e, 0x67, 0x6f,
	0x6f, 0x67, 0x6c, 0x65, 0x2e, 0x70, 0x72, 0x6f, 0x74, 0x6f, 0x62, 0x75, 0x66, 0x2e, 0x46, 0x69,
	0x65, 0x6c, 0x64, 0x4f, 0x70, 0x74, 0x69, 0x6f, 0x6e, 0x73, 0x18, 0xea, 0xc1, 0xb9, 0x0d, 0x20,
	0x01, 0x28, 0x08, 0x52, 0x0e, 0x6f, 0x76, 0x65, 0x72, 0x72, 0x69, 0x64, 0x65, 0x47, 0x65, 0x74,
	0x74, 0x65, 0x72, 0x3a, 0x49, 0x0a, 0x0f, 0x6f, 0x76, 0x65, 0x72, 0x72, 0x69, 0x64, 0x65, 0x5f,
	0x73, 0x65, 0x74, 0x74, 0x65, 0x72, 0x12, 0x1d, 0x2e, 0x67, 0x6f, 0x6f, 0x67, 0x6c, 0x65, 0x2e,
	0x70, 0x72, 0x6f, 0x74, 0x6f, 0x62, 0x75, 0x66, 0x2e, 0x46, 0x69, 0x65, 0x6c, 0x64, 0x4f, 0x70,
	0x74, 0x69, 0x6f, 0x6e, 0x73, 0x18, 0x96, 0x99, 0xe6, 0x0d, 0x20, 0x01, 0x28, 0x08, 0x52, 0x0e,
	0x6f, 0x76, 0x65, 0x72, 0x72, 0x69, 0x64, 0x65, 0x53, 0x65, 0x74, 0x74, 0x65, 0x72, 0x3a, 0x50,
	0x0a, 0x13, 0x6f, 0x76, 0x65, 0x72, 0x72, 0x69, 0x64, 0x65, 0x5f, 0x68, 0x61, 0x73, 0x5f, 0x6d,
	0x65, 0x74, 0x68, 0x6f, 0x64, 0x12, 0x1d, 0x2e, 0x67, 0x6f, 0x6f, 0x67, 0x6c, 0x65, 0x2e, 0x70,
	0x72, 0x6f, 0x74, 0x6f, 0x62, 0x75, 0x66, 0x2e, 0x46, 0x69, 0x65, 0x6c, 0x64, 0x4f, 0x70, 0x74,
	0x69, 0x6f, 0x6e, 0x73, 0x18, 0xf5, 0x99, 0xe6, 0x0d, 0x20, 0x01, 0x28, 0x08, 0x52, 0x11, 0x6f,
	0x76, 0x65, 0x72, 0x72, 0x69, 0x64, 0x65, 0x48, 0x61, 0x73, 0x4d, 0x65, 0x74, 0x68, 0x6f, 0x64,
	0x3a, 0x54, 0x0a, 0x15, 0x6f, 0x76, 0x65, 0x72, 0x72, 0x69, 0x64, 0x65, 0x5f, 0x63, 0x6c, 0x65,
	0x61, 0x72, 0x5f, 0x6d, 0x65, 0x74, 0x68, 0x6f, 0x64, 0x12, 0x1d, 0x2e, 0x67, 0x6f, 0x6f, 0x67,
	0x6c, 0x65, 0x2e, 0x70, 0x72, 0x6f, 0x74, 0x6f, 0x62, 0x75, 0x66, 0x2e, 0x46, 0x69, 0x65, 0x6c,
	0x64, 0x4f, 0x70, 0x74, 0x69, 0x6f, 0x6e, 0x73, 0x18, 0x83, 0xb3, 0xe4, 0x0d, 0x20, 0x01, 0x28,
	0x08, 0x52, 0x13, 0x6f, 0x76, 0x65, 0x72, 0x72, 0x69, 0x64, 0x65, 0x43, 0x6c, 0x65, 0x61, 0x72,
	0x4d, 0x65, 0x74, 0x68, 0x6f, 0x64, 0x3a, 0x3d, 0x0a, 0x09, 0x64, 0x61, 0x72, 0x74, 0x5f, 0x6e,
	0x61, 0x6d, 0x65, 0x12, 0x1d, 0x2e, 0x67, 0x6f, 0x6f, 0x67, 0x6c, 0x65, 0x2e, 0x70, 0x72, 0x6f,
	0x74, 0x6f, 0x62, 0x75, 0x66, 0x2e, 0x46, 0x69, 0x65, 0x6c, 0x64, 0x4f, 0x70, 0x74, 0x69, 0x6f,
	0x6e, 0x73, 0x18, 0xf7, 0xe1, 0xd7, 0x0d, 0x20, 0x01, 0x28, 0x09, 0x52, 0x08, 0x64, 0x61, 0x72,
	0x74, 0x4e, 0x61, 0x6d, 0x65, 0x42, 0x9b, 0x01, 0x0a, 0x10, 0x63, 0x6f, 0x6d, 0x2e, 0x64, 0x61,
	0x72, 0x74, 0x5f, 0x6f, 0x70, 0x74, 0x69, 0x6f, 0x6e, 0x73, 0x42, 0x10, 0x44, 0x61, 0x72, 0x74,
	0x4f, 0x70, 0x74, 0x69, 0x6f, 0x6e, 0x73, 0x50, 0x72, 0x6f, 0x74, 0x6f, 0x50, 0x01, 0x5a, 0x29,
	0x67, 0x69, 0x74, 0x68, 0x75, 0x62, 0x2e, 0x63, 0x6f, 0x6d, 0x2f, 0x63, 0x65, 0x6c, 0x65, 0x73,
	0x74, 0x2d, 0x64, 0x65, 0x76, 0x2f, 0x63, 0x6f, 0x72, 0x6b, 0x73, 0x2f, 0x67, 0x6f, 0x2f, 0x70,
	0x72, 0x6f, 0x74, 0x6f, 0x2f, 0x64, 0x61, 0x72, 0x74, 0xa2, 0x02, 0x03, 0x44, 0x58, 0x58, 0xaa,
	0x02, 0x0b, 0x44, 0x61, 0x72, 0x74, 0x4f, 0x70, 0x74, 0x69, 0x6f, 0x6e, 0x73, 0xca, 0x02, 0x0b,
	0x44, 0x61, 0x72, 0x74, 0x4f, 0x70, 0x74, 0x69, 0x6f, 0x6e, 0x73, 0xe2, 0x02, 0x17, 0x44, 0x61,
	0x72, 0x74, 0x4f, 0x70, 0x74, 0x69, 0x6f, 0x6e, 0x73, 0x5c, 0x47, 0x50, 0x42, 0x4d, 0x65, 0x74,
	0x61, 0x64, 0x61, 0x74, 0x61, 0xea, 0x02, 0x0b, 0x44, 0x61, 0x72, 0x74, 0x4f, 0x70, 0x74, 0x69,
	0x6f, 0x6e, 0x73,
}

var (
	file_dart_dart_options_proto_rawDescOnce sync.Once
	file_dart_dart_options_proto_rawDescData = file_dart_dart_options_proto_rawDesc
)

func file_dart_dart_options_proto_rawDescGZIP() []byte {
	file_dart_dart_options_proto_rawDescOnce.Do(func() {
		file_dart_dart_options_proto_rawDescData = protoimpl.X.CompressGZIP(file_dart_dart_options_proto_rawDescData)
	})
	return file_dart_dart_options_proto_rawDescData
}

var file_dart_dart_options_proto_msgTypes = make([]protoimpl.MessageInfo, 2)
var file_dart_dart_options_proto_goTypes = []any{
	(*DartMixin)(nil),                   // 0: dart_options.DartMixin
	(*Imports)(nil),                     // 1: dart_options.Imports
	(*descriptorpb.FileOptions)(nil),    // 2: google.protobuf.FileOptions
	(*descriptorpb.MessageOptions)(nil), // 3: google.protobuf.MessageOptions
	(*descriptorpb.FieldOptions)(nil),   // 4: google.protobuf.FieldOptions
}
var file_dart_dart_options_proto_depIdxs = []int32{
	0,  // 0: dart_options.Imports.mixins:type_name -> dart_options.DartMixin
	2,  // 1: dart_options.imports:extendee -> google.protobuf.FileOptions
	2,  // 2: dart_options.default_mixin:extendee -> google.protobuf.FileOptions
	3,  // 3: dart_options.mixin:extendee -> google.protobuf.MessageOptions
	4,  // 4: dart_options.override_getter:extendee -> google.protobuf.FieldOptions
	4,  // 5: dart_options.override_setter:extendee -> google.protobuf.FieldOptions
	4,  // 6: dart_options.override_has_method:extendee -> google.protobuf.FieldOptions
	4,  // 7: dart_options.override_clear_method:extendee -> google.protobuf.FieldOptions
	4,  // 8: dart_options.dart_name:extendee -> google.protobuf.FieldOptions
	1,  // 9: dart_options.imports:type_name -> dart_options.Imports
	10, // [10:10] is the sub-list for method output_type
	10, // [10:10] is the sub-list for method input_type
	9,  // [9:10] is the sub-list for extension type_name
	1,  // [1:9] is the sub-list for extension extendee
	0,  // [0:1] is the sub-list for field type_name
}

func init() { file_dart_dart_options_proto_init() }
func file_dart_dart_options_proto_init() {
	if File_dart_dart_options_proto != nil {
		return
	}
	if !protoimpl.UnsafeEnabled {
		file_dart_dart_options_proto_msgTypes[0].Exporter = func(v any, i int) any {
			switch v := v.(*DartMixin); i {
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
		file_dart_dart_options_proto_msgTypes[1].Exporter = func(v any, i int) any {
			switch v := v.(*Imports); i {
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
			RawDescriptor: file_dart_dart_options_proto_rawDesc,
			NumEnums:      0,
			NumMessages:   2,
			NumExtensions: 8,
			NumServices:   0,
		},
		GoTypes:           file_dart_dart_options_proto_goTypes,
		DependencyIndexes: file_dart_dart_options_proto_depIdxs,
		MessageInfos:      file_dart_dart_options_proto_msgTypes,
		ExtensionInfos:    file_dart_dart_options_proto_extTypes,
	}.Build()
	File_dart_dart_options_proto = out.File
	file_dart_dart_options_proto_rawDesc = nil
	file_dart_dart_options_proto_goTypes = nil
	file_dart_dart_options_proto_depIdxs = nil
}
