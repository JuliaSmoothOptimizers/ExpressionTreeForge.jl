module M_plus_operator

import ..M_abstract_expr_node: ab_ex_nd, create_node_expr
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
  _node_bound,
  _node_convexity
import ..M_implementation_type_expr.t_type_expr_basic

using ..M_implementation_convexity_type
using ..M_implementation_type_expr
using ..M_trait_type_expr
using ..M_abstract_expr_node
import Base.(==)
export plus_operator

mutable struct plus_operator <: ab_ex_nd end

my_and(a::Bool, b::Bool) = (a && b)
function _node_convexity(
  op::plus_operator,
  son_cvx::AbstractVector{M_implementation_convexity_type.Convexity_type},
  son_bound::AbstractVector{Tuple{T, T}},
) where {T <: Number}
  all_constant = mapreduce(
    x::M_implementation_convexity_type.Convexity_type ->
      M_implementation_convexity_type.is_constant(x),
    my_and,
    son_cvx,
  )
  all_linear = mapreduce(
    x::M_implementation_convexity_type.Convexity_type -> M_implementation_convexity_type.is_linear(x),
    my_and,
    son_cvx,
  )
  all_convex = mapreduce(
    x::M_implementation_convexity_type.Convexity_type -> M_implementation_convexity_type.is_convex(x),
    my_and,
    son_cvx,
  )
  all_concave = mapreduce(
    x::M_implementation_convexity_type.Convexity_type ->
      M_implementation_convexity_type.is_concave(x),
    my_and,
    son_cvx,
  )
  if all_constant
    return M_implementation_convexity_type.constant_type()
  elseif all_linear
    return M_implementation_convexity_type.linear_type()
  elseif all_convex
    return M_implementation_convexity_type.convex_type()
  elseif all_concave
    return M_implementation_convexity_type.concave_type()
  else
    return M_implementation_convexity_type.unknown_type()
  end
end

function _node_bound(
  op::plus_operator,
  son_bound::AbstractVector{Tuple{T, T}},
  t::DataType,
) where {T <: Number}
  vector_inf_bound = [p[1] for p in son_bound]
  vector_sup_bound = [p[2] for p in son_bound]
  return (sum(vector_inf_bound), sum(vector_sup_bound))
end

@inline create_node_expr(op::plus_operator) = plus_operator()

@inline _node_is_operator(op::plus_operator) = true
@inline _node_is_plus(op::plus_operator) = true
@inline _node_is_minus(op::plus_operator) = false
@inline _node_is_times(op::plus_operator) = false
@inline _node_is_power(op::plus_operator) = false
@inline _node_is_sin(op::plus_operator) = false
@inline _node_is_cos(op::plus_operator) = false
@inline _node_is_tan(op::plus_operator) = false

@inline _node_is_variable(op::plus_operator) = false

@inline _node_is_constant(op::plus_operator) = false

function _get_type_node(op::plus_operator, type_ch::Vector{t_type_expr_basic})
  if length(type_ch) == 1
    return type_ch[1]
  else
    return max(type_ch...)
  end
end

@inline (==)(a::plus_operator, b::plus_operator) = true

@inline _evaluate_node(op::plus_operator, value_ch::AbstractVector{T}) where {T <: Number} =
  sum(value_ch)
@inline _evaluate_node!(
  op::plus_operator,
  value_ch::AbstractVector{M_abstract_expr_node.MyRef{T}},
  ref::M_abstract_expr_node.MyRef{T},
) where {T <: Number} =
  length(value_ch) > 1 ? M_abstract_expr_node.set_myRef!(ref, sum(value_ch)) :
            M_abstract_expr_node.set_myRef!(ref, get_myRef(value_ch[1]))
@inline function _evaluate_node!(
  op::plus_operator,
  vec_value_ch::Vector{Vector{M_abstract_expr_node.MyRef{T}}},
  vec_ref::Vector{M_abstract_expr_node.MyRef{T}},
) where {T <: Number}
  for i = 1:length(vec_value_ch)
    _evaluate_node!(op, vec_value_ch[i], vec_ref[i])
  end
end

@inline _node_to_Expr(op::plus_operator) = [:+]

end
