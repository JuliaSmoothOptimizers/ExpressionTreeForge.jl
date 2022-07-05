module M_interface_expr_tree

using ..M_abstract_expr_tree

_get_expr_node(tree::AbstractExprTree) = @error("Sould not be called")

_get_expr_children(tree::AbstractExprTree) = @error("Sould not be called")

_inverse_expr_tree(tree::AbstractExprTree) = @error("Sould not be called")

_get_real_node(tree::AbstractExprTree) = @error("Sould not be called")

_transform_to_expr_tree(tree::AbstractExprTree) = @error("Sould not be called")

_expr_tree_to_create(tree::AbstractExprTree) = @error("Sould not be called")

end
