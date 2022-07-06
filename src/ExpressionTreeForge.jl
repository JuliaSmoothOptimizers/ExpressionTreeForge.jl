module ExpressionTreeForge

include("type_expr/ordered_include.jl")
include("node_expr_tree/ordered_include.jl")
include("tree/ordered_include.jl")
include("expr_tree/ordered_include.jl")

using .algo_expr_tree, .M_evaluation_expr_tree, .M_trait_expr_tree, .M_implementation_type_expr
using .algo_tree
using .M_implementation_complete_expr_tree,
  .M_implementation_pre_compiled_tree, .M_implementation_pre_n_compiled_tree
using .M_bound_propagations, .M_convexity_detection

export create_bound_tree, get_bound, set_bounds!
export Complete_expr_tree, re_compiled_tree, Pre_n_compiled_tree, Type_calculus_tree
export concave_type, constant_type, convex_type, linear_type, not_treated_type, unknown_type
export is_concave, is_constant, is_convex, is_linear, is_not_treated, is_treated, is_unknown
export get_convexity_status, set_convexity!, create_convex_tree
export is_constant, is_linear, is_quadratic, is_cubic, is_more_than_quadratic
export transform_to_Expr, transform_to_Expr_julia, transform_to_expr_tree
export delete_imbricated_plus,
  get_type_tree, get_elemental_variable, element_fun_from_N_to_Ni, cast_type_of_constant!
export evaluate_expr_tree, calcul_gradient_expr_tree, calcul_Hessian_expr_tree

"""
    bound_tree = create_bound_tree(tree)

Return a `similar` expression tree to `tree`, where each node correspond to the undefined bounds of the nodes of `tree`.
"""
@inline create_bound_tree(t) = M_bound_propagations.create_bound_tree(t)

"""
    set_bounds!(tree, bound_tree::Bound_tree)
    set_bounds!(complete_tree::Complete_expr_tree)

Set the bounds of `bound_tree` by walking `tree` and propagate the computation from the leaves to the root.
A `Complete_expr_tree` contains a precompiled `bound_tree`, and then can be use alone.
"""
@inline set_bounds!(tree, bound_tree) = M_bound_propagations.set_bounds!(tree, bound_tree)

@inline set_bounds!(complete_tree) = M_bound_propagations.set_bounds!(complete_tree)

"""
    (inf_bound, sup_bound) = get_bound(bound_tree::Bound_tree)

Retrieve the bounds of the root of `bound_tree`, the bounds of expression tree.
"""
@inline get_bound(bound_tree) = M_bound_propagations.get_bound(bound_tree)

@inline create_convex_tree(tree) = M_convexity_detection.create_convex_tree(tree)

@inline set_convexity!(tree, cvx_tree, bound_tree) =
  M_convexity_detection.set_convexity!(tree, cvx_tree, bound_tree)

@inline set_convexity!(complete_tree) = M_convexity_detection.set_convexity!(complete_tree)

@inline get_convexity_status(cvx_tree::M_convexity_detection.Convexity_tree) =
  M_convexity_detection.get_convexity_status(cvx_tree)

@inline get_convexity_status(complete_tree::M_implementation_complete_expr_tree.Complete_expr_tree) =
  M_convexity_detection.get_convexity_status(complete_tree)

@inline constant_type() = M_implementation_convexity_type.constant_type()
@inline linear_type() = M_implementation_convexity_type.linear_type()
@inline convex_type() = M_implementation_convexity_type.convex_type()
@inline concave_type() = M_implementation_convexity_type.concave_type()
@inline unknown_type() = M_implementation_convexity_type.unknown_type()

@inline is_treated(c) = M_implementation_convexity_type.is_treated(c)
@inline is_not_treated(c) = M_implementation_convexity_type.is_not_treated(c)
@inline is_constant(c) = M_implementation_convexity_type.is_constant(c)
@inline is_linear(c) = M_implementation_convexity_type.is_linear(c)
@inline is_convex(c) = M_implementation_convexity_type.is_convex(c)
@inline is_concave(c) = M_implementation_convexity_type.is_concave(c)
@inline is_unknown(c) = M_implementation_convexity_type.is_unknown(c)

Type_expr_tree = M_implementation_expr_tree.Type_expr_tree

@inline create_complete_tree(tree) =
  M_implementation_complete_expr_tree.create_complete_expr_tree(tree)

Complete_expr_tree{T <: Number} = M_implementation_complete_expr_tree.Complete_expr_tree{T}

Pre_compiled_tree{T <: Number} = M_implementation_pre_compiled_tree.Pre_compiled_tree{T}

@inline create_pre_compiled_tree(tree, x) =
  M_implementation_pre_compiled_tree.create_pre_compiled_tree(tree, x)

Pre_n_compiled_tree{T <: Number} = M_implementation_pre_n_compiled_tree.Pre_n_compiled_tree{T}

@inline create_pre_n_compiled_tree(tree, x::Vector{Vector{T}}) where {T <: Number} =
  M_implementation_pre_n_compiled_tree.create_pre_n_compiled_tree(tree, x)

@inline create_pre_n_compiled_tree(
  tree,
  multiple_x_view::Vector{SubArray{T, 1, Array{T, 1}, N, false}},
) where {N} where {T <: Number} =
  M_implementation_pre_n_compiled_tree.create_pre_n_compiled_tree(tree, multiple_x_view)

Type_calculus_tree = M_implementation_type_expr.Type_expr_basic

@inline is_constant(t::Type_calculus_tree) = t == Type_calculus_tree(0)
@inline is_linear(t::Type_calculus_tree) = t == Type_calculus_tree(1)
@inline is_quadratic(t::Type_calculus_tree) = t == Type_calculus_tree(2)
@inline is_cubic(t::Type_calculus_tree) = t == Type_calculus_tree(3)
@inline is_more_than_quadratic(t::Type_calculus_tree) = t == Type_calculus_tree(4)

@inline print_tree(t) = algo_tree.printer_tree(t)
# trait_expr_tree's functions
"""
    expr = transform_to_Expr(expr_tree)

Transform `expr_tree` into an `Expr`.
Warning: This function return an `Expr` with variables as MathOptInterface.VariableIndex.
In order to get an standard `Expr` use `transform_to_Expr_julia`.
"""
@inline transform_to_Expr(e::Any) = M_trait_expr_tree.transform_to_Expr(e::Any)

"""
    expr = transform_to_Expr_julia(expr_tree)

Transform `expr_tree` into an `Expr`.
"""
@inline transform_to_Expr_julia(e::Any) = M_trait_expr_tree.transform_to_Expr2(e::Any)

"""
    expr_tree = transform_to_expr_tree(expr)

Transform `expr` into an `expr_tree::Type_expr_tree`.
"""
@inline transform_to_expr_tree(e::Any) = M_trait_expr_tree.transform_to_expr_tree(e)::Type_expr_tree

"""
    separated_terms = delete_imbricated_plus(expr_tree)

Divide the expression tree as a terms of a sum if possible.
It returns a vector where each component is a sub expression tree of `expr_tree`.

Example:
```julia
julia> delete_imbricated_plus(:(x[1] + x[2] + x[3]*x[4] ) )
[
x[1],
x[2],
x[3] * x[4]
]
```
"""
@inline delete_imbricated_plus(a::Any) = algo_expr_tree.delete_imbricated_plus(a)

"""
    type = get_type_tree(expr_tree)

Return the type of `expr_tree`.
It can either be: `constant`, `linear`, `quadratic`, `cubic` or `more`.

Example:
```julia
julia> get_type_tree(:(5+4)) == constant
true
julia> get_type_tree(:(x[1])) == linear
true
julia> get_type_tree(:(x[1]* x[2])) == quadratic
true
```
"""
@inline get_type_tree(a::Any) = algo_expr_tree.get_type_tree(a)

"""
    indices = get_elemental_variable(expr_tree)

Return the `indices` of the variable appearing in the `expr_tree`.
This function find the elemental variable from the expression tree of an element function.

Example:
```julia
julia> get_elemental_variable(:(x[1] + x[3]) )
[1, 3]
julia> get_elemental_variable(:(x[1]^2 + x[6] + x[2]) )
[1, 6, 2]
```
"""
@inline get_elemental_variable(a::Any) = algo_expr_tree.get_elemental_variable(a)

"""
    Ui = get_Ui(indices::Vector{Int}, n::Int)

Create a sparse matrix `Ui` from `indices` computed by `get_elemental_variable`.
Every index `i` (of `indices`) form a line of `Ui` corresponding to `i`-th Euclidian vector.
"""
@inline get_Ui(indices::Vector{Int}, n::Int) = algo_expr_tree.get_Ui(indices, n)

"""
    element_fun_from_N_to_Ni!(expr_tree, vector_indices)

Change the indices of the variables of `expr_tree` given the order given by `vector_indices`.
It it paired with `get_elemental_variable` to define the elemental element functions.

Example:
```julia
julia> element_fun_from_N_to_Ni!(:(x[4] + x[5]), [4,5])
:(x[1] + x[2])
```
"""
@inline element_fun_from_N_to_Ni!(a::Any, v::AbstractVector{Int}) =
  algo_expr_tree.element_fun_from_N_to_Ni!(a, v)

"""
    cast_type_of_constant(expr_tree, type)

Cast the constant of `expr_tree` to `type`.
"""
@inline cast_type_of_constant(ex::Any, t::DataType) = algo_expr_tree.cast_type_of_constant(ex, t)

"""
    evaluate_expr_tree(expr_tree, x::AbstractVector)

Evaluate the `expr_tree` given the vector `x`.

Example:
```julia
julia> evaluate_expr_tree(:(x[1] + x[2]), ones(2))
2.
```
"""
@inline evaluate_expr_tree(expr_tree::Any, x::AbstractVector{T}) where {T <: Number} =
  M_evaluation_expr_tree.evaluate_expr_tree(expr_tree, x)

@inline evaluate_expr_tree(e::Any, x::AbstractVector) =
  M_evaluation_expr_tree.evaluate_expr_tree(e, x)

@inline evaluate_expr_tree(e::Any) = (x::AbstractVector{} -> evaluate_expr_tree(e, x))

@inline evaluate_expr_tree_multiple_points(e::Any, x::AbstractVector) =
  M_evaluation_expr_tree.evaluate_expr_tree_multiple_points(e, x)

@inline evaluate_expr_tree_multiple_points(e::Any) =
  M_implementation_pre_n_compiled_tree.evaluate_pre_n_compiled_tree(e)

"""
    gradient = calcul_gradient_expr_tree(expr_tree, x)

Evaluate the `gradient` of `expr_tree` at the point `x`.

Example:
```julia
julia> calcul_gradient_expr_tree(:(x[1] + x[2]), rand(2))
[1.0 1.0]
```
"""
@inline calcul_gradient_expr_tree(e::Any, x::AbstractVector) =
  M_evaluation_expr_tree.calcul_gradient_expr_tree(e, x)

"""
    gradient = calcul_gradient_expr_tree_reverse(expr_tree, x)

Evaluate the `gradient` of `expr_tree` at the point `x`.

Example:
julia> calcul_gradient_expr_tree_reverse(:(x[1] + x[2]), rand(2))
[1.0 1.0]
"""
@inline calcul_gradient_expr_tree_reverse(e::Any, x::AbstractVector) =
  M_evaluation_expr_tree.calcul_gradient_expr_tree2(e, x)

"""
    hessian = calcul_Hessian_expr_tree(expr_tree, x)

Evaluate the Hessian of `expr_tree` at the point x.

Example:
```julia
julia> calcul_Hessian_expr_tree(:(x[1]^2 + x[2]), rand(2))
[2.0 0.0; 0.0 0.0]
```
"""
@inline calcul_Hessian_expr_tree(e::Any, x::AbstractVector) =
  M_evaluation_expr_tree.calcul_Hessian_expr_tree(e, x)

"""
    get_function_of_evaluation(ex)

Return a evaluation function of ex with better performance than the actual evaluate_expr_tree.
"""
@inline get_function_of_evaluation(ex::M_implementation_expr_tree.Type_expr_tree) =
  algo_expr_tree.get_function_of_evaluation(ex)

end
