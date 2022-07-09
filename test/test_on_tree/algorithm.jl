using ..ExpressionTreeForge.M_trait_expr_tree

@testset "Algorithm tests" begin
  m = Model()
  n = 4
  @variable(m, x[1:n])
  @NLobjective(m, Min, (x[1]*x[3]+5)^2 + sin(x[2]+cos(x[3])) + (-1 + x[4])^2)

  evaluator = JuMP.NLPEvaluator(m)
  MathOptInterface.initialize(evaluator, [:ExprGraph, :Hess])

  v = ones(n)
  Expr_j = MathOptInterface.objective_expr(evaluator)
  expr_tree = ExpressionTreeForge.transform_to_expr_tree(Expr_j)
  expr_tree_j = copy(expr_tree)
  @test ExpressionTreeForge.M_trait_expr_tree.expr_tree_equal(expr_tree, expr_tree_j)

  complete_tree = ExpressionTreeForge.create_complete_tree(expr_tree_j)

  element_functions = delete_imbricated_plus(expr_tree_j)
  element_variables = get_elemental_variable.(element_functions)

  map((fun, var) -> element_fun_from_N_to_Ni!(fun, var), element_functions, element_variables)
  @test ExpressionTreeForge.M_trait_expr_tree.expr_tree_equal(expr_tree, expr_tree_j) == false
end

