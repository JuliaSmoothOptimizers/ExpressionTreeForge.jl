module M_implementation_tree

import ..M_abstract_tree: AbstractTree, create_tree
import ..M_interface_tree: _get_node, _get_children
import Base.==

export Type_node

"""
    Type_node{T} <: AbstractTree

Basic implementation of a tree.
A `Type_node` has fields:

* `field` gathering the informations about the current node;
* `children` a vector of children, each of them being a `Type_node`.
"""
mutable struct Type_node{T} <: AbstractTree
  field::T
  children::Vector{Type_node{T}}
end

@inline create_tree(field::T, children::Vector{Type_node{T}}) where {T} =
  Type_node{T}(field, children)
@inline create_tree(field::T, children::Array{Any, 1}) where {T} = Type_node{T}(field, children)

@inline _get_node(tree::Type_node{T}) where {T} = tree.field

@inline _get_children(tree::Type_node{T}) where {T} = tree.children
@inline _get_children(tree::Type_node{T}, i::Int) where {T} = tree.children[i]

@inline (==)(a::Type_node{T}, b::Type_node{T}) where {T} = equal_tree(a, b)
@inline my_and(x, y) = x && y

"""
    bool = equal_tree(tree1::Type_node{T}, tree2::Type_node{T})

Check recursively if every node from `tree1` is the same for `tree2`.
"""
function equal_tree(tree1::Type_node{T}, tree2::Type_node{T}) where {T}
  children_tree1 = _get_children(tree1)
  children_tree2 = _get_children(tree2)
  l1 = length(children_tree1)
  l2 = length(children_tree2)
  _get_node(tree1) == _get_node(tree2) && l1 == l2 ?
  (l1 > 0 ? mapreduce(equal_tree, my_and, children_tree1, children_tree2) : true) : false
end

end
