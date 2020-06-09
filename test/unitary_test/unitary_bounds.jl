using JuMP, MathOptInterface


@testset "test du sinus" begin
    m = Model()
    n = 1
    @variable(m, x[1:n])
    @NLobjective(m, Min, sin(sin(x[1])*(π*0.5)) )
    evaluator = JuMP.NLPEvaluator(m)
    MathOptInterface.initialize(evaluator, [:ExprGraph])

    obj = MathOptInterface.objective_expr(evaluator)
    expr_tree_obj = CalculusTreeTools.transform_to_expr_tree(obj)
    bound_expr_tree = CalculusTreeTools.create_bound_tree(expr_tree_obj)
    CalculusTreeTools.set_bounds!(expr_tree_obj, bound_expr_tree)
    # CalculusTreeTools.print_tree(bound_expr_tree)
    @test CalculusTreeTools.get_bound(bound_expr_tree) == (-1,1)
end


@testset "test du produit" begin
    e1 = :(x[1] * x[2])
    et1 = CalculusTreeTools.transform_to_expr_tree(e1)
    bound_tree = CalculusTreeTools.create_bound_tree(et1)
    CalculusTreeTools.set_bounds!(et1, bound_tree)
    @test CalculusTreeTools.get_bound(bound_tree) == (-Inf,Inf)

    e1 = :(sin(x[1]) *3 *  x[2]^2)
    et1 = CalculusTreeTools.transform_to_expr_tree(e1)
    bound_tree = CalculusTreeTools.create_bound_tree(et1)
    CalculusTreeTools.set_bounds!(et1, bound_tree)
    @test CalculusTreeTools.get_bound(bound_tree) == (-Inf,Inf)

    e1 = :(sin(x[1]) * 3)
    et1 = CalculusTreeTools.transform_to_expr_tree(e1)
    bound_tree = CalculusTreeTools.create_bound_tree(et1)
    CalculusTreeTools.set_bounds!(et1, bound_tree)
    @test CalculusTreeTools.get_bound(bound_tree) == (-3,3)
end

@testset "test de exp et ^" begin
    m = Model()
    n = 1
    @variable(m, x[1:n])
    @NLobjective(m, Min, exp(x[1]) )
    evaluator = JuMP.NLPEvaluator(m)
    MathOptInterface.initialize(evaluator, [:ExprGraph])

    obj = MathOptInterface.objective_expr(evaluator)
    expr_tree_obj = CalculusTreeTools.transform_to_expr_tree(obj)
    bound_expr_tree = CalculusTreeTools.create_bound_tree(expr_tree_obj)
    CalculusTreeTools.set_bounds!(expr_tree_obj, bound_expr_tree)
    @test CalculusTreeTools.get_bound(bound_expr_tree) == (0,Inf)

    m = Model()
    n = 1
    @variable(m, x[1:n])
    @NLobjective(m, Min, exp(x[1])^2 )
    evaluator = JuMP.NLPEvaluator(m)
    MathOptInterface.initialize(evaluator, [:ExprGraph])

    obj = MathOptInterface.objective_expr(evaluator)
    expr_tree_obj = CalculusTreeTools.transform_to_expr_tree(obj)
    bound_expr_tree = CalculusTreeTools.create_bound_tree(expr_tree_obj)
    CalculusTreeTools.set_bounds!(expr_tree_obj, bound_expr_tree)
    @test CalculusTreeTools.get_bound(bound_expr_tree) == (0,Inf)

    m = Model()
    n = 1
    @variable(m, x[1:n])
    @NLobjective(m, Min, x[1]^2 )
    evaluator = JuMP.NLPEvaluator(m)
    MathOptInterface.initialize(evaluator, [:ExprGraph])

    obj = MathOptInterface.objective_expr(evaluator)
    expr_tree_obj = CalculusTreeTools.transform_to_expr_tree(obj)
    bound_expr_tree = CalculusTreeTools.create_bound_tree(expr_tree_obj)
    CalculusTreeTools.set_bounds!(expr_tree_obj, bound_expr_tree)
    @test CalculusTreeTools.get_bound(bound_expr_tree) == (0,Inf)

    m = Model()
    n = 1
    @variable(m, x[1:n])
    @NLobjective(m, Min, x[1]^3 )
    evaluator = JuMP.NLPEvaluator(m)
    MathOptInterface.initialize(evaluator, [:ExprGraph])

    obj = MathOptInterface.objective_expr(evaluator)
    expr_tree_obj = CalculusTreeTools.transform_to_expr_tree(obj)
    bound_expr_tree = CalculusTreeTools.create_bound_tree(expr_tree_obj)
    CalculusTreeTools.set_bounds!(expr_tree_obj, bound_expr_tree)
    @test CalculusTreeTools.get_bound(bound_expr_tree) == (-Inf,Inf)
end
