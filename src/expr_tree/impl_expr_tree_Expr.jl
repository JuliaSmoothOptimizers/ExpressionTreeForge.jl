module M_implementation_expr_tree_Expr

using ..M_abstract_expr_node
using ..M_abstract_expr_tree
using ..M_implementation_expr_tree

import ..M_abstract_expr_tree: create_expr_tree, create_Expr
import ..M_interface_expr_tree:
  _get_expr_node,
  _get_expr_children,
  _inverse_expr_tree,
  _get_real_node,
  _transform_to_expr_tree,
  _sum_expr_trees

"""
    Variable_counter

Associate the index of the symbol variable to their integer index.  
"""
mutable struct Variable_counter
  current_var::Int
  dic_var::Dict{Symbol, Int}
end
Variable_counter(; index = 0, dic_var = Dict{Symbol, Int}()) = Variable_counter(index, dic_var)

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
      pow_op = M_abstract_expr_node.create_node_expr(op, index_power, true)
      return pow_op
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

@inline _sum_expr_trees(exprs::Vector) = Expr(:call, :+, exprs...)

@inline _inverse_expr_tree(ex::Expr) = Expr(:call, :-, ex)

@inline _inverse_expr_tree(ex::Number) = Expr(:call, :-, ex)

function _get_real_node(ex::Expr)
  hd = ex.head
  args = ex.args
  if hd == :call
    op = args[1]
    if op != :^
      return op
    else
      error("unary operator which is not ^ (_get_real_node(ex::Expr)")
    end
  elseif hd == :ref
    return ex
  else
    error("Unsupported, _get_real_node")
  end
end

@inline _get_real_node(ex::Number) = ex

function _transform_to_expr_tree(ex::Expr; vc::Variable_counter = Variable_counter())
  n_node = _get_expr_node(ex)::M_abstract_expr_node.Abstract_expr_node
  children = _get_expr_children(ex)
  if isempty(children)
    return M_abstract_expr_tree.create_expr_tree(n_node)::M_implementation_expr_tree.Type_expr_tree
  else
    n_children = _transform_to_expr_tree.(children; vc)
    return M_abstract_expr_tree.create_expr_tree(
      n_node,
      n_children,
    )::M_implementation_expr_tree.Type_expr_tree
  end
end

_transform_to_expr_tree(ex::Number; vc::Variable_counter = Variable_counter()) =
  M_abstract_expr_tree.create_expr_tree(
    M_abstract_expr_node.create_node_expr(ex),
  )::M_implementation_expr_tree.Type_expr_tree

function _transform_to_expr_tree(sym::Symbol; vc::Variable_counter = Variable_counter())
  string_sym = string(sym)
  if string_sym[1] == 'x'
    index = get_value(vc, sym)
    if index == -1
      add_dic_var!(vc, sym)
      index = get_value(vc, sym)
    end
    M_abstract_expr_tree.create_expr_tree(M_abstract_expr_node.create_node_expr(:x, index))
  end
end

end
