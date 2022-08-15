module M_interface_expr_tree

using ..M_abstract_expr_tree

"""
    node = _get_expr_node(tree::AbstractExprTree)

Return the `node` being the `root` of the `tree`.
"""
_get_expr_node(tree::AbstractExprTree) = error("Should not be called.")

"""
    children = _get_expr_children(tree::AbstractExprTree)

Return the `children` of the `root` of `tree`.
"""
_get_expr_children(tree::AbstractExprTree) = error("Should not be called.")

"""
    minus_tree = _inverse_expr_tree(tree::AbstractExprTree)

Apply a unary minus on `tree`.
"""
_inverse_expr_tree(tree::AbstractExprTree) = error("Should not be called.")

"""
    _get_real_node(tree::AbstractExprTree)
 
Return the value of a leaf in a suitable format for particular algorithm.
"""
_get_real_node(tree::AbstractExprTree) = error("Should not be called.")

"""
    expr_tree = _transform_to_expr_tree(tree::AbstractExprTree)

Return `expr_tree::Type_expr_tree` from `tree`.
`Type_expr_tree` is the internal expression tree structure.
"""
_transform_to_expr_tree(tree::AbstractExprTree) = error("Should not be called.")

"""
    expr_tree = _expr_tree_to_create(tree1::AbstractExprTree, tree2::AbstractExprTree)

Return `expr_tree`, a expression tree of the type from `tree2` with the values of `tree1`.
It is supported for few expression-tree structure.
"""
_expr_tree_to_create(tree1::AbstractExprTree, tree2::AbstractExprTree) =
  error("Should not be called.")

end
