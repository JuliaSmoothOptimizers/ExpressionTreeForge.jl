module M_frac_operator

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
import Base.(==), Base.string

using ..M_implementation_convexity_type
using ..M_implementation_type_expr
using ..M_trait_type_expr
using ..M_abstract_expr_node

export Frac_operator

mutable struct Frac_operator <: Abstract_expr_node end

function _node_convexity(
  op::Frac_operator,
  son_cvx::AbstractVector{M_implementation_convexity_type.Convexity_type},
  son_bound::AbstractVector{Tuple{T, T}},
) where {T <: Number}
  length(son_cvx) == length(son_bound) ||
    error("unsuitable parameter _node_convexity : minus_operator")
  st_denom = son_cvx[2]
  st_num = son_cvx[1]
  (bi_num, bs_num) = son_bound[1]
  (bi_denom, bs_denom) = son_bound[2]
  if M_implementation_convexity_type.is_constant(st_denom) &&
     M_implementation_convexity_type.is_constant(st_num)
    return M_implementation_convexity_type.constant_type()
  elseif M_implementation_convexity_type.is_constant(st_denom) &&
         M_implementation_convexity_type.is_linear(st_num)
    return M_implementation_convexity_type.linear_type()
  elseif M_implementation_convexity_type.is_constant(st_denom) && (
    (bi_denom > 0 && M_implementation_convexity_type.is_convex(st_num)) ||
    (bi_denom < 0 && M_implementation_convexity_type.is_concave(st_num))
  )
    return M_implementation_convexity_type.convex_type()
  elseif M_implementation_convexity_type.is_constant(st_denom) && (
    (bs_denom < 0 && M_implementation_convexity_type.is_convex(st_num)) ||
    (bi_denom > 0 && M_implementation_convexity_type.is_concave(st_num))
  )
    return M_implementation_convexity_type.concave_type()
  elseif !(check_0_in(bi_denom, bs_denom)) &&
    M_implementation_convexity_type.is_constant(st_num) &&
    (
      (
        (bi_num >= 0) &&
        (bi_denom > 0) &&
        M_implementation_convexity_type.is_concave(st_denom)
      ) ||
      ((bs_num <= 0) && (bs_denom < 0) && M_implementation_convexity_type.is_convex(st_denom))
    )
    return M_implementation_convexity_type.convex_type()
  elseif !(check_0_in(bi_denom, bs_denom)) &&
    M_implementation_convexity_type.is_constant(st_num) &&
    (
      (
        (bi_num >= 0) && (bs_denom < 0) && M_implementation_convexity_type.is_convex(st_denom)
      ) || (
        (bs_num <= 0) &&
        (bi_denom > 0) &&
        M_implementation_convexity_type.is_concave(st_denom)
      )
    )
    return M_implementation_convexity_type.concave_type()
  else
    return M_implementation_convexity_type.unknown_type()
  end
end

check_0_in(bi::T, bs::T) where {T <: Number} = (bi <= 0) && (bs >= 0)
check_0_plus(bi::T, bs::T) where {T <: Number} = (bi <= 0) && (bs > 0)
check_0_minus(bi::T, bs::T) where {T <: Number} = (bi < 0) && (bs >= 0)
check_positive(bi::T, bs::T) where {T <: Number} = (bi >= 0)
check_negative(bi::T, bs::T) where {T <: Number} = (bs <= 0)
check_positive_negative(bi::T, bs::T) where {T <: Number} = (bi < 0) && (bs > 0)
function _node_bound(
  op::Frac_operator,
  son_bound::AbstractVector{Tuple{T, T}},
  t::DataType,
) where {T <: Number}
  (bi_num, bs_num) = son_bound[1]
  (bi_denom, bs_denom) = son_bound[2]
  (length(son_bound) == 2) || error("Too many children")
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
    println("unsupported _node_bound frac")
    return (t(-Inf), t(Inf))
  end
end

function brut_force_bound_frac(bi1::T, bs1::T, bi2::T, bs2::T) where {T <: Number}
  products = [bi1 / bi2, bi1 / bs2, bs1 / bi2, bs1 / bs2]
  filtered_products = filter((x -> isnan(x) == false), products)
  bi = min(filtered_products...)
  bs = max(filtered_products...)
  return (bi, bs)
end

@inline create_node_expr(op::Frac_operator) = Frac_operator()

@inline _node_is_operator(op::Frac_operator) = true
@inline _node_is_plus(op::Frac_operator) = false
@inline _node_is_minus(op::Frac_operator) = false
@inline _node_is_times(op::Frac_operator) = false
@inline _node_is_power(op::Frac_operator) = false
@inline _node_is_sin(op::Frac_operator) = false
@inline _node_is_cos(op::Frac_operator) = false
@inline _node_is_tan(op::Frac_operator) = false
@inline _node_is_frac(op::Frac_operator) = true

@inline _node_is_variable(op::Frac_operator) = false

@inline _node_is_constant(op::Frac_operator) = false

function _get_type_node(op::Frac_operator, type_ch::Vector{Type_expr_basic})
  t_denom = type_ch[2]
  if M_trait_type_expr._is_constant(t_denom)
    return type_ch[1]
  else
    M_implementation_type_expr.return_more()
  end
end

@inline (==)(a::Frac_operator, b::Frac_operator) = true
@inline string(a::Frac_operator) = "/"

@inline _evaluate_node(op::Frac_operator, value_ch::AbstractVector{T}) where {T <: Number} =
  value_ch[1] / value_ch[2]
@inline _evaluate_node!(
  op::Frac_operator,
  value_ch::AbstractVector{M_abstract_expr_node.MyRef{T}},
  ref::M_abstract_expr_node.MyRef{T},
) where {T <: Number} = M_abstract_expr_node.set_myRef!(ref, value_ch[1] / value_ch[2])
@inline function _evaluate_node!(
  op::Frac_operator,
  vec_value_ch::Vector{Vector{M_abstract_expr_node.MyRef{T}}},
  vec_ref::Vector{M_abstract_expr_node.MyRef{T}},
) where {T <: Number}
  for i = 1:length(vec_value_ch)
    _evaluate_node!(op, vec_value_ch[i], vec_ref[i])
  end
end

@inline _node_to_Expr(op::Frac_operator) = [:/]

end
