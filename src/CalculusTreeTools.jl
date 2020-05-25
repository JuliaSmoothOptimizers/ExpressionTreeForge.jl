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


using .CalculusTreeTools
using JuMP, MathOptInterface, BenchmarkTools



# 
# e1 = :(x[1] + x[2])
# et1 = CalculusTreeTools.transform_to_expr_tree(e1)
# # @show et1
# x = ones(2)
# res_e1 = CalculusTreeTools.evaluate_expr_tree(e1, x)
# res_et1 = CalculusTreeTools.evaluate_expr_tree(et1, x)
# @show res_e1, res_et1
# res_grad_e1 = CalculusTreeTools.calcul_gradient_expr_tree(e1,x)
# res_grad_et1 = CalculusTreeTools.calcul_gradient_expr_tree(et1,x)
# @show res_grad_e1, res_grad_et1
#
#
# m = Model()
# n = 1000
# @variable(m, x[1:n])
# @NLobjective(m, Min, sum( x[j] * x[j+1] for j in 1:n-1 ) + (sin(x[1]))^2 + x[n-1]^3  + 5 )
# eval_test = JuMP.NLPEvaluator(m)
# MathOptInterface.initialize(eval_test, [:ExprGraph])
# obj = MathOptInterface.objective_expr(eval_test)
# t_obj = CalculusTreeTools.transform_to_expr_tree(obj)
# type_obj = CalculusTreeTools.get_type_tree(obj)
# type_tobj = CalculusTreeTools.get_type_tree(t_obj)
# @show type_obj, type_tobj
#
# x = ones(n)
#
# # @show @benchmark CalculusTreeTools.get_type_tree(obj)
# # @show @benchmark CalculusTreeTools.get_type_tree(t_obj)
# b_eval1 = @benchmark CalculusTreeTools.evaluate_expr_tree(obj, x)
# b_eval2 = @benchmark CalculusTreeTools.evaluate_expr_tree(t_obj, x)
