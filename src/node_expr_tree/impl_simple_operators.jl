module M_simple_operator

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
export simple_operator

using ..M_plus_operator, ..M_minus_operator, ..M_times_operator, ..M_sinus_operator
using ..M_tan_operator, ..M_cos_operator, ..M_exp_operator, ..M_frac_operator

mutable struct simple_operator <: ab_ex_nd
  op::Symbol
end

function create_node_expr(op::Symbol)
  if op == :+
    M_plus_operator.plus_operator()
  elseif op == :-
    M_minus_operator.minus_operator()
  elseif op == :*
    M_times_operator.time_operator()
  elseif op == :/
    M_frac_operator.frac_operator()
  elseif op == :sin
    M_sinus_operator.sinus_operator()
  elseif op == :tan
    M_tan_operator.tan_operator()
  elseif op == :cos
    M_cos_operator.cos_operator()
  elseif op == :exp
    M_exp_operator.exp_operator()
  else
    return simple_operator(op)
  end
end

function create_node_expr(op::Symbol, x::AbstractVector{Y}) where {Y <: Number}
  if op == :+
    M_plus_operator.plus_operator()
  elseif op == :-
    M_minus_operator.minus_operator()
  elseif op == :*
    M_times_operator.time_operator()
  elseif op == :/
    M_frac_operator.frac_operator()
  elseif op == :sin
    M_sinus_operator.sinus_operator()
  elseif op == :tan
    M_tan_operator.tan_operator()
  elseif op == :cos
    M_cos_operator.cos_operator()
  elseif op == :exp
    M_exp_operator.exp_operator()
  else
    return simple_operator(op)
  end
end

end
