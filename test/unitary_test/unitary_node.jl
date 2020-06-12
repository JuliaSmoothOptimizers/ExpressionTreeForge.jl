using ..abstract_expr_node, ..trait_expr_node

using ..variables
using ..constants
using ..plus_operators, ..minus_operators, ..times_operators, ..sinus_operators, ..tan_operators, ..power_operators, ..frac_operators, ..exp_operators
using ..simple_operators
using ..complex_operators

using Test
using MathOptInterface


@testset "test des constructeurs node" begin
    @test abstract_expr_node.create_node_expr(4) == constants.constant(4)


    @test abstract_expr_node.create_node_expr(:x, 5) == variables.variable(:x, 5)
    @test abstract_expr_node.create_node_expr(:x, MathOptInterface.VariableIndex(5)) == variables.variable(:x, 5)

    @test abstract_expr_node.create_node_expr(:x, MathOptInterface.VariableIndex(5)) == abstract_expr_node.create_node_expr(:x, 5)

    @test abstract_expr_node.create_node_expr(:+) == plus_operators.plus_operator()
    @test abstract_expr_node.create_node_expr(:-) == minus_operators.minus_operator()
    @test abstract_expr_node.create_node_expr(:*) == times_operators.time_operator()
    @test abstract_expr_node.create_node_expr(:sin) == sinus_operators.sinus_operator()
    @test abstract_expr_node.create_node_expr(:tan) == tan_operators.tan_operator()
    @test abstract_expr_node.create_node_expr(:exp) == exp_operators.exp_operator()
    @test abstract_expr_node.create_node_expr(:/) == frac_operators.frac_operator()

    @test abstract_expr_node.create_node_expr(:^,2, true ) == power_operators.power_operator(2)
    @test abstract_expr_node.create_node_expr(:^,[2]) == complex_operators.complex_operator(:^,[2])

end

@testset "test des fonctions de tests" begin

    constant = abstract_expr_node.create_node_expr(4)
    variable = abstract_expr_node.create_node_expr(:x, 5)
    times = abstract_expr_node.create_node_expr(:*)
    plus = abstract_expr_node.create_node_expr(:+)
    minus = abstract_expr_node.create_node_expr(:-)
    power_operator = abstract_expr_node.create_node_expr(:^,2, true )
    exp = abstract_expr_node.create_node_expr(:exp)
    frac = abstract_expr_node.create_node_expr(:/)
    collection = [constant, variable, times, power_operator, plus, minus, exp, frac]

    @test trait_expr_node.is_expr_node.( vcat(collection,[:+, :*]) ) == [trait_expr_node.type_expr_node(), trait_expr_node.type_expr_node(), trait_expr_node.type_expr_node(), trait_expr_node.type_expr_node(), trait_expr_node.type_expr_node(), trait_expr_node.type_expr_node(), trait_expr_node.type_expr_node(), trait_expr_node.type_expr_node(), trait_expr_node.type_not_expr_node(), trait_expr_node.type_not_expr_node()]
    @test trait_expr_node.node_is_operator.( collection ) == [false, false, true, true, true, true, true ,true ]
    @test trait_expr_node.node_is_constant.( collection ) == [true, false, false, false, false, false, false, false]
    @test trait_expr_node.node_is_variable.( collection ) == [false, true, false, false, false, false, false, false]




    coll_simple_op = [ abstract_expr_node.create_node_expr(:+), abstract_expr_node.create_node_expr(:-), abstract_expr_node.create_node_expr(:*), abstract_expr_node.create_node_expr(:sin), abstract_expr_node.create_node_expr(:cos), abstract_expr_node.create_node_expr(:tan)]

    @test trait_expr_node.is_expr_node.(coll_simple_op) == [trait_expr_node.type_expr_node(), trait_expr_node.type_expr_node(), trait_expr_node.type_expr_node(), trait_expr_node.type_expr_node(), trait_expr_node.type_expr_node(), trait_expr_node.type_expr_node()]
    @test trait_expr_node.node_is_operator.(coll_simple_op) == [true, true, true, true, true, true]
    @test trait_expr_node.node_is_plus.(coll_simple_op) == [true, false, false, false, false, false]
    @test trait_expr_node.node_is_minus.(coll_simple_op) == [false, true, false, false, false, false]
    @test trait_expr_node.node_is_times.(coll_simple_op) == [false, false, true, false, false, false]
    @test trait_expr_node.node_is_sin.(coll_simple_op) == [false, false, false, true, false, false]
    @test trait_expr_node.node_is_cos.(coll_simple_op) == [false, false, false, false, true, false]
    @test trait_expr_node.node_is_tan.(coll_simple_op) == [false, false, false, false, false, true]
    @test trait_expr_node.node_is_power.(coll_simple_op) == [false, false, false, false, false, false]

    @test trait_expr_node.node_is_constant.(coll_simple_op) == [false, false, false, false, false, false]
    @test trait_expr_node.node_is_variable.(coll_simple_op) == [false, false, false, false, false, false]

    @test trait_expr_node.get_var_index(variable) == 5
end



@testset "evaluation des noeuds" begin
    constant = abstract_expr_node.create_node_expr(4.0)
    variable = abstract_expr_node.create_node_expr(:x, 5)
    product = abstract_expr_node.create_node_expr(:*)
    plus = abstract_expr_node.create_node_expr(:+)
    minus = abstract_expr_node.create_node_expr(:-)
    power_operator = abstract_expr_node.create_node_expr(:^,2, true )
    collection = [constant, variable, product, power_operator, plus, minus]

    @test trait_expr_node.evaluate_node(constant,zeros(0)) == 4
    @test trait_expr_node.evaluate_node(variable,zeros(5)) == 0
    @test trait_expr_node.evaluate_node(variable, [1:5;]) == 5
    @test trait_expr_node.evaluate_node(product, [1:5;]) == foldl(*, [1:5;])
    @test trait_expr_node.evaluate_node(plus, [1:5;]) == sum([1:5;])
    @test trait_expr_node.evaluate_node(minus, [1,5]) == -4
    @test trait_expr_node.evaluate_node(minus, [1]) == -1
    @test trait_expr_node.evaluate_node(power_operator, [1]) == 1
    @test trait_expr_node.evaluate_node(power_operator, [2]) == 4
    @test trait_expr_node._evaluate_node(power_operator, 2) == 4

end
