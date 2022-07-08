module M_trait_expr_node

using ..M_abstract_expr_node

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
  _node_to_Expr2
import ..M_interface_expr_node._node_bound, ..M_interface_expr_node._node_convexity

using ..M_trait_type_expr
using ..M_implementation_convexity_type

"""Type instantiated dynamically checking that an argument is an expression node."""
struct Type_expr_node end
"""Type instantiated dynamically checking that an argument is a not an expression node."""
struct Type_not_expr_node end

"""
    (lowerbound, upper_bound) = node_bound(node::Abstract_expr_node, children_bounds::AbstractVector{Tuple{T, T}}, type::DataType)

Return the bounds of `node` given the `children_bounds`.
"""
@inline node_bound(a, t::DataType) = _node_bound(a, is_expr_node(a), t)
@inline _node_bound(a, ::Type_expr_node, t::DataType) = _node_bound(a, t)
@inline _node_bound(a, ::Type_not_expr_node, t::DataType) =
  error("This node is not a expression tree node; node_bound function")

@inline node_bound(a, son_bound::AbstractVector{Tuple{T, T}}, t::DataType) where {T <: Number} =
  _node_bound(a, son_bound, is_expr_node(a), t)

@inline _node_bound(
  a,
  son_bound::AbstractVector{Tuple{T, T}},
  ::Type_expr_node,
  t::DataType,
) where {T <: Number} = _node_bound(a, son_bound, t)

@inline _node_bound(
  a,
  son_bound::AbstractVector{Tuple{T, T}},
  ::Type_not_expr_node,
  t::DataType,
) where {T <: Number} = error("This node is not a expression tree node; node_bound function")

"""
    bool = _node_is_operator(node::Abstract_expr_node, children_convex_status::AbstractVector{M_implementation_convexity_type.Convexity_type})

Return the convexity status of `node` given the `children_convex_status`.
"""
@inline node_convexity(a) = _node_convexity(a, is_expr_node(a))
@inline _node_convexity(a, ::Type_expr_node) = _node_convexity(a)
@inline _node_convexity(a, ::Type_not_expr_node) =
  error("This node is not a expression tree node; node_convexity function")

@inline node_convexity(
  a,
  son_convexity::AbstractVector{M_implementation_convexity_type.Convexity_type},
  son_bound::AbstractVector{Tuple{T, T}},
) where {T <: Number} = _node_convexity(a, son_convexity, son_bound, is_expr_node(a))

@inline _node_convexity(
  a,
  son_convexity::AbstractVector{M_implementation_convexity_type.Convexity_type},
  son_bound::AbstractVector{Tuple{T, T}},
  ::Type_expr_node,
) where {T <: Number} = _node_convexity(a, son_convexity, son_bound)

@inline _node_convexity(
  a,
  son_convexity::AbstractVector{M_implementation_convexity_type.Convexity_type},
  son_bound::AbstractVector{Tuple{T, T}},
  ::Type_not_expr_node,
) where {T <: Number} = error("This node is not a expression tree node; node_convexity function")

#  operators's part
@inline is_expr_node(a::M_abstract_expr_node.Abstract_expr_node) = Type_expr_node()
@inline is_expr_node(a::Expr) = Type_expr_node()
@inline is_expr_node(a::Number) = Type_expr_node()
@inline is_expr_node(a::Any) = Type_not_expr_node()

"""
    bool = node_is_operator(node::Abstract_expr_node)

Check if `node` is an operator.
It could be also a variable or a constant.
"""
@inline node_is_operator(a) = _node_is_operator(a, is_expr_node(a))
@inline _node_is_operator(a, ::Type_expr_node) = _node_is_operator(a)
@inline _node_is_operator(a, ::Type_not_expr_node) =
  error("This node is not a expression tree node")

"""
    bool = node_is_plus(node::Abstract_expr_node)

Check if `node` is a `+` operator or not.
"""
@inline node_is_plus(a) = _node_is_plus(a, is_expr_node(a))
@inline _node_is_plus(a, ::Type_expr_node) = _node_is_plus(a)
@inline _node_is_plus(a, ::Type_not_expr_node) = error("This node is not a expression tree node")

"""
    bool = _node_is_times(node::Abstract_expr_node)

Check if `node` is a `*` operator or not.
"""
@inline node_is_times(a) = _node_is_times(a, is_expr_node(a))
@inline _node_is_times(a, ::Type_expr_node) = _node_is_times(a)
@inline _node_is_times(a, ::Type_not_expr_node) = error("This node is not a expression tree node")

"""
    bool = node_is_minus(node::Abstract_expr_node)

Check if `node` is a `-` operator or not.
"""
@inline node_is_minus(a) = _node_is_minus(a, is_expr_node(a))
@inline _node_is_minus(a, ::Type_expr_node) = _node_is_minus(a)
@inline _node_is_minus(a, ::Type_not_expr_node) = error("This node is not a expression tree node")

"""
    bool = node_is_power(node::Abstract_expr_node)

Check if `node` is a `^` operator or not.
"""
@inline node_is_power(a) = _node_is_power(a, is_expr_node(a))
@inline _node_is_power(a, ::Type_expr_node) = _node_is_power(a)
@inline _node_is_power(a, ::Type_not_expr_node) = error("This node is not a expression tree node")

"""
    bool = node_is_sin(node::Abstract_expr_node)

Check if `node` is a `sin` operator.
"""
@inline node_is_sin(a) = _node_is_sin(a, is_expr_node(a))
@inline _node_is_sin(a, ::Type_expr_node) = _node_is_sin(a)
@inline _node_is_sin(a, ::Type_not_expr_node) = error("This node is not a expression tree node")

"""
    bool = node_is_cos(node::Abstract_expr_node)

Check if `node` is a `cos` operator.
"""
@inline node_is_cos(a) = _node_is_cos(a, is_expr_node(a))
@inline _node_is_cos(a, ::Type_expr_node) = _node_is_cos(a)
@inline _node_is_cos(a, ::Type_not_expr_node) = error("This node is not a expression tree node")

"""
    bool = node_is_tan(node::Abstract_expr_node)

Check if `node` is a `tan` operator.
"""
@inline node_is_tan(a) = _node_is_tan(a, is_expr_node(a))
@inline _node_is_tan(a, ::Type_expr_node) = _node_is_tan(a)
@inline _node_is_tan(a, ::Type_not_expr_node) = error("This node is not a expression tree node")

# Variables's part
"""
    bool = _node_is_variable(node::Abstract_expr_node)

Check if `node` is a variable.
It could be also an operator or a constant.
"""
@inline node_is_variable(a) = _node_is_variable(a, is_expr_node(a))
@inline _node_is_variable(a, ::Type_expr_node) = _node_is_variable(a)
@inline _node_is_variable(a, ::Type_not_expr_node) =
  error("This node is not a expression tree node")

"""
    index = get_var_index(variable::Abstract_expr_node)

Return the `index` of the `variable`.
"""
@inline get_var_index(a) = _get_var_index(a, is_expr_node(a))
@inline _get_var_index(a, ::Type_expr_node) = _get_var_index(a)
@inline _get_var_index(a, ::Type_not_expr_node) = error("This node is not a expression tree node")

# M_constant's part
"""
    bool = node_is_constant(node::Abstract_expr_node)

Check if `node` is a constant.
"""
@inline node_is_constant(a) = _node_is_constant(a, is_expr_node(a))
@inline _node_is_constant(a, ::Type_expr_node) = _node_is_constant(a)
@inline _node_is_constant(a, ::Type_not_expr_node) =
  error("This node is not a expression tree node")

# This part is used in algorithms defined in expr_tree/tr_expr_tree
"""
    type = get_type_node(node::Abstract_expr_node, children_types::AbstractVector{Type_expr_basic})

Return the type of `node` given the type of its children `children_types`.
The types avaible are`constant, linear, quadratic, cubic` or `more`.
"""
@inline get_type_node(a) = _get_type_node(a, is_expr_node(a))
@inline _get_type_node(a, ::Type_expr_node) = _get_type_node(a)
@inline _get_type_node(a, ::Type_not_expr_node) = error("This node is not a expression tree node")
@inline _get_type_node(a, ::Type_not_expr_node, b::Array) =
  error("nous n'avons pas que des types expr")

@inline get_type_node(a, b) = _get_type_node(a, is_expr_node(a), b)

function _get_type_node(a, ::Type_expr_node, b::Array)
  trait_array = M_trait_type_expr.is_trait_type_expr.(b)
  preparation_cond = isa.(trait_array, M_trait_type_expr.Type_type_expr)
  foldl(&, preparation_cond) ? _get_type_node(a, b) : error("not only types expr")
end

"""
    value = _evaluate_node(node::Abstract_expr_node, value_children::AbstractVector{T}) where T<:Number

Evaluate `node` depending `value_children`.
"""
@inline evaluate_node(a, x::Vector{T}) where {T <: Number} = _evaluate_node(a, is_expr_node(a), x)
@inline _evaluate_node(a, ::Type_expr_node, x::Vector{T}) where {T <: Number} = _evaluate_node(a, x)
@inline _evaluate_node(a, ::Type_not_expr_node, x::Vector{T}) where {T <: Number} =
  error("This node is not a expression tree node")

@inline evaluate_node(a, x::Dict{Int, Number}) = _evaluate_node(a, is_expr_node(a), x)
@inline _evaluate_node(a, ::Type_expr_node, x::Dict{Int, Number}) = _evaluate_node(a, x)
@inline _evaluate_node(a, ::Type_not_expr_node, x::Dict{Int, Number}) =
  error("This node is not a expression tree node")

@inline evaluate_node(
  a,
  x::SubArray{T, 1, Array{T, 1}, Tuple{Array{Int64, 1}}},
) where {T <: Number} = _evaluate_node(a, is_expr_node(a), x)

@inline _evaluate_node(
  a,
  ::Type_expr_node,
  x::SubArray{T, 1, Array{T, 1}, Tuple{Array{Int64, 1}}},
) where {T <: Number} = _evaluate_node(a, x)

@inline _evaluate_node(
  a,
  ::Type_not_expr_node,
  x::SubArray{T, 1, Array{T, 1}, Tuple{Array{Int64, 1}}},
) where {T <: Number} = error("This node is not a expression tree node")

@inline evaluate_node(a, x::AbstractVector{T}) where {T <: Number} =
  _evaluate_node(a, is_expr_node(a), x)

@inline _evaluate_node(a, ::Type_expr_node, x::AbstractVector{T}) where {T <: Number} =
  _evaluate_node(a, x)

@inline _evaluate_node(a, ::Type_not_expr_node, x::AbstractVector{T}) where {T <: Number} =
  error("This node is not a expression tree node")

"""
    evaluate_node!(node::Abstract_expr_node, value_children::AbstractVector{T}, ref::MyRef{T}) where T<:Number

Evaluate `node` depending `value_children` and store the result in `ref`.
"""
@inline evaluate_node!(
  a,
  x::AbstractVector{T},
  ref::M_abstract_expr_node.MyRef{T},
) where {T <: Number} = _evaluate_node!(a, is_expr_node(a), x, ref)

@inline _evaluate_node!(
  a,
  ::Type_expr_node,
  x::AbstractVector{T},
  ref::M_abstract_expr_node.MyRef{T},
) where {T <: Number} = _evaluate_node!(a, x, ref)

@inline _evaluate_node!(
  a,
  ::Type_not_expr_node,
  x::AbstractVector{T},
  ref::M_abstract_expr_node.MyRef{T},
) where {T <: Number} = error("This node is not a expression tree node")

@inline evaluate_node!(
  a,
  x::AbstractVector{M_abstract_expr_node.MyRef{T}},
  ref::M_abstract_expr_node.MyRef{T},
) where {T <: Number} = _evaluate_node!(a, is_expr_node(a), x, ref)

@inline _evaluate_node!(
  a,
  ::Type_expr_node,
  x::AbstractVector{M_abstract_expr_node.MyRef{T}},
  ref::M_abstract_expr_node.MyRef{T},
) where {T <: Number} = _evaluate_node!(a, x, ref)

@inline _evaluate_node!(
  a,
  ::Type_not_expr_node,
  x::AbstractVector{M_abstract_expr_node.MyRef{T}},
  ref::M_abstract_expr_node.MyRef{T},
) where {T <: Number} = error("This node is not a expression tree node")

@inline evaluate_node!(
  a,
  x::Vector{Vector{M_abstract_expr_node.MyRef{T}}},
  ref::Vector{M_abstract_expr_node.MyRef{T}},
) where {T <: Number} = _evaluate_node!(a, is_expr_node(a), x, ref)

@inline _evaluate_node!(
  a,
  ::Type_expr_node,
  x::Vector{Vector{M_abstract_expr_node.MyRef{T}}},
  ref::Vector{M_abstract_expr_node.MyRef{T}},
) where {T <: Number} = _evaluate_node!(a, x, ref)

@inline _evaluate_node!(
  a,
  ::Type_not_expr_node,
  x::Vector{Vector{M_abstract_expr_node.MyRef{T}}},
  ref::Vector{M_abstract_expr_node.MyRef{T}},
) where {T <: Number} = error("This node is not a expression tree node")

"""
    change_from_N_to_Ni!(node::Abstract_expr_node, dic_new_indices::Dict{Int, Int})

Change the index of the variables following the index given by `dic_new_indices`.
"""
@inline change_from_N_to_Ni!(a, dic_new_var::Dict{Int, Int}) =
  _change_from_N_to_Ni!(a, is_expr_node(a), dic_new_var)

@inline _change_from_N_to_Ni!(a, ::Type_expr_node, dic_new_var::Dict{Int, Int}) =
  _change_from_N_to_Ni!(a, dic_new_var)

@inline _change_from_N_to_Ni!(a, ::Type_not_expr_node, dic_new_var::Dict{Int, Int}) =
  error("This node is not a expression tree node")

"""
    bool = node_to_Expr(node::Abstract_expr_node)

Return the information required to build later on a julia `Expr`.
An `operator` return the operator symbol (ex: `+` -> `:+`).
A `variable` return a variable as a `MathOptInterface` variable.
A `constant` return its value.
"""
@inline node_to_Expr(a) = _node_to_Expr(a, is_expr_node(a))
@inline _node_to_Expr(a, ::Type_expr_node) = _node_to_Expr(a)
@inline _node_to_Expr(a, ::Type_not_expr_node) = error("This node is not a expression tree node")

"""
    bool = node_to_Expr2(node::Abstract_expr_node)

Return the information required to build later on a julia `Expr`.
An `operator` return the operator symbol (ex: `+` -> `:+`).
A `variable` return a variable.
A `constant` return its value.
"""
@inline node_to_Expr2(a) = _node_to_Expr2(a, is_expr_node(a))
@inline _node_to_Expr2(a, ::Type_expr_node) = _node_to_Expr2(a)
@inline _node_to_Expr2(a, ::Type_not_expr_node) = error("This node is not a expression tree node")
@inline _node_to_Expr2(a) = _node_to_Expr(a)

"""
    bool = cast_constant!(node::Abstract_expr_node, type::Datatype)

Rewrite the `Number`s composing `node` as `type`.
"""
@inline cast_constant!(a, t::DataType) = _cast_constant!(a, is_expr_node(a), t)
@inline _cast_constant!(a, ::Type_expr_node, t::DataType) = _cast_constant!(a, t)
@inline _cast_constant!(a, ::Type_not_expr_node, t::DataType) =
  error("This node is not a expression tree node")

end
