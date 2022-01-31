using CalculusTreeTools.trait_type_expr
using CalculusTreeTools.implementation_type_expr, CalculusTreeTools.implementation_convexity_type, CalculusTreeTools.implementation_convexity_type

@testset "test implementation_type_expr" begin

    # vérification des fonction renvoyant des booléens
    @test implementation_type_expr._is_constant(implementation_type_expr.return_constant())
    @test implementation_type_expr._is_constant(implementation_type_expr.return_linear()) == false
    @test implementation_type_expr._is_constant(implementation_type_expr.return_quadratic()) == false
    @test implementation_type_expr._is_constant(implementation_type_expr.return_cubic()) == false
    @test implementation_type_expr._is_constant(implementation_type_expr.return_more()) == false

    @test implementation_type_expr._is_linear(implementation_type_expr.return_constant()) == false
    @test implementation_type_expr._is_linear(implementation_type_expr.return_linear())
    @test implementation_type_expr._is_linear(implementation_type_expr.return_quadratic()) == false
    @test implementation_type_expr._is_linear(implementation_type_expr.return_cubic()) == false
    @test implementation_type_expr._is_linear(implementation_type_expr.return_more()) == false

    @test implementation_type_expr._is_quadratic(implementation_type_expr.return_constant()) == false
    @test implementation_type_expr._is_quadratic(implementation_type_expr.return_linear()) == false
    @test implementation_type_expr._is_quadratic(implementation_type_expr.return_quadratic())
    @test implementation_type_expr._is_quadratic(implementation_type_expr.return_cubic()) == false
    @test implementation_type_expr._is_quadratic(implementation_type_expr.return_more()) == false

    @test implementation_type_expr._is_cubic(implementation_type_expr.return_constant()) == false
    @test implementation_type_expr._is_cubic(implementation_type_expr.return_linear()) == false
    @test implementation_type_expr._is_cubic(implementation_type_expr.return_quadratic()) == false
    @test implementation_type_expr._is_cubic(implementation_type_expr.return_cubic())
    @test implementation_type_expr._is_cubic(implementation_type_expr.return_more()) == false

    @test implementation_type_expr._is_more(implementation_type_expr.return_constant()) == false
    @test implementation_type_expr._is_more(implementation_type_expr.return_linear()) == false
    @test implementation_type_expr._is_more(implementation_type_expr.return_quadratic()) == false
    @test implementation_type_expr._is_more(implementation_type_expr.return_cubic()) == false
    @test implementation_type_expr._is_more(implementation_type_expr.return_more())

    # défintion de variable étant du même type que leur nom
    constante = implementation_type_expr.return_constant()
    linear = implementation_type_expr.return_linear()
    quadratic = implementation_type_expr.return_quadratic()
    cubic = implementation_type_expr.return_cubic()
    more = implementation_type_expr.return_more()
    all_types = [constante, linear, quadratic, cubic, more]

    # test de la fonction _type_product
    @test (x -> implementation_type_expr._type_product(constante, x)).(all_types) == all_types
    @test (x -> implementation_type_expr._type_product(linear, x)).(all_types) == [linear, quadratic, cubic, more, more]
    @test (x -> implementation_type_expr._type_product(quadratic, x)).(all_types) == [quadratic, cubic, more, more, more]
    @test (x -> implementation_type_expr._type_product(cubic, x)).(all_types) == [cubic, more, more, more, more]
    @test (x -> implementation_type_expr._type_product(cubic, x)).(all_types) == [cubic, more, more, more, more]
    @test (x -> implementation_type_expr._type_product(more, x)).(all_types) == [more, more, more, more, more]

    # test de _type_power
    @test (x -> implementation_type_expr._type_power(0, x)).(all_types) == [constante, constante, constante, constante, constante]
    @test (x -> implementation_type_expr._type_power(1, x)).(all_types) == all_types
    @test (x -> implementation_type_expr._type_power(2, x)).(all_types) == [constante, quadratic, more, more, more]
    @test (x -> implementation_type_expr._type_power(3, x)).(all_types) == [constante, cubic, more, more, more]
    @test (x -> implementation_type_expr._type_power(4, x)).(all_types) == [constante, more, more, more, more]


#=-----------------------------------------------------------------------------------------------------------------------------------=#

    # vérification des fonction renvoyant des booléens
    @test trait_type_expr.is_constant(implementation_type_expr.return_constant())
    @test trait_type_expr.is_constant(implementation_type_expr.return_linear()) == false
    @test trait_type_expr.is_constant(implementation_type_expr.return_quadratic()) == false
    @test trait_type_expr.is_constant(implementation_type_expr.return_cubic()) == false
    @test trait_type_expr.is_constant(implementation_type_expr.return_more()) == false

    @test trait_type_expr.is_linear(implementation_type_expr.return_constant()) == false
    @test trait_type_expr.is_linear(implementation_type_expr.return_linear())
    @test trait_type_expr.is_linear(implementation_type_expr.return_quadratic()) == false
    @test trait_type_expr.is_linear(implementation_type_expr.return_cubic()) == false
    @test trait_type_expr.is_linear(implementation_type_expr.return_more()) == false

    @test trait_type_expr.is_quadratic(implementation_type_expr.return_constant()) == false
    @test trait_type_expr.is_quadratic(implementation_type_expr.return_linear()) == false
    @test trait_type_expr.is_quadratic(implementation_type_expr.return_quadratic())
    @test trait_type_expr.is_quadratic(implementation_type_expr.return_cubic()) == false
    @test trait_type_expr.is_quadratic(implementation_type_expr.return_more()) == false

    @test trait_type_expr.is_cubic(implementation_type_expr.return_constant()) == false
    @test trait_type_expr.is_cubic(implementation_type_expr.return_linear()) == false
    @test trait_type_expr.is_cubic(implementation_type_expr.return_quadratic()) == false
    @test trait_type_expr.is_cubic(implementation_type_expr.return_cubic())
    @test trait_type_expr.is_cubic(implementation_type_expr.return_more()) == false

    @test trait_type_expr.is_more(implementation_type_expr.return_constant()) == false
    @test trait_type_expr.is_more(implementation_type_expr.return_linear()) == false
    @test trait_type_expr.is_more(implementation_type_expr.return_quadratic()) == false
    @test trait_type_expr.is_more(implementation_type_expr.return_cubic()) == false
    @test trait_type_expr.is_more(implementation_type_expr.return_more())

    # test de la fonction _type_product

    @test (x -> trait_type_expr.type_product(constante, x)).(all_types) == all_types
    @test (x -> trait_type_expr.type_product(linear, x)).(all_types) == [linear, quadratic, cubic, more, more]
    @test (x -> trait_type_expr.type_product(quadratic, x)).(all_types) == [quadratic, cubic, more, more, more]
    @test (x -> trait_type_expr.type_product(cubic, x)).(all_types) == [cubic, more, more, more, more]
    @test (x -> trait_type_expr.type_product(cubic, x)).(all_types) == [cubic, more, more, more, more]
    @test (x -> trait_type_expr.type_product(more, x)).(all_types) == [more, more, more, more, more]

    # test de _type_power
    @test (x -> trait_type_expr.type_power(0, x)).(all_types) == [constante, constante, constante, constante, constante]
    @test (x -> trait_type_expr.type_power(1, x)).(all_types) == all_types
    @test (x -> trait_type_expr.type_power(2, x)).(all_types) == [constante, quadratic, more, more, more]
    @test (x -> trait_type_expr.type_power(3, x)).(all_types) == [constante, cubic, more, more, more]
    @test (x -> trait_type_expr.type_power(4, x)).(all_types) == [constante, more, more, more, more]

end

@testset "Convexity" begin
	not_treated = implementation_convexity_type.not_treated_type()
	cst = implementation_convexity_type.constant_type()
	lnr = implementation_convexity_type.linear_type()
	convex = implementation_convexity_type.convex_type()
	concave = implementation_convexity_type.concave_type()
	unknown = implementation_convexity_type.unknown_type()
	all_status = [not_treated, cst, lnr, convex, concave, unknown]

	@test (x -> implementation_convexity_type.is_treated(x)).(all_status) == [false, true, true, true, true, true]
	@test (x -> implementation_convexity_type.is_not_treated(x)).(all_status) == [true, false, false, false, false, false]
	@test (x -> implementation_convexity_type.is_constant(x)).(all_status) == [false, true, false, false, false, false]
	@test (x -> implementation_convexity_type.is_linear(x)).(all_status) == [false, true, true, false, false, false]
	@test (x -> implementation_convexity_type.is_convex(x)).(all_status) == [false, true, true, true, false, false]
	@test (x -> implementation_convexity_type.is_concave(x)).(all_status) == [false, true, true, false, true, false]
	@test (x -> implementation_convexity_type.is_unknown(x)).(all_status) == [false, false, false, false, false, true]

	not_treated_wrapper = implementation_convexity_type.init_conv_status()
	constant_wrapper = implementation_convexity_type.constant_wrapper()
	linear_wrapper = implementation_convexity_type.linear_wrapper()
	convex_wrapper = implementation_convexity_type.convex_wrapper()
	concave_wrapper = implementation_convexity_type.concave_wrapper()
	unknown_wrapper = implementation_convexity_type.unknown_wrapper()
	all_status_wrapper = [not_treated_wrapper, constant_wrapper, linear_wrapper, convex_wrapper, concave_wrapper, unknown_wrapper]

	@test (x -> implementation_convexity_type.is_treated(x)).(all_status_wrapper) == [false, true, true, true, true, true]
	@test (x -> implementation_convexity_type.is_not_treated(x)).(all_status_wrapper) == [true, false, false, false, false, false]
	@test (x -> implementation_convexity_type.is_constant(x)).(all_status_wrapper) == [false, true, false, false, false, false]
	@test (x -> implementation_convexity_type.is_linear(x)).(all_status_wrapper) == [false, true, true, false, false, false]
	@test (x -> implementation_convexity_type.is_convex(x)).(all_status_wrapper) == [false, true, true, true, false, false]
	@test (x -> implementation_convexity_type.is_concave(x)).(all_status_wrapper) == [false, true, true, false, true, false]
	@test (x -> implementation_convexity_type.is_unknown(x)).(all_status_wrapper) == [false, false, false, false, false, true]


	@test (x -> implementation_convexity_type.get_convexity_wrapper(x)).(all_status_wrapper) == all_status
		# (x -> implementation_convexity_type.set_convexity_wrapper!(x, cst)).(all_status_wrapper)

end
