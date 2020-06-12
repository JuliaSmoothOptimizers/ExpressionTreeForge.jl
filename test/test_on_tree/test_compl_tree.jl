using CalculusTreeTools
using JuMP, MathOptInterface, LinearAlgebra, SparseArrays
using Test

# Ces tests vérifie que compl expr tree se comporte de la même manière que expr_tree
@testset "test des arbres complets" begin
    θ = 1e-5
    m = Model()
    n = 5
    @variable(m, x[1:n])
    @NLobjective(m, Min, sin(sum( (1/2) * ((x[j+1]/(x[j]^2)) * x[j+1]^3) for j in 1:n-1 )) + ( sin(sin(x[1])*(π*0.5)) - (x[4]^2 * - (x[5]/2)^2 - 1)) + cos(sin(x[3])*(0.5*π )) )

    evaluator = JuMP.NLPEvaluator(m)
    MathOptInterface.initialize(evaluator, [:ExprGraph, :Hess])

    v = ones(n)
    Expr_j = MathOptInterface.objective_expr(evaluator)
    expr_tree = CalculusTreeTools.transform_to_expr_tree(Expr_j)
    expr_tree_j = copy(expr_tree)
    complete_tree = CalculusTreeTools.create_complete_tree(expr_tree_j)

    @test expr_tree_j == expr_tree
    @test CalculusTreeTools.evaluate_expr_tree(complete_tree, v) == CalculusTreeTools.evaluate_expr_tree(expr_tree, v)
    @test CalculusTreeTools.evaluate_expr_tree(complete_tree, v) == MathOptInterface.eval_objective(evaluator, v)

    deleted_comp_expr_tree = CalculusTreeTools.delete_imbricated_plus(complete_tree)
    deleted_expr_tree = CalculusTreeTools.delete_imbricated_plus(expr_tree)
    comp_elem = CalculusTreeTools.get_elemental_variable.(deleted_comp_expr_tree)
    elem = CalculusTreeTools.get_elemental_variable.(deleted_expr_tree)

    @test length(deleted_comp_expr_tree) == length(deleted_expr_tree)
    @test comp_elem == elem
    res_deleted_comp_tree_evaluated = (x -> x(v)).(CalculusTreeTools.evaluate_expr_tree.(deleted_comp_expr_tree))
    res_deleted_tree_evaluated = (x -> x(v)).(CalculusTreeTools.evaluate_expr_tree.(deleted_expr_tree))
    @test res_deleted_tree_evaluated == res_deleted_comp_tree_evaluated


    grad = zeros(n)
    MathOptInterface.eval_objective_gradient(evaluator, grad, v)
    @test CalculusTreeTools.calcul_gradient_expr_tree(complete_tree, v) == CalculusTreeTools.calcul_gradient_expr_tree(expr_tree, v)
    @test (norm(CalculusTreeTools.calcul_gradient_expr_tree(complete_tree, v)) - norm(grad)) < θ



    MOI_pattern = MathOptInterface.hessian_lagrangian_structure(evaluator)
    column = [x[1] for x in MOI_pattern]
    row = [x[2]  for x in MOI_pattern]
    MOI_value_Hessian = Vector{ typeof(v[1]) }(undef,length(MOI_pattern))
    MathOptInterface.eval_hessian_lagrangian(evaluator, MOI_value_Hessian, v, 1.0, zeros(0))
    values = [x for x in MOI_value_Hessian]

    MOI_half_hessian_en_x = sparse(row,column,values,n,n)
    MOI_hessian_en_x = Symmetric(MOI_half_hessian_en_x)

    H = CalculusTreeTools.calcul_Hessian_expr_tree(complete_tree, v)
    @test (norm(MOI_hessian_en_x) - norm(H)) < θ



    CalculusTreeTools.set_bounds!(complete_tree)
    bound_tree = CalculusTreeTools.create_bound_tree(expr_tree)
    CalculusTreeTools.set_bounds!(expr_tree, bound_tree)
    @test CalculusTreeTools.get_bound(complete_tree) == CalculusTreeTools.get_bound(bound_tree)


    convexity_tree = CalculusTreeTools.create_convex_tree(expr_tree_j)
    CalculusTreeTools.set_convexity!(expr_tree, convexity_tree, bound_tree)
    CalculusTreeTools.set_convexity!(complete_tree)

    @test CalculusTreeTools.get_convexity_status(convexity_tree) == CalculusTreeTools.get_convexity_status(complete_tree)


    CalculusTreeTools.element_fun_from_N_to_Ni!(deleted_comp_expr_tree[3], comp_elem[3])
    CalculusTreeTools.element_fun_from_N_to_Ni!(deleted_expr_tree[3], elem[3])

    @test CalculusTreeTools.evaluate_expr_tree(deleted_expr_tree[3], v) == CalculusTreeTools.evaluate_expr_tree(deleted_comp_expr_tree[3], v)


end
