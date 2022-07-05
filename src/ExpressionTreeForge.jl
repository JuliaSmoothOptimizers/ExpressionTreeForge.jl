module ExpressionTreeForge

include("type_expr/ordered_include.jl")
include("node_expr_tree/ordered_include.jl")
include("tree/ordered_include.jl")
include("expr_tree/ordered_include.jl")

using .algo_expr_tree, .M_evaluation_expr_tree, .M_trait_expr_tree, .M_implementation_type_expr
using .algo_tree
using .implementation_complete_expr_tree,
  .implementation_pre_compiled_tree, .implementation_pre_n_compiled_tree
using .bound_propagations, .M_convexity_detection

export create_bound_tree, get_bound, set_bounds!
export complete_expr_tree, pre_compiled_tree, pre_n_compiled_tree, type_calculus_tree
export concave_type, constant_type, convex_type, linear_type, not_treated_type, unknown_type
export is_concave, is_constant, is_convex, is_linear, is_not_treated, is_treated, is_unknown
export get_convexity_status, set_convexity!, create_convex_tree
export is_constant, is_linear, is_quadratic, is_cubic, is_more_than_quadratic
export transform_to_Expr, transform_to_Expr_julia, transform_to_expr_tree
export delete_imbricated_plus,
  get_type_tree, get_elemental_variable, element_fun_from_N_to_Ni, cast_type_of_constant!
export evaluate_expr_tree, calcul_gradient_expr_tree, calcul_Hessian_expr_tree

@inline create_bound_tree(t) = bound_propagations.create_bound_tree(t)

@inline set_bounds!(tree, bound_tree) = bound_propagations.set_bounds!(tree, bound_tree)

@inline set_bounds!(tree) = bound_propagations.set_bounds!(tree)

@inline get_bound(bound_tree) = bound_propagations.get_bound(bound_tree)

convexity_wrapper = M_implementation_convexity_type.Convexity_wrapper

@inline get_convexity_wrapper(t::M_implementation_convexity_type.Convexity_wrapper) =
  M_implementation_convexity_type.get_convexity_wrapper(t)

@inline set_convexity_wrapper!(
  cw::M_implementation_convexity_type.Convexity_wrapper,
  typ::M_implementation_convexity_type.Convexity_type,
) = M_implementation_convexity_type.set_convexity_wrapper!(cw, typ)

@inline create_convex_tree(tree) = M_convexity_detection.create_convex_tree(tree)

@inline set_convexity!(tree, cvx_tree, bound_tree) =
  M_convexity_detection.set_convexity!(tree, cvx_tree, bound_tree)

@inline set_convexity!(complete_tree) = M_convexity_detection.set_convexity!(complete_tree)

@inline get_convexity_status(cvx_tree::M_convexity_detection.Convexity_tree) =
  M_convexity_detection.get_convexity_status(cvx_tree)

@inline get_convexity_status(complete_tree::implementation_complete_expr_tree.complete_expr_tree) =
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

t_expr_tree = implementation_expr_tree.t_expr_tree

@inline create_complete_tree(tree) =
  implementation_complete_expr_tree.create_complete_expr_tree(tree)

complete_expr_tree{T <: Number} = implementation_complete_expr_tree.complete_expr_tree{T}

pre_compiled_tree{T <: Number} = implementation_pre_compiled_tree.pre_compiled_tree{T}

@inline create_pre_compiled_tree(tree, x) =
  implementation_pre_compiled_tree.create_pre_compiled_tree(tree, x)

pre_n_compiled_tree{T <: Number} = implementation_pre_n_compiled_tree.pre_n_compiled_tree{T}

@inline create_pre_n_compiled_tree(tree, x::Vector{Vector{T}}) where {T <: Number} =
  implementation_pre_n_compiled_tree.create_pre_n_compiled_tree(tree, x)

@inline create_pre_n_compiled_tree(
  tree,
  multiple_x_view::Vector{SubArray{T, 1, Array{T, 1}, N, false}},
) where {N} where {T <: Number} =
  implementation_pre_n_compiled_tree.create_pre_n_compiled_tree(tree, multiple_x_view)

type_calculus_tree = M_implementation_type_expr.Type_expr_basic

@inline is_constant(t::type_calculus_tree) = t == type_calculus_tree(0)
@inline is_linear(t::type_calculus_tree) = t == type_calculus_tree(1)
@inline is_quadratic(t::type_calculus_tree) = t == type_calculus_tree(2)
@inline is_cubic(t::type_calculus_tree) = t == type_calculus_tree(3)
@inline is_more_than_quadratic(t::type_calculus_tree) = t == type_calculus_tree(4)

@inline print_tree(t) = algo_tree.printer_tree(t)
# trait_expr_tree's functions
"""
    transform_to_Expr(expr_tree)

Transform into an Expr the parameter expr_tree if expr_tree satisfies the trait defined in M_trait_expr_tree.
ATTENTION: This function return an Expr with variable as MathOptInterface.VariableIndex
In order to get an standard Expr use transform_to_Expr_julia.
"""
@inline transform_to_Expr(e::Any) = M_trait_expr_tree.transform_to_Expr(e::Any)

"""
    transform_to_Expr_julia(expr_tree)

Transform into an Expr the parameter expr_tree if expr_tree satisfies the trait define in M_trait_expr_tree.
"""
@inline transform_to_Expr_julia(e::Any) = M_trait_expr_tree.transform_to_Expr2(e::Any)

"""
    transform_to_expr_tree(Expr)

Transform into an expr_tree the parameter Expr if expr_tree satisfies the trait define in M_trait_expr_tree
"""
@inline transform_to_expr_tree(e::Any) = M_trait_expr_tree.transform_to_expr_tree(e)::t_expr_tree

"""
    delete_imbricated_plus(e)

If e represent a calculus tree, delete_imbricated_plus(e) will split that function into element function if it is possible.
concretely if divides the tree into subtrees as long as top nodes are + or -

Example:
julia> delete_imbricated_plus(:(x[1] + x[2] + x[3]*x[4] ) )
[
x[1],
x[2],
x[3] * x[4]
]
"""
@inline delete_imbricated_plus(a::Any) = algo_expr_tree.delete_imbricated_plus(a)

"""
    get_type_tree(t)

Return the type of the expression tree t, whose the types are defined in type_expr/impl_type_expr.jl

Example:
julia> get_type_tree(:(5+4)) == constant
true
julia> get_type_tree(:(x[1])) == linear
true
julia> get_type_tree(:(x[1]* x[2])) == quadratic
true
"""
@inline get_type_tree(a::Any) = algo_expr_tree.get_type_tree(a)

"""
    get_elemental_variable(expr_tree)

Return the index of the variable appearing in the expression tree.

Example:
julia> get_elemental_variable(:(x[1] + x[3]) )
[1, 3]
julia> get_elemental_variable(:(x[1]^2 + x[6] + x[2]) )
[1, 6, 2]
"""
@inline get_elemental_variable(a::Any) = algo_expr_tree.get_elemental_variable(a)

"""
    get_Ui(index_new_var, n)

Create a the matrix U associated to the variable appearing in index_new_var.
This function create a sparse matrix of size length(index_new_var)×n.
"""
@inline get_Ui(a::Vector{Int}, n::Int) = algo_expr_tree.get_Ui(a, n)

"""
    element_fun_from_N_to_Ni!(expr_tree, v)

Transform the tree expr_tree, which represent a function from Rⁿ ⇢ R, to an element, function from Rⁱ → R, where i is the length of the vector v .
This function rename the variable of expr_tree to x₁,x₂,... instead of x₇,x₉ for example
element_fun_from_N_to_Ni!(:(x[4] + x[5]), [1,2])
> :(x[1] + x[2])
"""
@inline element_fun_from_N_to_Ni!(a::Any, v::AbstractVector{Int}) =
  algo_expr_tree.element_fun_from_N_to_Ni!(a, v)

"""
    cast_type_of_constant(expr_tree, t)

Cast the constant of the Calculus tree expr_tree to the type t.
"""
@inline cast_type_of_constant(ex::Any, t::DataType) = algo_expr_tree.cast_type_of_constant(ex, t)

# M_evaluation_expr_tree's functions
"""
    evaluate_expr_tree(t, x)

Evaluate the Calculus tree t given the vector x, the value of the variables in t.

Example:
julia> evaluate_expr_tree(:(x[1] + x[2]), ones(2))
2
julia> evaluate_expr_tree(:(x[1] + x[2]), [0,1])
1
"""
@inline evaluate_expr_tree(e::Any, x::AbstractVector{T}) where {T <: Number} =
  M_evaluation_expr_tree.evaluate_expr_tree(e, x)

@inline evaluate_expr_tree(e::Any, x::AbstractVector) =
  M_evaluation_expr_tree.evaluate_expr_tree(e, x)

@inline evaluate_expr_tree(e::Any, x::AbstractArray) =
  M_evaluation_expr_tree.evaluate_expr_tree(e, x)

@inline evaluate_expr_tree(e::Any) = (x::AbstractVector{} -> evaluate_expr_tree(e, x))

@inline evaluate_expr_tree_multiple_points(e::Any, x::AbstractVector) =
  M_evaluation_expr_tree.evaluate_expr_tree_multiple_points(e, x)

@inline evaluate_expr_tree_multiple_points(e::Any) =
  implementation_pre_n_compiled_tree.evaluate_pre_n_compiled_tree(e)

"""
    calcul_gradient_expr_tree(t, x)

Evaluate the gradient of the calculus tree t as the point x

Example:
julia> calcul_gradient_expr_tree(:(x[1] + x[2]), rand(2))
[1.0 1.0]
"""
@inline calcul_gradient_expr_tree(e::Any, x::AbstractVector) =
  M_evaluation_expr_tree.calcul_gradient_expr_tree(e, x)

"""
    calcul_gradient_expr_tree2(t, x)

Evaluate the gradient of the calculus tree t as the point x.

Example:
julia> calcul_gradient_expr_tree2(:(x[1] + x[2]), rand(2))
[1.0 1.0]
"""
@inline calcul_gradient_expr_tree2(e::Any, x::AbstractVector) =
  M_evaluation_expr_tree.calcul_gradient_expr_tree2(e, x)

"""
    calcul_Hessian_expr_tree(t, x)

Evaluate the Hessian of the calculus tree t as the point x.

julia> calcul_Hessian_expr_tree(:(x[1]^2 + x[2]), rand(2))
[2.0 0.0; 0.0 0.0]
"""
@inline calcul_Hessian_expr_tree(e::Any, x::AbstractVector) =
  M_evaluation_expr_tree.calcul_Hessian_expr_tree(e, x)

"""
    get_function_of_evaluation(ex)

Return a evaluation function of ex with better performance than the actual evaluate_expr_tree.
"""
@inline get_function_of_evaluation(ex::implementation_expr_tree.t_expr_tree) =
  algo_expr_tree.get_function_of_evaluation(ex)

end
