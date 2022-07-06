using ExpressionTreeForge
using JuMP, MathOptInterface
using Test

@testset "Bounds test" begin
  e1 = :(x[1] - x[2])
  et1 = ExpressionTreeForge.transform_to_expr_tree(e1)
  bound_tree = ExpressionTreeForge.create_bound_tree(et1)
  ExpressionTreeForge.set_bounds!(et1, bound_tree)
  @test ExpressionTreeForge.get_bound(bound_tree) == (-Inf, Inf)

  e2 = :(4 - (sin(x[3]) - sin(x[4]) * 3))
  et2 = ExpressionTreeForge.transform_to_expr_tree(e2)
  bound_tree2 = ExpressionTreeForge.create_bound_tree(et2)
  ExpressionTreeForge.set_bounds!(et2, bound_tree2)
  ExpressionTreeForge.print_tree(bound_tree2)

  m = Model()
  n = 3
  @variable(m, x[1:n])

  @NLobjective(
    m,
    Min,
    sin(sum((x[j]^2 * x[j + 1]^3) for j = 1:(n - 1))) +
    (sin(sin(x[1]) * (π * 0.5)) - (x[1]^2 * -(x[2])^2 - 1)) +
    cos(sin(x[3]) * (0.5 * π))
  )

  evaluator = JuMP.NLPEvaluator(m)
  MathOptInterface.initialize(evaluator, [:ExprGraph])
  Expr_j = MathOptInterface.objective_expr(evaluator)
  expr_tree_j = ExpressionTreeForge.transform_to_expr_tree(Expr_j)

  bound_expr_tree = ExpressionTreeForge.create_bound_tree(expr_tree_j)
  ExpressionTreeForge.set_bounds!(expr_tree_j, bound_expr_tree)
  ExpressionTreeForge.print_tree(bound_expr_tree)
end