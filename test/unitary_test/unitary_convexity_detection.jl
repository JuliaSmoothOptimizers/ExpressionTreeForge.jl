using CalculusTreeTools
using JuMP, MathOptInterface, LinearAlgebra, SparseArrays
using Test


@testset " test de la détection de la convexité" begin
    @testset " tests puissance et sum" begin
        m = Model()
        n = 5
        @variable(m, x[1:n])
        @NLobjective(m, Min, sum( (x[j]^2) for j in 1:n ))
        evaluator = JuMP.NLPEvaluator(m)
        MathOptInterface.initialize(evaluator, [:ExprGraph])
        Expr_j = MathOptInterface.objective_expr(evaluator)
        expr_tree_j = CalculusTreeTools.transform_to_expr_tree(Expr_j)

        bound_tree = CalculusTreeTools.create_bound_tree(expr_tree_j)
        convexity_tree = CalculusTreeTools.create_convex_tree(expr_tree_j)
        CalculusTreeTools.set_bounds!(expr_tree_j, bound_tree)
        CalculusTreeTools.set_convexity!(expr_tree_j, convexity_tree, bound_tree)

        @test CalculusTreeTools.get_convexity_status(convexity_tree) == CalculusTreeTools.convex_type()

        complete_tree = CalculusTreeTools.create_complete_tree(expr_tree_j)
        CalculusTreeTools.set_bounds!(complete_tree)
        CalculusTreeTools.set_convexity!(complete_tree)
        @test CalculusTreeTools.get_convexity_status(complete_tree) == CalculusTreeTools.convex_type()
        #=----------------------------------------------------------------------------------------------------=#
        m = Model()
        n = 5
        @variable(m, x[1:n])
        @NLobjective(m, Min, sum( (x[j]^(1.5)) for j in 1:n ))
        evaluator = JuMP.NLPEvaluator(m)
        MathOptInterface.initialize(evaluator, [:ExprGraph])
        Expr_j = MathOptInterface.objective_expr(evaluator)
        expr_tree_j = CalculusTreeTools.transform_to_expr_tree(Expr_j)

        bound_tree = CalculusTreeTools.create_bound_tree(expr_tree_j)
        convexity_tree = CalculusTreeTools.create_convex_tree(expr_tree_j)
        CalculusTreeTools.set_bounds!(expr_tree_j, bound_tree)
        CalculusTreeTools.set_convexity!(expr_tree_j, convexity_tree, bound_tree)

        @test CalculusTreeTools.get_convexity_status(convexity_tree) == CalculusTreeTools.unknown_type()

        complete_tree = CalculusTreeTools.create_complete_tree(expr_tree_j)
        CalculusTreeTools.set_bounds!(complete_tree)
        CalculusTreeTools.set_convexity!(complete_tree)
        @test CalculusTreeTools.get_convexity_status(complete_tree) == CalculusTreeTools.unknown_type()
        #=----------------------------------------------------------------------------------------------------=#
        m = Model()
        n = 5
        @variable(m, x[1:n])
        @NLobjective(m, Min, sum( (x[j]^2)^2 for j in 1:n) )
        evaluator = JuMP.NLPEvaluator(m)
        MathOptInterface.initialize(evaluator, [:ExprGraph])
        Expr_j = MathOptInterface.objective_expr(evaluator)
        expr_tree_j = CalculusTreeTools.transform_to_expr_tree(Expr_j)

        bound_tree = CalculusTreeTools.create_bound_tree(expr_tree_j)
        convexity_tree = CalculusTreeTools.create_convex_tree(expr_tree_j)
        CalculusTreeTools.set_bounds!(expr_tree_j, bound_tree)
        CalculusTreeTools.set_convexity!(expr_tree_j, convexity_tree, bound_tree)

        @test CalculusTreeTools.get_convexity_status(convexity_tree) == CalculusTreeTools.convex_type()

        complete_tree = CalculusTreeTools.create_complete_tree(expr_tree_j)
        CalculusTreeTools.set_bounds!(complete_tree)
        CalculusTreeTools.set_convexity!(complete_tree)
        @test CalculusTreeTools.get_convexity_status(complete_tree) == CalculusTreeTools.convex_type()
        #=----------------------------------------------------------------------------------------------------=#
        m = Model()
        n = 5
        @variable(m, x[1:n])
        @NLobjective(m, Min, sum( (- (x[j]^2))^2 for j in 1:n) )
        evaluator = JuMP.NLPEvaluator(m)
        MathOptInterface.initialize(evaluator, [:ExprGraph])
        Expr_j = MathOptInterface.objective_expr(evaluator)
        expr_tree_j = CalculusTreeTools.transform_to_expr_tree(Expr_j)

        bound_tree = CalculusTreeTools.create_bound_tree(expr_tree_j)
        convexity_tree = CalculusTreeTools.create_convex_tree(expr_tree_j)
        CalculusTreeTools.set_bounds!(expr_tree_j, bound_tree)
        CalculusTreeTools.set_convexity!(expr_tree_j, convexity_tree, bound_tree)

        @test CalculusTreeTools.get_convexity_status(convexity_tree) == CalculusTreeTools.convex_type()

        complete_tree = CalculusTreeTools.create_complete_tree(expr_tree_j)
        CalculusTreeTools.set_bounds!(complete_tree)
        CalculusTreeTools.set_convexity!(complete_tree)
        @test CalculusTreeTools.get_convexity_status(complete_tree) == CalculusTreeTools.convex_type()
        #=----------------------------------------------------------------------------------------------------=#
        m = Model()
        n = 5
        @variable(m, x[1:n])
        @NLobjective(m, Min, (- exp(x[1]))^2 +  (exp(x[2])^2)  )
        # - (exp(x[j])^2) créé une fonction concave donc la borne sup est 0
        evaluator = JuMP.NLPEvaluator(m)
        MathOptInterface.initialize(evaluator, [:ExprGraph])
        Expr_j = MathOptInterface.objective_expr(evaluator)
        expr_tree_j = CalculusTreeTools.transform_to_expr_tree(Expr_j)

        bound_tree = CalculusTreeTools.create_bound_tree(expr_tree_j)
        convexity_tree = CalculusTreeTools.create_convex_tree(expr_tree_j)
        CalculusTreeTools.set_bounds!(expr_tree_j, bound_tree)
        CalculusTreeTools.set_convexity!(expr_tree_j, convexity_tree, bound_tree)

        @test CalculusTreeTools.get_convexity_status(convexity_tree) == CalculusTreeTools.convex_type()

        complete_tree = CalculusTreeTools.create_complete_tree(expr_tree_j)
        CalculusTreeTools.set_bounds!(complete_tree)
        CalculusTreeTools.set_convexity!(complete_tree)
        @test CalculusTreeTools.get_convexity_status(complete_tree) == CalculusTreeTools.convex_type()

    end

    @testset " tests minus" begin
        m = Model()
        n = 5
        @variable(m, x[1:n])
        @NLobjective(m, Min, sum( - (x[j]^2) for j in 1:n ))
        evaluator = JuMP.NLPEvaluator(m)
        MathOptInterface.initialize(evaluator, [:ExprGraph])
        Expr_j = MathOptInterface.objective_expr(evaluator)
        expr_tree_j = CalculusTreeTools.transform_to_expr_tree(Expr_j)

        bound_tree = CalculusTreeTools.create_bound_tree(expr_tree_j)
        convexity_tree = CalculusTreeTools.create_convex_tree(expr_tree_j)
        CalculusTreeTools.set_bounds!(expr_tree_j, bound_tree)

        CalculusTreeTools.set_convexity!(expr_tree_j, convexity_tree, bound_tree)

        @test CalculusTreeTools.get_convexity_status(convexity_tree) == CalculusTreeTools.concave_type()

        complete_tree = CalculusTreeTools.create_complete_tree(expr_tree_j)
        CalculusTreeTools.set_bounds!(complete_tree)
        CalculusTreeTools.set_convexity!(complete_tree)
        @test CalculusTreeTools.get_convexity_status(complete_tree) == CalculusTreeTools.concave_type()
    end

    @testset " tests variable" begin
        m = Model()
        n = 5
        @variable(m, x[1:n])
        @NLobjective(m, Min, sum( x[j]  for j in 1:n-1 ) )
        evaluator = JuMP.NLPEvaluator(m)
        MathOptInterface.initialize(evaluator, [:ExprGraph])
        Expr_j = MathOptInterface.objective_expr(evaluator)
        expr_tree_j = CalculusTreeTools.transform_to_expr_tree(Expr_j)

        bound_tree = CalculusTreeTools.create_bound_tree(expr_tree_j)
        convexity_tree = CalculusTreeTools.create_convex_tree(expr_tree_j)
        CalculusTreeTools.set_bounds!(expr_tree_j, bound_tree)

        CalculusTreeTools.set_convexity!(expr_tree_j, convexity_tree, bound_tree)

        @test CalculusTreeTools.get_convexity_status(convexity_tree) == CalculusTreeTools.linear_type()

        complete_tree = CalculusTreeTools.create_complete_tree(expr_tree_j)
        CalculusTreeTools.set_bounds!(complete_tree)
        CalculusTreeTools.set_convexity!(complete_tree)
        @test CalculusTreeTools.get_convexity_status(complete_tree) == CalculusTreeTools.linear_type()
    end


    @testset " tests constante et produit" begin
        m = Model()
        n = 5
        @variable(m, x[1:n])
        @NLobjective(m, Min, 360 )
        evaluator = JuMP.NLPEvaluator(m)
        MathOptInterface.initialize(evaluator, [:ExprGraph])
        Expr_j = MathOptInterface.objective_expr(evaluator)
        expr_tree_j = CalculusTreeTools.transform_to_expr_tree(Expr_j)

        bound_tree = CalculusTreeTools.create_bound_tree(expr_tree_j)
        convexity_tree = CalculusTreeTools.create_convex_tree(expr_tree_j)
        CalculusTreeTools.set_bounds!(expr_tree_j, bound_tree)

        CalculusTreeTools.set_convexity!(expr_tree_j, convexity_tree, bound_tree)

        @test CalculusTreeTools.get_convexity_status(convexity_tree) == CalculusTreeTools.constant_type()

        complete_tree = CalculusTreeTools.create_complete_tree(expr_tree_j)
        CalculusTreeTools.set_bounds!(complete_tree)
        CalculusTreeTools.set_convexity!(complete_tree)
        @test CalculusTreeTools.get_convexity_status(complete_tree) == CalculusTreeTools.constant_type()
        #=----------------------------------------------------------------------------------------------------=#
        m = Model()
        n = 5
        @variable(m, x[1:n])
        @NLobjective(m, Min, sum( (-(x[j]*5 - 6 * 3))^2 for j in 1:n-1 ))
        evaluator = JuMP.NLPEvaluator(m)
        MathOptInterface.initialize(evaluator, [:ExprGraph])
        Expr_j = MathOptInterface.objective_expr(evaluator)
        expr_tree_j = CalculusTreeTools.transform_to_expr_tree(Expr_j)

        bound_tree = CalculusTreeTools.create_bound_tree(expr_tree_j)
        convexity_tree = CalculusTreeTools.create_convex_tree(expr_tree_j)
        CalculusTreeTools.set_bounds!(expr_tree_j, bound_tree)

        CalculusTreeTools.set_convexity!(expr_tree_j, convexity_tree, bound_tree)

        @test CalculusTreeTools.get_convexity_status(convexity_tree) == CalculusTreeTools.convex_type()

        complete_tree = CalculusTreeTools.create_complete_tree(expr_tree_j)
        CalculusTreeTools.set_bounds!(complete_tree)
        CalculusTreeTools.set_convexity!(complete_tree)
        @test CalculusTreeTools.get_convexity_status(complete_tree) == CalculusTreeTools.convex_type()
    end


    @testset " tests exp/power" begin
        m = Model()
        n = 5
        @variable(m, x[1:n])
        @NLobjective(m, Min, sum( exp(x[j])^3  for j in 1:n-1 ))
        evaluator = JuMP.NLPEvaluator(m)
        MathOptInterface.initialize(evaluator, [:ExprGraph])
        Expr_j = MathOptInterface.objective_expr(evaluator)
        expr_tree_j = CalculusTreeTools.transform_to_expr_tree(Expr_j)

        bound_tree = CalculusTreeTools.create_bound_tree(expr_tree_j)
        convexity_tree = CalculusTreeTools.create_convex_tree(expr_tree_j)
        CalculusTreeTools.set_bounds!(expr_tree_j, bound_tree)

        CalculusTreeTools.set_convexity!(expr_tree_j, convexity_tree, bound_tree)

        @test CalculusTreeTools.get_convexity_status(convexity_tree) == CalculusTreeTools.convex_type()

        complete_tree = CalculusTreeTools.create_complete_tree(expr_tree_j)
        CalculusTreeTools.set_bounds!(complete_tree)
        CalculusTreeTools.set_convexity!(complete_tree)
        @test CalculusTreeTools.get_convexity_status(complete_tree) == CalculusTreeTools.convex_type()
    end


    @testset "test lone constant" begin
        Expr_j = :(5)
        expr_tree_j = CalculusTreeTools.transform_to_expr_tree(Expr_j)
        bound_tree = CalculusTreeTools.create_bound_tree(expr_tree_j)
        convexity_tree = CalculusTreeTools.create_convex_tree(expr_tree_j)
        CalculusTreeTools.set_bounds!(expr_tree_j, bound_tree)

        CalculusTreeTools.set_convexity!(expr_tree_j, convexity_tree, bound_tree)

        @test CalculusTreeTools.get_convexity_status(convexity_tree) == CalculusTreeTools.constant_type()

        complete_tree = CalculusTreeTools.create_complete_tree(expr_tree_j)
        CalculusTreeTools.set_bounds!(complete_tree)
        CalculusTreeTools.set_convexity!(complete_tree)
        @test CalculusTreeTools.get_convexity_status(complete_tree) == CalculusTreeTools.constant_type()
    end

    @testset "test variable" begin
        Expr_j = :(x[1] + x[2]/5 + x[3] * 5)
        expr_tree_j = CalculusTreeTools.transform_to_expr_tree(Expr_j)
        bound_tree = CalculusTreeTools.create_bound_tree(expr_tree_j)
        convexity_tree = CalculusTreeTools.create_convex_tree(expr_tree_j)
        CalculusTreeTools.set_bounds!(expr_tree_j, bound_tree)

        CalculusTreeTools.set_convexity!(expr_tree_j, convexity_tree, bound_tree)

        @test CalculusTreeTools.get_convexity_status(convexity_tree) == CalculusTreeTools.linear_type()

        complete_tree = CalculusTreeTools.create_complete_tree(expr_tree_j)
        CalculusTreeTools.set_bounds!(complete_tree)
        CalculusTreeTools.set_convexity!(complete_tree)
        @test CalculusTreeTools.get_convexity_status(complete_tree) == CalculusTreeTools.linear_type()

    end

end
