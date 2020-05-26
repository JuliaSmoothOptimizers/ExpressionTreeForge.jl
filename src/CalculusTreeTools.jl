module CalculusTreeTools

"""
    greet()
Test de la documentation
"""
greet() = print("Hello World!")


"""
    return2()
Test function that return 2
"""
return2() = 2


include("type_expr/ordered_include.jl")
include("node_expr_tree/ordered_include.jl")
include("tree/ordered_include.jl")
include("expr_tree/ordered_include.jl")

using .algo_expr_tree, .M_evaluation_expr_tree, .trait_expr_tree

# Fonction trait_expr_tree
transform_to_Expr(e :: Any) = trait_expr_tree.transform_to_Expr(e :: Any)
transform_to_expr_tree(e :: Any) = trait_expr_tree.transform_to_expr_tree(e)

#Fonction de algo_expr_tree
delete_imbricated_plus(a :: Any) = algo_expr_tree.delete_imbricated_plus(a)
get_type_tree(a :: Any) =  algo_expr_tree.get_type_tree(a)
get_elemental_variable(a :: Any) = algo_expr_tree.get_elemental_variable(a)
element_fun_from_N_to_Ni(a :: Any) = algo_expr_tree.element_fun_from_N_to_Ni(a)
cast_type_of_constant(a :: Any ,v :: AbstractVector) = algo_expr_tree.cast_type_of_constant(a, v)

#fonction de M_evaluation_expr_tree
evaluate_expr_tree(e :: Any, x :: AbstractVector) = M_evaluation_expr_tree.evaluate_expr_tree(e, x)
calcul_gradient_expr_tree(e :: Any, x :: AbstractVector) = M_evaluation_expr_tree.calcul_gradient_expr_tree(e, x)
calcul_gradient_expr_tree2(e :: Any, x :: AbstractVector) = M_evaluation_expr_tree.calcul_gradient_expr_tree2(e, x)
calcul_Hessian_expr_tree(e :: Any, x :: AbstractVector) = M_evaluation_expr_tree.calcul_Hessian_expr_tree(e,x)

export delete_imbricated_plus, get_type_tree, get_elemental_variable, element_fun_from_N_to_Ni, cast_type_of_constant, transform_to_Expr

end # module
