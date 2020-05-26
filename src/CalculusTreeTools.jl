module CalculusTreeTools


include("type_expr/ordered_include.jl")
include("node_expr_tree/ordered_include.jl")
include("tree/ordered_include.jl")
include("expr_tree/ordered_include.jl")

using .algo_expr_tree, .M_evaluation_expr_tree, .trait_expr_tree

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
    element_fun_from_N_to_Ni!(expr_tree, v)
Transform the tree expr_tree, which represent a function from Rⁿ ⇢ R, to an element, function from Rⁱ → R, where i is the length of the vector v .
This function rename the variable of expr_tree to x₁,x₂,... instead of x₇,x₉ for example
element_fun_from_N_to_Ni!( :(x[4] + x[5]), [1,2])
> :(x[1] + x[2])
"""
element_fun_from_N_to_Ni(a :: Any) = algo_expr_tree.element_fun_from_N_to_Ni(a)

"""
    cast_type_of_constant(expr_tree, t)
Cast the constant of the Calculus tree expr_tree to the type t.
"""
cast_type_of_constant(a :: Any ,v :: AbstractVector) = algo_expr_tree.cast_type_of_constant(a, v)



# M_evaluation_expr_tree's functions
"""
    evaluate_expr_tree(t, x)
evaluate the Calculus tree t using the vector x as value for the variables in t.
evaluate_expr_tree(:(x[1] + x[2]), ones(2))
> 2
evaluate_expr_tree(:(x[1] + x[2]), [0,1])
> 1
"""
evaluate_expr_tree(e :: Any, x :: AbstractVector) = M_evaluation_expr_tree.evaluate_expr_tree(e, x)

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


export transform_to_Expr, transform_to_expr_tree
export delete_imbricated_plus, get_type_tree, get_elemental_variable, element_fun_from_N_to_Ni, cast_type_of_constant
export evaluate_expr_tree, calcul_gradient_expr_tree, calcul_Hessian_expr_tree
end # module
