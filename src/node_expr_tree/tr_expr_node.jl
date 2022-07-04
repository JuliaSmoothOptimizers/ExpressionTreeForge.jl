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

struct Type_expr_node end
struct Type_not_expr_node end

@inline node_bound(a, t::DataType) = _node_bound(a, is_expr_node(a), t)
@inline _node_bound(a, ::Type_expr_node, t::DataType) = _node_bound(a, t)
@inline _node_bound(a, ::Type_not_expr_node, t::DataType) =
  error("This node is not a expr node; node_bound function")
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
) where {T <: Number} = error("This node is not a expr node; node_bound function")

@inline node_convexity(a) = _node_convexity(a, is_expr_node(a))
@inline _node_convexity(a, ::Type_expr_node) = _node_convexity(a)
@inline _node_convexity(a, ::Type_not_expr_node) =
  error("This node is not a expr node; node_convexity function")
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
) where {T <: Number} = error("This node is not a expr node; node_convexity function")

#  operators's part
@inline is_expr_node(a::M_abstract_expr_node.Abstract_expr_node) = Type_expr_node()
@inline is_expr_node(a::Expr) = Type_expr_node()
@inline is_expr_node(a::Number) = Type_expr_node()
@inline is_expr_node(a::Any) = Type_not_expr_node()

@inline node_is_operator(a) = _node_is_operator(a, is_expr_node(a))
@inline _node_is_operator(a, ::Type_expr_node) = _node_is_operator(a)
@inline _node_is_operator(a, ::Type_not_expr_node) = error("This node is not a expr node")

@inline node_is_plus(a) = _node_is_plus(a, is_expr_node(a))
@inline _node_is_plus(a, ::Type_expr_node) = _node_is_plus(a)
@inline _node_is_plus(a, ::Type_not_expr_node) = error("This node is not a expr node")

@inline node_is_times(a) = _node_is_times(a, is_expr_node(a))
@inline _node_is_times(a, ::Type_expr_node) = _node_is_times(a)
@inline _node_is_times(a, ::Type_not_expr_node) = error("This node is not a expr node")

@inline node_is_minus(a) = _node_is_minus(a, is_expr_node(a))
@inline _node_is_minus(a, ::Type_expr_node) = _node_is_minus(a)
@inline _node_is_minus(a, ::Type_not_expr_node) = error("This node is not a expr node")

@inline node_is_power(a) = _node_is_power(a, is_expr_node(a))
@inline _node_is_power(a, ::Type_expr_node) = _node_is_power(a)
@inline _node_is_power(a, ::Type_not_expr_node) = error("This node is not a expr node")

@inline node_is_sin(a) = _node_is_sin(a, is_expr_node(a))
@inline _node_is_sin(a, ::Type_expr_node) = _node_is_sin(a)
@inline _node_is_sin(a, ::Type_not_expr_node) = error("This node is not a expr node")

@inline node_is_cos(a) = _node_is_cos(a, is_expr_node(a))
@inline _node_is_cos(a, ::Type_expr_node) = _node_is_cos(a)
@inline _node_is_cos(a, ::Type_not_expr_node) = error("This node is not a expr node")

@inline node_is_tan(a) = _node_is_tan(a, is_expr_node(a))
@inline _node_is_tan(a, ::Type_expr_node) = _node_is_tan(a)
@inline _node_is_tan(a, ::Type_not_expr_node) = error("This node is not a expr node")

# Variables's part
@inline node_is_variable(a) = _node_is_variable(a, is_expr_node(a))
@inline _node_is_variable(a, ::Type_expr_node) = _node_is_variable(a)
@inline _node_is_variable(a, ::Type_not_expr_node) = error("This node is not a expr node")

@inline get_var_index(a) = _get_var_index(a, is_expr_node(a))
@inline _get_var_index(a, ::Type_expr_node) = _get_var_index(a)
@inline _get_var_index(a, ::Type_not_expr_node) = error("This node is not a expr node")

#  M_constant's part
@inline node_is_constant(a) = _node_is_constant(a, is_expr_node(a))
@inline _node_is_constant(a, ::Type_expr_node) = _node_is_constant(a)
@inline _node_is_constant(a, ::Type_not_expr_node) = error("This node is not a expr node")

# This part is used in algorithms defined in expr_tree/tr_expr_tree
@inline get_type_node(a) = _get_type_node(a, is_expr_node(a))
@inline _get_type_node(a, ::Type_expr_node) = _get_type_node(a)
@inline _get_type_node(a, ::Type_not_expr_node) = error("This node is not a expr node")
@inline _get_type_node(a, ::Type_not_expr_node, b::Array) =
  error("nous n'avons pas que des types expr")
@inline get_type_node(a, b) = _get_type_node(a, is_expr_node(a), b)
function _get_type_node(a, ::Type_expr_node, b::Array)
  trait_array = M_trait_type_expr.is_trait_type_expr.(b)
  preparation_cond = isa.(trait_array, M_trait_type_expr.Type_type_expr)
  foldl(&, preparation_cond) ? _get_type_node(a, b) : error("not only types expr")
end

@inline evaluate_node(a, x::Vector{T}) where {T <: Number} = _evaluate_node(a, is_expr_node(a), x)
@inline _evaluate_node(a, ::Type_expr_node, x::Vector{T}) where {T <: Number} = _evaluate_node(a, x)
@inline _evaluate_node(a, ::Type_not_expr_node, x::Vector{T}) where {T <: Number} =
  error("This node is not a expr node")
@inline evaluate_node(a, x::Dict{Int, Number}) = _evaluate_node(a, is_expr_node(a), x)
@inline _evaluate_node(a, ::Type_expr_node, x::Dict{Int, Number}) = _evaluate_node(a, x)
@inline _evaluate_node(a, ::Type_not_expr_node, x::Dict{Int, Number}) =
  error("This node is not a expr node")
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
) where {T <: Number} = error("This node is not a expr node")

@inline evaluate_node(a, x::AbstractVector{T}) where {T <: Number} =
  _evaluate_node(a, is_expr_node(a), x)
@inline _evaluate_node(a, ::Type_expr_node, x::AbstractVector{T}) where {T <: Number} =
  _evaluate_node(a, x)
@inline _evaluate_node(a, ::Type_not_expr_node, x::AbstractVector{T}) where {T <: Number} =
  error("This node is not a expr node")

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
) where {T <: Number} = error("This node is not a expr node")

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
) where {T <: Number} = error("This node is not a expr node")

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
) where {T <: Number} = error("This node is not a expr node")

@inline change_from_N_to_Ni!(a, dic_new_var::Dict{Int, Int}) =
  _change_from_N_to_Ni!(a, is_expr_node(a), dic_new_var)
@inline _change_from_N_to_Ni!(a, ::Type_expr_node, dic_new_var::Dict{Int, Int}) =
  _change_from_N_to_Ni!(a, dic_new_var)
@inline _change_from_N_to_Ni!(a, ::Type_not_expr_node, dic_new_var::Dict{Int, Int}) =
  error("This node is not a expr node")

@inline node_to_Expr(a) = _node_to_Expr(a, is_expr_node(a))
@inline _node_to_Expr(a, ::Type_expr_node) = _node_to_Expr(a)
@inline _node_to_Expr(a, ::Type_not_expr_node) = error("This node is not a expr node")

@inline node_to_Expr2(a) = _node_to_Expr2(a, is_expr_node(a))
@inline _node_to_Expr2(a, ::Type_expr_node) = _node_to_Expr2(a)
@inline _node_to_Expr2(a, ::Type_not_expr_node) = error("This node is not a expr node")
@inline _node_to_Expr2(a) = _node_to_Expr(a)

@inline cast_constant!(a, t::DataType) = _cast_constant!(a, is_expr_node(a), t)
@inline _cast_constant!(a, ::Type_expr_node, t::DataType) = _cast_constant!(a, t)
@inline _cast_constant!(a, ::Type_not_expr_node, t::DataType) =
  error("This node is not a expr node")

end  # module M_trait_expr_node
