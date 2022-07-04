module variables
using MathOptInterface

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
using ..abstract_expr_node
import Base.(==)
export variable

mutable struct variable <: ab_ex_nd
  name::Symbol
  index::Int
end

@inline get_name(v::variable) = v.name
@inline get_index(v::variable) = v.index
@inline get_value(v::variable, x::AbstractVector{T}) where {T <: Number} = x[get_index(v)]

_node_bound(v::variable, t::DataType) = ((t)(-Inf), (t)(Inf))

_node_convexity(v::variable) = implementation_convexity_type.linear_type()

create_node_expr(n::Symbol, id::Int) = variable(n, id)
create_node_expr(n::Symbol, id::MathOptInterface.VariableIndex) = variable(n, id.value)
create_node_expr(v::variable) = variable(v.name, v.index)

create_node_expr(n::Symbol, id::Int, x::AbstractVector{Y}) where {Y <: Number} = variable(n, id)
create_node_expr(
  n::Symbol,
  id::MathOptInterface.VariableIndex,
  x::AbstractVector{Y},
) where {Y <: Number} = variable(n, id.value)
create_node_expr(v::variable, x::AbstractVector{Y}) where {Y <: Number} = variable(v.name, v.index)

_node_is_operator(v::variable) = false
_node_is_plus(v::variable) = false
_node_is_minus(v::variable) = false
_node_is_times(v::variable) = false
_node_is_power(v::variable) = false
_node_is_sin(v::variable) = false
_node_is_cos(v::variable) = false
_node_is_tan(v::variable) = false

_node_is_variable(v::variable) = true
_node_is_variable(v::Symbol) = true

_node_is_constant(v::variable) = false

_get_type_node(v::variable) = implementation_type_expr.return_linear()

_get_var_index(v::variable) = v.index::Int

(==)(a::variable, b::variable) = (a.name == b.name) && (a.index == b.index)

function _evaluate_node(v::variable, dic::Dict{Int, T}) where {T <: Number}
  return dic[v.index]::T
end

@inline _evaluate_node(v::variable, x::AbstractVector{T}) where {T <: Number} = x[v.index]
@inline _evaluate_node!(
  v::variable,
  x::AbstractVector{T},
  ref::myRef{T},
) where {T <: Number} = abstract_expr_node.set_myRef!(ref, get_value(v, x))

function change_index(v::MathOptInterface.VariableIndex, x::AbstractVector{T}) where {T <: Number}
  return x[v.value]
end

function _change_from_N_to_Ni!(v::variable, dic_new_var::Dict{Int, Int})
  v.index = dic_new_var[v.index]
end

function _change_from_N_to_Ni!(v::Expr, dic_new_var::Dict{Int, Int})
  hd = v.head
  if hd != :ref
    error("on ne traite pas autre chose qu'une variable")
  else
    index_variable = v.args[2]
    v.args[2] = change_index(index_variable, dic_new_var)
  end
end

change_index(x::Int, dic_new_var::Dict{Int, Int}) = dic_new_var[x]
change_index(x::MathOptInterface.VariableIndex, dic_new_var::Dict{Int, Int}) =
  MathOptInterface.VariableIndex(dic_new_var[x.value])

_node_to_Expr(v::variable) = Expr(:ref, v.name, MathOptInterface.VariableIndex(v.index))
_node_to_Expr2(v::variable) = Symbol(string(v.name) * string(v.index))
_cast_constant!(v::variable, t::DataType) = v

end
