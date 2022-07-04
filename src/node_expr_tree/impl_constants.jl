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
  _cast_constant!,
  _node_to_Expr,
  _node_to_Expr2,
  _node_bound,
  _node_convexity
import ..M_implementation_type_expr.Type_expr_basic

using ..M_implementation_convexity_type
using ..M_implementation_type_expr
using ..M_trait_type_expr
using ..M_abstract_expr_node
import Base.(==)
export constant

mutable struct constant{T <: Number} <: Abstract_expr_node
  value::T
end

# Base.convert(::Type{constant{T}}, x :: constant{Y}) where T <: Number where Y <: Number = constant{T}(T(x.value))
@inline Base.convert(::Type{constant{T}}, x::constant{Y}) where {Y <: Number,T <: Number} =
  constant{T}(T(x.value))
@inline _node_bound(c::constant{T}, t::DataType) where {T <: Number} = ((t)(c.value), (t)(c.value))
@inline _node_convexity(c::constant{T}) where {T <: Number} =
  M_implementation_convexity_type.constant_type()

@inline create_node_expr(x::T) where {T <: Number} = constant{T}(x)
@inline create_node_expr(c::constant{T}) where {T <: Number} = constant{T}(c.value)
@inline create_node_expr(c::T, x::AbstractVector{T}) where {T <: Number} = constant{T}(c)
@inline create_node_expr(c::constant{T}, x::AbstractVector{T}) where {T <: Number} =
  constant{T}(c.value)

@inline create_node_expr(c::constant{T}, x::Vector{Vector{T}}) where {T <: Number} =
  constant{T}(c.value)

@inline create_node_expr(
  c::constant{T},
  x::Vector{SubArray{T, 1, Array{T, 1}, N, false}},
) where {N} where {T <: Number} = constant{T}(c.value)

@inline _node_is_operator(c::constant{T}) where {T <: Number} = false
@inline _node_is_plus(c::constant{T}) where {T <: Number} = false
@inline _node_is_minus(c::constant{T}) where {T <: Number} = false
@inline _node_is_times(c::constant{T}) where {T <: Number} = false
@inline _node_is_power(c::constant{T}) where {T <: Number} = false
@inline _node_is_sin(c::constant{T}) where {T <: Number} = false
@inline _node_is_cos(c::constant{T}) where {T <: Number} = false
@inline _node_is_tan(c::constant{T}) where {T <: Number} = false

@inline _node_is_variable(c::constant{T}) where {T <: Number} = false

@inline _node_is_constant(c::constant{T}) where {T <: Number} = true

@inline _get_type_node(c::constant{T}) where {T <: Number} =
  M_implementation_type_expr.return_constant()

@inline (==)(a::constant{T}, b::constant{T}) where {T <: Number} = (a.value == b.value)

@inline _evaluate_node(
  c::constant{Y},
  x::SubArray{T, 1, Array{T, 1}, Tuple{Array{Int64, 1}}, false},
) where {Y <: Number} where {T <: Number} = (T)(c.value)::T

@inline _evaluate_node(c::constant{Y}, dic::Dict{Int, T where T <: Number}) where {Y <: Number} =
  c.value::Y

@inline _evaluate_node(
  c::constant{Y},
  x::AbstractVector{T},
) where {Y <: Number} where {T <: Number} = (c.value)

@inline _evaluate_node(c::constant{Y}, x::AbstractVector{Y}) where {Y <: Number} = c.value::Y
@inline _evaluate_node(c::constant{Y}) where {Y <: Number} = c.value::Y

@inline _evaluate_node!(
  c::constant{Y},
  x::AbstractVector{Y},
  ref::M_abstract_expr_node.MyRef{Y},
) where {Y <: Number} = M_abstract_expr_node.set_myRef!(ref, c.value::Y)

@inline _evaluate_node!(c::constant{Y}, ref::M_abstract_expr_node.MyRef{Y}) where {Y <: Number} =
  M_abstract_expr_node.set_myRef!(ref, c.value::Y)

@inline _evaluate_node!(
  c::constant{Y},
  multiple_ref::AbstractVector{M_abstract_expr_node.MyRef{Y}},
) where {Y <: Number} = begin
  for ref in multiple_ref
    M_abstract_expr_node.set_myRef!(ref, c.value::Y)
  end
end

@inline _cast_constant!(c::constant{Y}, t::DataType) where {Y <: Number} = constant{t}((t)(c.value))
@inline _cast_constant!(c::Number, t::DataType) = (t)(c)

@inline _node_to_Expr(c::constant{Y}) where {Y <: Number} = c.value
@inline _node_to_Expr2(c::constant{Y}) where {Y <: Number} = c.value

end
