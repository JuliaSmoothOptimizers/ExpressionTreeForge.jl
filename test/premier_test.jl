using JuMP, MathOptInterface

# using BenchmarkTools




e1 = :(x[1] + x[2])
et1 = CalculusTreeTools.transform_to_expr_tree(e1)
# @show et1
x = ones(2)
res_e1 = CalculusTreeTools.evaluate_expr_tree(e1, x)
res_et1 = CalculusTreeTools.evaluate_expr_tree(et1, x)
@test res_e1 == res_et1
res_grad_e1 = CalculusTreeTools.calcul_gradient_expr_tree(e1,x)
res_grad_et1 = CalculusTreeTools.calcul_gradient_expr_tree(et1,x)
@test res_grad_e1 == res_grad_et1
type_e1 = CalculusTreeTools.get_type_tree(e1)
type_et1 = CalculusTreeTools.get_type_tree(et1)
@test type_e1 == type_et1


m = Model()
n = 1000
@variable(m, x[1:n])
@NLobjective(m, Min, sum( x[j] * x[j+1] for j in 1:n-1 ) + (sin(x[1]))^2 + x[n-1]^3  + 5 )
evaluator = JuMP.NLPEvaluator(m)
MathOptInterface.initialize(evaluator, [:ExprGraph])
Expr_j = MathOptInterface.objective_expr(evaluator)
expr_tree_j = CalculusTreeTools.transform_to_expr_tree(Expr_j)

x = ones(n)
res_obj_Expr = CalculusTreeTools.evaluate_expr_tree(expr_tree_j, x)
res_obj_expr_tree = CalculusTreeTools.evaluate_expr_tree(Expr_j, x)
res_obj_jump = MathOptInterface.eval_objective( evaluator, x)
@test res_obj_Expr == res_obj_expr_tree && res_obj_expr_tree == res_obj_jump

# b_eval1 = @benchmark CalculusTreeTools.evaluate_expr_tree(obj, x)
# b_eval2 = @benchmark CalculusTreeTools.evaluate_expr_tree(t_obj, x)
