module trait_type_expr

    using ..implementation_type_expr

    import ..interface_type_expr._is_constant, ..interface_type_expr._is_linear, ..interface_type_expr._is_quadratic,
    ..interface_type_expr._is_more, ..interface_type_expr._is_cubic
    import ..interface_type_expr._type_product, ..interface_type_expr._type_power

    struct type_type_expr end
    struct type_not_type_expr end

    is_trait_type_expr(a :: Any) = type_not_type_expr()
    is_trait_type_expr(a :: implementation_type_expr.t_type_expr_basic) = type_type_expr()

    is_constant(a :: Any ) = _is_constant(a, is_trait_type_expr(a))
    _is_constant(a, ::type_not_type_expr ) = error("This is not a type of expr")
    _is_constant(a, ::type_type_expr ) = _is_constant(a)

    is_linear(a :: Any ) = _is_linear(a, is_trait_type_expr(a))
    _is_linear(a, ::type_not_type_expr ) = error("This is not a type of expr")
    _is_linear(a, ::type_type_expr ) = _is_linear(a)

    is_quadratic(a :: Any ) = _is_quadratic(a, is_trait_type__expr(a))
    _is_quadratic(a, ::type_not_type_expr ) = error("This is not a type of expr")
    _is_quadratic(a, ::type_type_expr ) = _is_quadratic(a)

    is_cubic(a :: Any ) = _is_cubic(a, is_trait_type__expr(a))
    _is_cubic(a, ::type_not_type_expr ) = error("This is not a type of expr")
    _is_cubic(a, ::type_type_expr ) = _is_cubic(a)

    is_more(a :: Any ) = _is_more(a, is_trait_type_expr(a))
    _is_more(a, ::type_not_type_expr ) = error("This is not a type of expr")
    _is_more(a, ::type_type_expr ) = _is_more(a)

    type_product(a :: Any, b ::Any) = _type_product(a,b, is_trait_type_expr(a), is_trait_type_expr(b))
    _type_product(a,b, :: type_not_type_expr, :: Any) = error("We don't have 2 type")
    _type_product(a,b, :: Any, :: type_not_type_expr) = error("We don't have 2 type")
    _type_product(a,b, :: type_type_expr,:: type_type_expr) = _type_product(a,b)

    type_power(a :: Number, b :: Any) = _type_power(a, b , is_trait_type_expr(b))
    _type_power(a :: Number, b ,  :: type_not_type_expr) = error(" type_power not a tpye_expr")
    _type_power(a :: Number, b ,  :: type_type_expr) = _type_power(a,b)

    export is_trait_type_expr, is_linear, is_constant, is_quadratic, is_cubic, is_more_than_quadratic

end
