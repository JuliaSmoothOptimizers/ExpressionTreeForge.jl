@testset "ADNLPModel modelisation" begin
  n = 5
  function f(x)
    n = length(x)
    return sum(x[n - i + 1]^2 - x[i] for i = 1:n)
  end

  Symbolics.@variables x[1:n]

  fun_tree = f(x)
  obj_expr = Symbolics._toexpr(fun_tree)
  expr_tree = transform_to_expr_tree(obj_expr)


  m = Model()
  @variable(m, x[1:n])
  @NLobjective(
    m,
    Min,
    sum(x[i]^2 - x[i] for i = 1:n)
  )
  evaluator = JuMP.NLPEvaluator(m)
  MathOptInterface.initialize(evaluator, [:ExprGraph])
  Expr_j = MathOptInterface.objective_expr(evaluator)
  expr_tree_jump = ExpressionTreeForge.transform_to_expr_tree(Expr_j)

  y = ones(n)
  @test M_evaluation_expr_tree.evaluate_expr_tree(expr_tree, y) == M_evaluation_expr_tree.evaluate_expr_tree(expr_tree_jump, y)
  # @test expr_tree == expr_tree_jump
end
