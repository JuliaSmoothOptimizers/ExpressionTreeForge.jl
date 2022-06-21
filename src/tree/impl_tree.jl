module implementation_tree

import ..abstract_tree: ab_tree, create_tree
import ..interface_tree: _get_node, _get_children
import Base.==

mutable struct type_node{T} <: ab_tree
  field::T
  children::Vector{type_node{T}}
end

@inline create_tree(field::T, children::Vector{type_node{T}}) where {T} =
  type_node{T}(field, children)
@inline create_tree(field::T, children::Array{Any, 1}) where {T} = type_node{T}(field, children)

@inline _get_node(tree::type_node{T}) where {T} = tree.field

@inline _get_children(tree::type_node{T}) where {T} = tree.children
@inbounds @inline _get_children(tree::type_node{T}, i::Int) where {T} = tree.children[i]
@inline _get_length_children(tree::type_node{T}) where {T} = length(_get_children(tree))

@inline (==)(a::type_node{T}, b::type_node{T}) where {T} = equal_tree(a, b)
@inline my_and(x, y) = x && y
@inline equal_tree(a::type_node{T}, b::type_node{T}) where {T} = begin
  ca = _get_children(a)
  cb = _get_children(b)
  la = length(ca)
  lb = length(cb)
  _get_node(a) == _get_node(b) && la == lb ?
  (la > 0 ? mapreduce(equal_tree, my_and, ca, cb) : true) : false
end

end  # module implementation_tree
