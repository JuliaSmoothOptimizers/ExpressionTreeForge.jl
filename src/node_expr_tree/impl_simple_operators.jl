module simple_operators

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
export simple_operator

using ..plus_operators, ..minus_operators, ..times_operators, ..sinus_operators
using ..tan_operators, ..cos_operators, ..exp_operators, ..frac_operators

mutable struct simple_operator <: ab_ex_nd
  op::Symbol
end

function create_node_expr(op::Symbol)
  if op == :+
    plus_operators.plus_operator()
  elseif op == :-
    minus_operators.minus_operator()
  elseif op == :*
    times_operators.time_operator()
  elseif op == :/
    frac_operators.frac_operator()
  elseif op == :sin
    sinus_operators.sinus_operator()
  elseif op == :tan
    tan_operators.tan_operator()
  elseif op == :cos
    cos_operators.cos_operator()
  elseif op == :exp
    exp_operators.exp_operator()
  else
    return simple_operator(op)
  end
end

function create_node_expr(op::Symbol, x::AbstractVector{Y}) where {Y <: Number}
  if op == :+
    plus_operators.plus_operator()
  elseif op == :-
    minus_operators.minus_operator()
  elseif op == :*
    times_operators.time_operator()
  elseif op == :/
    frac_operators.frac_operator()
  elseif op == :sin
    sinus_operators.sinus_operator()
  elseif op == :tan
    tan_operators.tan_operator()
  elseif op == :cos
    cos_operators.cos_operator()
  elseif op == :exp
    exp_operators.exp_operator()
  else
    return simple_operator(op)
  end
end

end
