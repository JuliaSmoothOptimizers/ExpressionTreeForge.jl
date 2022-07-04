
module hl_trait_expr_tree

import ..interface_expr_tree._expr_tree_to_create

using ..trait_expr_tree, ..trait_expr_node
using ..implementation_expr_tree,
  ..implementation_expr_tree_Expr, ..implementation_complete_expr_tree

@inline _expr_tree_to_create(
  original_ex::implementation_expr_tree.t_expr_tree,
  tree_of_needed_type::Expr,
) = trait_expr_tree.transform_to_Expr(original_ex)
@inline _expr_tree_to_create(
  original_ex::implementation_expr_tree.t_expr_tree,
  tree_of_needed_type::implementation_expr_tree.t_expr_tree,
) = original_ex

function _cast_type_of_constant(ex::implementation_expr_tree.t_expr_tree, t::DataType)
  ch = trait_expr_tree.get_expr_children(ex)
  nd = trait_expr_tree.get_expr_node(ex)
  if isempty(ch)
    node = trait_expr_node._cast_constant!(nd, t)
    return implementation_expr_tree.create_expr_tree(node)
  elseif trait_expr_node.node_is_power(nd)
    new_node = trait_expr_node._cast_constant!(nd, t)
    new_ch = _cast_type_of_constant.(ch, t)
    return implementation_expr_tree.create_expr_tree(new_node, new_ch)
  else
    new_ch = _cast_type_of_constant.(ch, t)
    return implementation_expr_tree.create_expr_tree(nd, new_ch)
  end
end

function _cast_type_of_constant(ex::Expr, t::DataType)
  ch = trait_expr_tree.get_expr_children(ex)
  for i = 1:length(ch)
    node_i = trait_expr_tree.get_expr_node(ch[i])
    if trait_expr_node.node_is_constant(node_i)
      ex.args[i + 1] = trait_expr_node._cast_constant!(i, t) #manipulation assez bas niveau des Expr
    # @show i, ch[i]
    elseif trait_expr_node.node_is_power(node_i)
      ch[i].args[end] = trait_expr_node._cast_constant!(node_i, t)
    end
  end
end

function _cast_type_of_constant(
  ex::implementation_complete_expr_tree.complete_expr_tree,
  t::DataType,
)
  ch = trait_expr_tree.get_expr_children(ex)
  nd = trait_expr_tree.get_expr_node(ex)
  if isempty(ch)
    treated_nd = trait_expr_node._cast_constant!(nd, t)
    new_nd = implementation_complete_expr_tree.create_complete_node(treated_nd, t)
    return implementation_complete_expr_tree.create_complete_expr_tree(new_nd)
  elseif trait_expr_node.node_is_power(nd)
    treated_nd = trait_expr_node._cast_constant!(nd, t)
    new_nd = implementation_complete_expr_tree.create_complete_node(treated_nd, t)
    treated_ch = _cast_type_of_constant.(ch, t)
    new_ch = implementation_complete_expr_tree.create_complete_expr_tree.(treated_ch)
    return implementation_complete_expr_tree.create_complete_expr_tree(new_nd, new_ch)
  else
    new_ch = _cast_type_of_constant.(ch, t)
    new_nd = implementation_complete_expr_tree.create_complete_node(nd, t)
    new_ex = implementation_complete_expr_tree.create_complete_expr_tree(new_nd, new_ch)
    return new_ex
  end
end

end