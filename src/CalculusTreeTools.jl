module CalculusTreeTools

using Revise

include("type_expr/ordered_include.jl")
include("node_expr_tree/ordered_include.jl")
include("tree/ordered_include.jl")
include("expr_tree/ordered_include.jl")

using .algo_expr_tree, .M_evaluation_expr_tree, .trait_expr_tree, .implementation_type_expr
using .algo_tree
using .implementation_complete_expr_tree

using .bound_propagations
using .convexity_detection


create_bound_tree(t) = bound_propagations.create_bound_tree(t)
set_bounds!(tree, bound_tree) = bound_propagations.set_bounds!(tree, bound_tree)
set_bounds!(tree) = bound_propagations.set_bounds!(tree)
get_bound(bound_tree) = bound_propagations.get_bound(bound_tree)

create_convex_tree(tree) = convexity_detection.create_convex_tree(tree)
set_convexity!(tree, cvx_tree, bound_tree) = convexity_detection.set_convexity!(tree, cvx_tree, bound_tree)
set_convexity!(complete_tree) = convexity_detection.set_convexity!(complete_tree)
get_convexity_status(cvx_tree :: convexity_detection.convexity_tree) = convexity_detection.get_convexity_status(cvx_tree)
get_convexity_status(complete_tree :: implementation_complete_expr_tree.complete_expr_tree) = convexity_detection.get_convexity_status(complete_tree)
constant_type() = convexity_detection.constant_type()
linear_type() = convexity_detection.linear_type()
convex_type() = convexity_detection.convex_type()
concave_type() = convexity_detection.concave_type()
unknown_type() = convexity_detection.unknown_type()




create_complete_tree(tree) = implementation_complete_expr_tree.create_complete_expr_tree(tree)



type_calculus_tree = implementation_type_expr.t_type_expr_basic
is_constant(t :: type_calculus_tree) = t == type_calculus_tree(0)
is_linear(t :: type_calculus_tree) = t == type_calculus_tree(1)
is_quadratic(t :: type_calculus_tree) = t == type_calculus_tree(2)
is_cubic(t :: type_calculus_tree) = t == type_calculus_tree(3)
is_more_than_quadratic(t :: type_calculus_tree) = t == type_calculus_tree(4)

print_tree(t) = algo_tree.printer_tree(t)
# trait_expr_tree's functions
"""
    transform_to_Expr(expr_tree)
Transform into an Expr the parameter expr_tree if expr_tree satisfies the trait define in trait_expr_tree
"""
transform_to_Expr(e :: Any) = trait_expr_tree.transform_to_Expr(e :: Any)

"""
    transform_to_expr_tree(Expr)
Transform into an expr_tree the parameter Expr if expr_tree satisfies the trait define in trait_expr_tree
"""
transform_to_expr_tree(e :: Any) = trait_expr_tree.transform_to_expr_tree(e)




# algo_expr_tree's functions
"""
    delete_imbricated_plus(e)
If e represent a calculus tree, delete_imbricated_plus(e) will split that function into element function if it is possible.
concretely if divides the tree into subtrees as long as top nodes are + or -

delete_imbricated_plus(:(x[1] + x[2] + x[3]*x[4] ) )
[
x[1],
x[2],
x[3] * x[4]
]
"""
delete_imbricated_plus(a :: Any) = algo_expr_tree.delete_imbricated_plus(a)

"""
    get_type_tree(t)
Return the type of the expression tree t, whose the types are defined in type_expr/impl_type_expr.jl

get_type_tree( :(5+4)) = constant
get_type_tree( :(x[1])) = linear
get_type_tree( :(x[1]* x[2])) = quadratic

"""
get_type_tree(a :: Any) =  algo_expr_tree.get_type_tree(a)

"""
    get_elemental_variable(expr_tree)
Return the index of the variable appearing in the expression tree
get_elemental_variable( :(x[1] + x[3]) )
> [1, 3]
get_elemental_variable( :(x[1]^2 + x[6] + x[2]) )
> [1, 6, 2]
"""
get_elemental_variable(a :: Any) = algo_expr_tree.get_elemental_variable(a)

"""
    get_Ui(index_new_var, n)
Create a the matrix U associated to the variable appearing in index_new_var.
This function create a sparse matrix of size length(index_new_var)×n.
"""
get_Ui(a :: Vector{Int}, n :: Int) = algo_expr_tree.get_Ui(a,n)


"""
    element_fun_from_N_to_Ni!(expr_tree, v)
Transform the tree expr_tree, which represent a function from Rⁿ ⇢ R, to an element, function from Rⁱ → R, where i is the length of the vector v .
This function rename the variable of expr_tree to x₁,x₂,... instead of x₇,x₉ for example
element_fun_from_N_to_Ni!( :(x[4] + x[5]), [1,2])
> :(x[1] + x[2])
"""
element_fun_from_N_to_Ni!(a :: Any, v :: AbstractVector{Int}) = algo_expr_tree.element_fun_from_N_to_Ni!(a, v)

"""
    cast_type_of_constant(expr_tree, t)
Cast the constant of the Calculus tree expr_tree to the type t.
"""
cast_type_of_constant(ex :: Any ,t :: DataType) = algo_expr_tree.cast_type_of_constant!(ex, t)



# M_evaluation_expr_tree's functions
"""
    evaluate_expr_tree(t, x)
evaluate the Calculus tree t using the vector x as value for the variables in t.
evaluate_expr_tree(:(x[1] + x[2]), ones(2))
> 2
evaluate_expr_tree(:(x[1] + x[2]), [0,1])
> 1
"""
evaluate_expr_tree(e :: Any, x :: AbstractVector{T}) where T <: Number  = M_evaluation_expr_tree.evaluate_expr_tree(e, x) :: T
evaluate_expr_tree(e :: Any) = (x :: AbstractVector{} -> evaluate_expr_tree(e,x) )



"""
    calcul_gradient_expr_tree(t, x)
Evaluate the gradient of the calculus tree t as the point x
calcul_gradient_expr_tree( :(x[1] + x[2]), ones(2))
>[1.0 1.0]
"""
calcul_gradient_expr_tree(e :: Any, x :: AbstractVector) = M_evaluation_expr_tree.calcul_gradient_expr_tree(e, x)


"""
    calcul_gradient_expr_tree2(t, x)
Evaluate the gradient of the calculus tree t as the point x
calcul_gradient_expr_tree2( :(x[1] + x[2]), ones(2))
>[1.0 1.0]
"""
calcul_gradient_expr_tree2(e :: Any, x :: AbstractVector) = M_evaluation_expr_tree.calcul_gradient_expr_tree2(e, x)


"""
    calcul_Hessian_expr_tree(t, x)
Evaluate the Hessian of the calculus tree t as the point x
calcul_Hessian_expr_tree( :(x[1]^2 + x[2]), ones(2))
>[2.0 0.0; 0.0 0.0]
"""
calcul_Hessian_expr_tree(e :: Any, x :: AbstractVector) = M_evaluation_expr_tree.calcul_Hessian_expr_tree(e,x)


export type_calculus_tree, is_constant, is_linear, is_quadratic, is_cubic, is_more_than_quadratic

export transform_to_Expr, transform_to_expr_tree
export delete_imbricated_plus, get_type_tree, get_elemental_variable, element_fun_from_N_to_Ni, cast_type_of_constant!
export evaluate_expr_tree, calcul_gradient_expr_tree, calcul_Hessian_expr_tree
end # module
