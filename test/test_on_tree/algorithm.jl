@testset "" begin
  m = Model()
  n = 5
  @variable(m, x[1:n])
  @NLobjective(m, Min, (x[1]*x[3]+5)^2 + x[2] + x[3] + x[4])

  evaluator = JuMP.NLPEvaluator(m)
  MathOptInterface.initialize(evaluator, [:ExprGraph, :Hess])

  v = ones(n)
  Expr_j = MathOptInterface.objective_expr(evaluator)
  expr_tree = ExpressionTreeForge.transform_to_expr_tree(Expr_j)
  expr_tree_j = copy(expr_tree)
  complete_tree = ExpressionTreeForge.create_complete_tree(expr_tree_j)

end

