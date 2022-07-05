@testset "premiers tests" begin
  e1 = :(x[1] + x[2])
  et1 = ExpressionTreeForge.transform_to_expr_tree(e1)
  x = ones(2)
  res_e1 = ExpressionTreeForge.evaluate_expr_tree(e1, x)
  res_et1 = ExpressionTreeForge.evaluate_expr_tree(et1, x)
  res_grad_e1 = ExpressionTreeForge.calcul_gradient_expr_tree(e1, x)
  res_grad_et1 = ExpressionTreeForge.calcul_gradient_expr_tree(et1, x)
  type_e1 = ExpressionTreeForge.get_type_tree(e1)
  type_et1 = ExpressionTreeForge.get_type_tree(et1)
  @test res_e1 == res_et1
  @test res_grad_e1 == res_grad_et1
  @test type_e1 == type_et1
  @test ExpressionTreeForge.is_linear(type_e1)
  @test ExpressionTreeForge.is_constant(type_e1) == false

  m = Model()
  n = 10
  @variable(m, x[1:n])
  @NLobjective(m, Min, sum(x[j] * x[j + 1] for j = 1:(n - 1)) + (sin(x[1]))^2 + x[n - 1]^3 + 5)
  evaluator = JuMP.NLPEvaluator(m)
  MathOptInterface.initialize(evaluator, [:ExprGraph])
  Expr_j = MathOptInterface.objective_expr(evaluator)
  expr_tree_j = ExpressionTreeForge.transform_to_expr_tree(Expr_j)

  x = ones(n)
  res_obj_Expr = ExpressionTreeForge.evaluate_expr_tree(expr_tree_j, x)
  res_obj_expr_tree = ExpressionTreeForge.evaluate_expr_tree(Expr_j, x)
  res_obj_jump = MathOptInterface.eval_objective(evaluator, x)
  @test res_obj_Expr == res_obj_expr_tree && res_obj_expr_tree == res_obj_jump
end
