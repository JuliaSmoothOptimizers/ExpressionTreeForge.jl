using ExpressionTreeForge.M_trait_expr_tree, ExpressionTreeForge.M_trait_type_expr
using ExpressionTreeForge.M_abstract_expr_node, ExpressionTreeForge.M_abstract_expr_tree
using ExpressionTreeForge.algo_expr_tree, ExpressionTreeForge.algo_tree
using ExpressionTreeForge.M_implementation_expr_tree
using ExpressionTreeForge.M_evaluation_expr_tree

@testset "test building of trees and equality" begin
  expr_1 = :(x[1] + x[2])
  t_expr_1 = M_abstract_expr_tree.create_expr_tree(expr_1)
  @test t_expr_1 == expr_1
  @test M_trait_expr_tree.expr_tree_equal(t_expr_1, expr_1)

  t1 = M_trait_expr_tree.transform_to_expr_tree(t_expr_1)
  @test M_trait_expr_tree.expr_tree_equal(t1, t_expr_1)

  expr_2 = :((x[3] + x[4])^2 + x[1] * x[2])
  @test M_trait_expr_tree.expr_tree_equal(expr_1, expr_2) == false
  t_expr_2 = M_abstract_expr_tree.create_expr_tree(expr_2)
  @test t_expr_2 == expr_2
  t2 = M_trait_expr_tree.transform_to_expr_tree(t_expr_2)
  @test M_trait_expr_tree.expr_tree_equal(expr_2, t2)
  @test M_trait_expr_tree.expr_tree_equal(t_expr_2, t2)

  n3_1_1 = M_abstract_expr_tree.create_expr_tree(M_abstract_expr_node.create_node_expr(:x, 1))
  n3_1_2 = M_abstract_expr_tree.create_expr_tree(M_abstract_expr_node.create_node_expr(:x, 2))
  n3_1_op = M_abstract_expr_node.create_node_expr(:*)
  n3_1 = M_abstract_expr_tree.create_expr_tree(n3_1_op, [n3_1_1, n3_1_2])

  n3_2_1_1 = M_abstract_expr_tree.create_expr_tree(M_abstract_expr_node.create_node_expr(:x, 3))
  n3_2_1_2 = M_abstract_expr_tree.create_expr_tree(M_abstract_expr_node.create_node_expr(:x, 4))
  n3_2_1_op = M_abstract_expr_node.create_node_expr(:+)
  n3_2_1 = M_abstract_expr_tree.create_expr_tree(n3_2_1_op, [n3_2_1_1, n3_2_1_2])
  n3_2_op = M_abstract_expr_node.create_node_expr(:^, 2, true)
  n3_2 = M_abstract_expr_tree.create_expr_tree(n3_2_op, [n3_2_1])
  n3_op = M_abstract_expr_node.create_node_expr(:+)
  t3 = M_abstract_expr_tree.create_expr_tree(n3_op, [n3_2, n3_1])
  @test M_trait_expr_tree.expr_tree_equal(t_expr_2, t3)
  @test M_trait_expr_tree.expr_tree_equal(t2, t3)
end

@testset " Deletion of imbricated +" begin
  t_expr_4 = M_abstract_expr_tree.create_expr_tree(:((x[3] + x[4]) + (x[1] + x[2])))
  t4 = M_trait_expr_tree.transform_to_expr_tree(t_expr_4)
  res_t4 = algo_expr_tree.extract_element_functions(t4)
  res_t_expr_4 = algo_expr_tree.extract_element_functions(t_expr_4)
  test_res_t_expr_4 = [:(x[3]), :(x[4]), :(x[1]), :(x[2])]
  @test res_t_expr_4 == test_res_t_expr_4
  @test foldl(&, M_trait_expr_tree.expr_tree_equal.(res_t4, res_t_expr_4))

  t_expr_5 = M_abstract_expr_tree.create_expr_tree(:((x[3])^2 + (x[5] * x[4]) + (x[1] + x[2])))
  t5 = M_trait_expr_tree.transform_to_expr_tree(t_expr_5)
  res_t_expr_5 = algo_expr_tree.extract_element_functions(t_expr_5)
  res_t5 = algo_expr_tree.extract_element_functions(t5)
  test_res_t_expr_5 = [:(x[3]^2), :(x[5] * x[4]), :(x[1]), :(x[2])]
  @test res_t_expr_5 == test_res_t_expr_5
  @test foldl(&, M_trait_expr_tree.expr_tree_equal.(res_t5, res_t_expr_5))

  t_expr_6 = M_abstract_expr_tree.create_expr_tree(:((x[3])^2 + (x[5] * x[4]) - (x[1] + x[2])))
  t6 = M_trait_expr_tree.transform_to_expr_tree(t_expr_6)
  res_t_expr_6 = algo_expr_tree.extract_element_functions(t_expr_6)
  res_t6 = algo_expr_tree.extract_element_functions(t6)
  test_res_t_expr_6 = [:(x[3]^2), :(x[5] * x[4]), :(-(x[1])), :(-(x[2]))]
  @test res_t_expr_6 == test_res_t_expr_6
  @test foldl(&, M_trait_expr_tree.expr_tree_equal.(res_t6, res_t_expr_6))

  t_expr_7 = M_abstract_expr_tree.create_expr_tree(:((x[3])^2 + (x[5] * x[4]) - (x[1] - x[2])))
  t7 = M_trait_expr_tree.transform_to_expr_tree(t_expr_7)
  res_t_expr_7 = algo_expr_tree.extract_element_functions(t_expr_7)
  res_t7 = algo_expr_tree.extract_element_functions(t7)
  test_res_t_expr_7 = [:(x[3]^2), :(x[5] * x[4]), :(-(x[1])), :(-(-(x[2])))]
  @test res_t_expr_7 == test_res_t_expr_7
  @test foldl(&, M_trait_expr_tree.expr_tree_equal.(res_t7, res_t_expr_7))
end

@testset "get type of a expr tree" begin
  t_expr_8 = M_abstract_expr_tree.create_expr_tree(:((x[3]^4) + (x[5] * x[4]) - (x[1] - x[2])))
  t8 = M_trait_expr_tree.transform_to_expr_tree(t_expr_8)

  test_res8 = algo_expr_tree.get_type_tree(t_expr_8)
  test_res_t8 = algo_expr_tree.get_type_tree(t8)
  @test test_res8 == test_res_t8
  @test M_trait_type_expr.is_more(test_res_t8)

  t_expr_cubic = M_abstract_expr_tree.create_expr_tree(:((x[3]^3) + (x[5] * x[4]) - (x[1] - x[2])))
  t_cubic = M_trait_expr_tree.transform_to_expr_tree(t_expr_cubic)

  res_cubic = algo_expr_tree.get_type_tree(t_expr_cubic)
  res_t_cubic = algo_expr_tree.get_type_tree(t_cubic)
  @test res_cubic == res_t_cubic
  @test M_trait_type_expr._is_cubic(res_t_cubic)

  t_expr_cubic2 =
    M_abstract_expr_tree.create_expr_tree(:((x[3]^3) + (x[5] * x[4]) - (x[1] - x[2]) + sin(5)))
  t_cubic2 = M_trait_expr_tree.transform_to_expr_tree(t_expr_cubic2)

  res_cubic2 = algo_expr_tree.get_type_tree(t_expr_cubic2)
  res_t_cubic2 = algo_expr_tree.get_type_tree(t_cubic2)
  @test res_cubic2 == res_t_cubic2
  @test M_trait_type_expr._is_cubic(res_t_cubic2)

  t_expr_sin = M_abstract_expr_tree.create_expr_tree(:((x[3]^3) + sin(x[5] * x[4]) - (x[1] - x[2])))
  t_sin = M_trait_expr_tree.transform_to_expr_tree(t_expr_sin)

  res_sin = algo_expr_tree.get_type_tree(t_expr_sin)
  res_t_sin = algo_expr_tree.get_type_tree(t_sin)
  @test res_sin == res_t_sin
  @test M_trait_type_expr.is_more(res_t_sin)

  m = Model()
  n_x = 100
  @variable(m, x[1:n_x])
  @NLobjective(m, Min, sum((x[j] * x[j + 1] for j = 1:(n_x - 1))))
  eval_test = JuMP.NLPEvaluator(m)
  MathOptInterface.initialize(eval_test, [:ExprGraph])
  obj = MathOptInterface.objective_expr(eval_test)
  t_obj = M_trait_expr_tree.transform_to_expr_tree(obj)

  test_res_obj = algo_expr_tree.get_type_tree(t_obj)
  @test M_trait_type_expr._is_quadratic(test_res_obj)
  @test M_trait_type_expr.is_more(test_res_obj) == false

  t_expr_9 = M_abstract_expr_tree.create_expr_tree(:(x[1] + sin(x[2])))
  res_t_expr_9 = algo_expr_tree.extract_element_functions(t_expr_9)

  @test M_trait_type_expr.is_linear(algo_expr_tree.get_type_tree(t_expr_9)) == false
  @test M_trait_type_expr.is_more(algo_expr_tree.get_type_tree(t_expr_9))
end

@testset "Retrieve the elemental variables" begin
  t_expr_var = M_abstract_expr_tree.create_expr_tree(:((x[1]^3) + sin(x[1] * x[2]) - (x[3] - x[2])))
  t_var = M_trait_expr_tree.transform_to_expr_tree(t_expr_var)
  res = algo_expr_tree.get_elemental_variables(t_var)
  res2 = algo_expr_tree.get_elemental_variables(t_expr_var)
  @test res == res2
  @test res == [1, 2, 3]
  t_expr_var1 = M_abstract_expr_tree.create_expr_tree(:((x[1]^3)))
  t_var1 = M_trait_expr_tree.transform_to_expr_tree(t_expr_var1)
  res_expr_var1 = algo_expr_tree.get_elemental_variables(t_expr_var1)
  res_var1 = algo_expr_tree.get_elemental_variables(t_var1)
  @test res_var1 == res_expr_var1
  @test res_var1 == [1]
end

@testset "Compare to a JuMP model" begin
  m = Model()
  n_x = 10
  @variable(m, x[1:n_x])
  @NLobjective(m, Min, sum(x[j] * x[j + 1] for j = 1:(n_x - 1)) + (sin(x[1]))^2 + x[n_x - 1]^3 + 5)
  eval_test = JuMP.NLPEvaluator(m)
  MathOptInterface.initialize(eval_test, [:ExprGraph])
  obj = MathOptInterface.objective_expr(eval_test)
  t_obj = M_trait_expr_tree.transform_to_expr_tree(obj)
  elmt_fun = algo_expr_tree.extract_element_functions(obj)
  type_elmt_fun = algo_expr_tree.get_type_tree.(elmt_fun)
  U = algo_expr_tree.get_elemental_variables.(elmt_fun)

  t_elmt_fun = algo_expr_tree.extract_element_functions(t_obj)
  t_type_elmt_fun = algo_expr_tree.get_type_tree.(t_elmt_fun)
  t_U = algo_expr_tree.get_elemental_variables.(t_elmt_fun)

  x = ones(Float32, n_x)
  eval_ones = 15.708073371141893
  @test foldl(&, M_trait_expr_tree.expr_tree_equal.(elmt_fun, t_elmt_fun))
  @test type_elmt_fun == t_type_elmt_fun
  res_elemental_variable = Array{Int64, 1}[
    [1, 2],
    [2, 3],
    [3, 4],
    [4, 5],
    [5, 6],
    [6, 7],
    [7, 8],
    [8, 9],
    [9, 10],
    [1],
    [9],
    [],
  ]

  @test U == t_U
  @test U == res_elemental_variable
  res = M_evaluation_expr_tree.evaluate_expr_tree(obj, x)
  t_res = M_evaluation_expr_tree.evaluate_expr_tree(t_obj, x)
  @test res == (Float32)(eval_ones)

  n_element = length(elmt_fun)
  res_p = Vector{Number}(undef, n_element)
  for i = 1:n_element
    res_p[i] = M_evaluation_expr_tree.evaluate_expr_tree(elmt_fun[i], x)
  end
  res_total = sum(res_p)
  @test (typeof(res))(res_total) == res
end

function expr_tree_factorielle_dif_node(n::Integer)
  if n == 0
    constant_node = M_abstract_expr_node.create_node_expr(:x, 1)
    new_leaf = M_abstract_expr_tree.create_expr_tree(constant_node)
    return new_leaf
  else
    if n % 3 == 0
      op_node = M_abstract_expr_node.create_node_expr(:+)
      new_node = M_abstract_expr_tree.create_expr_tree(
        op_node,
        expr_tree_factorielle_dif_node.((n - 1) * ones(Integer, n)),
      )
      return new_node
    elseif n % 3 == 1
      op_node = M_abstract_expr_node.create_node_expr(:-)
      new_node = M_abstract_expr_tree.create_expr_tree(
        op_node,
        expr_tree_factorielle_dif_node.((n - 1) * ones(Integer, n)),
      )
      return new_node
    elseif n % 3 == 2
      op_node = M_abstract_expr_node.create_node_expr(:*)
      new_node = M_abstract_expr_tree.create_expr_tree(
        op_node,
        expr_tree_factorielle_dif_node.((n - 1) * ones(Integer, n)),
      )
      return new_node
    end
  end
end

function expr_tree_factorielle_plus(n::Integer, op::Symbol)
  if n == 0
    constant_node = M_abstract_expr_node.create_node_expr(1)
    new_leaf = M_abstract_expr_tree.create_expr_tree(constant_node)
    return new_leaf
  else
    op_node = M_abstract_expr_node.create_node_expr(op)
    new_node = M_abstract_expr_tree.create_expr_tree(
      op_node,
      expr_tree_factorielle_plus.((n - 1) * ones(Integer, n), op),
    )
    return new_node
  end
end

@testset "Factorial tree divide the terms + and get_type " begin
  n = 5
  @time test_fac_expr_tree_plus =
    expr_tree_factorielle_plus(n, :+)::M_implementation_expr_tree.Type_expr_tree
  test_fac_expr_tree_plus_no_plus = algo_expr_tree.extract_element_functions(test_fac_expr_tree_plus)
  algo_expr_tree.get_type_tree(test_fac_expr_tree_plus)
  res3 = algo_expr_tree.get_elemental_variables(test_fac_expr_tree_plus)
  res = M_evaluation_expr_tree.evaluate_expr_tree(test_fac_expr_tree_plus, ones(5))
  @test res == factorial(n)
end

function create_trees(n::Int)
  m = Model()
  @variable(m, x[1:n])
  @NLobjective(
    m,
    Min,
    sum((1 / 2) * (x[j + 1] / (x[j]^2)) + sin(x[j + 1]^3) for j = 1:(n - 1)) +
    tan(x[1]) * 1 / x[3] +
    exp(x[2]) - 4
  )
  evaluator = JuMP.NLPEvaluator(m)
  MathOptInterface.initialize(evaluator, [:ExprGraph, :Hess])
  Expr_j = MathOptInterface.objective_expr(evaluator)
  expr_tree = ExpressionTreeForge.transform_to_expr_tree(Expr_j)
  expr_tree_j = copy(expr_tree)
  complete_tree = ExpressionTreeForge.complete_tree(expr_tree_j)

  return Expr_j, expr_tree_j, complete_tree, evaluator
end

@testset "Create a evaluation function" begin
  n = 50
  expr, expr_tree, comp_tree, evaluator = create_trees(n)
  f = ExpressionTreeForge.get_function_of_evaluation(expr_tree)
  x = ones(50)
  obj_MOI_x = MathOptInterface.eval_objective(evaluator, x)
  obj_f = ExpressionTreeForge.algo_expr_tree.eval_function_wrapper(f, x)
  @test obj_f == obj_MOI_x
  @test obj_f ≈ obj_MOI_x
end
