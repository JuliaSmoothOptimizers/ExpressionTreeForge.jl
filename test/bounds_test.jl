using CalculusTreeTools
using JuMP, MathOptInterface


e1 = :(x[1] + x[2])
et1 = CalculusTreeTools.transform_to_expr_tree(e1)




m = Model()
n = 1000
@variable(m, x[1:n])
@NLobjective(m, Min, sum( x[j] * x[j+1] for j in 1:n-1 ) + (sin(x[1]))^2 + x[n-1]^3  + 5 )
evaluator = JuMP.NLPEvaluator(m)
MathOptInterface.initialize(evaluator, [:ExprGraph])
Expr_j = MathOptInterface.objective_expr(evaluator)
expr_tree_j = CalculusTreeTools.transform_to_expr_tree(Expr_j)
