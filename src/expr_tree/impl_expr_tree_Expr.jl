module M_implementation_expr_tree_Expr

using ..M_abstract_expr_node
using ..M_abstract_expr_tree
using ..M_implementation_expr_tree

import ..M_abstract_expr_tree:
  create_expr_tree,
  create_Expr
import ..M_interface_expr_tree:
  _get_expr_node,
  _get_expr_children,
  _inverse_expr_tree,
  _get_real_node,
  _transform_to_expr_tree

@inline create_expr_tree(ex::Expr) = ex

@inline create_Expr(ex::Expr) = ex

@inline _get_expr_node(ex::Number) = M_abstract_expr_node.create_node_expr(ex)

function _get_expr_node(ex::Expr)
  hd = ex.head
  args = ex.args
  if hd == :call
    op = args[1]
    if op != :^
      return M_abstract_expr_node.create_node_expr(op)
    else
      index_power = args[end]
      return M_abstract_expr_node.create_node_expr(op, index_power, true)
    end
  elseif hd == :ref
    name_variable = args[1]
    index_variable = args[2]
    return M_abstract_expr_node.create_node_expr(name_variable, index_variable)
  else
    error("Unsupported")
  end
end

@inline _get_expr_children(t::Number) = []

function _get_expr_children(ex::Expr)
  hd = ex.head
  args = ex.args
  if hd == :ref
    return []
  elseif hd == :call
    op = args[1]
    if op != :^
      return args[2:end]
    else
      return args[2:(end - 1)]
    end
  else
    error("Unsupported")
  end
end

@inline _inverse_expr_tree(ex::Expr) = Expr(:call, :-, ex)

@inline _inverse_expr_tree(ex::Number) = Expr(:call, :-, ex)

#Fonction à reprendre potetiellement, pourle moment ca marche
function _get_real_node(ex::Expr)
  hd = ex.head
  args = ex.args
  if hd == :call
    op = args[1]
    if op != :^
      return op
    else
      index_power = args[end]
      error("Not done yet, _get_real_node")
    end
  elseif hd == :ref
    return ex
  else
    error("Unsupported, _get_real_node")
  end
end

@inline _get_real_node(ex::Number) = ex

function _transform_to_expr_tree(ex::Expr)
  n_node = _get_expr_node(ex)::M_abstract_expr_node.Abstract_expr_node
  children = _get_expr_children(ex)
  if isempty(children)
    return M_abstract_expr_tree.create_expr_tree(n_node)::M_implementation_expr_tree.Type_expr_tree
  else
    n_children = _transform_to_expr_tree.(children)::Vector{M_implementation_expr_tree.Type_expr_tree}
    return M_abstract_expr_tree.create_expr_tree(
      n_node,
      n_children,
    )::M_implementation_expr_tree.Type_expr_tree
  end
end

_transform_to_expr_tree(ex::Number) = M_abstract_expr_tree.create_expr_tree(
  M_abstract_expr_node.create_node_expr(ex),
)::M_implementation_expr_tree.Type_expr_tree

end
