@testset "Bounds detection " begin
  @testset "Sinus" begin
    m = Model()
    n = 1
    @variable(m, x[1:n])
    @NLobjective(m, Min, sin(sin(x[1]) * (π * 0.5)))
    evaluator = JuMP.NLPEvaluator(m)
    MathOptInterface.initialize(evaluator, [:ExprGraph])

    obj = MathOptInterface.objective_expr(evaluator)
    expr_tree_obj = ExpressionTreeForge.transform_to_expr_tree(obj)
    bound_expr_tree = ExpressionTreeForge.create_bounds_tree(expr_tree_obj)
    ExpressionTreeForge.set_bounds!(expr_tree_obj, bound_expr_tree)
    @test ExpressionTreeForge.get_bounds(bound_expr_tree) == (-1, 1)
  end

  @testset "Product" begin
    e1 = :(x[1] * x[2])
    et1 = ExpressionTreeForge.transform_to_expr_tree(e1)
    bound_tree = ExpressionTreeForge.create_bounds_tree(et1)
    ExpressionTreeForge.set_bounds!(et1, bound_tree)
    @test ExpressionTreeForge.get_bounds(bound_tree) == (-Inf, Inf)

    e1 = :(sin(x[1]) * 3 * x[2]^2)
    et1 = ExpressionTreeForge.transform_to_expr_tree(e1)
    bound_tree = ExpressionTreeForge.create_bounds_tree(et1)
    ExpressionTreeForge.set_bounds!(et1, bound_tree)
    @test ExpressionTreeForge.get_bounds(bound_tree) == (-Inf, Inf)

    e1 = :(sin(x[1]) * 3)
    et1 = ExpressionTreeForge.transform_to_expr_tree(e1)
    bound_tree = ExpressionTreeForge.create_bounds_tree(et1)
    ExpressionTreeForge.set_bounds!(et1, bound_tree)
    @test ExpressionTreeForge.get_bounds(bound_tree) == (-3, 3)
  end

  @testset "Tan" begin
    e1 = :(tan(x[2]))
    et1 = ExpressionTreeForge.transform_to_expr_tree(e1)
    bound_tree = ExpressionTreeForge.create_bounds_tree(et1)
    ExpressionTreeForge.set_bounds!(et1, bound_tree)
    @test ExpressionTreeForge.get_bounds(bound_tree) == (-Inf, Inf)

    e1 = :(tan(4))
    et1 = ExpressionTreeForge.transform_to_expr_tree(e1)
    bound_tree = ExpressionTreeForge.create_bounds_tree(et1)
    ExpressionTreeForge.set_bounds!(et1, bound_tree)
    @test ExpressionTreeForge.get_bounds(bound_tree) == (-Inf, Inf)
  end

  @testset "Exp and Power" begin
    m = Model()
    n = 1
    @variable(m, x[1:n])
    @NLobjective(m, Min, exp(x[1]))
    evaluator = JuMP.NLPEvaluator(m)
    MathOptInterface.initialize(evaluator, [:ExprGraph])
    obj = MathOptInterface.objective_expr(evaluator)
    expr_tree_obj = ExpressionTreeForge.transform_to_expr_tree(obj)
    bound_expr_tree = ExpressionTreeForge.create_bounds_tree(expr_tree_obj)
    ExpressionTreeForge.set_bounds!(expr_tree_obj, bound_expr_tree)
    @test ExpressionTreeForge.get_bounds(bound_expr_tree) == (0, Inf)

    m = Model()
    n = 1
    @variable(m, x[1:n])
    @NLobjective(m, Min, exp(x[1])^2)
    evaluator = JuMP.NLPEvaluator(m)
    MathOptInterface.initialize(evaluator, [:ExprGraph])
    obj = MathOptInterface.objective_expr(evaluator)
    expr_tree_obj = ExpressionTreeForge.transform_to_expr_tree(obj)
    bound_expr_tree = ExpressionTreeForge.create_bounds_tree(expr_tree_obj)
    ExpressionTreeForge.set_bounds!(expr_tree_obj, bound_expr_tree)
    @test ExpressionTreeForge.get_bounds(bound_expr_tree) == (0, Inf)

    m = Model()
    n = 1
    @variable(m, x[1:n])
    @NLobjective(m, Min, x[1]^2)
    evaluator = JuMP.NLPEvaluator(m)
    MathOptInterface.initialize(evaluator, [:ExprGraph])
    obj = MathOptInterface.objective_expr(evaluator)
    expr_tree_obj = ExpressionTreeForge.transform_to_expr_tree(obj)
    bound_expr_tree = ExpressionTreeForge.create_bounds_tree(expr_tree_obj)
    ExpressionTreeForge.set_bounds!(expr_tree_obj, bound_expr_tree)
    @test ExpressionTreeForge.get_bounds(bound_expr_tree) == (0, Inf)

    m = Model()
    n = 1
    @variable(m, x[1:n])
    @NLobjective(m, Min, x[1]^3)
    evaluator = JuMP.NLPEvaluator(m)
    MathOptInterface.initialize(evaluator, [:ExprGraph])
    obj = MathOptInterface.objective_expr(evaluator)
    expr_tree_obj = ExpressionTreeForge.transform_to_expr_tree(obj)
    bound_expr_tree = ExpressionTreeForge.create_bounds_tree(expr_tree_obj)
    ExpressionTreeForge.set_bounds!(expr_tree_obj, bound_expr_tree)
    @test ExpressionTreeForge.get_bounds(bound_expr_tree) == (-Inf, Inf)
  end
end
