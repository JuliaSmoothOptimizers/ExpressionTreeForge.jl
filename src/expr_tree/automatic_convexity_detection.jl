module M_convexity_detection

using ..M_implementation_convexity_type
using ..M_abstract_expr_tree
using ..M_trait_tree, ..M_trait_expr_tree, ..M_trait_expr_node
using ..M_implementation_tree,
  ..M_implementation_complete_expr_tree, ..M_implementation_complete_expr_tree
using ..M_bound_propagations

"""
    Convexity_tree

A tree where each node is a convexity status.
Must be paired with an expression tree.
"""
Convexity_tree{T} =
  M_implementation_tree.Type_node{M_implementation_convexity_type.Convexity_wrapper}

"""
    convex_tree = create_convex_tree(tree::Type_node)

Return bounds' tree with the same shaped  than `tree`, where each node has an undefined convexity status.
"""
@inline create_convex_tree(tree::M_implementation_tree.Type_node) = Convexity_tree(
  M_implementation_convexity_type.init_conv_status(),
  create_convex_tree.(M_trait_tree.get_children(tree)),
)

@inline create_convex_tree(constant::T) where {T <: Number} =
  Convexity_tree(M_implementation_convexity_type.init_conv_status(), [])

"""
    convexity_status = get_convexity_status(convexity_tree::M_convexity_detection.Convexity_tree)
    convexity_status = get_convexity_status(complete_tree::M_implementation_complete_expr_tree.Complete_expr_tree)

Return the convexity status of either a `convexity_tree` or a `complete_tree`.
The status can be:
* `constant`
* `linear`
* strictly `convex`
* strictly `concave`
* `unknown`
"""
@inline get_convexity_status(cvx_tree::Convexity_tree) =
  M_implementation_convexity_type.get_convexity_wrapper(M_trait_tree.get_node(cvx_tree))

@inline get_convexity_status(
  complete_tree::M_implementation_complete_expr_tree.Complete_expr_tree,
) = M_implementation_complete_expr_tree.get_convexity_status(M_trait_tree.get_node(complete_tree))

"""
    constant = constant_type() 

Return the value `constant` from the enumerative type `M_implementation_convexity_type.Convexity_type`.
"""
@inline constant_type() = M_implementation_convexity_type.constant_type()

"""
    linear = linear_type() 

Return the value `linear` from the enumerative type `M_implementation_convexity_type.Convexity_type`.
"""
@inline linear_type() = M_implementation_convexity_type.linear_type()

"""
    convex = convex_type() 

Return the value `convex` from the enumerative type `M_implementation_convexity_type.Convexity_type`.
"""
@inline convex_type() = M_implementation_convexity_type.convex_type()

"""
    concave = concave_type() 

Return the value `concave` from the enumerative type `M_implementation_convexity_type.Convexity_type`.
"""
@inline concave_type() = M_implementation_convexity_type.concave_type()

"""
    unknown = unknown_type() 

Return the value `unknown` from the enumerative type `M_implementation_convexity_type.Convexity_type`.
"""
@inline unknown_type() = M_implementation_convexity_type.unknown_type()

"""
    set_convexity!(tree, convexity_tree, bound_tree)
    set_convexity!(complete_tree)

Deduce from elementary rules the convexity status of `tree` nodes or `complete_tree` nodes.
`complete_tree` stores a bounds tree and can run the convexity detection standalone whereas `tree`
 requires the `bound_tree` (see `create_bounds_tree`) and `convexity_tree` (see `create_convex_tree`).
"""
function set_convexity!(
  tree::M_implementation_tree.Type_node,
  cvx_tree::Convexity_tree,
  bounds_tree,
)
  node = M_trait_tree.get_node(tree)
  if M_trait_expr_node.node_is_operator(node) == false
    (length(M_trait_tree.get_children(tree)) == length(M_trait_tree.get_children(cvx_tree))) ||
      error("Both trees do not have the same shape")
    convex_wrapper = M_trait_tree.get_node(cvx_tree)
    status = M_trait_expr_node.node_convexity(node)
    M_implementation_convexity_type.set_convexity_wrapper!(convex_wrapper, status)
  else
    children_tree = M_trait_tree.get_children(tree)
    children_convex_tree = M_trait_tree.get_children(cvx_tree)
    children_bounds_tree = M_trait_tree.get_children(bounds_tree)
    n = length(children_tree)
    (n == length(children_convex_tree) && n == length(children_bounds_tree)) ||
      error("different shape between trees set_convexity!")
    for i = 1:n
      set_convexity!(children_tree[i], children_convex_tree[i], children_bounds_tree[i])
    end
    son_cvxs =
      (
        x::Convexity_tree ->
          M_implementation_convexity_type.get_convexity_wrapper(M_trait_tree.get_node(x))
      ).(children_convex_tree)
    convex_wrapper = M_trait_tree.get_node(cvx_tree)
    son_bounds =
      (x -> M_bound_propagations.bound_to_tuple(M_trait_tree.get_node(x))).(children_bounds_tree)
    status = M_trait_expr_node.node_convexity(node, son_cvxs, son_bounds)
    M_implementation_convexity_type.set_convexity_wrapper!(convex_wrapper, status)
  end
end

function set_convexity!(
  tree::M_implementation_complete_expr_tree.Complete_expr_tree{T},
) where {T <: Number}
  node = M_trait_tree.get_node(tree)
  op = M_implementation_complete_expr_tree.get_op_from_node(node)
  if M_trait_expr_node.node_is_operator(op) == false
    status = M_trait_expr_node.node_convexity(op)
    M_implementation_complete_expr_tree.set_convexity_status!(node, status)
  else
    children = M_trait_tree.get_children(tree)
    set_convexity!.(children)
    son_cvxs =
      (
        x -> M_implementation_complete_expr_tree.get_convexity_status(M_trait_tree.get_node(x))
      ).(children)
    son_bounds =
      (x -> M_implementation_complete_expr_tree.get_bounds(M_trait_tree.get_node(x))).(children)
    status = M_trait_expr_node.node_convexity(op, son_cvxs, son_bounds)
    M_implementation_complete_expr_tree.set_convexity_status!(node, status)
  end
end

end
