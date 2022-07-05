using ModelingToolkit
using ExpressionTreeForge
using ADNLPModels

# include("test\\script_dvpt\\modelingTKfunctions.jl")
n = 4

"Arrow head model in size `n`"
function arwhead(x::AbstractVector{Y}) where {Y <: Number}
  n = length(x)
  n < 2 && @warn("arwhead: number of variables must be ≥ 2")
  n = max(2, n)

  return sum((x[i]^2 + x[n]^2)^2 - 4 * x[i] + 3 for i = 1:(n - 1))
end

function cragglvy(x::AbstractVector{Y}) where {Y <: Number}
  n = length(x)
  n < 2 && @warn("cragglvy: number of variables must be ≥ 2")
  n = max(2, n)

  return sum(
    (exp(x[2 * i - 1]) - x[2 * i])^4 +
    100 * (x[2 * i] - x[2 * i + 1])^6 +
    (tan(x[2 * i + 1] - x[2 * i + 2]) + x[2 * i + 1] - x[2 * i + 2])^4 +
    x[2 * i - 1]^8 +
    (x[2 * i + 2] - 1)^2 for i = 1:(div(n, 2) - 1)
  )
end

function chainwoo(x::AbstractVector{Y}) where {Y <: Number}
  n = length(x)
  (n % 4 == 0) || @warn("chainwoo: number of variables adjusted to be a multiple of 4")
  n = 4 * max(1, div(n, 4))

  1.0 + sum(
    100 * (x[2 * i] - x[2 * i - 1]^2)^2 +
    (1 - x[2 * i - 1])^2 +
    90 * (x[2 * i + 2] - x[2 * i + 1]^2)^2 +
    (1 - x[2 * i + 1])^2 +
    10 * (x[2 * i] + x[2 * i + 2] - 2)^2 +
    0.1 * (x[2 * i] - x[2 * i + 2])^2 for i = 1:(div(n, 2) - 1)
  )
end

function nondquar(x::AbstractVector{Y}) where {Y <: Number}
  n = length(x)
  n < 2 && @warn("nondquar: number of variables must be ≥ 2")
  n = max(2, n)

  (x[1] - x[2])^2 + (x[n - 1] - x[n])^2 + sum((x[i] + x[i + 1] + x[n])^4 for i = 1:(n - 2))
end

function srosenbr(x::AbstractVector{Y}) where {Y <: Number}
  n = length(x)
  (n % 2 == 0) || @warn("srosenbr: number of variables adjusted to be even")
  n = 2 * max(1, div(n, 2))

  sum(100.0 * (x[2 * i] - x[2 * i - 1]^2)^2 + (x[2 * i - 1] - 1.0)^2 for i = 1:div(n, 2))
end

f(x) = tan(x[1]) + (sin(x[2]) * cos(x[3]))^2 + exp(x[4] / 2)^2 + 5
@variables x[1:5]
tmp = f(x)

function produce_complete_tree_from_julia_function(f, n)
  @variables x[1:n]
  tmp = f(x)
  ex = ExpressionTreeForge.transform_to_expr_tree(tmp)
  ExpressionTreeForge.print_tree(ex)
  complete_ex = ExpressionTreeForge.create_complete_tree(ex)
  ExpressionTreeForge.set_convexity!(complete_ex)
  ExpressionTreeForge.get_convexity_status(complete_ex)
  ExpressionTreeForge.set_bounds!(complete_ex)
  ExpressionTreeForge.get_bound(complete_ex)

  return ex, complete_ex
end

(tmp_tree, tmp_ctree) = produce_complete_tree_from_julia_function(f, n)

(arwhead_tree, arwhead_ctree) = produce_complete_tree_from_julia_function(arwhead, n)
ExpressionTreeForge.print_tree(arwhead_tree)

(cragglvy_tree, cragglvy_ctree) = produce_complete_tree_from_julia_function(cragglvy, n)
ExpressionTreeForge.print_tree(cragglvy_tree)

(chainwoo_tree, chainwoo_ctree) = produce_complete_tree_from_julia_function(chainwoo, n)
ExpressionTreeForge.print_tree(chainwoo_tree)

(srosenbr_tree, srosenbr_ctree) = produce_complete_tree_from_julia_function(srosenbr, n)
ExpressionTreeForge.print_tree(srosenbr_tree)

(nondquar_tree, nondquar_ctree) = produce_complete_tree_from_julia_function(nondquar, n)
ExpressionTreeForge.print_tree(nondquar_tree)
