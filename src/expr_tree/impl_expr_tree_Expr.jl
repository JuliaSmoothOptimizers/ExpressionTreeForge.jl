module implementation_expr_tree_Expr

using ..M_abstract_expr_node
using ..abstract_expr_tree
using ..implementation_expr_tree

import ..abstract_expr_tree.create_expr_tree, ..abstract_expr_tree.create_Expr

import ..interface_expr_tree._get_expr_node,
  ..interface_expr_tree._get_expr_children, ..interface_expr_tree._inverse_expr_tree
import ..interface_expr_tree._get_real_node, ..interface_expr_tree._transform_to_expr_tree

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
    error("partie non traite des Expr pour le moment ")
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
    error("partie non traité des expr")
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
      error("pas encore fait")
    end
  elseif hd == :ref
    # name_variable = args[1]
    # index_variable = args[2]
    # return [name_variable, index_variable]
    return ex
  else
    error("partie non traite des Expr pour le moment ")
  end
end

@inline _get_real_node(ex::Number) = ex

function _transform_to_expr_tree(ex::Expr)
  n_node = _get_expr_node(ex)::M_abstract_expr_node.Abstract_expr_node
  children = _get_expr_children(ex)
  if isempty(children)
    return abstract_expr_tree.create_expr_tree(n_node)::implementation_expr_tree.t_expr_tree
  else
    n_children = _transform_to_expr_tree.(children)::Vector{implementation_expr_tree.t_expr_tree}
    return abstract_expr_tree.create_expr_tree(
      n_node,
      n_children,
    )::implementation_expr_tree.t_expr_tree
  end
end

_transform_to_expr_tree(ex::Number) = abstract_expr_tree.create_expr_tree(
  M_abstract_expr_node.create_node_expr(ex),
)::implementation_expr_tree.t_expr_tree

end
