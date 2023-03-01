module M_constant

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
using ..M_trait_type_expr
using ..M_abstract_expr_node

export Constant

mutable struct Constant{T <: Number} <: Abstract_expr_node
  value::T
end

@inline Base.convert(::Type{Constant{T}}, x::Constant{Y}) where {Y <: Number, T <: Number} =
  Constant{T}(T(x.value))
@inline _node_bound(c::Constant{T}, t::DataType) where {T <: Number} = ((t)(c.value), (t)(c.value))
@inline _node_convexity(c::Constant{T}) where {T <: Number} =
  M_implementation_convexity_type.constant_type()

@inline create_node_expr(x::T) where {T <: Number} = Constant{T}(x)
@inline create_node_expr(c::Constant{T}) where {T <: Number} = Constant{T}(c.value)
@inline create_node_expr(c::T, x::AbstractVector{T}) where {T <: Number} = Constant{T}(c)
@inline create_node_expr(c::Constant{T}, x::AbstractVector{T}) where {T <: Number} =
  Constant{T}(c.value)

@inline create_node_expr(c::Constant{T}, x::Vector{Vector{T}}) where {T <: Number} =
  Constant{T}(c.value)

@inline create_node_expr(
  c::Constant{T},
  x::Vector{SubArray{T, 1, Array{T, 1}, N, false}},
) where {N} where {T <: Number} = Constant{T}(c.value)

@inline _node_is_operator(c::Constant{T}) where {T <: Number} = false
@inline _node_is_plus(c::Constant{T}) where {T <: Number} = false
@inline _node_is_minus(c::Constant{T}) where {T <: Number} = false
@inline _node_is_times(c::Constant{T}) where {T <: Number} = false
@inline _node_is_power(c::Constant{T}) where {T <: Number} = false
@inline _node_is_sin(c::Constant{T}) where {T <: Number} = false
@inline _node_is_cos(c::Constant{T}) where {T <: Number} = false
@inline _node_is_tan(c::Constant{T}) where {T <: Number} = false

@inline _node_is_variable(c::Constant{T}) where {T <: Number} = false

@inline _node_is_constant(c::Constant{T}) where {T <: Number} = true

@inline _get_type_node(c::Constant{T}) where {T <: Number} =
  M_implementation_type_expr.return_constant()

@inline (==)(a::Constant{T}, b::Constant{T}) where {T <: Number} = (a.value == b.value)
@inline string(a::Constant{T}) where {T <: Number} = string(a.value)

@inline _evaluate_node(
  c::Constant{Y},
  x::SubArray{T, 1, Array{T, 1}, Tuple{Array{Int64, 1}}, false},
) where {Y <: Number} where {T <: Number} = (T)(c.value)::T

@inline _evaluate_node(c::Constant{Y}, dic::Dict{Int, T where T <: Number}) where {Y <: Number} =
  c.value::Y

@inline _evaluate_node(
  c::Constant{Y},
  x::AbstractVector{T},
) where {Y <: Number} where {T <: Number} = (c.value)

@inline _evaluate_node(c::Constant{Y}, x::AbstractVector{Y}) where {Y <: Number} = c.value::Y
@inline _evaluate_node(c::Constant{Y}) where {Y <: Number} = c.value::Y

@inline _change_from_N_to_Ni!(c::Constant, dic_new_indices::Dict{Int, Int}) = c

@inline _cast_constant!(c::Constant{Y}, t::DataType) where {Y <: Number} = Constant{t}((t)(c.value))
@inline _cast_constant!(c::Number, t::DataType) = (t)(c)

@inline _node_to_Expr(c::Constant{Y}) where {Y <: Number} = c.value
@inline _node_to_Expr2(c::Constant{Y}) where {Y <: Number} = c.value
@inline _node_to_Expr_JuMP(c::Constant{Y}) where {Y <: Number} = c.value

end
