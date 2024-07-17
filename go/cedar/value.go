package cedar

import cedarv3 "github.com/celest-dev/corks/go/proto/cedar/v3"

type Value interface {
	RawValue() *cedarv3.Value
}

type String string

func (s String) RawValue() *cedarv3.Value {
	return &cedarv3.Value{
		Value: &cedarv3.Value_String_{
			String_: string(s),
		},
	}
}

type Long int64

func (l Long) RawValue() *cedarv3.Value {
	return &cedarv3.Value{
		Value: &cedarv3.Value_Long{
			Long: int64(l),
		},
	}
}

type Bool bool

func (b Bool) RawValue() *cedarv3.Value {
	return &cedarv3.Value{
		Value: &cedarv3.Value_Bool{
			Bool: bool(b),
		},
	}
}

func Set[T setValue](values []T) set[T] {
	s := make(set[T])
	for _, v := range values {
		s[v] = struct{}{}
	}
	return s
}

type setValue interface {
	Value
	comparable
}

type set[T setValue] map[T]struct{}

func (s set[T]) RawValue() *cedarv3.Value {
	var values []*cedarv3.Value
	for v := range s {
		values = append(values, v.RawValue())
	}
	return &cedarv3.Value{
		Value: &cedarv3.Value_Set{
			Set: &cedarv3.SetValue{
				Values: values,
			},
		},
	}
}

type Record map[string]Value

func (r Record) RawValue() *cedarv3.Value {
	fields := make(map[string]*cedarv3.Value)
	for k, v := range r {
		fields[k] = v.RawValue()
	}
	return &cedarv3.Value{
		Value: &cedarv3.Value_Record{
			Record: &cedarv3.RecordValue{
				Values: fields,
			},
		},
	}
}

type Extension struct {
	Function string `json:"fn"`
	Arg      Value  `json:"arg"`
}

func (e Extension) RawValue() *cedarv3.Value {
	return &cedarv3.Value{
		Value: &cedarv3.Value_Extension{
			Extension: &cedarv3.ExtensionValue{
				Fn:  e.Function,
				Arg: e.Arg.RawValue(),
			},
		},
	}
}

func (e *EntityID) RawValue() *cedarv3.Value {
	return &cedarv3.Value{
		Value: &cedarv3.Value_Entity{
			Entity: &cedarv3.EntityValue{
				Uid: (*cedarv3.EntityId)(e),
			},
		},
	}
}
