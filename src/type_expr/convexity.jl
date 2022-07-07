module M_implementation_convexity_type

# définition of all distinct properties that can have a calculus tree
"""
    Convexity_type

Type representing wether an expression is `not_treated, constant, linear, convex, concave` or `unknown`.
"""
@enum Convexity_type not_treated = 0 constant = 1 linear = 2 convex = 3 concave = 4 unknown = 5

"""
    Convexity_wrapper

Wrapper around `Convexity_type`.
"""
mutable struct Convexity_wrapper
  status::Convexity_type
end

"""
    convexity_status = get_convexity_wrapper(convexity::Convexity_wrapper)

Return the convexity status of `convexity`.
"""
@inline get_convexity_wrapper(convexity::Convexity_wrapper) = convexity.status

"""
    set_convexity_wrapper!(convexity::Convexity_wrapper, t::Convexity_type)

Set the convexity status of `convexity` to `type`.
"""
@inline set_convexity_wrapper!(convexity::Convexity_wrapper, type::Convexity_type) = convexity.status = type

"""
    untreated_wrapper = init_conv_status()

Return a `Convexity_wrapper` with value `not_treated`.
"""
@inline init_conv_status() = Convexity_wrapper(not_treated)

"""
    constant_wrapper = constant_wrapper()

Return a `Convexity_wrapper` with value `constant`.
"""
@inline constant_wrapper() = Convexity_wrapper(constant)

"""
    linear_wrapper = linear_wrapper()

Return a `Convexity_wrapper` with value `linear`.
"""
@inline linear_wrapper() = Convexity_wrapper(linear)

"""
    convex_wrapper = convex_wrapper()

Return a `Convexity_wrapper` with value `convex`.
"""
@inline convex_wrapper() = Convexity_wrapper(convex)

"""
    concave_wrapper = concave_wrapper()

Return a `Convexity_wrapper` with value `concave`.
"""
@inline concave_wrapper() = Convexity_wrapper(concave)

"""
    unknown_wrapper = unknown_wrapper()

Return a `Convexity_wrapper` with value `unknown`.
"""
@inline unknown_wrapper() = Convexity_wrapper(unknown)

"""
    not_treated = not_treated_type()

Return a `not_treated::Convexity_type`.
"""
@inline not_treated_type() = not_treated

"""
    constant = constant_type()

Return a `constant::Convexity_type`.
"""
@inline constant_type() = constant

"""
    linear = linear_type()

Return a `linear::Convexity_type`.
"""
@inline linear_type() = linear

"""
    convex = convex_type()

Return a `convex::Convexity_type`.
"""
@inline convex_type() = convex

"""
    concave = concave_type()

Return a `concave::Convexity_type`.
"""
@inline concave_type() = concave

"""
    unknown = unknown_type()

Return a `unknown::Convexity_type`.
"""
@inline unknown_type() = unknown

"""
    bool = is_treated(status::Convexity_type)
    bool = is_treated(convexity::Convexity_wrapper)

Check if `status` or `convexity.status` equals `not_treated`.
"""
@inline is_treated(status::Convexity_type) = status != not_treated
@inline is_treated(convexity::Convexity_wrapper) = convexity.status != not_treated

"""
    bool = is_not_treated(status::Convexity_type)
    bool = is_not_treated(convexity::Convexity_wrapper)

Check if `status` or `convexity.status` equals `not_treated`.
"""
@inline is_not_treated(status::Convexity_type) = status == not_treated
@inline is_not_treated(convexity::Convexity_wrapper) = convexity.status == not_treated

"""
    bool = is_constant(status::Convexity_type)
    bool = is_constant(convexity::Convexity_wrapper)

Check if `status` or `convexity.status` equals `constant`.
"""
@inline is_constant(status::Convexity_type) = status == constant
@inline is_constant(convexity::Convexity_wrapper) = convexity.status == constant

"""
    bool = is_linear(status::Convexity_type)
    bool = is_linear(convexity::Convexity_wrapper)

Check if `status` or `convexity.status` equals `linear`.
"""
@inline is_linear(status::Convexity_type) = (status == linear) || is_constant(status)
@inline is_linear(convexity::Convexity_wrapper) = convexity.status == linear || is_constant(convexity)

"""
    bool = is_convex(status::Convexity_type)
    bool = is_convex(convexity::Convexity_wrapper)

Check if `status` or `convexity.status` equals `convex`.
"""
@inline is_convex(status::Convexity_type) = (status == convex) || is_linear(status)
@inline is_convex(convexity::Convexity_wrapper) = (convexity.status == convex) || is_linear(convexity)

"""
    bool = is_concave(status::Convexity_type)
    bool = is_concave(convexity::Convexity_wrapper)

Check if `status` or `convexity.status` equals `concave`.
"""
@inline is_concave(status::Convexity_type) = (status == concave) || is_linear(status)
@inline is_concave(convexity::Convexity_wrapper) = (convexity.status == concave) || is_linear(convexity)

"""
    bool = is_unknown(status::Convexity_type)
    bool = is_unknown(convexity::Convexity_wrapper)

Check if `status` or `convexity.status` equals `unknown`.
"""
@inline is_unknown(status::Convexity_type) = status == unknown
@inline is_unknown(convexity::Convexity_wrapper) = (convexity.status == unknown)

end
