module M_evaluation_expr_tree
# Define multiple ways to evaluate every type of expression tree.

using ForwardDiff, ReverseDiff

using ..M_trait_expr_tree, ..M_trait_expr_node
using ..M_implementation_expr_tree, ..M_implementation_complete_expr_tree
using ..M_abstract_expr_node

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
  if M_trait_expr_node.node_is_operator(
    expr_tree.field::M_trait_expr_node.Abstract_expr_node,
  )::Bool == false
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
    gradient_forward(expr_tree, x)

Evaluate the gradient of the function represented by ``expr_tree` at the point `x`.
"""
@inline gradient_forward(a::Any, x::Vector{}) = _gradient_forward(a, is_expr_tree(a), x)

@inline _gradient_forward(a::Any, ::M_trait_expr_tree.Is_not_expr_tree, x::Vector{}) =
  error("The first argument is not an expression tree")

@inline _gradient_forward(a::Any, ::M_trait_expr_tree.Is_expr_tree, x::Vector{}) =
  _gradient_forward(a, x)

@inline gradient_forward(a::Any, x::Vector{}, elmt_var::Vector{Int}) =
  _gradient_forward(a, is_expr_tree(a), x, elmt_var)

@inline _gradient_forward(
  a::Any,
  ::M_trait_expr_tree.Is_not_expr_tree,
  x::Vector{},
  elmt_var::Vector{Int},
) = error("The first argument is not an expression tree")

@inline _gradient_forward(
  a::Any,
  ::M_trait_expr_tree.Is_expr_tree,
  x::Vector{},
  elmt_var::Vector{Int},
) = _gradient_forward(a, x, elmt_var)

@inline _gradient_forward(expr_tree, x::Vector{T}) where {T <: Number} =
  ForwardDiff.gradient(evaluate_expr_tree(expr_tree), x)

@inline _gradient_forward(expr_tree, x::Vector{}, elmt_var::Vector{Int}) =
  ForwardDiff.gradient(evaluate_expr_tree(expr_tree, elmt_var), x)

@inline gradient_reverse(a::Any, x::Vector{}, elmt_var::Vector{Int}) =
  _gradient_reverse(a, is_expr_tree(a), x, elmt_var)

@inline gradient_reverse(a::Any, x::Vector{}) = _gradient_reverse(a, is_expr_tree(a), x)

@inline _gradient_reverse(a::Any, ::M_trait_expr_tree.Is_not_expr_tree, x::Vector{}) =
  error("The first argument is not an expression tree")

@inline _gradient_reverse(a::Any, ::M_trait_expr_tree.Is_expr_tree, x::Vector{}) =
  _gradient_reverse(a, x)

@inline _gradient_reverse(
  a::Any,
  ::M_trait_expr_tree.Is_not_expr_tree,
  x::Vector{},
  elmt_var::Vector{Int},
) = error("The first argument is not an expression tree")

@inline _gradient_reverse(
  a::Any,
  ::M_trait_expr_tree.Is_expr_tree,
  x::Vector{},
  elmt_var::Vector{Int},
) = _gradient_reverse(a, x, elmt_var)

@inline _gradient_reverse(expr_tree, x::Vector{T}) where {T <: Number} =
  ReverseDiff.gradient(evaluate_expr_tree(expr_tree), x)

@inline _gradient_reverse(expr_tree, x::Vector{}, elmt_var::Vector{Int}) =
  ReverseDiff.gradient(evaluate_element_expr_tree(expr_tree, elmt_var), x)

"""
    hess = hessian(expr_tree, x)
    
Compute the hessian matrix of the function represented by `expr_tree` at the point `x`.
"""
@inline hessian(a::Any, x::Vector{}) = _hessian(a, is_expr_tree(a), x)

@inline _hessian(a::Any, ::M_trait_expr_tree.Is_not_expr_tree, x::Vector{}) =
  error("The first argument is not an expression tree")

@inline _hessian(a::Any, ::M_trait_expr_tree.Is_expr_tree, x::Vector{}) = _hessian(a, x)

@inline _hessian(expr_tree, x::Vector{}) = ForwardDiff.hessian(evaluate_expr_tree(expr_tree), x)

end
