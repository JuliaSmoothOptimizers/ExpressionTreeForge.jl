@testset "Convexity detection" begin
  @testset "Power and Sum" begin
    m = Model()
    n = 5
    @variable(m, x[1:n])
    @NLobjective(m, Min, sum((x[j]^2) for j = 1:n))
    evaluator = JuMP.NLPEvaluator(m)
    MathOptInterface.initialize(evaluator, [:ExprGraph])
    Expr_j = MathOptInterface.objective_expr(evaluator)
    expr_tree_j = ExpressionTreeForge.transform_to_expr_tree(Expr_j)

    bound_tree = ExpressionTreeForge.create_bounds_tree(expr_tree_j)
    convexity_tree = ExpressionTreeForge.create_convex_tree(expr_tree_j)
    ExpressionTreeForge.set_bounds!(expr_tree_j, bound_tree)
    ExpressionTreeForge.set_convexity!(expr_tree_j, convexity_tree, bound_tree)
    @test ExpressionTreeForge.get_convexity_status(convexity_tree) ==
          ExpressionTreeForge.convex_type()

    complete_tree = ExpressionTreeForge.complete_tree(expr_tree_j)
    ExpressionTreeForge.set_bounds!(complete_tree)
    ExpressionTreeForge.set_convexity!(complete_tree)
    @test ExpressionTreeForge.get_convexity_status(complete_tree) ==
          ExpressionTreeForge.convex_type()

    m = Model()
    n = 5
    @variable(m, x[1:n])
    @NLobjective(m, Min, sum((x[j]^(1.5)) for j = 1:n))
    evaluator = JuMP.NLPEvaluator(m)
    MathOptInterface.initialize(evaluator, [:ExprGraph])
    Expr_j = MathOptInterface.objective_expr(evaluator)
    expr_tree_j = ExpressionTreeForge.transform_to_expr_tree(Expr_j)
    bound_tree = ExpressionTreeForge.create_bounds_tree(expr_tree_j)
    convexity_tree = ExpressionTreeForge.create_convex_tree(expr_tree_j)
    ExpressionTreeForge.set_bounds!(expr_tree_j, bound_tree)
    ExpressionTreeForge.set_convexity!(expr_tree_j, convexity_tree, bound_tree)
    @test ExpressionTreeForge.get_convexity_status(convexity_tree) ==
          ExpressionTreeForge.unknown_type()

    complete_tree = ExpressionTreeForge.complete_tree(expr_tree_j)
    ExpressionTreeForge.set_bounds!(complete_tree)
    ExpressionTreeForge.set_convexity!(complete_tree)
    @test ExpressionTreeForge.get_convexity_status(complete_tree) ==
          ExpressionTreeForge.unknown_type()

    m = Model()
    n = 5
    @variable(m, x[1:n])
    @NLobjective(m, Min, sum((x[j]^2)^2 for j = 1:n))
    evaluator = JuMP.NLPEvaluator(m)
    MathOptInterface.initialize(evaluator, [:ExprGraph])
    Expr_j = MathOptInterface.objective_expr(evaluator)
    expr_tree_j = ExpressionTreeForge.transform_to_expr_tree(Expr_j)
    bound_tree = ExpressionTreeForge.create_bounds_tree(expr_tree_j)
    convexity_tree = ExpressionTreeForge.create_convex_tree(expr_tree_j)
    ExpressionTreeForge.set_bounds!(expr_tree_j, bound_tree)
    ExpressionTreeForge.set_convexity!(expr_tree_j, convexity_tree, bound_tree)
    @test ExpressionTreeForge.get_convexity_status(convexity_tree) ==
          ExpressionTreeForge.convex_type()

    complete_tree = ExpressionTreeForge.complete_tree(expr_tree_j)
    ExpressionTreeForge.set_bounds!(complete_tree)
    ExpressionTreeForge.set_convexity!(complete_tree)
    @test ExpressionTreeForge.get_convexity_status(complete_tree) ==
          ExpressionTreeForge.convex_type()

    m = Model()
    n = 5
    @variable(m, x[1:n])
    @NLobjective(m, Min, sum((-(x[j]^2))^2 for j = 1:n))
    evaluator = JuMP.NLPEvaluator(m)
    MathOptInterface.initialize(evaluator, [:ExprGraph])
    Expr_j = MathOptInterface.objective_expr(evaluator)
    expr_tree_j = ExpressionTreeForge.transform_to_expr_tree(Expr_j)

    bound_tree = ExpressionTreeForge.create_bounds_tree(expr_tree_j)
    convexity_tree = ExpressionTreeForge.create_convex_tree(expr_tree_j)
    ExpressionTreeForge.set_bounds!(expr_tree_j, bound_tree)
    ExpressionTreeForge.set_convexity!(expr_tree_j, convexity_tree, bound_tree)
    @test ExpressionTreeForge.get_convexity_status(convexity_tree) ==
          ExpressionTreeForge.convex_type()

    complete_tree = ExpressionTreeForge.complete_tree(expr_tree_j)
    ExpressionTreeForge.set_bounds!(complete_tree)
    ExpressionTreeForge.set_convexity!(complete_tree)
    @test ExpressionTreeForge.get_convexity_status(complete_tree) ==
          ExpressionTreeForge.convex_type()

    m = Model()
    n = 5
    @variable(m, x[1:n])
    @NLobjective(m, Min, (-exp(x[1]))^2 + (exp(x[2])^2))
    evaluator = JuMP.NLPEvaluator(m)
    MathOptInterface.initialize(evaluator, [:ExprGraph])
    Expr_j = MathOptInterface.objective_expr(evaluator)
    expr_tree_j = ExpressionTreeForge.transform_to_expr_tree(Expr_j)
    bound_tree = ExpressionTreeForge.create_bounds_tree(expr_tree_j)
    convexity_tree = ExpressionTreeForge.create_convex_tree(expr_tree_j)
    ExpressionTreeForge.set_bounds!(expr_tree_j, bound_tree)
    ExpressionTreeForge.set_convexity!(expr_tree_j, convexity_tree, bound_tree)
    @test ExpressionTreeForge.get_convexity_status(convexity_tree) ==
          ExpressionTreeForge.convex_type()

    complete_tree = ExpressionTreeForge.complete_tree(expr_tree_j)
    ExpressionTreeForge.set_bounds!(complete_tree)
    ExpressionTreeForge.set_convexity!(complete_tree)
    @test ExpressionTreeForge.get_convexity_status(complete_tree) ==
          ExpressionTreeForge.convex_type()
  end

  @testset "Minus" begin
    m = Model()
    n = 5
    @variable(m, x[1:n])
    @NLobjective(m, Min, sum(-(x[j]^2) for j = 1:n))
    evaluator = JuMP.NLPEvaluator(m)
    MathOptInterface.initialize(evaluator, [:ExprGraph])
    Expr_j = MathOptInterface.objective_expr(evaluator)
    expr_tree_j = ExpressionTreeForge.transform_to_expr_tree(Expr_j)
    bound_tree = ExpressionTreeForge.create_bounds_tree(expr_tree_j)
    convexity_tree = ExpressionTreeForge.create_convex_tree(expr_tree_j)
    ExpressionTreeForge.set_bounds!(expr_tree_j, bound_tree)
    ExpressionTreeForge.set_convexity!(expr_tree_j, convexity_tree, bound_tree)
    @test ExpressionTreeForge.get_convexity_status(convexity_tree) ==
          ExpressionTreeForge.concave_type()

    complete_tree = ExpressionTreeForge.complete_tree(expr_tree_j)
    ExpressionTreeForge.set_bounds!(complete_tree)
    ExpressionTreeForge.set_convexity!(complete_tree)
    @test ExpressionTreeForge.get_convexity_status(complete_tree) ==
          ExpressionTreeForge.concave_type()
  end

  @testset "Variable" begin
    m = Model()
    n = 5
    @variable(m, x[1:n])
    @NLobjective(m, Min, sum(x[j] for j = 1:(n - 1)))
    evaluator = JuMP.NLPEvaluator(m)
    MathOptInterface.initialize(evaluator, [:ExprGraph])
    Expr_j = MathOptInterface.objective_expr(evaluator)
    expr_tree_j = ExpressionTreeForge.transform_to_expr_tree(Expr_j)
    bound_tree = ExpressionTreeForge.create_bounds_tree(expr_tree_j)
    convexity_tree = ExpressionTreeForge.create_convex_tree(expr_tree_j)
    ExpressionTreeForge.set_bounds!(expr_tree_j, bound_tree)
    ExpressionTreeForge.set_convexity!(expr_tree_j, convexity_tree, bound_tree)
    @test ExpressionTreeForge.get_convexity_status(convexity_tree) ==
          ExpressionTreeForge.linear_type()

    complete_tree = ExpressionTreeForge.complete_tree(expr_tree_j)
    ExpressionTreeForge.set_bounds!(complete_tree)
    ExpressionTreeForge.set_convexity!(complete_tree)
    @test ExpressionTreeForge.get_convexity_status(complete_tree) ==
          ExpressionTreeForge.linear_type()
  end

  @testset "Constant and product" begin
    m = Model()
    n = 5
    @variable(m, x[1:n])
    @NLobjective(m, Min, 360)
    evaluator = JuMP.NLPEvaluator(m)
    MathOptInterface.initialize(evaluator, [:ExprGraph])
    Expr_j = MathOptInterface.objective_expr(evaluator)
    expr_tree_j = ExpressionTreeForge.transform_to_expr_tree(Expr_j)
    bound_tree = ExpressionTreeForge.create_bounds_tree(expr_tree_j)
    convexity_tree = ExpressionTreeForge.create_convex_tree(expr_tree_j)
    ExpressionTreeForge.set_bounds!(expr_tree_j, bound_tree)
    ExpressionTreeForge.set_convexity!(expr_tree_j, convexity_tree, bound_tree)
    @test ExpressionTreeForge.get_convexity_status(convexity_tree) ==
          ExpressionTreeForge.constant_type()

    complete_tree = ExpressionTreeForge.complete_tree(expr_tree_j)
    ExpressionTreeForge.set_bounds!(complete_tree)
    ExpressionTreeForge.set_convexity!(complete_tree)
    @test ExpressionTreeForge.get_convexity_status(complete_tree) ==
          ExpressionTreeForge.constant_type()

    m = Model()
    n = 5
    @variable(m, x[1:n])
    @NLobjective(m, Min, sum((-(x[j] * 5 - 6 * 3))^2 for j = 1:(n - 1)))
    evaluator = JuMP.NLPEvaluator(m)
    MathOptInterface.initialize(evaluator, [:ExprGraph])
    Expr_j = MathOptInterface.objective_expr(evaluator)
    expr_tree_j = ExpressionTreeForge.transform_to_expr_tree(Expr_j)

    bound_tree = ExpressionTreeForge.create_bounds_tree(expr_tree_j)
    convexity_tree = ExpressionTreeForge.create_convex_tree(expr_tree_j)
    ExpressionTreeForge.set_bounds!(expr_tree_j, bound_tree)
    ExpressionTreeForge.set_convexity!(expr_tree_j, convexity_tree, bound_tree)
    @test ExpressionTreeForge.get_convexity_status(convexity_tree) ==
          ExpressionTreeForge.convex_type()

    complete_tree = ExpressionTreeForge.complete_tree(expr_tree_j)
    ExpressionTreeForge.set_bounds!(complete_tree)
    ExpressionTreeForge.set_convexity!(complete_tree)
    @test ExpressionTreeForge.get_convexity_status(complete_tree) ==
          ExpressionTreeForge.convex_type()
  end

  @testset "Exp and Power" begin
    m = Model()
    n = 5
    @variable(m, x[1:n])
    @NLobjective(m, Min, sum(exp(x[j])^3 for j = 1:(n - 1)))
    evaluator = JuMP.NLPEvaluator(m)
    MathOptInterface.initialize(evaluator, [:ExprGraph])
    Expr_j = MathOptInterface.objective_expr(evaluator)
    expr_tree_j = ExpressionTreeForge.transform_to_expr_tree(Expr_j)

    bound_tree = ExpressionTreeForge.create_bounds_tree(expr_tree_j)
    convexity_tree = ExpressionTreeForge.create_convex_tree(expr_tree_j)
    ExpressionTreeForge.set_bounds!(expr_tree_j, bound_tree)
    ExpressionTreeForge.set_convexity!(expr_tree_j, convexity_tree, bound_tree)
    @test ExpressionTreeForge.get_convexity_status(convexity_tree) ==
          ExpressionTreeForge.convex_type()

    complete_tree = ExpressionTreeForge.complete_tree(expr_tree_j)
    ExpressionTreeForge.set_bounds!(complete_tree)
    ExpressionTreeForge.set_convexity!(complete_tree)
    @test ExpressionTreeForge.get_convexity_status(complete_tree) ==
          ExpressionTreeForge.convex_type()
  end

  @testset "Constant" begin
    Expr_j = :(5)
    expr_tree_j = ExpressionTreeForge.transform_to_expr_tree(Expr_j)
    bound_tree = ExpressionTreeForge.create_bounds_tree(expr_tree_j)
    convexity_tree = ExpressionTreeForge.create_convex_tree(expr_tree_j)
    ExpressionTreeForge.set_bounds!(expr_tree_j, bound_tree)
    ExpressionTreeForge.set_convexity!(expr_tree_j, convexity_tree, bound_tree)
    @test ExpressionTreeForge.get_convexity_status(convexity_tree) ==
          ExpressionTreeForge.constant_type()

    complete_tree = ExpressionTreeForge.complete_tree(expr_tree_j)
    ExpressionTreeForge.set_bounds!(complete_tree)
    ExpressionTreeForge.set_convexity!(complete_tree)
    @test ExpressionTreeForge.get_convexity_status(complete_tree) ==
          ExpressionTreeForge.constant_type()
  end

  @testset "Variable" begin
    Expr_j = :(x[1] + x[2] / 5 + x[3] * 5)
    expr_tree_j = ExpressionTreeForge.transform_to_expr_tree(Expr_j)
    bound_tree = ExpressionTreeForge.create_bounds_tree(expr_tree_j)
    convexity_tree = ExpressionTreeForge.create_convex_tree(expr_tree_j)
    ExpressionTreeForge.set_bounds!(expr_tree_j, bound_tree)
    ExpressionTreeForge.set_convexity!(expr_tree_j, convexity_tree, bound_tree)
    @test ExpressionTreeForge.get_convexity_status(convexity_tree) ==
          ExpressionTreeForge.linear_type()

    complete_tree = ExpressionTreeForge.complete_tree(expr_tree_j)
    ExpressionTreeForge.set_bounds!(complete_tree)
    ExpressionTreeForge.set_convexity!(complete_tree)
    @test ExpressionTreeForge.get_convexity_status(complete_tree) ==
          ExpressionTreeForge.linear_type()
  end
end
