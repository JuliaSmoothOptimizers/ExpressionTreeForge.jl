using ..ExpressionTreeForge.M_trait_expr_tree

@testset "Algorithm tests" begin
  m = Model()
  n = 4
  @variable(m, x[1:n])
  @NLobjective(m, Min, (x[1] * x[3] + 5)^2 + sin(x[2] + cos(x[3])) + (-1 + x[4])^2)

  evaluator = JuMP.NLPEvaluator(m)
  MathOptInterface.initialize(evaluator, [:ExprGraph, :Hess])

  v = ones(n)
  Expr_j = MathOptInterface.objective_expr(evaluator)
  expr_tree = ExpressionTreeForge.transform_to_expr_tree(Expr_j)
  expr_tree_j = copy(expr_tree)
  @test ExpressionTreeForge.M_trait_expr_tree.expr_tree_equal(expr_tree, expr_tree_j)

  complete_tree = ExpressionTreeForge.complete_tree(expr_tree_j)

  element_functions = extract_element_functions(expr_tree_j)
  element_variables = get_elemental_variables.(element_functions)

  ExpressionTreeForge.M_algo_expr_tree.get_Ui([1,3], n)

  map((fun, var) -> normalize_indices!(fun, var), element_functions, element_variables)
  @test ExpressionTreeForge.M_trait_expr_tree.expr_tree_equal(expr_tree, expr_tree_j) == false
end

@testset "MOI.Nonlinear.Model from trees" begin
  expr = :(5*x[3] + 3*x[1] + 4*x[4]^2 + 3)
  expr_tree = transform_to_expr_tree(expr)
  complete_expr_tree = complete_tree(expr_tree)

  transform_to_Expr_JuMP(expr)

  evaluator_expr = non_linear_JuMP_model_evaluator(expr)
  evaluator_expr_tree = non_linear_JuMP_model_evaluator(expr_tree)
  evaluator_complete_tree = non_linear_JuMP_model_evaluator(complete_expr_tree)

  x= Float64[0,1,2]
  @test MOI.eval_objective(evaluator_expr, x) == 24
  @test MOI.eval_objective(evaluator_expr_tree, x) == 24
  @test MOI.eval_objective(evaluator_complete_tree, x) == 24

  grad_expr = similar(x)
  grad_expr_tree = similar(x)
  grad_complete_tree = similar(x)

  MOI.eval_objective_gradient(evaluator_expr, grad_expr, x)
  MOI.eval_objective_gradient(evaluator_expr_tree, grad_expr_tree, x)
  MOI.eval_objective_gradient(evaluator_complete_tree, grad_complete_tree, x)
  grad_sol = Float64[3,5,16]

  @test grad_expr == grad_sol
  @test grad_expr_tree == grad_sol
  @test grad_complete_tree == grad_sol
end