module interface_type_expr

"""
    bool = _is_constant(type)

Return `true` if `type` is a constant type.
"""
_is_constant() = ()

"""
    bool = _is_linear(type)

Return `true` if `type` is a linear type.
"""
_is_linear() = ()

"""
    bool = _is_quadratic(type)

Return `true` if `type` is a quadratic type.
"""
_is_quadratic() = ()

"""
    bool = _is_cubic(type)

Return `true` if `type` is a cubic type.
"""
_is_cubic() = ()

"""
    bool = _is_more(type)

Return `true` if `type` is more than a quadratic type.
"""
_is_more() = ()

"""
    result_type = _type_product(type1, type2)

Return the type resulting of a product between `type1` and `type2`.
"""
_type_product() = ()

"""
    result_type = _type_power(index, type)

Return the type resulting of `type` to power `index`.
"""
_type_power() = ()

end  # module interface_type_expr
