module M_exp_operator

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
export exp_operator

mutable struct exp_operator <: ab_ex_nd end

function _node_convexity(
  op::exp_operator,
  son_cvx::AbstractVector{implementation_convexity_type.Convexity_type},
  son_bound::AbstractVector{Tuple{T, T}},
) where {T <: Number}
  (length(son_cvx) == length(son_bound) && length(son_cvx) == 1) ||
    error("unsuitable length of parameters _node_convexity : exp_operator")
  status = son_cvx[1]
  if implementation_convexity_type.is_constant(status)
    return implementation_convexity_type.constant_type()
  elseif implementation_convexity_type.is_convex(status)
    return implementation_convexity_type.convex_type()
  else
    return implementation_convexity_type.unknown_type()
  end
end

function _node_bound(
  op::exp_operator,
  son_bound::AbstractVector{Tuple{T, T}},
  t::DataType,
) where {Y <: Number} where {T <: Number}
  vector_inf_bound = [p[1] for p in son_bound]
  vector_sup_bound = [p[2] for p in son_bound]
  length(vector_inf_bound) == 1 || error("puissance non unaire")
  length(vector_sup_bound) == 1 || error("puissance non unaire")
  bi = vector_inf_bound[1]
  bs = vector_sup_bound[1]
  return (exp(bi), exp(bs))
end

@inline create_node_expr(op::exp_operator) = exp_operator()

@inline _node_is_operator(op::exp_operator) = true
@inline _node_is_plus(op::exp_operator) = false
@inline _node_is_minus(op::exp_operator) = false
@inline _node_is_times(op::exp_operator) = false
@inline _node_is_power(op::exp_operator) = false
@inline _node_is_sin(op::exp_operator) = false
@inline _node_is_cos(op::exp_operator) = false
@inline _node_is_tan(op::exp_operator) = false

@inline _node_is_variable(op::exp_operator) = false

@inline _node_is_constant(op::exp_operator) = false

function _get_type_node(op::exp_operator, type_ch::Vector{t_type_expr_basic})
  if length(type_ch) == 1
    t_child = type_ch[1]
    if trait_type_expr._is_constant(t_child)
      return t_child
    else
      return implementation_type_expr.return_more()
    end
  end
end

@inline (==)(a::exp_operator, b::exp_operator) = true

@inline function _evaluate_node(op::exp_operator, value_ch::AbstractVector{T}) where {T <: Number}
  length(value_ch) == 1 || error("more than one argument for exp")
  return exp(value_ch[1])
end

@inline function _evaluate_node!(
  op::exp_operator,
  value_ch::AbstractVector{MyRef{Y}},
  ref::abstract_expr_node.MyRef{Y},
) where {Y <: Number}
  length(value_ch) == 1 || error("exp has more than one argument")
  abstract_expr_node.set_myRef!(ref, exp(value_ch[1]))
  return ref
end

@inline function _evaluate_node!(
  op::exp_operator,
  vec_value_ch::Vector{Vector{MyRef{Y}}},
  vec_ref::Vector{abstract_expr_node.MyRef{Y}},
) where {Y <: Number}
  for i = 1:length(vec_value_ch)
    _evaluate_node!(op, vec_value_ch[i], vec_ref[i])
  end
end

@inline _node_to_Expr(op::exp_operator) = [:exp]

end
