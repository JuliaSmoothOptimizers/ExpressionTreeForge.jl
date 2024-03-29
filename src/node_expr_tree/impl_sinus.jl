module M_sinus_operator

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

export Sinus_operator

mutable struct Sinus_operator <: Abstract_expr_node end

function _node_convexity(
  op::Sinus_operator,
  son_cvx::AbstractVector{M_implementation_convexity_type.Convexity_type},
  son_bound::AbstractVector{Tuple{T, T}},
) where {T <: Number}
  (length(son_cvx) == length(son_bound) && length(son_cvx) == 1) ||
    error("unsuitable length of parameters _node_convexity : sin_operator")
  status = son_cvx[1]
  (bi, bs) = son_bound[1]
  if M_implementation_convexity_type.is_constant(status)
    return M_implementation_convexity_type.constant_type()
  elseif (bs - bi > π) || (sin(bi) * sin(bs) < 0)
    return M_implementation_convexity_type.unknown_type()
  elseif ((bs - bi <= π) && (sin(bi) >= 0) && (sin(bs) >= 0)) && (
    M_implementation_convexity_type.is_linear(status) ||
    (M_implementation_convexity_type.is_convex(status) && cos(bi) <= 0 && cos(bs <= 0)) ||
    (M_implementation_convexity_type.is_concave(status) && cos(bi) >= 0 && cos(bs >= 0))
  )
    return M_implementation_convexity_type.concave_type()
  elseif ((bs - bi <= π) && (sin(bi) <= 0) && (sin(bs) <= 0)) && (
    M_implementation_convexity_type.is_linear(status) ||
    (M_implementation_convexity_type.is_convex(status) && cos(bi) >= 0 && cos(bs >= 0)) ||
    (M_implementation_convexity_type.is_concave(status) && cos(bi) <= 0 && cos(bs <= 0))
  )
    return M_implementation_convexity_type.convex_type()
  else
    return M_implementation_convexity_type.unknown_type()
  end
end

function _node_bound(
  op::Sinus_operator,
  son_bound::AbstractVector{Tuple{T, T}},
  t::DataType,
) where {T <: Number}
  vector_inf_bound = [p[1] for p in son_bound]
  vector_sup_bound = [p[2] for p in son_bound]
  length(vector_inf_bound) == 1 || error("non unary sinus")
  length(vector_sup_bound) == 1 || error("non unary sinus")
  bi = vector_inf_bound[1]
  bs = vector_sup_bound[1]
  if abs(bs - bi) > 2 * π || isinf(bi) || isinf(bs)
    return (t(-1), t(1))
  else
    bs_π = max(bs % (2 * π), bi % (2 * π))
    bi_π = min(bs % (2 * π), bi % (2 * π))
    return (inf_bound_sin(bi_π, bs_π, t), sup_bound_sin(bi_π, bs_π, t))
  end
end

function sup_bound_sin(bi, bs, t::DataType)
  if belong(bi, bs, π / 2)
    return t(1)
  elseif bs < π / 2 # bi < π / 2
    return sin(bs)
  else
    return max(sin(bs), sin(bi))
  end
end

function inf_bound_sin(bi, bs, t::DataType)
  if belong(bi, bs, -π / 2)
    return t(-1)
  elseif bi > -π / 2 # bs > -π / 2
    return sin(bi)
  else
    return min(sin(bs), sin(bi)) # case where bi=0 and bs = 3π/4
  end
end

@inline belong(bi, bs, x) = (bi <= x) && (bs >= x)

@inline create_node_expr(op::Sinus_operator) = Sinus_operator()

@inline _node_is_operator(op::Sinus_operator) = true
@inline _node_is_plus(op::Sinus_operator) = false
@inline _node_is_minus(op::Sinus_operator) = false
@inline _node_is_times(op::Sinus_operator) = false
@inline _node_is_power(op::Sinus_operator) = false
@inline _node_is_sin(op::Sinus_operator) = true
@inline _node_is_cos(op::Sinus_operator) = false
@inline _node_is_tan(op::Sinus_operator) = false

@inline _node_is_variable(op::Sinus_operator) = false

@inline _node_is_constant(op::Sinus_operator) = false

function _get_type_node(op::Sinus_operator, type_ch::Vector{Type_expr_basic})
  if length(type_ch) == 1
    t_child = type_ch[1]
    if M_trait_type_expr._is_constant(t_child)
      return t_child
    else
      return M_implementation_type_expr.return_more()
    end
  end
end

@inline (==)(a::Sinus_operator, b::Sinus_operator) = true
@inline string(a::Sinus_operator) = "sin"

@inline function _evaluate_node(op::Sinus_operator, value_ch::AbstractVector{T}) where {T <: Number}
  length(value_ch) == 1 || error("more than one argument for sin")
  return sin(value_ch[1])
end

@inline _node_to_Expr(op::Sinus_operator) = [:sin]
@inline _node_to_Expr2(op::Sinus_operator) = [:sin]
@inline _node_to_Expr_JuMP(op::Sinus_operator) = [:sin]

end
