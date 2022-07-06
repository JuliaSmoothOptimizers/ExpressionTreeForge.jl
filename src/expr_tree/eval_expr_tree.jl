module M_evaluation_expr_tree
using ForwardDiff, ReverseDiff

using ..M_trait_expr_tree, ..M_trait_expr_node
using ..M_implementation_expr_tree,
  ..M_implementation_complete_expr_tree, ..M_implementation_pre_compiled_tree
using ..M_abstract_expr_node
using ..M_implementation_pre_n_compiled_tree

# IMPORTANT The fonction evaluate_expr_tree keep the type of x
# IT requires that the M_constant have the same type of x
@inline evaluate_expr_tree(a::Any) = (x::AbstractVector{} -> evaluate_expr_tree(a, x))

@inline evaluate_expr_tree(a::Any, elmt_var::Vector{Int}) =
  (x::AbstractVector{} -> evaluate_expr_tree(a, view(x, elmt_var)))

@inline evaluate_expr_tree(a::Any, x::AbstractVector{T}) where {T <: Number} =
  _evaluate_expr_tree(a, M_trait_expr_tree.is_expr_tree(a), x)

@inline evaluate_expr_tree(a::Any, x::AbstractVector) =
  _evaluate_expr_tree(a, M_trait_expr_tree.is_expr_tree(a), x)

@inline evaluate_expr_tree(a::Any, x::AbstractArray) =
  _evaluate_expr_tree(a, M_trait_expr_tree.is_expr_tree(a), x)

@inline _evaluate_expr_tree(
  a,
  ::M_trait_expr_tree.Is_not_expr_tree,
  x::AbstractVector{T},
) where {T <: Number} = error(" This is not an Expr tree")

@inline _evaluate_expr_tree(
  a,
  ::M_trait_expr_tree.Is_expr_tree,
  x::AbstractVector{T},
) where {T <: Number} = _evaluate_expr_tree(a, x)

@inline _evaluate_expr_tree(a, ::M_trait_expr_tree.Is_not_expr_tree, x::AbstractVector) =
  error(" This is not an Expr tree")

@inline _evaluate_expr_tree(a, ::M_trait_expr_tree.Is_expr_tree, x::AbstractVector) =
  _evaluate_expr_tree(a, x)

@inline _evaluate_expr_tree(a, ::M_trait_expr_tree.Is_not_expr_tree, x::AbstractArray) =
  error(" This is not an Expr tree")

@inline _evaluate_expr_tree(a, ::M_trait_expr_tree.Is_expr_tree, x::AbstractArray) =
  _evaluate_expr_tree(a, x)

function _evaluate_expr_tree(expr_tree::Y, x::AbstractVector{T}) where {T <: Number} where {Y}
  nd = M_trait_expr_tree._get_expr_node(expr_tree)
  if M_trait_expr_node.node_is_operator(nd) == false
    M_trait_expr_node.evaluate_node(nd, x)
  else
    ch = M_trait_expr_tree._get_expr_children(expr_tree)
    n = length(ch)
    temp = Vector{T}(undef, n)
    map!(y -> evaluate_expr_tree(y, x), temp, ch)
    M_trait_expr_node.evaluate_node(nd, temp)
  end
end

@inline function _evaluate_expr_tree(
  expr_tree::M_implementation_expr_tree.Type_expr_tree,
  x::AbstractVector{T},
) where {T <: Number}
  if M_trait_expr_node.node_is_operator(expr_tree.field::M_trait_expr_node.Abstract_expr_node)::Bool == false
    return M_trait_expr_node._evaluate_node(expr_tree.field, x)
  else
    n = length(expr_tree.children)
    temp = Vector{T}(undef, n)
    map!(
      y::M_implementation_expr_tree.Type_expr_tree -> _evaluate_expr_tree(y, x),
      temp,
      expr_tree.children,
    )
    return M_trait_expr_node._evaluate_node(expr_tree.field, temp)
  end
end

@inline function _evaluate_expr_tree(
  expr_tree_cmp::M_implementation_complete_expr_tree.Complete_expr_tree,
  x::AbstractVector{T},
) where {T <: Number}
  op = M_trait_expr_tree.get_expr_node(expr_tree_cmp)::M_trait_expr_node.Abstract_expr_node
  if M_trait_expr_node.node_is_operator(op)::Bool == false
    return M_trait_expr_node._evaluate_node(op, x)
  else
    children = M_trait_expr_tree.get_expr_children(expr_tree_cmp)
    n = length(children)::Int
    temp = Vector{T}(undef, n)
    map!(
      y::M_implementation_complete_expr_tree.Complete_expr_tree -> _evaluate_expr_tree(y, x),
      temp,
      children,
    )
    return M_trait_expr_node._evaluate_node(op, temp)
  end
end

@inline _evaluate_expr_tree(
  tree::M_implementation_pre_compiled_tree.Pre_compiled_tree{T},
  x::AbstractVector{T},
) where {T <: Number} = M_implementation_pre_compiled_tree.evaluate_pre_compiled_tree(tree, x)

"""
    _evaluate_expr_tree_multiple_points(expr_tree, vec_x)


Evaluate the expr_tree as many times as there is vector in vec_x
"""
function _evaluate_expr_tree_multiple_points(
  expr_tree::M_implementation_expr_tree.Type_expr_tree,
  xs::Array{SubArray{T, 1, Array{T, 1}, N, false}, 1},
) where {N} where {T <: Number}
  op = M_trait_expr_tree.get_expr_node(expr_tree)::M_trait_expr_node.Abstract_expr_node
  number_x = length(xs)
  if M_trait_expr_node.node_is_operator(op::M_trait_expr_node.Abstract_expr_node)::Bool == false
    temp = Vector{T}(undef, number_x)
    map!(x -> M_trait_expr_node._evaluate_node(op, x), temp, xs)
    return temp
  else
    children = M_trait_expr_tree.get_expr_children(expr_tree)
    n = length(children)
    lx = length(xs[1])
    res = Vector{T}(undef, number_x)
    temp = Array{T, 2}(undef, n, number_x)
    for i = 1:n
      view(temp, i, :) .= _evaluate_expr_tree_multiple_points(children[i], xs)
    end
    for i = 1:number_x
      res[i] = M_trait_expr_node._evaluate_node(op, view(temp, :, i))
    end
    return res
  end
end

@inline evaluate_expr_tree_multiple_points(
  tree::M_implementation_pre_n_compiled_tree.Pre_n_compiled_tree{T},
  multiple_x::Vector{Vector{T}},
) where {T <: Number} =
  M_implementation_pre_n_compiled_tree.evaluate_pre_n_compiled_tree(tree, multiple_x)

@inline evaluate_expr_tree_multiple_points(
  tree::M_implementation_pre_n_compiled_tree.Pre_n_compiled_tree{T},
  multiple_x_view::Array{SubArray{T, 1, Array{T, 1}, N, false}, 1},
) where {N} where {T <: Number} =
  M_implementation_pre_n_compiled_tree.evaluate_pre_n_compiled_tree(tree, multiple_x_view)

@inline evaluate_expr_tree_multiple_points(a::Any, x::Array{Array{T, 1}, 1}) where {T <: Number} =
  _evaluate_expr_tree_multiple_points(a, M_trait_expr_tree.is_expr_tree(a), x)

@inline _evaluate_expr_tree_multiple_points(
  a,
  ::M_trait_expr_tree.Is_not_expr_tree,
  x::Array{Array{T, 1}, 1},
) where {T <: Number} = error(" This is not an Expr tree")

@inline _evaluate_expr_tree_multiple_points(
  a,
  ::M_trait_expr_tree.Is_expr_tree,
  x::Array{Array{T, 1}, 1},
) where {T <: Number} = _evaluate_expr_tree_multiple_points(a, x)

@inline evaluate_expr_tree_multiple_points(
  a::Any,
  x::Array{SubArray{T, 1, Array{T, 1}, N, true}, 1},
) where {N} where {T <: Number} =
  _evaluate_expr_tree_multiple_points(a, M_trait_expr_tree.is_expr_tree(a), x)

@inline _evaluate_expr_tree_multiple_points(
  a,
  ::M_trait_expr_tree.Is_not_expr_tree,
  x::Array{SubArray{T, 1, Array{T, 1}, N, true}, 1},
) where {N} where {T <: Number} = error(" This is not an Expr tree")

@inline _evaluate_expr_tree_multiple_points(
  a,
  ::M_trait_expr_tree.Is_expr_tree,
  x::Array{SubArray{T, 1, Array{T, 1}, N, true}, 1},
) where {N} where {T <: Number} = _evaluate_expr_tree_multiple_points(a, x)

@inline evaluate_expr_tree_multiple_points(
  a::Any,
  x::Array{SubArray{T, 1, Array{T, 1}, N, false}, 1},
) where {N} where {T <: Number} =
  _evaluate_expr_tree_multiple_points(a, M_trait_expr_tree.is_expr_tree(a), x)

@inline _evaluate_expr_tree_multiple_points(
  a,
  ::M_trait_expr_tree.Is_not_expr_tree,
  x::Array{SubArray{T, 1, Array{T, 1}, N, false}, 1},
) where {N} where {T <: Number} = error(" This is not an Expr tree")

@inline _evaluate_expr_tree_multiple_points(
  a,
  ::M_trait_expr_tree.Is_expr_tree,
  x::Array{SubArray{T, 1, Array{T, 1}, N, false}, 1},
) where {N} where {T <: Number} = _evaluate_expr_tree_multiple_points(a, x)

@inline function _evaluate_expr_tree_multiple_points(
  expr_tree_cmp::M_implementation_complete_expr_tree.Complete_expr_tree,
  xs::Array{Array{T, 1}, 1},
) where {T <: Number}
  op = M_trait_expr_tree.get_expr_node(expr_tree_cmp)::M_trait_expr_node.Abstract_expr_node
  number_x = length(xs)
  if M_trait_expr_node.node_is_operator(op::M_trait_expr_node.Abstract_expr_node)::Bool == false
    temp = Vector{T}(undef, number_x)
    map!(x -> M_trait_expr_node._evaluate_node(op, x), temp, xs)
    return temp
  else
    children = M_trait_expr_tree.get_expr_children(expr_tree_cmp)
    n = length(children)
    lx = length(xs[1])
    res = Vector{T}(undef, number_x)
    temp = Array{T, 2}(undef, n, number_x)
    for i = 1:n
      view(temp, i, :) .= _evaluate_expr_tree_multiple_points(children[i], xs)
    end
    for i = 1:number_x
      res[i] = M_trait_expr_node._evaluate_node(op, view(temp, :, i))
    end
    return res
  end
end

function _evaluate_expr_tree_multiple_points(
  expr_tree_cmp::M_implementation_complete_expr_tree.Complete_expr_tree,
  xs::Array{SubArray{T, 1, Array{T, 1}, N, true}, 1},
) where {N} where {T <: Number}
  op = M_trait_expr_tree.get_expr_node(expr_tree_cmp)::M_trait_expr_node.Abstract_expr_node
  number_x = length(xs)
  if M_trait_expr_node.node_is_operator(op::M_trait_expr_node.Abstract_expr_node)::Bool == false
    temp = Vector{T}(undef, number_x)
    map!(x -> M_trait_expr_node._evaluate_node(op, x), temp, xs)
    return temp
  else
    children = M_trait_expr_tree.get_expr_children(expr_tree_cmp)
    n = length(children)
    lx = length(xs[1])
    res = Vector{T}(undef, number_x)
    temp = Array{T, 2}(undef, n, number_x)
    for i = 1:n
      view(temp, i, :) .= _evaluate_expr_tree_multiple_points(children[i], xs)
    end
    for i = 1:number_x
      res[i] = M_trait_expr_node._evaluate_node(op, view(temp, :, i))
    end
    return res
  end
end

function _evaluate_expr_tree_multiple_points(
  expr_tree_cmp::M_implementation_complete_expr_tree.Complete_expr_tree,
  xs::Array{SubArray{T, 1, Array{T, 1}, N, false}, 1},
) where {N} where {T <: Number}
  op = M_trait_expr_tree.get_expr_node(expr_tree_cmp)::M_trait_expr_node.Abstract_expr_node
  number_x = length(xs)
  if M_trait_expr_node.node_is_operator(op::M_trait_expr_node.Abstract_expr_node)::Bool == false
    temp = Vector{T}(undef, number_x)
    map!(x -> M_trait_expr_node._evaluate_node(op, x), temp, xs)
    return temp
  else
    children = M_trait_expr_tree.get_expr_children(expr_tree_cmp)
    n = length(children)
    lx = length(xs[1])
    res = Vector{T}(undef, number_x)
    temp = Array{T, 2}(undef, n, number_x)
    for i = 1:n
      view(temp, i, :) .= _evaluate_expr_tree_multiple_points(children[i], xs)
    end
    for i = 1:number_x
      res[i] = M_trait_expr_node._evaluate_node(op, view(temp, :, i))
    end
    return res
  end
end

"""
    calcul_gradient_expr_tree(expr_tree, x)

Evaluation the gradient of the function represented by expr_tree at the point x
"""
@inline calcul_gradient_expr_tree(a::Any, x::Vector{}) =
  _calcul_gradient_expr_tree(a, is_expr_tree(a), x)
@inline _calcul_gradient_expr_tree(a::Any, ::M_trait_expr_tree.Is_not_expr_tree, x::Vector{}) =
  error("ce n'est pas un arbre d'expression")
@inline _calcul_gradient_expr_tree(a::Any, ::M_trait_expr_tree.Is_expr_tree, x::Vector{}) =
  _calcul_gradient_expr_tree(a, x)
@inline calcul_gradient_expr_tree(a::Any, x::Vector{}, elmt_var::Vector{Int}) =
  _calcul_gradient_expr_tree(a, is_expr_tree(a), x, elmt_var)
@inline _calcul_gradient_expr_tree(
  a::Any,
  ::M_trait_expr_tree.Is_not_expr_tree,
  x::Vector{},
  elmt_var::Vector{Int},
) = error("ce n'est pas un arbre d'expression")

@inline _calcul_gradient_expr_tree(
  a::Any,
  ::M_trait_expr_tree.Is_expr_tree,
  x::Vector{},
  elmt_var::Vector{Int},
) = _calcul_gradient_expr_tree(a, x, elmt_var)

@inline _calcul_gradient_expr_tree(expr_tree, x::Vector{T}) where {T <: Number} =
  ForwardDiff.gradient(evaluate_expr_tree(expr_tree), x)

@inline _calcul_gradient_expr_tree(expr_tree, x::Vector{}, elmt_var::Vector{Int}) =
  ForwardDiff.gradient(evaluate_expr_tree(expr_tree, elmt_var), x)

@inline calcul_gradient_expr_tree2(a::Any, x::Vector{}, elmt_var::Vector{Int}) =
  _calcul_gradient_expr_tree2(a, is_expr_tree(a), x, elmt_var)

@inline calcul_gradient_expr_tree2(a::Any, x::Vector{}) =
  _calcul_gradient_expr_tree2(a, is_expr_tree(a), x)

@inline _calcul_gradient_expr_tree2(a::Any, ::M_trait_expr_tree.Is_not_expr_tree, x::Vector{}) =
  error("ce n'est pas un arbre d'expression")

@inline _calcul_gradient_expr_tree2(a::Any, ::M_trait_expr_tree.Is_expr_tree, x::Vector{}) =
  _calcul_gradient_expr_tree2(a, x)

@inline _calcul_gradient_expr_tree2(
  a::Any,
  ::M_trait_expr_tree.Is_not_expr_tree,
  x::Vector{},
  elmt_var::Vector{Int},
) = error("ce n'est pas un arbre d'expression")

@inline _calcul_gradient_expr_tree2(
  a::Any,
  ::M_trait_expr_tree.Is_expr_tree,
  x::Vector{},
  elmt_var::Vector{Int},
) = _calcul_gradient_expr_tree2(a, x, elmt_var)

@inline _calcul_gradient_expr_tree2(expr_tree, x::Vector{T}) where {T <: Number} =
  ReverseDiff.gradient(evaluate_expr_tree(expr_tree), x)
  
@inline _calcul_gradient_expr_tree2(expr_tree, x::Vector{}, elmt_var::Vector{Int}) =
  ReverseDiff.gradient(evaluate_element_expr_tree(expr_tree, elmt_var), x)

"""
    calcul_Hessian_expr_tree(expr_tree, x)
    
Compute the hessian matrix of the function represented by expr_tree at the point x
"""
@inline calcul_Hessian_expr_tree(a::Any, x::Vector{}) =
  _calcul_Hessian_expr_tree(a, is_expr_tree(a), x)
@inline _calcul_Hessian_expr_tree(a::Any, ::M_trait_expr_tree.Is_not_expr_tree, x::Vector{}) =
  error("ce n'est pas un arbre d'expression")
@inline _calcul_Hessian_expr_tree(a::Any, ::M_trait_expr_tree.Is_expr_tree, x::Vector{}) =
  _calcul_Hessian_expr_tree(a, x)
@inline _calcul_Hessian_expr_tree(expr_tree, x::Vector{}) =
  ForwardDiff.hessian(evaluate_expr_tree(expr_tree), x)

#=-----------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------
Fonction de test pour améliorer
-----------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------=#

# evaluate_expr_tree(a :: Any) = (x :: AbstractVector{} -> evaluate_expr_tree(a,x) )
# evaluate_expr_tree(a :: Any, elmt_var :: Vector{Int}) = (x :: AbstractVector{} -> evaluate_expr_tree(a,view(x,elmt_var) ) )
@inline evaluate_expr_tree2(
  a::M_implementation_expr_tree.Type_expr_tree,
  x::AbstractVector{T},
) where {T <: Number} = _evaluate_expr_tree2(a, M_trait_expr_tree.is_expr_tree(a), x)
@inline _evaluate_expr_tree2(
  a::M_implementation_expr_tree.Type_expr_tree,
  ::M_trait_expr_tree.Is_not_expr_tree,
  x::AbstractVector{T},
) where {T <: Number} = error(" This is not an Expr tree")
@inline _evaluate_expr_tree2(
  a::M_implementation_expr_tree.Type_expr_tree,
  ::M_trait_expr_tree.Is_expr_tree,
  x::AbstractVector{T},
) where {T <: Number} = _evaluate_expr_tree2(a, x)
function _evaluate_expr_tree2(
  expr_tree::M_implementation_expr_tree.Type_expr_tree,
  x::AbstractVector{T},
) where {T <: Number}
  n_children = length(expr_tree.children)
  if n_children == 0
    return M_trait_expr_node._evaluate_node2(expr_tree.field, x)::T
  elseif n_children == 1
    temp = Vector{T}(undef, 1)
    temp[1] = _evaluate_expr_tree2(expr_tree.children[1], x)::T
    return M_trait_expr_node._evaluate_node2(expr_tree.field, temp)::T
  else
    field = expr_tree.field
    return mapreduce(
      y::M_implementation_expr_tree.Type_expr_tree -> _evaluate_expr_tree2(y, x)::T,
      M_trait_expr_node._evaluate_node2(field),
      expr_tree.children::Vector{M_implementation_expr_tree.Type_expr_tree},
    )::T
  end
end

end
