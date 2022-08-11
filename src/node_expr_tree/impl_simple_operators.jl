module M_simple_operator

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

using ..M_implementation_convexity_type
using ..M_implementation_type_expr
using ..M_trait_type_expr
using ..M_abstract_expr_node

export Simple_operator

using ..M_plus_operator, ..M_minus_operator, ..M_times_operator, ..M_sinus_operator
using ..M_tan_operator, ..M_cos_operator, ..M_exp_operator, ..M_frac_operator

mutable struct Simple_operator <: Abstract_expr_node
  op::Symbol
end

function create_node_expr(op::Symbol)
  if op == :+
    M_plus_operator.Plus_operator()
  elseif op == :-
    M_minus_operator.Minus_operator()
  elseif op == :*
    M_times_operator.Time_operator()
  elseif op == :/
    M_frac_operator.Frac_operator()
  elseif op == :sin
    M_sinus_operator.Sinus_operator()
  elseif op == :tan
    M_tan_operator.Tan_operator()
  elseif op == :cos
    M_cos_operator.Cos_operator()
  elseif op == :exp
    M_exp_operator.Exp_operator()
  else
    return Simple_operator(op)
  end
end

function create_node_expr(op::Symbol, x::AbstractVector{Y}) where {Y <: Number}
  if op == :+
    M_plus_operator.Plus_operator()
  elseif op == :-
    M_minus_operator.Minus_operator()
  elseif op == :*
    M_times_operator.Time_operator()
  elseif op == :/
    M_frac_operator.Frac_operator()
  elseif op == :sin
    M_sinus_operator.Sinus_operator()
  elseif op == :tan
    M_tan_operator.Tan_operator()
  elseif op == :cos
    M_cos_operator.Cos_operator()
  elseif op == :exp
    M_exp_operator.Exp_operator()
  else
    return Simple_operator(op)
  end
end

end
