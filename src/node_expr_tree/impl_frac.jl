module frac_operators

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
export variable

mutable struct frac_operator <: ab_ex_nd
end

function _node_convexity(
  op::frac_operator,
  son_cvx::AbstractVector{implementation_convexity_type.convexity_type},
  son_bound::AbstractVector{Tuple{T, T}},
) where {T <: Number}
  length(son_cvx) == length(son_bound) ||
    error("unsuitable parameter _node_convexity : minus_operator")
  st_denom = son_cvx[2]
  st_num = son_cvx[1]
  (bi_num, bs_num) = son_bound[1]
  (bi_denom, bs_denom) = son_bound[2]
  if implementation_convexity_type.is_constant(st_denom) &&
     implementation_convexity_type.is_constant(st_num)
    return implementation_convexity_type.constant_type()
  elseif implementation_convexity_type.is_constant(st_denom) &&
         implementation_convexity_type.is_linear(st_num)
    return implementation_convexity_type.linear_type()
  elseif implementation_convexity_type.is_constant(st_denom) && (
    (bi_denom > 0 && implementation_convexity_type.is_convex(st_num)) ||
    (bi_denom < 0 && implementation_convexity_type.is_concave(st_num))
  )
    return implementation_convexity_type.convex_type()
  elseif implementation_convexity_type.is_constant(st_denom) && (
    (bs_denom < 0 && implementation_convexity_type.is_convex(st_num)) ||
    (bi_denom > 0 && implementation_convexity_type.is_concave(st_num))
  )
    return implementation_convexity_type.concave_type()
  elseif !(check_0_in(bi_denom, bs_denom)) &&
         implementation_convexity_type.is_constant(st_num) &&
         (
           (
             (bi_num >= 0) && (bi_denom > 0) && implementation_convexity_type.is_concave(st_denom)
           ) ||
           ((bs_num <= 0) && (bs_denom < 0) && implementation_convexity_type.is_convex(st_denom))
         )
    return implementation_convexity_type.convex_type()
  elseif !(check_0_in(bi_denom, bs_denom)) &&
         implementation_convexity_type.is_constant(st_num) &&
         (
           ((bi_num >= 0) && (bs_denom < 0) && implementation_convexity_type.is_convex(st_denom)) ||
           ((bs_num <= 0) && (bi_denom > 0) && implementation_convexity_type.is_concave(st_denom))
         )
    return implementation_convexity_type.concave_type()
  else
    return implementation_convexity_type.unknown_type()
  end
end

check_0_in(bi::T, bs::T) where {T <: Number} = (bi <= 0) && (bs >= 0)
check_0_plus(bi::T, bs::T) where {T <: Number} = (bi <= 0) && (bs > 0)
check_0_minus(bi::T, bs::T) where {T <: Number} = (bi < 0) && (bs >= 0)
check_positive(bi::T, bs::T) where {T <: Number} = (bi >= 0)
check_negative(bi::T, bs::T) where {T <: Number} = (bs <= 0)
check_positive_negative(bi::T, bs::T) where {T <: Number} = (bi < 0) && (bs > 0)
function _node_bound(
  op::frac_operator,
  son_bound::AbstractVector{Tuple{T, T}},
  t::DataType,
) where {T <: Number}
  (bi_num, bs_num) = son_bound[1]
  (bi_denom, bs_denom) = son_bound[2]
  (length(son_bound) == 2) || error("error bound minus operator")
  if (check_0_in(bi_denom, bs_denom) && check_positive_negative(bi_num, bs_num)) ||
     (check_0_plus(bi_denom, bs_denom) && check_0_minus(bi_denom, bs_denom)) ||
     (
       check_positive_negative(bi_num, bs_num) &&
       (check_0_plus(bi_denom, bs_denom) || check_0_minus(bi_denom, bs_denom))
     )
    return (t(-Inf), t(Inf))
  elseif check_positive(bi_denom, bs_denom) || check_negative(bi_denom, bs_denom)
    brut_force_bound_frac(bi_num, bs_num, bi_denom, bs_denom)
  else
    println("non traité _node_bound frac")
    return (t(-Inf), t(Inf))
  end
end

function brut_force_bound_frac(bi1::T, bs1::T, bi2::T, bs2::T) where {T <: Number}
  products = [bi1 / bi2, bi1 / bs2, bs1 / bi2, bs1 / bs2]
  filtered_products = filter((x -> isnan(x) == false), products)
  # @show filtered_products, products, bi1,bs1,bi2,bs2
  bi = min(filtered_products...)
  bs = max(filtered_products...)
  return (bi, bs)
end

@inline create_node_expr(op::frac_operator) = frac_operator()

@inline _node_is_operator(op::frac_operator) = true
@inline _node_is_plus(op::frac_operator) = false
@inline _node_is_minus(op::frac_operator) = false
@inline _node_is_times(op::frac_operator) = false
@inline _node_is_power(op::frac_operator) = false
@inline _node_is_sin(op::frac_operator) = false
@inline _node_is_cos(op::frac_operator) = false
@inline _node_is_tan(op::frac_operator) = false
@inline _node_is_frac(op::frac_operator) = true

@inline _node_is_variable(op::frac_operator) = false

@inline _node_is_constant(op::frac_operator) = false

function _get_type_node(op::frac_operator, type_ch::Vector{t_type_expr_basic})
  t_denom = type_ch[2]
  if trait_type_expr._is_constant(t_denom)
    return type_ch[1]
  else
    implementation_type_expr.return_more()
  end
end

@inline (==)(a::frac_operator, b::frac_operator) = true

@inline _evaluate_node(op::frac_operator, value_ch::AbstractVector{T}) where {T <: Number} =
  value_ch[1] / value_ch[2]
@inline _evaluate_node!(
  op::frac_operator,
  value_ch::AbstractVector{abstract_expr_node.myRef{T}},
  ref::abstract_expr_node.myRef{T},
) where {T <: Number} = abstract_expr_node.set_myRef!(ref, value_ch[1] / value_ch[2])
@inline function _evaluate_node!(
  op::frac_operator,
  vec_value_ch::Vector{Vector{abstract_expr_node.myRef{T}}},
  vec_ref::Vector{abstract_expr_node.myRef{T}},
) where {T <: Number}
  for i = 1:length(vec_value_ch)
    _evaluate_node!(op, vec_value_ch[i], vec_ref[i])
  end
end

@inline _node_to_Expr(op::frac_operator) = [:/]

end
