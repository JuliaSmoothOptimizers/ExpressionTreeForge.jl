module M_tan_operator

import ..M_abstract_expr_node: Abstract_expr_node, create_node_expr
import ..M_interface_expr_node:
  _node_is_plus,
  _node_is_minus,
  _node_is_power,
  _node_is_times,
  _node_is_constant,
  _node_is_variable,
  _node_is_operator,
  _node_is_sin,
  _node_is_cos,
  _node_is_tan
import ..M_interface_expr_node:
  _get_type_node,
  _get_var_index,
  _evaluate_node,
  _evaluate_node!,
  _node_to_Expr,
  _node_to_Expr2,
  _node_to_Expr_JuMP,
  _node_bound,
  _node_convexity
import ..M_implementation_type_expr.Type_expr_basic
import Base.(==), Base.string

using ..M_implementation_convexity_type
using ..M_implementation_type_expr
using ..M_trait_type_expr
using ..M_abstract_expr_node

export Tan_operator

mutable struct Tan_operator <: Abstract_expr_node end

_node_convexity(
  op::Tan_operator,
  son_cvx::AbstractVector{M_implementation_convexity_type.Convexity_type},
  son_bound::AbstractVector{Tuple{T, T}},
) where {T <: Number} = M_implementation_convexity_type.unknown_type()

@inline _node_bound(
  op::Tan_operator,
  son_bound::AbstractVector{Tuple{T, T}},
  t::DataType,
) where {T <: Number} = ((t)(-Inf), (t)(Inf))

@inline create_node_expr(op::Tan_operator) = Tan_operator()

@inline _node_is_operator(op::Tan_operator) = true
@inline _node_is_plus(op::Tan_operator) = false
@inline _node_is_minus(op::Tan_operator) = false
@inline _node_is_times(op::Tan_operator) = false
@inline _node_is_power(op::Tan_operator) = false
@inline _node_is_sin(op::Tan_operator) = false
@inline _node_is_cos(op::Tan_operator) = false
@inline _node_is_tan(op::Tan_operator) = true

@inline _node_is_variable(op::Tan_operator) = false

@inline _node_is_constant(op::Tan_operator) = false

function _get_type_node(op::Tan_operator, type_ch::Vector{Type_expr_basic})
  if length(type_ch) == 1
    t_child = type_ch[1]
    if M_trait_type_expr._is_constant(t_child)
      return t_child
    else
      return M_implementation_type_expr.return_more()
    end
  end
end

@inline (==)(a::Tan_operator, b::Tan_operator) = true
@inline string(a::Tan_operator) = "tan"

@inline function _evaluate_node(op::Tan_operator, value_ch::AbstractVector{T}) where {T <: Number}
  length(value_ch) == 1 || error("more than one argument for tan")
  return tan(value_ch[1])
end

@inline _node_to_Expr(op::Tan_operator) = [:tan]
@inline _node_to_Expr2(op::Tan_operator) = [:tan]
@inline _node_to_Expr_JuMP(op::Tan_operator) = [:tan]

end
