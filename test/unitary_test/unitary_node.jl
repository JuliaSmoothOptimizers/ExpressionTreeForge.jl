using CalculusTreeTools.M_abstract_expr_node, CalculusTreeTools.M_trait_expr_node
using CalculusTreeTools.M_variable, CalculusTreeTools.M_constant
using CalculusTreeTools.M_simple_operator
using CalculusTreeTools.M_plus_operator,
  CalculusTreeTools.M_minus_operator,
  CalculusTreeTools.M_times_operator,
  CalculusTreeTools.M_sinus_operator,
  CalculusTreeTools.M_tan_operator,
  CalculusTreeTools.M_power_operator,
  CalculusTreeTools.M_frac_operator,
  CalculusTreeTools.M_exp_operator

@testset "Node constructors" begin
  @test M_abstract_expr_node.create_node_expr(4) == M_constant.Constant(4)
  @test M_abstract_expr_node.create_node_expr(:x, 5) ==M_variable.variable(:x, 5)
  @test M_abstract_expr_node.create_node_expr(:x, MathOptInterface.VariableIndex(5)) ==
       M_variable.variable(:x, 5)
  @test M_abstract_expr_node.create_node_expr(:x, MathOptInterface.VariableIndex(5)) ==
        M_abstract_expr_node.create_node_expr(:x, 5)

  @test M_abstract_expr_node.create_node_expr(:+) == M_plus_operator.plus_operator()
  @test M_abstract_expr_node.create_node_expr(:-) == M_minus_operator.Minus_operator()
  @test M_abstract_expr_node.create_node_expr(:*) == M_times_operator.time_operator()
  @test M_abstract_expr_node.create_node_expr(:sin) == M_sinus_operator.sinus_operator()
  @test M_abstract_expr_node.create_node_expr(:tan) == M_tan_operator.tan_operator()
  @test M_abstract_expr_node.create_node_expr(:exp) == M_exp_operator.Exp_operator()
  @test M_abstract_expr_node.create_node_expr(:/) == M_frac_operator.Frac_operator()

  @test M_abstract_expr_node.create_node_expr(:^, 2, true) == M_power_operator.power_operator(2)
end

@testset "Comparisons operators" begin
  constant = M_abstract_expr_node.create_node_expr(4)
  variable = M_abstract_expr_node.create_node_expr(:x, 5)
  times = M_abstract_expr_node.create_node_expr(:*)
  plus = M_abstract_expr_node.create_node_expr(:+)
  minus = M_abstract_expr_node.create_node_expr(:-)
  power_operator = M_abstract_expr_node.create_node_expr(:^, 2, true)
  exp = M_abstract_expr_node.create_node_expr(:exp)
  frac = M_abstract_expr_node.create_node_expr(:/)
  collection = [constant, variable, times, power_operator, plus, minus, exp, frac]

  @test M_trait_expr_node.is_expr_node.(vcat(collection, [:+, :*])) == [
    M_trait_expr_node.Type_expr_node(),
    M_trait_expr_node.Type_expr_node(),
    M_trait_expr_node.Type_expr_node(),
    M_trait_expr_node.Type_expr_node(),
    M_trait_expr_node.Type_expr_node(),
    M_trait_expr_node.Type_expr_node(),
    M_trait_expr_node.Type_expr_node(),
    M_trait_expr_node.Type_expr_node(),
    M_trait_expr_node.Type_not_expr_node(),
    M_trait_expr_node.Type_not_expr_node(),
  ]
  @test M_trait_expr_node.node_is_operator.(collection) ==
        [false, false, true, true, true, true, true, true]
  @test M_trait_expr_node.node_is_constant.(collection) ==
        [true, false, false, false, false, false, false, false]
  @test M_trait_expr_node.node_is_variable.(collection) ==
        [false, true, false, false, false, false, false, false]

  coll_simple_op = [
    M_abstract_expr_node.create_node_expr(:+),
    M_abstract_expr_node.create_node_expr(:-),
    M_abstract_expr_node.create_node_expr(:*),
    M_abstract_expr_node.create_node_expr(:sin),
    M_abstract_expr_node.create_node_expr(:cos),
    M_abstract_expr_node.create_node_expr(:tan),
  ]

  @test M_trait_expr_node.is_expr_node.(coll_simple_op) == [
    M_trait_expr_node.Type_expr_node(),
    M_trait_expr_node.Type_expr_node(),
    M_trait_expr_node.Type_expr_node(),
    M_trait_expr_node.Type_expr_node(),
    M_trait_expr_node.Type_expr_node(),
    M_trait_expr_node.Type_expr_node(),
  ]
  @test M_trait_expr_node.node_is_operator.(coll_simple_op) == [true, true, true, true, true, true]
  @test M_trait_expr_node.node_is_plus.(coll_simple_op) == [true, false, false, false, false, false]
  @test M_trait_expr_node.node_is_minus.(coll_simple_op) == [false, true, false, false, false, false]
  @test M_trait_expr_node.node_is_times.(coll_simple_op) == [false, false, true, false, false, false]
  @test M_trait_expr_node.node_is_sin.(coll_simple_op) == [false, false, false, true, false, false]
  @test M_trait_expr_node.node_is_cos.(coll_simple_op) == [false, false, false, false, true, false]
  @test M_trait_expr_node.node_is_tan.(coll_simple_op) == [false, false, false, false, false, true]
  @test M_trait_expr_node.node_is_power.(coll_simple_op) == [false, false, false, false, false, false]
  @test M_trait_expr_node.node_is_constant.(coll_simple_op) ==
        [false, false, false, false, false, false]
  @test M_trait_expr_node.node_is_variable.(coll_simple_op) ==
        [false, false, false, false, false, false]
  @test M_trait_expr_node.get_var_index(variable) == 5
end

@testset "Node evaluation" begin
  constant = M_abstract_expr_node.create_node_expr(4.0)
  variable = M_abstract_expr_node.create_node_expr(:x, 5)
  product = M_abstract_expr_node.create_node_expr(:*)
  plus = M_abstract_expr_node.create_node_expr(:+)
  minus = M_abstract_expr_node.create_node_expr(:-)
  power_operator = M_abstract_expr_node.create_node_expr(:^, 2, true)
  collection = [constant, variable, product, power_operator, plus, minus]

  @test M_trait_expr_node.evaluate_node(constant, zeros(0)) == 4
  @test M_trait_expr_node.evaluate_node(variable, zeros(5)) == 0
  @test M_trait_expr_node.evaluate_node(variable, [1:5;]) == 5
  @test M_trait_expr_node.evaluate_node(product, [1:5;]) == foldl(*, [1:5;])
  @test M_trait_expr_node.evaluate_node(plus, [1:5;]) == sum([1:5;])
  @test M_trait_expr_node.evaluate_node(minus, [1, 5]) == -4
  @test M_trait_expr_node.evaluate_node(minus, [1]) == -1
  @test M_trait_expr_node.evaluate_node(power_operator, [1]) == 1
  @test M_trait_expr_node.evaluate_node(power_operator, [2]) == 4
  @test M_trait_expr_node._evaluate_node(power_operator, 2) == 4
end
