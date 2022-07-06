module M_implementation_complete_expr_tree

import Base.==

using ..M_abstract_expr_node, ..M_abstract_expr_tree
using ..M_trait_tree, ..M_trait_expr_node
using ..M_implementation_convexity_type, ..M_implementation_expr_tree
using ..M_interface_expr_tree

import ..M_abstract_expr_tree:
  create_expr_tree,
  create_Expr,
  create_Expr2
import ..M_implementation_tree.Type_node
import ..M_interface_expr_tree:
  _get_expr_node,
  _get_expr_children,
  _inverse_expr_tree,
  _get_real_node,
  _transform_to_expr_tree

export Complete_node

""" """
mutable struct Complete_node{T <: Number}
  op::M_abstract_expr_node.Abstract_expr_node
  bounds::M_abstract_expr_tree.Bounds{T}
  convexity_status::M_implementation_convexity_type.Convexity_wrapper
end

Complete_expr_tree{T <: Number} = Type_node{Complete_node{T}}

@inline create_complete_node(
  op::Abstract_expr_node,
  bounds::M_abstract_expr_tree.Bounds{T},
  cvx_st::M_implementation_convexity_type.Convexity_wrapper,
) where {T <: Number} = Complete_node{T}(op, bounds, cvx_st)

@inline create_complete_node(
  op::Abstract_expr_node,
  bounds::M_abstract_expr_tree.Bounds{T},
) where {T <: Number} =
  create_complete_node(op, bounds, M_implementation_convexity_type.init_conv_status())

@inline create_complete_node(op::Abstract_expr_node, bi::T, bs::T) where {T <: Number} =
  create_complete_node(op, M_abstract_expr_tree.Bounds{T}(bi, bs))

@inline create_complete_node(op::Abstract_expr_node, t = Float64::DataType) =
  create_complete_node(op, (t)(-Inf), (t)(Inf))

@inline get_op_from_node(cmp_nope::Complete_node) = cmp_nope.op

@inline get_bounds_from_node(cmp_nope::Complete_node) = cmp_nope.bounds

@inline set_bound!(node::Complete_node{T}, bi::T, bs::T) where {T <: Number} =
  M_abstract_expr_tree.set_bound!(node.bounds, bi, bs)

@inline get_bounds(node::Complete_node{T}) where {T <: Number} =
  M_abstract_expr_tree.get_bounds(node.bounds)

@inline get_convexity_status(node::Complete_node{T}) where {T <: Number} =
  M_implementation_convexity_type.get_convexity_wrapper(node.convexity_status)

@inline set_convexity_status!(
  node::Complete_node{T},
  t::M_implementation_convexity_type.Convexity_type,
) where {T <: Number} =
  M_implementation_convexity_type.set_convexity_wrapper!(node.convexity_status, t)

@inline create_complete_expr_tree(
  cn::Complete_node{T},
  ch::AbstractVector{Complete_expr_tree{T}},
) where {T <: Number} = Complete_expr_tree{T}(cn, ch)

@inline create_complete_expr_tree(cn::Complete_node{T}) where {T <: Number} =
  create_complete_expr_tree(cn, Vector{Complete_expr_tree{T}}(undef, 0))

@inline create_complete_expr_tree(ex::Complete_expr_tree{T}) where {T <: Number} = ex

function create_complete_expr_tree(t::M_implementation_expr_tree.Type_node{T}) where {T <: Abstract_expr_node}
  nd = M_trait_tree.get_node(t)
  ch = M_trait_tree.get_children(t)
  if isempty(ch)
    new_nd = create_complete_node(nd)
    return create_complete_expr_tree(new_nd)
  else
    new_ch = create_complete_expr_tree.(ch)
    new_nd = create_complete_node(M_trait_tree.get_node(t))
    return create_complete_expr_tree(new_nd, new_ch)
  end
end

@inline create_expr_tree(tree::Complete_expr_tree{T}) where {T <: Number} =
  create_expr_tree(M_trait_tree.get_node(tree), M_trait_tree.get_children(tree))

@inline create_expr_tree(
  field::Complete_node{T},
  children::Vector{Complete_expr_tree{T}},
) where {T <: Number} = M_abstract_expr_tree.create_expr_tree(
  get_op_from_node(field),
  Vector{M_implementation_expr_tree.Type_expr_tree}(create_expr_tree.(children)),
)

@inline create_expr_tree(field::Complete_node{T}) where {T <: Number} =
  M_abstract_expr_tree.create_expr_tree(get_op_from_node(field))::M_implementation_expr_tree.Type_expr_tree

@inline _get_expr_node(t::Complete_expr_tree) = get_op_from_node(M_trait_tree.get_node(t))

@inline _get_expr_children(t::Complete_expr_tree) = M_trait_tree.get_children(t)

@inline _get_real_node(ex::Complete_expr_tree{T}) where {T <: Number} = _get_expr_node(ex)

@inline tuple_bound_from_tree(ex::Complete_expr_tree{T}) where {T <: Number} =
  get_bounds(M_trait_tree._get_node(ex))

@inline _transform_to_expr_tree(ex::Complete_expr_tree{T}) where {T <: Number} =
  create_expr_tree(ex)

function create_Expr(t::Complete_expr_tree)
  nd = M_trait_tree.get_node(t)
  ch = M_trait_tree.get_children(t)
  op = get_op_from_node(nd)
  if isempty(ch)
    return M_trait_expr_node.node_to_Expr(op)
  else
    children_Expr = create_Expr.(ch)
    node_Expr = M_trait_expr_node.node_to_Expr(op)
    if length(node_Expr) == 1 # easy case
      return Expr(:call, node_Expr[1], children_Expr...)
    elseif length(node_Expr) == 2 # :^
      return Expr(:call, node_Expr[1], children_Expr..., node_Expr[2])
    else
      error("non traité")
    end
  end
end

function _inverse_expr_tree(t::Complete_expr_tree{T}) where {T <: Number}
  op_minus = M_abstract_expr_node.create_node_expr(:-)
  bounds = M_abstract_expr_tree.create_empty_bounds(T)
  node = create_complete_node(op_minus, bounds)
  return create_complete_expr_tree(node, [t])
end

function Base.copy(ex::Complete_expr_tree{T}) where {T <: Number}
  nd = M_trait_tree.get_node(ex)
  ch = M_trait_tree.get_children(ex)::Vector{Complete_expr_tree{T}}
  if isempty(ch)
    leaf = create_complete_expr_tree(nd)
    return leaf
  else
    res_ch = Base.copy.(ch)
    new_node =
      create_complete_node(get_op_from_node(nd), get_bounds_from_node(nd), nd.convexity_status)
    return create_complete_expr_tree(new_node, res_ch)
  end
end

(==)(node1::Complete_node{T}, node2::Complete_node{T}) where {T <: Number} = (
  (node1.op == node2.op) &&
  (node1.bounds == node2.bounds) &&
  (node1.convexity_status == node2.convexity_status)
)

function (==)(ex1::Complete_expr_tree{T}, ex2::Complete_expr_tree{T}) where {T <: Number}
  ch1 = M_trait_tree.get_children(ex1)
  ch2 = M_trait_tree.get_children(ex2)
  nd1 = _get_expr_node(ex1)
  nd2 = _get_expr_node(ex2)
  if length(ch1) != length(ch2)
    return false
  end
  b = true
  for i = 1:length(ch1)
    b = b && (ch1[i] == ch2[i])
  end
  b = b && (nd1 == nd2)
  return b
end

end  # moduleM_implementation_expr_tree
