module minus_operators

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
export minus_operator

mutable struct minus_operator <: ab_ex_nd end

function _node_convexity(
  op::minus_operator,
  son_cvx::AbstractVector{implementation_convexity_type.Convexity_type},
  son_bound::AbstractVector{Tuple{T, T}},
) where {T <: Number}
  length(son_cvx) == length(son_bound) ||
    error("unsuitable parameter _node_convexity : minus_operator")
  if length(son_cvx) == 1
    st_ch = son_cvx[1]
    if implementation_convexity_type.is_constant(st_ch)
      return implementation_convexity_type.constant_type()
    elseif implementation_convexity_type.is_linear(st_ch)
      return implementation_convexity_type.linear_type()
    elseif implementation_convexity_type.is_convex(st_ch)
      return implementation_convexity_type.concave_type()
    elseif implementation_convexity_type.is_concave(st_ch)
      return implementation_convexity_type.convex_type()
    else
      return implementation_convexity_type.unknown_type()
    end
  else
    res_first_son = son_cvx[1]
    res_second_son = _node_convexity(op, [son_cvx[2]], [son_bound[2]])
    if res_first_son == res_second_son
      return res_first_son #or res_second_son
    elseif (
      implementation_convexity_type.is_linear(res_first_son) &&
      implementation_convexity_type.is_constant(res_second_son)
    ) || (
      implementation_convexity_type.is_linear(res_second_son) &&
      implementation_convexity_type.is_constant(res_first_son)
    )
      return implementation_convexity_type.linear_type()
    elseif (
      implementation_convexity_type.is_linear(res_first_son) ||
      implementation_convexity_type.is_constant(res_first_son)
    ) && (
      implementation_convexity_type.is_convex(res_second_son) ||
      implementation_convexity_type.is_concave(res_second_son)
    )
      return res_second_son
    elseif (
      implementation_convexity_type.is_linear(res_second_son) ||
      implementation_convexity_type.is_constant(res_second_son)
    ) && (
      implementation_convexity_type.is_convex(res_first_son) ||
      implementation_convexity_type.is_concave(res_first_son)
    )
      return res_first_son
    else
      return implementation_convexity_type.unknown_type()
    end
  end
end

function _node_bound(
  op::minus_operator,
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
  else #binary minus
    (bi1, bs1) = (vector_inf_bound[1], vector_sup_bound[1])
    (bi2, bs2) = (vector_inf_bound[2], vector_sup_bound[2])
    return (bi1 - bs2, bs1 - bi2)
  end
end

@inline create_node_expr(op::minus_operator) = minus_operator()

@inline _node_is_operator(op::minus_operator) = true
@inline _node_is_plus(op::minus_operator) = false
@inline _node_is_minus(op::minus_operator) = true
@inline _node_is_times(op::minus_operator) = false
@inline _node_is_power(op::minus_operator) = false
@inline _node_is_sin(op::minus_operator) = false
@inline _node_is_cos(op::minus_operator) = false
@inline _node_is_tan(op::minus_operator) = false

@inline _node_is_variable(op::minus_operator) = false

@inline _node_is_constant(op::minus_operator) = false

function _get_type_node(op::minus_operator, type_ch::Vector{t_type_expr_basic})
  if length(type_ch) == 1
    return type_ch[1]
  else
    return max(type_ch...)
  end
end

@inline (==)(a::minus_operator, b::minus_operator) = true

function _evaluate_node(op::minus_operator, value_ch::AbstractVector{T}) where {T <: Number}
  if length(value_ch) == 1
    return -value_ch[1]
  else
    return (value_ch[1] - value_ch[2])
  end
end

@inline function _evaluate_node!(
  op::minus_operator,
  value_ch::AbstractVector{abstract_expr_node.myRef{T}},
  ref::abstract_expr_node.myRef{T},
) where {T <: Number}
  if length(value_ch) == 1
    abstract_expr_node.set_myRef!(ref, -value_ch[1])
  else
    abstract_expr_node.set_myRef!(ref, value_ch[1] - value_ch[2])
  end
end

@inline function _evaluate_node!(
  op::minus_operator,
  vec_value_ch::Vector{Vector{abstract_expr_node.myRef{T}}},
  vec_ref::Vector{abstract_expr_node.myRef{T}},
) where {T <: Number}
  for i = 1:length(vec_value_ch)
    _evaluate_node!(op, vec_value_ch[i], vec_ref[i])
  end
end

@inline _node_to_Expr(op::minus_operator) = [:-]

end
