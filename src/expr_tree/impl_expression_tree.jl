module M_implementation_expression_tree_Expr

using ModelingToolkit

using ..M_abstract_expr_node, ..M_abstract_expr_tree
using ..M_implementation_expr_tree

import ..M_abstract_expr_tree:
  create_expr_tree,
  create_Expr
import ..M_interface_expr_tree:
  _inverse_expr_tree,
  _get_expr_node,
  _get_expr_children,
  _get_real_node,
  _transform_to_expr_tree

"""
    Variable_counter

Associate the index of the symbol variable to their integer index.  
"""
mutable struct Variable_counter
  current_var::Int
  dic_var::Dict{Symbol, Int64}
end
Variable_counter(; index = 0, dic_var = Dict{Symbol, Int64}()) = Variable_counter(index, dic_var)

@inline zero_vc() = Variable_counter()

@inline get_value(vc::Variable_counter, s::Symbol) = get(vc.dic_var, s, -1)

@inline decimal_basis(a::Int, b::Int) = a * 10 + b

function add_dic_var!(vc::Variable_counter, sym::Symbol)
  str_sym = String(sym) # Symbol -> String
  chains = split(str_sym, "x") # split from the "x"
  str = string(chains[2]) # get the indices
  int_chain = Vector{Int}(undef, length(str))
  for (id, v) in enumerate(str)
    int_chain[id] = Int(v) # transform unicode to Int
  end
  dec_basis = (x -> x - 8320).(int_chain) # Int('₁') = 8321
  index = mapreduce(x -> x, decimal_basis, dec_basis) # compute the index using a decimal basis
  vc.dic_var[sym] = index
end

@inline create_expr_tree(ex::ModelingToolkit.Operation) = ex

@inline create_Expr(ex::ModelingToolkit.Operation) = ex

function _get_expr_node(ex::ModelingToolkit.Operation; vc::Variable_counter = Variable_counter())
  op = ex.op
  if op == +
    return M_abstract_expr_node.create_node_expr(:+)
  elseif op == -
    return M_abstract_expr_node.create_node_expr(:-)
  elseif op == *
    return M_abstract_expr_node.create_node_expr(:*)
  elseif op == /
    return M_abstract_expr_node.create_node_expr(:/)
  elseif op == ^
    power_value = ex.args[end].value
    return M_abstract_expr_node.create_node_expr(:^, power_value, true)
  elseif op == tan
    return M_abstract_expr_node.create_node_expr(:tan)
  elseif op == cos
    return M_abstract_expr_node.create_node_expr(:cos)
  elseif op == sin
    return M_abstract_expr_node.create_node_expr(:sin)
  elseif op == exp
    return M_abstract_expr_node.create_node_expr(:exp)
  elseif typeof(op) == ModelingToolkit.Variable
    symbol = op.name
    index = get_value(vc, symbol)
    if index == -1
      add_dic_var!(vc, symbol)
      index = get_value(vc, symbol)
    end
    M_abstract_expr_node.create_node_expr(:x, index)
  elseif typeof(op) == ModelingToolkit.Variable{Number}
    symbol = op.name
    index = get_value(vc, symbol)
    if index == -1
      add_dic_var!(vc, symbol)
      index = get_value(vc, symbol)
    end
    M_abstract_expr_node.create_node_expr(:x, index)
  else
    @error("unsupported operator (ModelingToolKit Interface)")
  end
end

@inline _get_expr_node(ex::ModelingToolkit.Constant) = M_abstract_expr_node.create_node_expr(ex.value)

@inline _get_expr_children(ex::ModelingToolkit.Operation) =
  (ex.op == ^) ? ex.args[1:(end - 1)] : ex.args

@inline _get_expr_children(c::ModelingToolkit.Constant) = []

function _transform_to_expr_tree(ex::ModelingToolkit.Operation)
  vc = zero_vc()
  _transform_to_expr_tree2(ex::ModelingToolkit.Operation; vc)
end

function _transform_to_expr_tree2(ex::ModelingToolkit.Operation; vc::Variable_counter)
  n_node = _get_expr_node(ex; vc)::M_abstract_expr_node.Abstract_expr_node
  children = _get_expr_children(ex)
  if isempty(children)
    return M_abstract_expr_tree.create_expr_tree(n_node)::M_implementation_expr_tree.Type_expr_tree
  else
    n_children =
      _transform_to_expr_tree2.(children; vc)::Vector{M_implementation_expr_tree.Type_expr_tree}
    return M_abstract_expr_tree.create_expr_tree(
      n_node,
      n_children,
    )::M_implementation_expr_tree.Type_expr_tree
  end
end

_transform_to_expr_tree2(ex::ModelingToolkit.Constant; vc) = M_abstract_expr_tree.create_expr_tree(
  M_abstract_expr_node.create_node_expr(ex.value),
)::M_implementation_expr_tree.Type_expr_tree

end
