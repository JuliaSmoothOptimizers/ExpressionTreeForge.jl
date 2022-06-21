module variables_n_view
using MathOptInterface

import ..abstract_expr_node.ab_ex_nd, ..abstract_expr_node.create_node_expr
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
import ..interface_expr_node._node_bound, ..interface_expr_node._node_convexity
using ..implementation_convexity_type, ..implementation_type_expr
using ..abstract_expr_node
using ..variables
import Base.(==)

export variable_n_view

mutable struct variable_n_view{Y <: Number} <: ab_ex_nd
  name::Symbol
  index::Int
  multiple_x_view::Vector{SubArray{Y, 1, Array{Y, 1}, Tuple{Array{Int64, 1}}, false}}
end

@inline get_name(v::variable_n_view{Y}) where {Y <: Number} = v.name
@inline get_index(v::variable_n_view{Y}) where {Y <: Number} = v.index
@inline get_multiple_x_view(v::variable_n_view{Y}) where {Y <: Number} = v.multiple_x_view
@inline @inbounds get_x_view(v::variable_n_view{Y}, i::Int) where {Y <: Number} =
  get_multiple_x_view(v)[i]
@inline @inbounds get_value(v::variable_n_view{Y}, i::Int) where {Y <: Number} = get_x_view(v, i)[1]

@inline _node_bound(v::variable_n_view{Y}, t::DataType) where {Y <: Number} = ((t)(-Inf), (t)(Inf))

@inline _node_convexity(v::variable_n_view{Y}) where {Y <: Number} =
  implementation_convexity_type.linear_type()

@inline create_node_expr(n::Symbol, id::Int, multiple_x::Vector{Vector{Y}}) where {Y <: Number} =
  variable_n_view{Y}(n, id, map(x -> view(x, [id]), multiple_x))
@inline create_node_expr(v::variables.variable, multiple_x::Vector{Vector{Y}}) where {Y <: Number} =
  create_node_expr(variables.get_name(v), variables.get_index(v), multiple_x)

@inline create_node_expr(
  n::Symbol,
  id::Int,
  multiple_x_view::Vector{SubArray{T, 1, Array{T, 1}, N, false}},
) where {N} where {T <: Number} =
  variable_n_view{T}(n, id, map(x -> view(x, [id]), multiple_x_view))
@inline create_node_expr(
  v::variables.variable,
  multiple_x_view::Vector{SubArray{T, 1, Array{T, 1}, N, false}},
) where {N} where {T <: Number} =
  create_node_expr(variables.get_name(v), variables.get_index(v), multiple_x_view)

@inline _node_is_operator(v::variable_n_view{Y}) where {Y <: Number} = false
@inline _node_is_plus(v::variable_n_view{Y}) where {Y <: Number} = false
@inline _node_is_minus(v::variable_n_view{Y}) where {Y <: Number} = false
@inline _node_is_times(v::variable_n_view{Y}) where {Y <: Number} = false
@inline _node_is_power(v::variable_n_view{Y}) where {Y <: Number} = false
@inline _node_is_sin(v::variable_n_view{Y}) where {Y <: Number} = false
@inline _node_is_cos(v::variable_n_view{Y}) where {Y <: Number} = false
@inline _node_is_tan(v::variable_n_view{Y}) where {Y <: Number} = false

@inline _node_is_variable(v::variable_n_view{Y}) where {Y <: Number} = true

@inline _node_is_constant(v::variable_n_view{Y}) where {Y <: Number} = false

@inline _get_type_node(v::variable_n_view{Y}) where {Y <: Number} =
  implementation_type_expr.return_linear()

@inline _get_var_index(v::variable_n_view{Y}) where {Y <: Number} = v.index::Int

#peut-être à revoir
@inline (==)(a::variable_n_view{Y}, b::variable_n_view{Y}) where {Y <: Number} =
  (a.name == b.name) && (a.index == b.index) && (a.multiple_x_view .== b.multiple_x_view)

@inline _evaluate_node!(
  v::variable_n_view{Y},
  ref::abstract_expr_node.myRef{Y},
  i::Int,
) where {Y <: Number} = abstract_expr_node.set_myRef!(ref, get_value(v, i))
@inline _evaluate_node!(
  v::variable_n_view{Y},
  multiple_ref::AbstractVector{abstract_expr_node.myRef{Y}},
) where {Y <: Number} = begin
  for i in [1:length(multiple_ref);]
    _evaluate_node!(v, multiple_ref[i], i)
  end
end

function _change_from_N_to_Ni!(
  v::variable_n_view{Y},
  dic_new_var::Dict{Int, Int},
) where {Y <: Number}
  v.index = dic_new_var[v.index]
  function each_view(index::Int, v::variable_n_view{Y}) where {Y <: Number}
    x_view = v.multiple_x_view[i]
    parent_x_view = parent(x_view)
    v.multiple_x_view[i] = view(parent_x_view, [v.index])
  end
  map(i -> each_view(i, v), [1:length(v.multiple_x_view)])
end

# non fait
# function _node_to_Expr(v :: variable_view{Y}) where Y <: Number
#     return Expr(:ref, v.name,  MathOptInterface.VariableIndex(v.index))
# end

# non fait
# function _node_to_Expr2(v :: variable_view{Y}) where Y <: Number
#     return Expr(:ref, v.name,  v.index)
# end

# non fait
# function _cast_constant!(v :: variable_view{Y}, t :: DataType) where Y <: Number
#     x_view = get_x_view(v)
#     parent = parent(x_view)
#     eltype(parent) != t || ("wrong type from the parent of the variable view")
#     index = get_index(v)
#     name = get_name(v)
#     create_node_expr(n, index, parent)
# end

end
