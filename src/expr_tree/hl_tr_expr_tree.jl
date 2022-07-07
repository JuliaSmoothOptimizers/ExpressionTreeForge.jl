
module M_hl_trait_expr_tree

import ..M_interface_expr_tree._expr_tree_to_create

using ..M_trait_expr_tree, ..M_trait_expr_node
using ..M_implementation_expr_tree,
  ..M_implementation_expr_tree_Expr, ..M_implementation_complete_expr_tree

@inline _expr_tree_to_create(
  original_ex::M_implementation_expr_tree.Type_expr_tree,
  tree_of_needed_type::Expr,
) = M_trait_expr_tree.transform_to_Expr(original_ex)

@inline _expr_tree_to_create(
  original_ex::M_implementation_expr_tree.Type_expr_tree,
  tree_of_needed_type::M_implementation_expr_tree.Type_expr_tree,
) = original_ex

function _cast_type_of_constant(ex::M_implementation_expr_tree.Type_expr_tree, t::DataType)
  ch = M_trait_expr_tree.get_expr_children(ex)
  nd = M_trait_expr_tree.get_expr_node(ex)
  if isempty(ch)
    node = M_trait_expr_node._cast_constant!(nd, t)
    return M_implementation_expr_tree.create_expr_tree(node)
  elseif M_trait_expr_node.node_is_power(nd)
    new_node = M_trait_expr_node._cast_constant!(nd, t)
    new_ch = _cast_type_of_constant.(ch, t)
    return M_implementation_expr_tree.create_expr_tree(new_node, new_ch)
  else
    new_ch = _cast_type_of_constant.(ch, t)
    return M_implementation_expr_tree.create_expr_tree(nd, new_ch)
  end
end

function _cast_type_of_constant(ex::Expr, t::DataType)
  ch = M_trait_expr_tree.get_expr_children(ex)
  for i = 1:length(ch)
    node_i = M_trait_expr_tree.get_expr_node(ch[i])
    if M_trait_expr_node.node_is_constant(node_i)
      ex.args[i + 1] = M_trait_expr_node._cast_constant!(i, t) #manipulation assez bas niveau des Expr
    # @show i, ch[i]
    elseif M_trait_expr_node.node_is_power(node_i)
      ch[i].args[end] = M_trait_expr_node._cast_constant!(node_i, t)
    end
  end
end

function _cast_type_of_constant(
  ex::M_implementation_complete_expr_tree.Complete_expr_tree,
  t::DataType,
)
  ch = M_trait_expr_tree.get_expr_children(ex)
  nd = M_trait_expr_tree.get_expr_node(ex)
  if isempty(ch)
    treated_nd = M_trait_expr_node._cast_constant!(nd, t)
    new_nd = M_implementation_complete_expr_tree.create_complete_node(treated_nd, t)
    return M_implementation_complete_expr_tree.create_complete_expr_tree(new_nd)
  elseif M_trait_expr_node.node_is_power(nd)
    treated_nd = M_trait_expr_node._cast_constant!(nd, t)
    new_nd = M_implementation_complete_expr_tree.create_complete_node(treated_nd, t)
    treated_ch = _cast_type_of_constant.(ch, t)
    new_ch = M_implementation_complete_expr_tree.create_complete_expr_tree.(treated_ch)
    return M_implementation_complete_expr_tree.create_complete_expr_tree(new_nd, new_ch)
  else
    new_ch = _cast_type_of_constant.(ch, t)
    new_nd = M_implementation_complete_expr_tree.create_complete_node(nd, t)
    new_ex = M_implementation_complete_expr_tree.create_complete_expr_tree(new_nd, new_ch)
    return new_ex
  end
end

end
