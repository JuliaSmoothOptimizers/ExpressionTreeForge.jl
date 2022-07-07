module M_times_operator

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
  _node_bound,
  _node_convexity
import ..M_implementation_type_expr.Type_expr_basic

using ..M_implementation_convexity_type, ..M_implementation_type_expr
using ..M_trait_type_expr
using ..M_abstract_expr_node
import Base.(==)

export Time_operator

mutable struct Time_operator <: Abstract_expr_node end

function _node_convexity(
  op::Time_operator,
  son_cvx::AbstractVector{M_implementation_convexity_type.Convexity_type},
  son_bound::AbstractVector{Tuple{T, T}},
) where {T <: Number}
  length(son_cvx) == length(son_bound) || error("mismatch length of arguments")
  current_st = son_cvx[1]
  current_bounds = son_bound[1]
  for i = 2:length(son_cvx)
    current_st = node_convexity_binary_time(current_st, son_cvx[i], current_bounds, son_bound[i])
    current_bouds =
      bound_binary_times(current_bounds[1], current_bounds[2], son_bound[i][1], son_bound[i][2])
  end
  return current_st
end

function node_convexity_binary_time(
  status1::M_implementation_convexity_type.Convexity_type,
  status2::M_implementation_convexity_type.Convexity_type,
  bounds1::Tuple{T, T},
  bounds2::Tuple{T, T},
) where {T <: Number}
  cste_exist =
    M_implementation_convexity_type.is_constant(status1) ||
    M_implementation_convexity_type.is_constant(status2)
  check_all =
    M_implementation_convexity_type.is_constant(status1) &&
    M_implementation_convexity_type.is_constant(status2)
  if check_all # both status are M_constant
    return M_implementation_convexity_type.constant_type()
  elseif (
    M_implementation_convexity_type.is_constant(status2) &&
    M_implementation_convexity_type.is_linear(status1)
  ) || (
    M_implementation_convexity_type.is_constant(status1) &&
    M_implementation_convexity_type.is_linear(status2)
  )
    return M_implementation_convexity_type.linear_type()
  elseif cste_exist #only one status is constant
    if M_implementation_convexity_type.is_constant(status1) # les 2 éléments du tuples sont égaux
      cst = bounds1[1]
      if M_implementation_convexity_type.is_convex(status2)
        cst >= 0 ? M_implementation_convexity_type.convex_type() :
        M_implementation_convexity_type.concave_type()
      elseif M_implementation_convexity_type.is_concave(status2)
        cst >= 0 ? M_implementation_convexity_type.concave_type() :
        M_implementation_convexity_type.convex_type()
      else
        return M_implementation_convexity_type.unknown_type()
      end
    else
      cst = bounds2[1]
      if M_implementation_convexity_type.is_convex(status1)
        cst >= 0 ? M_implementation_convexity_type.convex_type() :
        M_implementation_convexity_type.concave_type()
      elseif M_implementation_convexity_type.is_concave(status1)
        cst >= 0 ? M_implementation_convexity_type.concave_type() :
        M_implementation_convexity_type.convex_type()
      else
        return M_implementation_convexity_type.unknown_type()
      end
    end
  else
    return M_implementation_convexity_type.unknown_type()
  end
end

function _node_bound(
  op::Time_operator,
  son_bound::AbstractVector{Tuple{T, T}},
  t::DataType,
) where {Y <: Number} where {T <: Number}
  vector_inf_bound = [p[1] for p in son_bound]
  vector_sup_bound = [p[2] for p in son_bound]
  bi = (T)(vector_inf_bound[1])::T
  bs = (T)(vector_sup_bound[1])::T
  n = length(vector_inf_bound)
  for i = 2:n
    (bi, bs) = bound_binary_times(bi, bs, vector_inf_bound[i], vector_sup_bound[i])
  end
  return (bi, bs)
end

function bound_binary_times(bi1::T, bs1::T, bi2::T, bs2::T) where {T <: Number}
  products = [bi1 * bi2, bi1 * bs2, bs1 * bi2, bs1 * bs2]
  filtered_products = filter((x -> isnan(x) == false), products)
  bi = min(filtered_products...)
  bs = max(filtered_products...)
  return (bi, bs)
end

@inline create_node_expr(op::Time_operator) = Time_operator()

@inline _node_is_operator(op::Time_operator) = true
@inline _node_is_plus(op::Time_operator) = false
@inline _node_is_minus(op::Time_operator) = false
@inline _node_is_times(op::Time_operator) = true
@inline _node_is_power(op::Time_operator) = false
@inline _node_is_sin(op::Time_operator) = false
@inline _node_is_cos(op::Time_operator) = false
@inline _node_is_tan(op::Time_operator) = false

@inline _node_is_variable(op::Time_operator) = false

@inline _node_is_constant(op::Time_operator) = false

@inline _get_type_node(op::Time_operator, type_ch::Vector{Type_expr_basic}) =
  foldl(M_trait_type_expr.type_product, type_ch)

@inline (==)(a::Time_operator, b::Time_operator) = true

@inline _evaluate_node(op::Time_operator, value_ch::AbstractVector{T}) where {T <: Number} =
  foldl(*, value_ch)

@inline _evaluate_node!(
  op::Time_operator,
  value_ch::AbstractVector{M_abstract_expr_node.MyRef{Y}},
  ref::M_abstract_expr_node.MyRef{Y},
) where {Y <: Number} = M_abstract_expr_node.set_myRef!(ref, foldl(*, value_ch))

@inline function _evaluate_node!(
  op::Time_operator,
  vec_value_ch::Vector{Vector{M_abstract_expr_node.MyRef{Y}}},
  vec_ref::Vector{M_abstract_expr_node.MyRef{Y}},
) where {Y <: Number}
  for i = 1:length(vec_value_ch)
    _evaluate_node!(op, vec_value_ch[i], vec_ref[i])
  end
end

@inline _node_to_Expr(op::Time_operator) = [:*]

end
