@testset "égalité obj" begin
  m = Model()
  n = 100
  @variable(m, x[1:n])
  @NLobjective(
    m,
    Min,
    sum(
      (x[j] + tan(x[j + 1]))^2 +
      (x[j] * (1 / 2) + (2 * exp(x[j])) / exp(x[j + 1]) + x[j + 1] * 4 + sin(x[j] / 5))^2 for
      j = 1:(n - 1)
    ) - (tan(x[6]))
  )
  evaluator = JuMP.NLPEvaluator(m)
  MathOptInterface.initialize(evaluator, [:ExprGraph])
  Expr_j = MathOptInterface.objective_expr(evaluator)

  expr_tree = ExpressionTreeForge.transform_to_expr_tree(Expr_j)
  expr_tree_j = copy(expr_tree)
  complete_tree = ExpressionTreeForge.create_complete_tree(expr_tree_j)

  x = ones(Float64, n)

  t = Float64
  n_eval = 200
  f(n, i, t) = (v -> i * v).(ones(t, n))
  all_x = map(i -> f(n, i, t), [1:n_eval;])
  resx = Vector{Float64}(undef, n_eval)
  all_x_views = map(x -> view(x, [1:length(x);]), all_x)

  obj_expr_tree = ExpressionTreeForge.evaluate_expr_tree(expr_tree, x)
  obj_complete_tree = ExpressionTreeForge.evaluate_expr_tree(complete_tree, x)
  obj_JuMP = MathOptInterface.eval_objective(evaluator, x)

  @test obj_expr_tree ≈ obj_JuMP
  @test obj_complete_tree ≈ obj_JuMP
  @test mapreduce(x -> ExpressionTreeForge.evaluate_expr_tree(expr_tree, x), +, all_x) ==
        mapreduce(x -> MathOptInterface.eval_objective(evaluator, x), +, all_x)
end
