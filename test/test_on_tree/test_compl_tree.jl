using ExpressionTreeForge
using JuMP, MathOptInterface, LinearAlgebra, SparseArrays
using Test

@testset "Test the behaviour of complete_tree" begin
  θ = 1e-5
  m = Model()
  n = 5
  @variable(m, x[1:n])
  @NLobjective(m, Min, x[1] + x[2] + x[3] + x[4])

  evaluator = JuMP.NLPEvaluator(m)
  MathOptInterface.initialize(evaluator, [:ExprGraph, :Hess])

  v = ones(n)
  Expr_j = MathOptInterface.objective_expr(evaluator)
  expr_tree = ExpressionTreeForge.transform_to_expr_tree(Expr_j)
  expr_tree_j = copy(expr_tree)
  complete_tree = ExpressionTreeForge.complete_tree(expr_tree_j)

  @test expr_tree_j == expr_tree
  @test ExpressionTreeForge.evaluate_expr_tree(complete_tree, v) ==
        ExpressionTreeForge.evaluate_expr_tree(expr_tree, v)
  @test ExpressionTreeForge.evaluate_expr_tree(complete_tree, v) ==
        MathOptInterface.eval_objective(evaluator, v)

  deleted_comp_expr_tree = ExpressionTreeForge.extract_element_functions(complete_tree)
  deleted_expr_tree = ExpressionTreeForge.extract_element_functions(expr_tree)
  comp_elem = ExpressionTreeForge.get_elemental_variables.(deleted_comp_expr_tree)
  elem = ExpressionTreeForge.get_elemental_variables.(deleted_expr_tree)

  @test length(deleted_comp_expr_tree) == length(deleted_expr_tree)
  @test comp_elem == elem

  res_deleted_comp_tree_evaluated =
    (x -> x(v)).(ExpressionTreeForge.evaluate_expr_tree.(deleted_comp_expr_tree))
  res_deleted_tree_evaluated =
    (x -> x(v)).(ExpressionTreeForge.evaluate_expr_tree.(deleted_expr_tree))
  @test res_deleted_tree_evaluated == res_deleted_comp_tree_evaluated

  grad = zeros(n)
  MathOptInterface.eval_objective_gradient(evaluator, grad, v)
  @test ExpressionTreeForge.gradient_forward(complete_tree, v) ==
        ExpressionTreeForge.gradient_forward(expr_tree, v)
  @test (norm(ExpressionTreeForge.gradient_forward(complete_tree, v)) - norm(grad)) < θ

  MOI_pattern = MathOptInterface.hessian_lagrangian_structure(evaluator)
  column = [x[1] for x in MOI_pattern]
  row = [x[2] for x in MOI_pattern]
  MOI_value_Hessian = Vector{typeof(v[1])}(undef, length(MOI_pattern))
  MathOptInterface.eval_hessian_lagrangian(evaluator, MOI_value_Hessian, v, 1.0, zeros(0))
  values = [x for x in MOI_value_Hessian]

  MOI_half_hessian_en_x = sparse(row, column, values, n, n)
  MOI_hessian_en_x = Symmetric(MOI_half_hessian_en_x)

  H = ExpressionTreeForge.hessian_forward(complete_tree, v)
  @test (norm(MOI_hessian_en_x) - norm(H)) < θ

  ExpressionTreeForge.set_bounds!(complete_tree)
  bound_tree = ExpressionTreeForge.create_bounds_tree(expr_tree)
  ExpressionTreeForge.set_bounds!(expr_tree, bound_tree)
  @test ExpressionTreeForge.get_bounds(complete_tree) == ExpressionTreeForge.get_bounds(bound_tree)

  convexity_tree = ExpressionTreeForge.create_convex_tree(expr_tree_j)
  ExpressionTreeForge.set_convexity!(expr_tree, convexity_tree, bound_tree)
  ExpressionTreeForge.set_convexity!(complete_tree)
  @test ExpressionTreeForge.get_convexity_status(convexity_tree) ==
        ExpressionTreeForge.get_convexity_status(complete_tree)

  x = (y -> y * 4).(ones(n))
  ExpressionTreeForge.normalize_indices!(deleted_comp_expr_tree[3], comp_elem[3])
  ExpressionTreeForge.normalize_indices!(deleted_expr_tree[3], elem[3])
  @test ExpressionTreeForge.evaluate_expr_tree(deleted_expr_tree[3], x) ==
        ExpressionTreeForge.evaluate_expr_tree(deleted_comp_expr_tree[3], x)

  ExpressionTreeForge.normalize_indices!(deleted_comp_expr_tree[2], comp_elem[2])
  ExpressionTreeForge.normalize_indices!(deleted_expr_tree[2], elem[2])
  @test ExpressionTreeForge.evaluate_expr_tree(deleted_expr_tree[2], x) ==
        ExpressionTreeForge.evaluate_expr_tree(deleted_comp_expr_tree[2], x)

  ExpressionTreeForge.normalize_indices!(deleted_comp_expr_tree[4], comp_elem[4])
  ExpressionTreeForge.normalize_indices!(deleted_expr_tree[4], elem[4])
  @test ExpressionTreeForge.evaluate_expr_tree(deleted_expr_tree[4], x) ==
        ExpressionTreeForge.evaluate_expr_tree(deleted_comp_expr_tree[4], x)

  copy_tree = copy(complete_tree)
  @test copy_tree == complete_tree

  ExpressionTreeForge.evaluate_expr_tree(copy_tree, x)
  ExpressionTreeForge.evaluate_expr_tree(complete_tree, x)
  @test ExpressionTreeForge.get_bounds(complete_tree) == ExpressionTreeForge.get_bounds(copy_tree)
  @test ExpressionTreeForge.get_convexity_status(complete_tree) ==
        ExpressionTreeForge.get_convexity_status(copy_tree)

  @testset "test supp " begin
    type_test = [Float32, Float16, BigFloat, Float64]
    for t in type_test
      x = ones(t, n)
      cast_new_tree = ExpressionTreeForge.cast_type_of_constant(expr_tree, t)
      cast_complete_tree = ExpressionTreeForge.cast_type_of_constant(complete_tree, t)
      obj_casted_ex_t = ExpressionTreeForge.evaluate_expr_tree(cast_new_tree, x)
      obj_casted_cp_t = ExpressionTreeForge.evaluate_expr_tree(cast_complete_tree, x)
      @test obj_casted_ex_t == obj_casted_cp_t
      @test typeof(obj_casted_ex_t) == t && typeof(obj_casted_cp_t) == t
    end
  end
end

@testset "test on ==/!= complete_expr_tree" begin
  Expr1 = :(x[1] + x[2])
  Expr2 = :(x[2] + x[2])
  Expr3 = :(x[2] + x[3] + x[4])
  Expr4 = :(x[2] + x[3] * x[4])
  expr_tree1 = ExpressionTreeForge.transform_to_expr_tree(Expr1)
  expr_tree2 = ExpressionTreeForge.transform_to_expr_tree(Expr2)
  expr_tree3 = ExpressionTreeForge.transform_to_expr_tree(Expr3)
  expr_tree4 = ExpressionTreeForge.transform_to_expr_tree(Expr4)
  complete_tree1 = ExpressionTreeForge.complete_tree(expr_tree1)
  complete_tree2 = ExpressionTreeForge.complete_tree(expr_tree2)
  complete_tree3 = ExpressionTreeForge.complete_tree(expr_tree3)
  complete_tree4 = ExpressionTreeForge.complete_tree(expr_tree4)
  complete_tree5 = copy(complete_tree1)

  @test complete_tree1 != complete_tree2

  @test complete_tree1 != complete_tree3
  @test complete_tree2 != complete_tree3

  @test complete_tree1 != complete_tree4
  @test complete_tree2 != complete_tree4
  @test complete_tree3 != complete_tree4

  @test complete_tree1 == complete_tree5
  @test complete_tree2 != complete_tree5
  @test complete_tree3 != complete_tree5
  @test complete_tree4 != complete_tree5

  ExpressionTreeForge.set_bounds!(complete_tree1)
  ExpressionTreeForge.set_bounds!(complete_tree2)
  ExpressionTreeForge.set_bounds!(complete_tree3)
  ExpressionTreeForge.set_bounds!(complete_tree4)

  ExpressionTreeForge.set_convexity!(complete_tree1)
  ExpressionTreeForge.set_convexity!(complete_tree2)
  ExpressionTreeForge.set_convexity!(complete_tree3)
  ExpressionTreeForge.set_convexity!(complete_tree4)

  @test complete_tree1 != complete_tree2

  @test complete_tree1 != complete_tree3
  @test complete_tree2 != complete_tree3

  @test complete_tree1 != complete_tree4
  @test complete_tree2 != complete_tree4
  @test complete_tree3 != complete_tree4

  @test complete_tree1 == complete_tree5
  @test complete_tree2 != complete_tree5
  @test complete_tree3 != complete_tree5
  @test complete_tree4 != complete_tree5
end

@testset "General tests" begin
  θ = 1e-5
  m = Model()
  n = 15
  @variable(m, x[1:n])
  @NLobjective(m, Min, sum((1 / 2) * ((x[j + 1] / (x[j]^2)) * x[j + 1]^3) for j = 1:(n - 1)))

  evaluator = JuMP.NLPEvaluator(m)
  MathOptInterface.initialize(evaluator, [:ExprGraph, :Hess])

  v = ones(n)
  Expr = MathOptInterface.objective_expr(evaluator)
  expr_tree = ExpressionTreeForge.transform_to_expr_tree(Expr)
  complete_tree = ExpressionTreeForge.complete_tree(expr_tree)

  complete_tree_cp = copy(complete_tree)
  expr_tree_trans = ExpressionTreeForge.transform_to_expr_tree(complete_tree)

  @test complete_tree_cp == complete_tree
  @test expr_tree_trans == expr_tree
end
