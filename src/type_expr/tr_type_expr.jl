module trait_type_expr

using ..implementation_type_expr
import ..interface_type_expr:
  _is_constant, _is_linear, _is_quadratic, _is_more, _is_cubic, _type_product, _type_power

export is_trait_type_expr, is_linear, is_constant, is_quadratic, is_cubic, is_more_than_quadratic

struct type_type_expr end
struct type_not_type_expr end

@inline is_trait_type_expr(a::Any) = type_not_type_expr()
@inline is_trait_type_expr(a::implementation_type_expr.t_type_expr_basic) = type_type_expr()

@inline is_constant(a::Any) = _is_constant(a, is_trait_type_expr(a))
@inline _is_constant(a, ::type_not_type_expr) = error("This is not a type of expr")
@inline _is_constant(a, ::type_type_expr) = _is_constant(a)

@inline is_linear(a::Any) = _is_linear(a, is_trait_type_expr(a))
@inline _is_linear(a, ::type_not_type_expr) = error("This is not a type of expr")
@inline _is_linear(a, ::type_type_expr) = _is_linear(a)

@inline is_quadratic(a::Any) = _is_quadratic(a, is_trait_type_expr(a))
@inline _is_quadratic(a, ::type_not_type_expr) = error("This is not a type of expr")
@inline _is_quadratic(a, ::type_type_expr) = _is_quadratic(a)

@inline is_cubic(a::Any) = _is_cubic(a, is_trait_type_expr(a))
@inline _is_cubic(a, ::type_not_type_expr) = error("This is not a type of expr")
@inline _is_cubic(a, ::type_type_expr) = _is_cubic(a)

@inline is_more(a::Any) = _is_more(a, is_trait_type_expr(a))
@inline _is_more(a, ::type_not_type_expr) = error("This is not a type of expr")
@inline _is_more(a, ::type_type_expr) = _is_more(a)

@inline type_product(a::Any, b::Any) =
  _type_product(a, b, is_trait_type_expr(a), is_trait_type_expr(b))
@inline _type_product(a, b, ::type_not_type_expr, ::Any) = error("We don't have 2 type")
@inline _type_product(a, b, ::Any, ::type_not_type_expr) = error("We don't have 2 type")
@inline _type_product(a, b, ::type_type_expr, ::type_type_expr) = _type_product(a, b)

@inline type_power(a::Number, b::Any) = _type_power(a, b, is_trait_type_expr(b))
@inline _type_power(a::Number, b, ::type_not_type_expr) = error(" type_power not a tpye_expr")
@inline _type_power(a::Number, b, ::type_type_expr) = _type_power(a, b)

end
