module abstract_tree

export create_tree

"""
  Supertype of every tree.
"""
abstract type Ab_tree end

"""
    tree = create_tree(field::T, children::Vector{Type_node{T}}) where {T}
    tree = create_tree(field::T, children::Array{Any, 1}) where {T}
    tree = create_tree(ex::Expr)

Create a `tree` of type `Type_node` from a `field` for the current node and its `children` or from an `Expr`.
"""
create_tree() = @error("Should not be called (abstract_tree)")

end
