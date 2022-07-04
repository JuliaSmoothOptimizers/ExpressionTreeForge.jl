module M_trait_type_expr

using ..M_implementation_type_expr
import ..M_interface_type_expr:
  _is_constant, _is_linear, _is_quadratic, _is_more, _is_cubic, _type_product, _type_power

export is_trait_type_expr, is_linear, is_constant, is_quadratic, is_cubic, is_more_than_quadratic


"""Type instantiated dynamically that checks if an argument is a `Type_expr_basic`"""
struct Type_type_expr end

"""Type instantiated dynamically that checks if an argument is not a `Type_expr_basic`"""
struct Type_not_type_expr end

"""
    type = is_trait_type_expr(arg)

Return `type::Type_type_expr` if `arg` is an `Type_expr_basic` otherwise is return `type::Type_not_type_expr`
"""
@inline is_trait_type_expr(a::Any) = Type_not_type_expr()
@inline is_trait_type_expr(a::M_implementation_type_expr.Type_expr_basic) = Type_type_expr()

"""
    bool = _is_constant(type)

Return `true` if `type` is a constant type.
"""
@inline is_constant(a::Any) = _is_constant(a, is_trait_type_expr(a))
@inline _is_constant(a, ::Type_not_type_expr) = error("This is not a type of expr")
@inline _is_constant(a, ::Type_type_expr) = _is_constant(a)

"""
    bool = _is_linear(type)

Return `true` if `type` is a linear type.
"""
@inline is_linear(a::Any) = _is_linear(a, is_trait_type_expr(a))
@inline _is_linear(a, ::Type_not_type_expr) = error("This is not a type of expr")
@inline _is_linear(a, ::Type_type_expr) = _is_linear(a)

"""
    bool = _is_quadratic(type)

Return `true` if `type` is a quadratic type.
"""
@inline is_quadratic(a::Any) = _is_quadratic(a, is_trait_type_expr(a))
@inline _is_quadratic(a, ::Type_not_type_expr) = error("This is not a type of expr")
@inline _is_quadratic(a, ::Type_type_expr) = _is_quadratic(a)

"""
    bool = _is_cubic(type)

Return `true` if `type` is a cubic type.
"""
@inline is_cubic(a::Any) = _is_cubic(a, is_trait_type_expr(a))
@inline _is_cubic(a, ::Type_not_type_expr) = error("This is not a type of expr")
@inline _is_cubic(a, ::Type_type_expr) = _is_cubic(a)

"""
    bool = _is_more(type)

Return `true` if `type` is more than a quadratic type.
"""
@inline is_more(a::Any) = _is_more(a, is_trait_type_expr(a))
@inline _is_more(a, ::Type_not_type_expr) = error("This is not a type of expr")
@inline _is_more(a, ::Type_type_expr) = _is_more(a)

"""
    result_type = type_product(type1, type2)

Return the type resulting of a product between `type1` and `type2`.
"""
@inline type_product(a::Any, b::Any) =
  _type_product(a, b, is_trait_type_expr(a), is_trait_type_expr(b))
@inline _type_product(a, b, ::Type_not_type_expr, ::Any) = error("We don't have 2 type")
@inline _type_product(a, b, ::Any, ::Type_not_type_expr) = error("We don't have 2 type")
@inline _type_product(a, b, ::Type_type_expr, ::Type_type_expr) = _type_product(a, b)

"""
    result_type = type_power(index, type)

Return the type resulting of `type` to power `index`.
"""
@inline type_power(a::Number, b::Any) = _type_power(a, b, is_trait_type_expr(b))
@inline _type_power(a::Number, b, ::Type_not_type_expr) = error(" type_power not a tpye_expr")
@inline _type_power(a::Number, b, ::Type_type_expr) = _type_power(a, b)

end
