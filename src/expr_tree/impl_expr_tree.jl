module M_implementation_expr_tree

using ..M_abstract_expr_node, ..M_trait_expr_node
using ..M_abstract_expr_tree
using ..M_trait_tree

import ..M_abstract_expr_tree: create_expr_tree, create_Expr, create_Expr2
import ..M_implementation_tree.Type_node
import ..M_interface_expr_tree:
  _inverse_expr_tree, _get_expr_node, _get_expr_children, _get_real_node, _transform_to_expr_tree, _sum_expr_trees

export Type_expr_tree

"""
    Type_expr_tree{T} <: AbstractTree

Basic implementation of an expression tree.`
Every expression tree supported must be able to return `Type_expr_tree`.
A `Type_expr_tree` has fields:

* `field::Abstract_expr_node` representing an operator, a constant or a variable;
* `children::Vector{Type_expr_tree{T}}` a vector of children, each of them being a `Type_expr_tree{T}`.
"""
Type_expr_tree = Type_node{Abstract_expr_node}

function create_Expr(t::Type_expr_tree)
  nd = M_trait_tree.get_node(t)
  ch = M_trait_tree.get_children(t)
  if isempty(ch)
    return M_trait_expr_node.node_to_Expr(nd)
  else
    children_Expr = create_Expr.(ch)
    node_Expr = M_trait_expr_node.node_to_Expr(nd)
    # differentiate the simple operators :+, :- and the more complicated :^2
    # simple operators
    if length(node_Expr) == 1
      return Expr(:call, node_Expr[1], children_Expr...)
      # complicate operators
    elseif length(node_Expr) == 2
      return Expr(:call, node_Expr[1], children_Expr..., node_Expr[2])
    else
      error("unsupported")
    end
  end
end

function create_Expr2(t::Type_expr_tree)
  nd = M_trait_tree.get_node(t)
  ch = M_trait_tree.get_children(t)
  if isempty(ch)
    return M_trait_expr_node.node_to_Expr2(nd)
  else
    children_Expr = create_Expr2.(ch)
    node_Expr = M_trait_expr_node.node_to_Expr2(nd)
    # differentiate the simple operators :+, :- and the more complicated :^2
    # simple operators
    if length(node_Expr) == 1
      return Expr(:call, node_Expr[1], children_Expr...)
      # complicate operators
    elseif length(node_Expr) == 2
      return Expr(:call, node_Expr[1], children_Expr..., node_Expr[2])
    else
      error("unsupported")
    end
  end
end

create_expr_tree(field::T, children::Vector{Type_node{T}}) where {T <: Abstract_expr_node} =
  length(children) == 0 ? create_expr_tree(field) : Type_expr_tree(field, children)

create_expr_tree(field::T) where {T <: Abstract_expr_node} =
  Type_expr_tree(field, Vector{Type_expr_tree}(undef, 0))

_get_expr_node(t::Type_expr_tree) = M_trait_tree.get_node(t)

_get_expr_children(t::Type_expr_tree) = M_trait_tree.get_children(t)

function _sum_expr_trees(trees::Vector{Type_expr_tree})
  op_sum = M_abstract_expr_node.create_node_expr(:+)
  new_node = M_abstract_expr_tree.create_expr_tree(op_sum, trees)
  return new_node
end

function _inverse_expr_tree(t::Type_expr_tree)
  op_minus = M_abstract_expr_node.create_node_expr(:-)
  new_node = M_abstract_expr_tree.create_expr_tree(op_minus, [t])
  return new_node
end

function _get_real_node(ex::Type_expr_tree)
  if isempty(_get_expr_children(ex))
    return ex.field
  else
    return _get_expr_node(ex)
  end
end

_transform_to_expr_tree(ex::Type_expr_tree) = copy(ex)::Type_expr_tree

function Base.copy(ex::Type_expr_tree)
  nd = M_trait_tree.get_node(ex)
  ch = M_trait_tree.get_children(ex)
  if isempty(ch)
    leaf = M_abstract_expr_tree.create_expr_tree(M_abstract_expr_node.create_node_expr(nd))
    return leaf
  else
    res_ch = Base.copy.(ch)
    new_node = M_abstract_expr_node.create_node_expr(nd)
    return create_expr_tree(new_node, res_ch)
  end
end

end
