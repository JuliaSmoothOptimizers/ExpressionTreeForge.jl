module tan_operators

import ..abstract_expr_node: ab_ex_nd, create_node_expr
import ..interface_expr_node:
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
import ..interface_expr_node:
  _get_type_node,
  _get_var_index,
  _evaluate_node,
  _evaluate_node!,
  _change_from_N_to_Ni!,
  _cast_constant!,
  _node_to_Expr,
  _node_to_Expr2,
  _node_bound,
  _node_convexity
import ..implementation_type_expr.t_type_expr_basic

using ..implementation_convexity_type
using ..implementation_type_expr
using ..trait_type_expr
using ..abstract_expr_node
import Base.(==)
export tan_operator

mutable struct tan_operator <: ab_ex_nd end

_node_convexity(
  op::tan_operator,
  son_cvx::AbstractVector{implementation_convexity_type.Convexity_type},
  son_bound::AbstractVector{Tuple{T, T}},
) where {T <: Number} = implementation_convexity_type.unknown_type()

@inline _node_bound(
  op::tan_operator,
  son_bound::AbstractVector{Tuple{T, T}},
  t::DataType,
) where {T <: Number} = ((t)(-Inf), (t)(Inf))

@inline create_node_expr(op::tan_operator) = tan_operator()

@inline _node_is_operator(op::tan_operator) = true
@inline _node_is_plus(op::tan_operator) = false
@inline _node_is_minus(op::tan_operator) = false
@inline _node_is_times(op::tan_operator) = false
@inline _node_is_power(op::tan_operator) = false
@inline _node_is_sin(op::tan_operator) = false
@inline _node_is_cos(op::tan_operator) = false
@inline _node_is_tan(op::tan_operator) = true

@inline _node_is_variable(op::tan_operator) = false

@inline _node_is_constant(op::tan_operator) = false

function _get_type_node(op::tan_operator, type_ch::Vector{t_type_expr_basic})
  if length(type_ch) == 1
    t_child = type_ch[1]
    if trait_type_expr._is_constant(t_child)
      return t_child
    else
      return implementation_type_expr.return_more()
    end
  end
end

@inline (==)(a::tan_operator, b::tan_operator) = true

@inline function _evaluate_node(op::tan_operator, value_ch::AbstractVector{T}) where {T <: Number}
  length(value_ch) == 1 || error("more than one argument for tan")
  return tan(value_ch[1])
end

@inline function _evaluate_node!(
  op::tan_operator,
  value_ch::AbstractVector{myRef{Y}},
  ref::abstract_expr_node.myRef{Y},
) where {Y <: Number}
  length(value_ch) == 1 || error("power has more than one argument")
  @inbounds @fastmath abstract_expr_node.set_myRef!(ref, tan(value_ch[1]))
end

@inline function _evaluate_node!(
  op::tan_operator,
  vec_value_ch::Vector{Vector{myRef{Y}}},
  vec_ref::Vector{abstract_expr_node.myRef{Y}},
) where {Y <: Number}
  for i = 1:length(vec_value_ch)
    _evaluate_node!(op, vec_value_ch[i], vec_ref[i])
  end
end

@inline _node_to_Expr(op::tan_operator) = [:tan]

end
