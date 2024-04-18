module M_abstract_tree

export create_tree
export AbstractTree

"""
  Supertype of every tree.
"""
abstract type AbstractTree end

"""
    tree = create_tree(field::T, children::Vector{Type_node{T}}) where {T}
    tree = create_tree(field::T, children::Array{Any, 1}) where {T}
    tree = create_tree(ex::Expr)

Create a `tree` of type `Type_node`.
`field` will be the root node with some `children`.
`create_tree` can also translate an `Expr` to a `Type_node`.
"""
create_tree(tree::AbstractTree) = error("Should not be called (abstract_tree)")

end
