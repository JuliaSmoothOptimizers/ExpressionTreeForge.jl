using ExpressionTreeForge.M_abstract_expr_node, ExpressionTreeForge.M_trait_expr_node
using ExpressionTreeForge.M_variable, ExpressionTreeForge.M_constant
using ExpressionTreeForge.M_simple_operator
using ExpressionTreeForge.M_plus_operator,
  ExpressionTreeForge.M_minus_operator,
  ExpressionTreeForge.M_times_operator,
  ExpressionTreeForge.M_sinus_operator,
  ExpressionTreeForge.M_tan_operator,
  ExpressionTreeForge.M_power_operator,
  ExpressionTreeForge.M_frac_operator,
  ExpressionTreeForge.M_exp_operator

@testset "Node constructors" begin
  @test M_abstract_expr_node.create_node_expr(4) == M_constant.Constant(4)
  @test M_abstract_expr_node.create_node_expr(:x, 5) == M_variable.Variable(:x, 5)
  @test M_abstract_expr_node.create_node_expr(:x, MathOptInterface.VariableIndex(5)) ==
        M_variable.Variable(:x, 5)
  @test M_abstract_expr_node.create_node_expr(:x, MathOptInterface.VariableIndex(5)) ==
        M_abstract_expr_node.create_node_expr(:x, 5)

  @test M_abstract_expr_node.create_node_expr(:+) == M_plus_operator.Plus_operator()
  @test M_abstract_expr_node.create_node_expr(:-) == M_minus_operator.Minus_operator()
  @test M_abstract_expr_node.create_node_expr(:*) == M_times_operator.Time_operator()
  @test M_abstract_expr_node.create_node_expr(:sin) == M_sinus_operator.Sinus_operator()
  @test M_abstract_expr_node.create_node_expr(:tan) == M_tan_operator.Tan_operator()
  @test M_abstract_expr_node.create_node_expr(:exp) == M_exp_operator.Exp_operator()
  @test M_abstract_expr_node.create_node_expr(:/) == M_frac_operator.Frac_operator()

  @test M_abstract_expr_node.create_node_expr(:^, 2, true) == M_power_operator.Power_operator(2)
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
  @test M_trait_expr_node.node_is_minus.(coll_simple_op) ==
        [false, true, false, false, false, false]
  @test M_trait_expr_node.node_is_times.(coll_simple_op) ==
        [false, false, true, false, false, false]
  @test M_trait_expr_node.node_is_sin.(coll_simple_op) == [false, false, false, true, false, false]
  @test M_trait_expr_node.node_is_cos.(coll_simple_op) == [false, false, false, false, true, false]
  @test M_trait_expr_node.node_is_tan.(coll_simple_op) == [false, false, false, false, false, true]
  @test M_trait_expr_node.node_is_power.(coll_simple_op) ==
        [false, false, false, false, false, false]
  @test M_trait_expr_node.node_is_constant.(coll_simple_op) ==
        [false, false, false, false, false, false]
  @test M_trait_expr_node.node_is_variable.(coll_simple_op) ==
        [false, false, false, false, false, false]
  @test M_trait_expr_node.get_var_index(variable) == 5

  @test M_trait_expr_node.node_is_operator(power_operator) == true
  @test M_trait_expr_node.node_is_plus(power_operator) == false
  @test M_trait_expr_node.node_is_minus(power_operator) == false
  @test M_trait_expr_node.node_is_times(power_operator) == false
  @test M_trait_expr_node.node_is_sin(power_operator) == false
  @test M_trait_expr_node.node_is_cos(power_operator) == false
  @test M_trait_expr_node.node_is_tan(power_operator) == false
  @test M_trait_expr_node.node_is_power(power_operator) == true
  @test M_trait_expr_node.node_is_constant(power_operator) == false
  @test M_trait_expr_node.node_is_variable(power_operator) == false

  @test M_trait_expr_node.node_is_operator(constant) == false
  @test M_trait_expr_node.node_is_plus(constant) == false
  @test M_trait_expr_node.node_is_minus(constant) == false
  @test M_trait_expr_node.node_is_times(constant) == false
  @test M_trait_expr_node.node_is_sin(constant) == false
  @test M_trait_expr_node.node_is_cos(constant) == false
  @test M_trait_expr_node.node_is_tan(constant) == false
  @test M_trait_expr_node.node_is_power(constant) == false
  @test M_trait_expr_node.node_is_constant(constant) == true
  @test M_trait_expr_node.node_is_variable(constant) == false

  @test M_trait_expr_node.node_is_operator(variable) == false
  @test M_trait_expr_node.node_is_plus(variable) == false
  @test M_trait_expr_node.node_is_minus(variable) == false
  @test M_trait_expr_node.node_is_times(variable) == false
  @test M_trait_expr_node.node_is_sin(variable) == false
  @test M_trait_expr_node.node_is_cos(variable) == false
  @test M_trait_expr_node.node_is_tan(variable) == false
  @test M_trait_expr_node.node_is_power(variable) == false
  @test M_trait_expr_node.node_is_constant(variable) == false
  @test M_trait_expr_node.node_is_variable(variable) == true
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
