module M_interface_tree

using ..M_abstract_tree

"""
    node = _get_node(tree)

Get the root `node` of `tree`.
"""
_get_node(tree::AbstractTree) = error("Should not be called")

"""
    children = _get_children(tree)

Get the `children` from the root node of `tree`.
"""
_get_children(tree::AbstractTree) = error("Should not be called")

end
