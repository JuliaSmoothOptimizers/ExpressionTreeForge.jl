module M_trait_expr_tree

using ModelingToolkit
using Base.Threads
using ..M_abstract_expr_tree,
  ..M_implementation_expr_tree,
  ..M_implementation_complete_expr_tree,
  ..M_implementation_expression_tree_Expr

import ..M_interface_expr_tree._get_expr_node,
  ..M_interface_expr_tree._get_expr_children, ..M_interface_expr_tree._inverse_expr_tree
import ..M_implementation_expr_tree.Type_expr_tree, ..M_interface_expr_tree._get_real_node
import ..M_interface_expr_tree._transform_to_expr_tree, ..M_interface_expr_tree._expr_tree_to_create
import Base.==

export is_expr_tree, get_expr_node, get_expr_children, inverse_expr_tree

"""Type instantiated dynamically checking that an argument is an expression tree."""
struct Is_expr_tree end
"""Type instantiated dynamically checking that an argument is not an expression tree."""
struct Is_not_expr_tree end

"""
    verifier_type = is_expr_tree(arg)

Return `Is_expr_tree ` if `arg` is considered as an implementation of an expression tree, it returns `Is_not_expr_tree` otherwise.
"""
@inline is_expr_tree(a::M_abstract_expr_tree.AbstractExprTree) = Is_expr_tree()
@inline is_expr_tree(a::Type_expr_tree) = Is_expr_tree()
@inline is_expr_tree(a::Expr) = Is_expr_tree()
@inline is_expr_tree(a::Number) = Is_expr_tree()
@inline is_expr_tree(::Number) = Is_expr_tree()
@inline is_expr_tree(
  a::M_implementation_complete_expr_tree.Complete_expr_tree{T},
) where {T <: Number} = Is_expr_tree()

@inline is_expr_tree(a::ModelingToolkit.Operation) = Is_expr_tree()
@inline is_expr_tree(a::ModelingToolkit.Constant) = Is_expr_tree()
@inline is_expr_tree(a::ModelingToolkit.Variable) = Is_expr_tree()
@inline is_expr_tree(a::Any) = Is_not_expr_tree()

"""
    node = get_expr_node(tree::AbstractExprTree)

Return the `node` being the `root` of the `tree`.
"""
@inline get_expr_node(a) = _get_expr_node(a, is_expr_tree(a))
@inline _get_expr_node(a, ::Is_not_expr_tree) = error(" This is not an expr tree")
@inline _get_expr_node(a, ::Is_expr_tree) = _get_expr_node(a)

"""
    children = get_expr_children(tree::AbstractExprTree)

Return the `children` of the `root` of `tree`.
"""
@inline get_expr_children(a) = _get_expr_children(a, is_expr_tree(a))
@inline _get_expr_children(a, ::Is_not_expr_tree) = error("This is not an expr tree")
@inline _get_expr_children(a, ::Is_expr_tree) = _get_expr_children(a)

"""
    minus_tree = inverse_expr_tree(tree::AbstractExprTree)

Apply a unary minus on `tree`.
"""
@inline inverse_expr_tree(a) = _inverse_expr_tree(a, is_expr_tree(a))
@inline _inverse_expr_tree(a, ::Is_not_expr_tree) = error("This is not an expr tree")
@inline _inverse_expr_tree(a, ::Is_expr_tree) = _inverse_expr_tree(a)

"""
    bool = expr_tree_equal(expr_tree1, expr_tree2, eq::Atomic{Bool} = Atomic{Bool}(true))

Check if `expr_tree1` and `expr_tree2` valued the same, by checking recursively their respective nodes. 
"""
@inline expr_tree_equal(a, b, eq::Atomic{Bool} = Atomic{Bool}(true)) =
  hand_expr_tree_equal(a, b, is_expr_tree(a), is_expr_tree(b), eq)

@inline hand_expr_tree_equal(a, b, ::Is_not_expr_tree, ::Any, eq) =
  error("An argument is not a expression tree")

@inline hand_expr_tree_equal(a, b, ::Any, ::Is_not_expr_tree, eq) =
  error("An argument is not a expression tree")

function hand_expr_tree_equal(a, b, ::Is_expr_tree, ::Is_expr_tree, eq::Atomic{Bool})
  if eq[]
    if _get_expr_node(a) == _get_expr_node(b)
      ch_a = _get_expr_children(a)
      ch_b = _get_expr_children(b)
      if length(ch_a) != length(ch_b)
        Threads.atomic_and!(eq, false)
      elseif ch_a == []
      else
        Threads.@threads for i = 1:length(ch_a)
          expr_tree_equal(ch_a[i], ch_b[i], eq)
        end
      end
    else
      Threads.atomic_and!(eq, false)
    end
    return eq[]
  end
  return false
end

"""
    _get_real_node(tree::AbstractExprTree)
 
Return the value of a leaf in a suitable format for particular algorithm.
"""
@inline get_real_node(a) = _get_real_node(is_expr_tree(a), a)

@inline _get_real_node(::Is_not_expr_tree, ::Any) = error("The argument is not a expression tree")

@inline _get_real_node(::Is_expr_tree, a::Any) = _get_real_node(a)

"""
    expr_tree = _transform_to_expr_tree(tree::AbstractExprTree)

Return `expr_tree::Type_expr_tree` from `tree`.
`Type_expr_tree` is the internal expression tree structure.
"""
@inline transform_to_expr_tree(a::T) where {T} =
  _transform_to_expr_tree(is_expr_tree(a), a)::M_implementation_expr_tree.Type_expr_tree

@inline _transform_to_expr_tree(::Is_not_expr_tree, ::T) where {T} =
  error("The argument is not a expression tree ")

@inline _transform_to_expr_tree(::Is_expr_tree, a::T) where {T} =
  _transform_to_expr_tree(a)::M_implementation_expr_tree.Type_expr_tree

"""
    expr = transform_to_Expr(expr_tree)

Return `expr::Expr` from the expression tree `expr_tree`.
"""
@inline transform_to_Expr(ex) = _transform_to_Expr(M_trait_expr_tree.is_expr_tree(ex), ex)

@inline _transform_to_Expr(::M_trait_expr_tree.Is_expr_tree, ex) = _transform_to_Expr(ex)

@inline _transform_to_Expr(::M_trait_expr_tree.Is_not_expr_tree, ex) =
  error("The argument is not a expression tree ")

@inline _transform_to_Expr(ex) = M_abstract_expr_tree.create_Expr(ex)

@inline transform_to_Expr2(ex) = _transform_to_Expr2(M_trait_expr_tree.is_expr_tree(ex), ex)

@inline _transform_to_Expr2(::M_trait_expr_tree.Is_expr_tree, ex) = _transform_to_Expr2(ex)
@inline _transform_to_Expr2(::M_trait_expr_tree.Is_not_expr_tree, ex) =
  error("The argument is not a expression tree ")

@inline _transform_to_Expr2(ex) = M_abstract_expr_tree.create_Expr2(ex)

"""
    expr_tree = expr_tree_to_create(tree1::AbstractExprTree, tree2::AbstractExprTree)

Return `expr_tree`, a expression tree of the type from `tree2` with the values of `tree1`.
It is supported for few expression-tree structure.
"""
@inline expr_tree_to_create(expr_tree_to_create, expr_tree_of_good_type) = _expr_tree_to_create(
  expr_tree_to_create,
  expr_tree_of_good_type,
  is_expr_tree(expr_tree_to_create),
  is_expr_tree(expr_tree_of_good_type),
)

@inline _expr_tree_to_create(a, b, ::Is_not_expr_tree, ::Any) =
  error("The argument is not an expression tree")

@inline _expr_tree_to_create(a, b, ::Any, ::Is_not_expr_tree) =
  error("The argument is not an expression tree")

function _expr_tree_to_create(a, b, ::Is_expr_tree, ::Is_expr_tree)
  uniformized_a = transform_to_expr_tree(a) # :: M_implementation_expr_tree.Type_expr_tree
  _expr_tree_to_create(uniformized_a, b)
end

end
