using ExpressionTreeForge.M_trait_type_expr
using ExpressionTreeForge.M_implementation_type_expr,
  ExpressionTreeForge.M_implementation_convexity_type, ExpressionTreeForge.M_implementation_convexity_type

@testset "test M_implementation_type_expr" begin

  # Check predicates
  @test M_implementation_type_expr._is_constant(M_implementation_type_expr.return_constant())
  @test M_implementation_type_expr._is_constant(M_implementation_type_expr.return_linear()) == false
  @test M_implementation_type_expr._is_constant(M_implementation_type_expr.return_quadratic()) == false
  @test M_implementation_type_expr._is_constant(M_implementation_type_expr.return_cubic()) == false
  @test M_implementation_type_expr._is_constant(M_implementation_type_expr.return_more()) == false

  @test M_implementation_type_expr._is_linear(M_implementation_type_expr.return_constant()) == false
  @test M_implementation_type_expr._is_linear(M_implementation_type_expr.return_linear())
  @test M_implementation_type_expr._is_linear(M_implementation_type_expr.return_quadratic()) == false
  @test M_implementation_type_expr._is_linear(M_implementation_type_expr.return_cubic()) == false
  @test M_implementation_type_expr._is_linear(M_implementation_type_expr.return_more()) == false

  @test M_implementation_type_expr._is_quadratic(M_implementation_type_expr.return_constant()) == false
  @test M_implementation_type_expr._is_quadratic(M_implementation_type_expr.return_linear()) == false
  @test M_implementation_type_expr._is_quadratic(M_implementation_type_expr.return_quadratic())
  @test M_implementation_type_expr._is_quadratic(M_implementation_type_expr.return_cubic()) == false
  @test M_implementation_type_expr._is_quadratic(M_implementation_type_expr.return_more()) == false

  @test M_implementation_type_expr._is_cubic(M_implementation_type_expr.return_constant()) == false
  @test M_implementation_type_expr._is_cubic(M_implementation_type_expr.return_linear()) == false
  @test M_implementation_type_expr._is_cubic(M_implementation_type_expr.return_quadratic()) == false
  @test M_implementation_type_expr._is_cubic(M_implementation_type_expr.return_cubic())
  @test M_implementation_type_expr._is_cubic(M_implementation_type_expr.return_more()) == false

  @test M_implementation_type_expr._is_more(M_implementation_type_expr.return_constant()) == false
  @test M_implementation_type_expr._is_more(M_implementation_type_expr.return_linear()) == false
  @test M_implementation_type_expr._is_more(M_implementation_type_expr.return_quadratic()) == false
  @test M_implementation_type_expr._is_more(M_implementation_type_expr.return_cubic()) == false
  @test M_implementation_type_expr._is_more(M_implementation_type_expr.return_more())

  # Type variables
  constant = M_implementation_type_expr.return_constant()
  linear = M_implementation_type_expr.return_linear()
  quadratic = M_implementation_type_expr.return_quadratic()
  cubic = M_implementation_type_expr.return_cubic()
  more = M_implementation_type_expr.return_more()
  all_types = [constant, linear, quadratic, cubic, more]

  # test of _type_product
  @test (x -> M_implementation_type_expr._type_product(constant, x)).(all_types) == all_types
  @test (x -> M_implementation_type_expr._type_product(linear, x)).(all_types) ==
        [linear, quadratic, cubic, more, more]
  @test (x -> M_implementation_type_expr._type_product(quadratic, x)).(all_types) ==
        [quadratic, cubic, more, more, more]
  @test (x -> M_implementation_type_expr._type_product(cubic, x)).(all_types) ==
        [cubic, more, more, more, more]
  @test (x -> M_implementation_type_expr._type_product(cubic, x)).(all_types) ==
        [cubic, more, more, more, more]
  @test (x -> M_implementation_type_expr._type_product(more, x)).(all_types) ==
        [more, more, more, more, more]

  # test of _type_power
  @test (x -> M_implementation_type_expr._type_power(0, x)).(all_types) ==
        [constant, constant, constant, constant, constant]
  @test (x -> M_implementation_type_expr._type_power(1, x)).(all_types) == all_types
  @test (x -> M_implementation_type_expr._type_power(2, x)).(all_types) ==
        [constant, quadratic, more, more, more]
  @test (x -> M_implementation_type_expr._type_power(3, x)).(all_types) ==
        [constant, cubic, more, more, more]
  @test (x -> M_implementation_type_expr._type_power(4, x)).(all_types) ==
        [constant, more, more, more, more]

  # same tests applied on the trait
  @test M_trait_type_expr.is_constant(M_implementation_type_expr.return_constant())
  @test M_trait_type_expr.is_constant(M_implementation_type_expr.return_linear()) == false
  @test M_trait_type_expr.is_constant(M_implementation_type_expr.return_quadratic()) == false
  @test M_trait_type_expr.is_constant(M_implementation_type_expr.return_cubic()) == false
  @test M_trait_type_expr.is_constant(M_implementation_type_expr.return_more()) == false

  @test M_trait_type_expr.is_linear(M_implementation_type_expr.return_constant()) == false
  @test M_trait_type_expr.is_linear(M_implementation_type_expr.return_linear())
  @test M_trait_type_expr.is_linear(M_implementation_type_expr.return_quadratic()) == false
  @test M_trait_type_expr.is_linear(M_implementation_type_expr.return_cubic()) == false
  @test M_trait_type_expr.is_linear(M_implementation_type_expr.return_more()) == false

  @test M_trait_type_expr.is_quadratic(M_implementation_type_expr.return_constant()) == false
  @test M_trait_type_expr.is_quadratic(M_implementation_type_expr.return_linear()) == false
  @test M_trait_type_expr.is_quadratic(M_implementation_type_expr.return_quadratic())
  @test M_trait_type_expr.is_quadratic(M_implementation_type_expr.return_cubic()) == false
  @test M_trait_type_expr.is_quadratic(M_implementation_type_expr.return_more()) == false

  @test M_trait_type_expr.is_cubic(M_implementation_type_expr.return_constant()) == false
  @test M_trait_type_expr.is_cubic(M_implementation_type_expr.return_linear()) == false
  @test M_trait_type_expr.is_cubic(M_implementation_type_expr.return_quadratic()) == false
  @test M_trait_type_expr.is_cubic(M_implementation_type_expr.return_cubic())
  @test M_trait_type_expr.is_cubic(M_implementation_type_expr.return_more()) == false

  @test M_trait_type_expr.is_more(M_implementation_type_expr.return_constant()) == false
  @test M_trait_type_expr.is_more(M_implementation_type_expr.return_linear()) == false
  @test M_trait_type_expr.is_more(M_implementation_type_expr.return_quadratic()) == false
  @test M_trait_type_expr.is_more(M_implementation_type_expr.return_cubic()) == false
  @test M_trait_type_expr.is_more(M_implementation_type_expr.return_more())

  # test of type_product
  @test (x -> M_trait_type_expr.type_product(constant, x)).(all_types) == all_types
  @test (x -> M_trait_type_expr.type_product(linear, x)).(all_types) ==
        [linear, quadratic, cubic, more, more]
  @test (x -> M_trait_type_expr.type_product(quadratic, x)).(all_types) ==
        [quadratic, cubic, more, more, more]
  @test (x -> M_trait_type_expr.type_product(cubic, x)).(all_types) == [cubic, more, more, more, more]
  @test (x -> M_trait_type_expr.type_product(cubic, x)).(all_types) == [cubic, more, more, more, more]
  @test (x -> M_trait_type_expr.type_product(more, x)).(all_types) == [more, more, more, more, more]

  # test of type_power
  @test (x -> M_trait_type_expr.type_power(0, x)).(all_types) ==
        [constant, constant, constant, constant, constant]
  @test (x -> M_trait_type_expr.type_power(1, x)).(all_types) == all_types
  @test (x -> M_trait_type_expr.type_power(2, x)).(all_types) ==
        [constant, quadratic, more, more, more]
  @test (x -> M_trait_type_expr.type_power(3, x)).(all_types) == [constant, cubic, more, more, more]
  @test (x -> M_trait_type_expr.type_power(4, x)).(all_types) == [constant, more, more, more, more]
end

@testset "Convexity" begin
  not_treated = M_implementation_convexity_type.not_treated_type()
  cst = M_implementation_convexity_type.constant_type()
  lnr = M_implementation_convexity_type.linear_type()
  convex = M_implementation_convexity_type.convex_type()
  concave = M_implementation_convexity_type.concave_type()
  unknown = M_implementation_convexity_type.unknown_type()
  all_status = [not_treated, cst, lnr, convex, concave, unknown]

  @test (x -> M_implementation_convexity_type.is_treated(x)).(all_status) ==
        [false, true, true, true, true, true]
  @test (x -> M_implementation_convexity_type.is_not_treated(x)).(all_status) ==
        [true, false, false, false, false, false]
  @test (x -> M_implementation_convexity_type.is_constant(x)).(all_status) ==
        [false, true, false, false, false, false]
  @test (x -> M_implementation_convexity_type.is_linear(x)).(all_status) ==
        [false, true, true, false, false, false]
  @test (x -> M_implementation_convexity_type.is_convex(x)).(all_status) ==
        [false, true, true, true, false, false]
  @test (x -> M_implementation_convexity_type.is_concave(x)).(all_status) ==
        [false, true, true, false, true, false]
  @test (x -> M_implementation_convexity_type.is_unknown(x)).(all_status) ==
        [false, false, false, false, false, true]

  not_treated_wrapper = M_implementation_convexity_type.init_conv_status()
  constant_wrapper = M_implementation_convexity_type.constant_wrapper()
  linear_wrapper = M_implementation_convexity_type.linear_wrapper()
  convex_wrapper = M_implementation_convexity_type.convex_wrapper()
  concave_wrapper = M_implementation_convexity_type.concave_wrapper()
  unknown_wrapper = M_implementation_convexity_type.unknown_wrapper()
  all_status_wrapper = [
    not_treated_wrapper,
    constant_wrapper,
    linear_wrapper,
    convex_wrapper,
    concave_wrapper,
    unknown_wrapper,
  ]

  @test (x -> M_implementation_convexity_type.is_treated(x)).(all_status_wrapper) ==
        [false, true, true, true, true, true]
  @test (x -> M_implementation_convexity_type.is_not_treated(x)).(all_status_wrapper) ==
        [true, false, false, false, false, false]
  @test (x -> M_implementation_convexity_type.is_constant(x)).(all_status_wrapper) ==
        [false, true, false, false, false, false]
  @test (x -> M_implementation_convexity_type.is_linear(x)).(all_status_wrapper) ==
        [false, true, true, false, false, false]
  @test (x -> M_implementation_convexity_type.is_convex(x)).(all_status_wrapper) ==
        [false, true, true, true, false, false]
  @test (x -> M_implementation_convexity_type.is_concave(x)).(all_status_wrapper) ==
        [false, true, true, false, true, false]
  @test (x -> M_implementation_convexity_type.is_unknown(x)).(all_status_wrapper) ==
        [false, false, false, false, false, true]

  @test (x -> M_implementation_convexity_type.get_convexity_wrapper(x)).(all_status_wrapper) ==
        all_status

end
