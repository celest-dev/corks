package cedarexpr

import cedarv4 "github.com/celest-dev/corks/go/proto/cedar/v4"

type Expr cedarv4.Expr

func (e *Expr) Proto() *cedarv4.Expr {
	if e == nil {
		return nil
	}
	return (*cedarv4.Expr)(e)
}

type Value = cedarv4.Expr_Value
type Variable = cedarv4.Expr_Variable
type Slot = cedarv4.Expr_Slot
type Unknown = cedarv4.Expr_Unknown
type Not = cedarv4.Expr_Not
type Negate = cedarv4.Expr_Negate
type Equals = cedarv4.Expr_Equals
type NotEquals = cedarv4.Expr_NotEquals
type In = cedarv4.Expr_In
type LessThan = cedarv4.Expr_LessThan
type LessThanOrEquals = cedarv4.Expr_LessThanOrEquals
type GreaterThan = cedarv4.Expr_GreaterThan
type GreaterThanOrEquals = cedarv4.Expr_GreaterThanOrEquals
type And = cedarv4.Expr_And
type Or = cedarv4.Expr_Or
type Add = cedarv4.Expr_Add
type Subtract = cedarv4.Expr_Subtract
type Multiply = cedarv4.Expr_Multiply
type Contains = cedarv4.Expr_Contains
type ContainsAll = cedarv4.Expr_ContainsAll
type ContainsAny = cedarv4.Expr_ContainsAny
type GetAttribute = cedarv4.Expr_GetAttribute
type HasAttribute = cedarv4.Expr_HasAttribute
type Like = cedarv4.Expr_Like
type Is = cedarv4.Expr_Is
type IfThenElse = cedarv4.Expr_IfThenElse
type Set = cedarv4.Expr_Set
type Record = cedarv4.Expr_Record
type ExtensionCall = cedarv4.Expr_ExtensionCall
