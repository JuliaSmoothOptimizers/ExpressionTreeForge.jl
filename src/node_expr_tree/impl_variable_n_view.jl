module M_variables_n_view
using MathOptInterface

import ..M_abstract_expr_node.Abstract_expr_node, ..M_abstract_expr_node.create_node_expr
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
  _node_to_Expr,
  _node_to_Expr2,
  _node_bound,
  _node_convexity

import ..M_implementation_type_expr.Type_expr_basic
import ..M_interface_expr_node._node_bound, ..M_interface_expr_node._node_convexity
using ..M_implementation_convexity_type, ..M_implementation_type_expr
using ..M_abstract_expr_node
using ..M_variable
import Base.(==)

export Variable_n_view

mutable struct Variable_n_view{Y <: Number} <: Abstract_expr_node
  name::Symbol
  index::Int
  multiple_x_view::Vector{SubArray{Y, 1, Array{Y, 1}, Tuple{Array{Int64, 1}}, false}}
end

@inline get_name(v::Variable_n_view{Y}) where {Y <: Number} = v.name
@inline get_index(v::Variable_n_view{Y}) where {Y <: Number} = v.index
@inline get_multiple_x_view(v::Variable_n_view{Y}) where {Y <: Number} = v.multiple_x_view
@inline get_x_view(v::Variable_n_view{Y}, i::Int) where {Y <: Number} =
  get_multiple_x_view(v)[i]
@inline get_value(v::Variable_n_view{Y}, i::Int) where {Y <: Number} = get_x_view(v, i)[1]

@inline _node_bound(v::Variable_n_view{Y}, t::DataType) where {Y <: Number} = ((t)(-Inf), (t)(Inf))

@inline _node_convexity(v::Variable_n_view{Y}) where {Y <: Number} =
  M_implementation_convexity_type.linear_type()

@inline create_node_expr(n::Symbol, id::Int, multiple_x::Vector{Vector{Y}}) where {Y <: Number} =
  Variable_n_view{Y}(n, id, map(x -> view(x, [id]), multiple_x))
@inline create_node_expr(v::M_variable.Variable, multiple_x::Vector{Vector{Y}}) where {Y <: Number} =
  create_node_expr(M_variable.get_name(v),M_variable.get_index(v), multiple_x)

@inline create_node_expr(
  n::Symbol,
  id::Int,
  multiple_x_view::Vector{SubArray{T, 1, Array{T, 1}, N, false}},
) where {N} where {T <: Number} =
  Variable_n_view{T}(n, id, map(x -> view(x, [id]), multiple_x_view))
@inline create_node_expr(
  v::M_variable.Variable,
  multiple_x_view::Vector{SubArray{T, 1, Array{T, 1}, N, false}},
) where {N} where {T <: Number} =
  create_node_expr(M_variable.get_name(v),M_variable.get_index(v), multiple_x_view)

@inline _node_is_operator(v::Variable_n_view{Y}) where {Y <: Number} = false
@inline _node_is_plus(v::Variable_n_view{Y}) where {Y <: Number} = false
@inline _node_is_minus(v::Variable_n_view{Y}) where {Y <: Number} = false
@inline _node_is_times(v::Variable_n_view{Y}) where {Y <: Number} = false
@inline _node_is_power(v::Variable_n_view{Y}) where {Y <: Number} = false
@inline _node_is_sin(v::Variable_n_view{Y}) where {Y <: Number} = false
@inline _node_is_cos(v::Variable_n_view{Y}) where {Y <: Number} = false
@inline _node_is_tan(v::Variable_n_view{Y}) where {Y <: Number} = false

@inline _node_is_variable(v::Variable_n_view{Y}) where {Y <: Number} = true

@inline _node_is_constant(v::Variable_n_view{Y}) where {Y <: Number} = false

@inline _get_type_node(v::Variable_n_view{Y}) where {Y <: Number} =
  M_implementation_type_expr.return_linear()

@inline _get_var_index(v::Variable_n_view{Y}) where {Y <: Number} = v.index::Int

#peut-être à revoir
@inline (==)(a::Variable_n_view{Y}, b::Variable_n_view{Y}) where {Y <: Number} =
  (a.name == b.name) && (a.index == b.index) && (a.multiple_x_view .== b.multiple_x_view)

@inline _evaluate_node!(
  v::Variable_n_view{Y},
  ref::M_abstract_expr_node.MyRef{Y},
  i::Int,
) where {Y <: Number} = M_abstract_expr_node.set_myRef!(ref, get_value(v, i))
@inline _evaluate_node!(
  v::Variable_n_view{Y},
  multiple_ref::AbstractVector{M_abstract_expr_node.MyRef{Y}},
) where {Y <: Number} = begin
  for i in [1:length(multiple_ref);]
    _evaluate_node!(v, multiple_ref[i], i)
  end
end

function _change_from_N_to_Ni!(
  v::Variable_n_view{Y},
  dic_new_var::Dict{Int, Int},
) where {Y <: Number}
  v.index = dic_new_var[v.index]
  function each_view(index::Int, v::Variable_n_view{Y}) where {Y <: Number}
    x_view = v.multiple_x_view[i]
    parent_x_view = parent(x_view)
    v.multiple_x_view[i] = view(parent_x_view, [v.index])
  end
  map(i -> each_view(i, v), [1:length(v.multiple_x_view)])
end

end
