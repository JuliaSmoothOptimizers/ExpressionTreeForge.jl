module M_minus_operator

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

export Minus_operator

mutable struct Minus_operator <: Abstract_expr_node end

function _node_convexity(
  op::Minus_operator,
  son_cvx::AbstractVector{M_implementation_convexity_type.Convexity_type},
  son_bound::AbstractVector{Tuple{T, T}},
) where {T <: Number}
  length(son_cvx) == length(son_bound) ||
    error("unsuitable parameter _node_convexity : Minus_operator")
  if length(son_cvx) == 1
    st_ch = son_cvx[1]
    if M_implementation_convexity_type.is_constant(st_ch)
      return M_implementation_convexity_type.constant_type()
    elseif M_implementation_convexity_type.is_linear(st_ch)
      return M_implementation_convexity_type.linear_type()
    elseif M_implementation_convexity_type.is_convex(st_ch)
      return M_implementation_convexity_type.concave_type()
    elseif M_implementation_convexity_type.is_concave(st_ch)
      return M_implementation_convexity_type.convex_type()
    else
      return M_implementation_convexity_type.unknown_type()
    end
  else
    res_first_son = son_cvx[1]
    res_second_son = _node_convexity(op, [son_cvx[2]], [son_bound[2]])
    if res_first_son == res_second_son
      return res_first_son # == res_second_son
    elseif (
      M_implementation_convexity_type.is_linear(res_first_son) &&
      M_implementation_convexity_type.is_constant(res_second_son)
    ) || (
      M_implementation_convexity_type.is_linear(res_second_son) &&
      M_implementation_convexity_type.is_constant(res_first_son)
    )
      return M_implementation_convexity_type.linear_type()
    elseif (
      M_implementation_convexity_type.is_linear(res_first_son) ||
      M_implementation_convexity_type.is_constant(res_first_son)
    ) && (
      M_implementation_convexity_type.is_convex(res_second_son) ||
      M_implementation_convexity_type.is_concave(res_second_son)
    )
      return res_second_son
    elseif (
      M_implementation_convexity_type.is_linear(res_second_son) ||
      M_implementation_convexity_type.is_constant(res_second_son)
    ) && (
      M_implementation_convexity_type.is_convex(res_first_son) ||
      M_implementation_convexity_type.is_concave(res_first_son)
    )
      return res_first_son
    else
      return M_implementation_convexity_type.unknown_type()
    end
  end
end

function _node_bound(
  op::Minus_operator,
  son_bound::AbstractVector{Tuple{T, T}},
  t::DataType,
) where {T <: Number}
  vector_inf_bound = [p[1] for p in son_bound]
  vector_sup_bound = [p[2] for p in son_bound]
  (length(vector_inf_bound) == length(vector_sup_bound) || length(vector_sup_bound) <= 2) ||
    error("error bound minus operator")
  if length(vector_inf_bound) == 1
    (bi, bs) = (vector_inf_bound[1], vector_sup_bound[1])
    return (-bs, -bi)
  else # binary minus
    (bi1, bs1) = (vector_inf_bound[1], vector_sup_bound[1])
    (bi2, bs2) = (vector_inf_bound[2], vector_sup_bound[2])
    return (bi1 - bs2, bs1 - bi2)
  end
end

@inline create_node_expr(op::Minus_operator) = Minus_operator()

@inline _node_is_operator(op::Minus_operator) = true
@inline _node_is_plus(op::Minus_operator) = false
@inline _node_is_minus(op::Minus_operator) = true
@inline _node_is_times(op::Minus_operator) = false
@inline _node_is_power(op::Minus_operator) = false
@inline _node_is_sin(op::Minus_operator) = false
@inline _node_is_cos(op::Minus_operator) = false
@inline _node_is_tan(op::Minus_operator) = false

@inline _node_is_variable(op::Minus_operator) = false

@inline _node_is_constant(op::Minus_operator) = false

function _get_type_node(op::Minus_operator, type_ch::Vector{Type_expr_basic})
  if length(type_ch) == 1
    return type_ch[1]
  else
    return max(type_ch...)
  end
end

@inline (==)(a::Minus_operator, b::Minus_operator) = true
@inline string(a::Minus_operator) = "-"

function _evaluate_node(op::Minus_operator, value_ch::AbstractVector{T}) where {T <: Number}
  if length(value_ch) == 1
    return -value_ch[1]
  else
    return (value_ch[1] - value_ch[2])
  end
end

@inline _node_to_Expr(op::Minus_operator) = [:-]
@inline _node_to_Expr2(op::Minus_operator) = [:-]
@inline _node_to_Expr_JuMP(op::Minus_operator) = [:-]

end
