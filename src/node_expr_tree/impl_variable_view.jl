module M_variables_view
using MathOptInterface

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
  _change_from_N_to_Ni!,
  _cast_constant!,
  _node_to_Expr,
  _node_to_Expr2,
  _node_bound,
  _node_convexity

import ..M_implementation_type_expr.t_type_expr_basic
using ..M_implementation_convexity_type
using ..M_implementation_type_expr
using ..M_abstract_expr_node
using ..M_variable
import Base.(==)

export variable_view

mutable struct variable_view{Y <: Number} <: ab_ex_nd
  name::Symbol
  index::Int
  x_view::SubArray{Y, 1, Array{Y, 1}, Tuple{Array{Int64, 1}}, false}
end

@inline get_name(v::variable_view{Y}) where {Y <: Number} = v.name
@inline get_index(v::variable_view{Y}) where {Y <: Number} = v.index
@inline get_x_view(v::variable_view{Y}) where {Y <: Number} = v.x_view
@inline get_value(v::variable_view{Y}) where {Y <: Number} = get_x_view(v)[1]

@inline _node_bound(v::variable_view{Y}, t::DataType) where {Y <: Number} = ((t)(-Inf), (t)(Inf))

@inline _node_convexity(v::variable_view{Y}) where {Y <: Number} =
  M_implementation_convexity_type.linear_type()

@inline create_node_expr(n::Symbol, id::Int, x::AbstractVector{Y}) where {Y <: Number} =
  variable_view(n, id, view(x, [id]))
@inline create_node_expr(
  n::Symbol,
  id::MathOptInterface.VariableIndex,
  x::AbstractVector{Y},
) where {Y <: Number} = variable_view(n, id.value, view(x, [id.value]))
@inline create_node_expr(v::variable_view{Y}, x::AbstractVector{Y}) where {Y <: Number} =
  variable_view(v.name, v.index, view(x, [v.index]))
@inline create_node_expr(v::M_variable.variable, x::AbstractVector{Y}) where {Y <: Number} =
  create_node_expr(M_variable.get_name(v),M_variable.get_index(v), x)

# (SubArray{Y,1,Array{Y,1},Tuple{Array{Int64,1}},false} where Y <: Number) <: (AbstractVector{Y} where Y <: Number)

@inline _node_is_operator(v::variable_view{Y}) where {Y <: Number} = false
@inline _node_is_plus(v::variable_view{Y}) where {Y <: Number} = false
@inline _node_is_minus(v::variable_view{Y}) where {Y <: Number} = false
@inline _node_is_times(v::variable_view{Y}) where {Y <: Number} = false
@inline _node_is_power(v::variable_view{Y}) where {Y <: Number} = false
@inline _node_is_sin(v::variable_view{Y}) where {Y <: Number} = false
@inline _node_is_cos(v::variable_view{Y}) where {Y <: Number} = false
@inline _node_is_tan(v::variable_view{Y}) where {Y <: Number} = false

@inline _node_is_variable(v::variable_view{Y}) where {Y <: Number} = true

@inline _node_is_constant(v::variable_view{Y}) where {Y <: Number} = false

@inline _get_type_node(v::variable_view{Y}) where {Y <: Number} =
  M_implementation_type_expr.return_linear()

@inline _get_var_index(v::variable_view{Y}) where {Y <: Number} = v.index::Int

@inline (==)(a::variable_view{Y}, b::variable_view{Y}) where {Y <: Number} =
  (a.name == b.name) && (a.index == b.index) && (a.x_view[1] == b.x_view[1])

@inline _evaluate_node(v::variable_view{Y}, dic::Dict{Int, Y}) where {Y <: Number} = dic[v.index]::T
@inline _evaluate_node(v::variable_view{Y}, x::AbstractVector{Y}) where {Y <: Number} =
  get_values(v)
@inline _evaluate_node!(
  v::variable_view{Y},
  x::AbstractVector{Y},
  ref::MyRef{Y},
) where {Y <: Number} = M_abstract_expr_node.set_myRef!(ref, get_value(v, x))
@inline _evaluate_node(v::variable_view{Y}) where {Y <: Number} = get_values(v)
@inline _evaluate_node!(v::variable_view{Y}, ref::MyRef{Y}) where {Y <: Number} =
  M_abstract_expr_node.set_myRef!(ref, get_value(v))

function change_index(v::MathOptInterface.VariableIndex, x::AbstractVector{T}) where {T <: Number}
  return x[v.value]
end

function _change_from_N_to_Ni!(v::variable_view{Y}, dic_new_var::Dict{Int, Int}) where {Y <: Number}
  v.index = dic_new_var[v.index]
  paren_x_view = parent(x_view)
  v.x_view = view(paren_x_view, [v.index])
end

@inline _node_to_Expr(v::variable_view{Y}) where {Y <: Number} =
  Expr(:ref, v.name, MathOptInterface.VariableIndex(v.index))
@inline _node_to_Expr2(v::variable_view{Y}) where {Y <: Number} = Expr(:ref, v.name, v.index)

function _cast_constant!(v::variable_view{Y}, t::DataType) where {Y <: Number}
  x_view = get_x_view(v)
  parent = parent(x_view)
  eltype(parent) != t || warning("wrong type from the parent of the variable view")
  index = get_index(v)
  name = get_name(v)
  create_node_expr(n, index, parent)
end

end
