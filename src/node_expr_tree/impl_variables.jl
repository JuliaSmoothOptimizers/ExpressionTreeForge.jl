module M_variable
using MathOptInterface

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
  _change_from_N_to_Ni!,
  _cast_constant!,
  _node_to_Expr,
  _node_to_Expr2,
  _node_to_Expr_JuMP,
  _node_bound,
  _node_convexity
import ..M_implementation_type_expr.Type_expr_basic
import Base.(==), Base.string

using ..M_implementation_convexity_type
using ..M_implementation_type_expr
using ..M_abstract_expr_node

export Variable

mutable struct Variable <: Abstract_expr_node
  name::Symbol
  index::Int
end

_node_bound(v::Variable, t::DataType) = ((t)(-Inf), (t)(Inf))

_node_convexity(v::Variable) = M_implementation_convexity_type.linear_type()

create_node_expr(n::Symbol, id::Int) = Variable(n, id)
create_node_expr(n::Symbol, id::MathOptInterface.VariableIndex) = Variable(n, id.value)
create_node_expr(v::Variable) = Variable(v.name, v.index)

create_node_expr(n::Symbol, id::Int, x::AbstractVector{Y}) where {Y <: Number} = Variable(n, id)
create_node_expr(
  n::Symbol,
  id::MathOptInterface.VariableIndex,
  x::AbstractVector{Y},
) where {Y <: Number} = Variable(n, id.value)
create_node_expr(v::Variable, x::AbstractVector{Y}) where {Y <: Number} = Variable(v.name, v.index)

_node_is_operator(v::Variable) = false
_node_is_plus(v::Variable) = false
_node_is_minus(v::Variable) = false
_node_is_times(v::Variable) = false
_node_is_power(v::Variable) = false
_node_is_sin(v::Variable) = false
_node_is_cos(v::Variable) = false
_node_is_tan(v::Variable) = false

_node_is_variable(v::Variable) = true

_node_is_constant(v::Variable) = false

_get_type_node(v::Variable) = M_implementation_type_expr.return_linear()

_get_var_index(v::Variable) = v.index::Int

(==)(a::Variable, b::Variable) = (a.name == b.name) && (a.index == b.index)
@inline string(a::Variable) = string(a.name) * "[" * string(a.index) * "]"

function _evaluate_node(v::Variable, dic::Dict{Int, T}) where {T <: Number}
  return dic[v.index]::T
end

@inline _evaluate_node(v::Variable, x::AbstractVector{T}) where {T <: Number} = x[v.index]

function change_index(v::MathOptInterface.VariableIndex, x::AbstractVector{T}) where {T <: Number}
  return x[v.value]
end

function _change_from_N_to_Ni!(v::Variable, dic_new_var::Dict{Int, Int})
  v.index = dic_new_var[v.index]
end

function _change_from_N_to_Ni!(v::Expr, dic_new_var::Dict{Int, Int})
  hd = v.head
  if hd != :ref
    error("The parameter is not a variable")
  else
    index_variable = v.args[2]
    v.args[2] = change_index(index_variable, dic_new_var)
  end
end

change_index(x::Int, dic_new_var::Dict{Int, Int}) = dic_new_var[x]
change_index(x::MathOptInterface.VariableIndex, dic_new_var::Dict{Int, Int}) =
  MathOptInterface.VariableIndex(dic_new_var[x.value])

_node_to_Expr(v::Variable) = Expr(:ref, v.name, MathOptInterface.VariableIndex(v.index))
_node_to_Expr2(v::Variable) = Symbol(string(v.name) * string(v.index))
_node_to_Expr_JuMP(v::Variable) = MathOptInterface.VariableIndex(v.index)

_cast_constant!(v::Variable, t::DataType) = v

end
