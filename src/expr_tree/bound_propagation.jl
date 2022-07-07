module M_bound_propagations

using ..M_abstract_expr_tree
using ..M_trait_tree, ..M_trait_expr_tree, ..M_trait_expr_node
using ..M_implementation_tree, ..M_implementation_complete_expr_tree

"""
    Bound_tree

A tree where each node is a pair `(bound_inf, bound_sup)`.
Must be paired with an expression tree.
"""
Bound_tree{T} = M_implementation_tree.Type_node{M_abstract_expr_tree.Bounds{T}}

"""
    bound_tree = create_bounds_tree(tree)

Return a `similar` expression tree to `tree`, where each node has an undefined bounds.
"""
@inline create_bounds_tree(tree::M_implementation_tree.Type_node, type = Float64::DataType) =
  return Bound_tree{type}(
    M_abstract_expr_tree.Bounds{type}((type)(0), (type)(0)),
    create_bounds_tree.(M_trait_tree.get_children(tree)),
  )

@inline create_bounds_tree(cst::T, type = Float64::DataType) where {T <: Number} =
  return Bound_tree{type}(M_abstract_expr_tree.Bounds{type}((type)(0), (type)(0)), [])

 """
    set_bounds!(tree, bound_tree::Bound_tree)
    set_bounds!(complete_tree::Complete_expr_tree)

Set the bounds of `bound_tree` by walking `tree` and by propagating the computations from the leaves to the root.
A `Complete_expr_tree` contains a precompiled `bound_tree`, and then can be use alone.
"""
function set_bounds!(
  tree::M_implementation_tree.Type_node,
  bounds_tree::Bound_tree{T},
) where {T <: Number}
  node = M_trait_tree.get_node(tree)
  if M_trait_expr_node.node_is_operator(node) == false # i.e. a constant or a variable
    (inf_bound_node, sup_bound_node) = M_trait_expr_node.node_bound(node, T)
    bound = M_trait_tree.get_node(bounds_tree)
    bound.inf_bound = inf_bound_node
    bound.sup_bound = sup_bound_node
  else
    children_tree = M_trait_tree.get_children(tree)
    children_bound_tree = M_trait_tree.get_children(bounds_tree)
    n = length(children_tree)
    n == length(children_bound_tree) || error("different shape between trees")
    for i = 1:n
      set_bounds!(children_tree[i], children_bound_tree[i])
    end
    son_bounds = (x::Bound_tree -> bound_to_tuple(M_trait_tree.get_node(x))).(children_bound_tree)
    (inf_bound_node, sup_bound_node) = M_trait_expr_node.node_bound(node, son_bounds, T)
    bound = M_trait_tree.get_node(bounds_tree)
    bound.inf_bound = inf_bound_node
    bound.sup_bound = sup_bound_node
  end
end

function set_bounds!(
  tree::M_implementation_complete_expr_tree.Complete_expr_tree{T},
) where {T <: Number}
  node = M_trait_tree.get_node(tree)
  op = M_trait_expr_tree._get_expr_node(tree)
  if M_trait_expr_node.node_is_operator(op) == false
    (inf_bound_node, sup_bound_node) = M_trait_expr_node.node_bound(op, T)
    M_implementation_complete_expr_tree.set_bound!(node, inf_bound_node, sup_bound_node)
  else
    ch = M_trait_tree.get_children(tree)
    set_bounds!.(ch)
    son_bounds =
      (
        x::M_implementation_complete_expr_tree.Complete_expr_tree{T} ->
          M_implementation_complete_expr_tree.get_bounds(M_trait_tree.get_node(x))
      ).(ch)
    (inf_bound_node, sup_bound_node) = M_trait_expr_node.node_bound(op, son_bounds, T)
    M_implementation_complete_expr_tree.set_bound!(node, inf_bound_node, sup_bound_node)
  end
end

@inline bound_to_tuple(b::M_abstract_expr_tree.Bounds{T}) where {T <: Number} =
  (b.inf_bound, b.sup_bound)

"""
    (inf_bound, sup_bound) = get_bound(bound_tree::Bound_tree)

Retrieve the bounds of the root of `bound_tree`, the bounds of expression tree.
"""
@inline get_bound(b::Bound_tree{T}) where {T <: Number} = bound_to_tuple(M_trait_tree.get_node(b))
@inline get_bound(ex::M_implementation_complete_expr_tree.Complete_expr_tree{T}) where {T <: Number} =
  M_implementation_complete_expr_tree.tuple_bound_from_tree(ex)

end
