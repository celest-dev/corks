package cedarexpr

import cedarv3 "github.com/celest-dev/corks/go/proto/cedar/v3"

type Expr cedarv3.Expr

func (e *Expr) Raw() *cedarv3.Expr {
	if e == nil {
		return nil
	}
	return (*cedarv3.Expr)(e)
}

type Value = cedarv3.Expr_Value
type Var = cedarv3.Expr_Var
type Slot = cedarv3.Expr_Slot
type Unknown = cedarv3.Expr_Unknown
type Not = cedarv3.Expr_Not
type Neg = cedarv3.Expr_Neg
type Equals = cedarv3.Expr_Equals
type NotEquals = cedarv3.Expr_NotEquals
type In = cedarv3.Expr_In
type LessThan = cedarv3.Expr_LessThan
type LessThanOrEquals = cedarv3.Expr_LessThanOrEquals
type GreaterThan = cedarv3.Expr_GreaterThan
type GreaterThanOrEquals = cedarv3.Expr_GreaterThanOrEquals
type And = cedarv3.Expr_And
type Or = cedarv3.Expr_Or
type Plus = cedarv3.Expr_Plus
type Minus = cedarv3.Expr_Minus
type Times = cedarv3.Expr_Times
type Contains = cedarv3.Expr_Contains
type ContainsAll = cedarv3.Expr_ContainsAll
type ContainsAny = cedarv3.Expr_ContainsAny
type GetAttribute = cedarv3.Expr_GetAttribute
type HasAttribute = cedarv3.Expr_HasAttribute
type Like = cedarv3.Expr_Like
type Is = cedarv3.Expr_Is
type IfThenElse = cedarv3.Expr_IfThenElse
type Set = cedarv3.Expr_Set
type Record = cedarv3.Expr_Record
type FuncCall = cedarv3.Expr_FuncCall
