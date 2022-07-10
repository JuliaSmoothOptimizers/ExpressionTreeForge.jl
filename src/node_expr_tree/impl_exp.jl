module M_exp_operator

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

export Exp_operator

mutable struct Exp_operator <: Abstract_expr_node end

function _node_convexity(
  op::Exp_operator,
  son_cvx::AbstractVector{M_implementation_convexity_type.Convexity_type},
  son_bound::AbstractVector{Tuple{T, T}},
) where {T <: Number}
  (length(son_cvx) == length(son_bound) && length(son_cvx) == 1) ||
    error("unsuitable length of parameters _node_convexity : Exp_operator")
  status = son_cvx[1]
  if M_implementation_convexity_type.is_constant(status)
    return M_implementation_convexity_type.constant_type()
  elseif M_implementation_convexity_type.is_convex(status)
    return M_implementation_convexity_type.convex_type()
  else
    return M_implementation_convexity_type.unknown_type()
  end
end

function _node_bound(
  op::Exp_operator,
  son_bound::AbstractVector{Tuple{T, T}},
  t::DataType,
) where {Y <: Number} where {T <: Number}
  vector_inf_bound = [p[1] for p in son_bound]
  vector_sup_bound = [p[2] for p in son_bound]
  length(vector_inf_bound) == 1 || error("more than one argument")
  length(vector_sup_bound) == 1 || error("more than one argument")
  bi = vector_inf_bound[1]
  bs = vector_sup_bound[1]
  return (exp(bi), exp(bs))
end

@inline create_node_expr(op::Exp_operator) = Exp_operator()

@inline _node_is_operator(op::Exp_operator) = true
@inline _node_is_plus(op::Exp_operator) = false
@inline _node_is_minus(op::Exp_operator) = false
@inline _node_is_times(op::Exp_operator) = false
@inline _node_is_power(op::Exp_operator) = false
@inline _node_is_sin(op::Exp_operator) = false
@inline _node_is_cos(op::Exp_operator) = false
@inline _node_is_tan(op::Exp_operator) = false

@inline _node_is_variable(op::Exp_operator) = false

@inline _node_is_constant(op::Exp_operator) = false

function _get_type_node(op::Exp_operator, type_ch::Vector{Type_expr_basic})
  if length(type_ch) == 1
    t_child = type_ch[1]
    if M_trait_type_expr._is_constant(t_child)
      return t_child
    else
      return M_implementation_type_expr.return_more()
    end
  end
end

@inline (==)(a::Exp_operator, b::Exp_operator) = true
@inline string(a::Exp_operator) = "exp"


@inline function _evaluate_node(op::Exp_operator, value_ch::AbstractVector{T}) where {T <: Number}
  length(value_ch) == 1 || error("more than one argument for exp")
  return exp(value_ch[1])
end

@inline function _evaluate_node!(
  op::Exp_operator,
  value_ch::AbstractVector{MyRef{Y}},
  ref::M_abstract_expr_node.MyRef{Y},
) where {Y <: Number}
  length(value_ch) == 1 || error("exp has more than one argument")
  M_abstract_expr_node.set_myRef!(ref, exp(value_ch[1]))
  return ref
end

@inline function _evaluate_node!(
  op::Exp_operator,
  vec_value_ch::Vector{Vector{MyRef{Y}}},
  vec_ref::Vector{M_abstract_expr_node.MyRef{Y}},
) where {Y <: Number}
  for i = 1:length(vec_value_ch)
    _evaluate_node!(op, vec_value_ch[i], vec_ref[i])
  end
end

@inline _node_to_Expr(op::Exp_operator) = [:exp]

end
