module implementation_convexity_type

# définition of all distinct properties that can have a calculus tree
"""
    Convexity_type

Type definition representing wether an expression is `not_treated, constant, linear, convex, concave` or `unknown`.
"""
@enum Convexity_type not_treated = 0 constant = 1 linear = 2 convex = 3 concave = 4 unknown = 5

"""
    Convexity_wrapper

"""
mutable struct Convexity_wrapper
  status::Convexity_type
end

@inline get_convexity_wrapper(c::Convexity_wrapper) = c.status
@inline set_convexity_wrapper!(c::Convexity_wrapper, t::Convexity_type) = c.status = t

@inline init_conv_status() = Convexity_wrapper(not_treated)
@inline constant_wrapper() = Convexity_wrapper(constant)
@inline linear_wrapper() = Convexity_wrapper(linear)
@inline convex_wrapper() = Convexity_wrapper(convex)
@inline concave_wrapper() = Convexity_wrapper(concave)
@inline unknown_wrapper() = Convexity_wrapper(unknown)

@inline not_treated_type() = not_treated
@inline constant_type() = constant
@inline linear_type() = linear
@inline convex_type() = convex
@inline concave_type() = concave
@inline unknown_type() = unknown

@inline is_treated(status::Convexity_type) = status != not_treated
@inline is_treated(c::Convexity_wrapper) = c.status != not_treated

@inline is_not_treated(status::Convexity_type) = status == not_treated
@inline is_not_treated(c::Convexity_wrapper) = c.status == not_treated

@inline is_constant(status::Convexity_type) = status == constant
@inline is_constant(c::Convexity_wrapper) = c.status == constant

@inline is_linear(status::Convexity_type) = (status == linear) || is_constant(status)
@inline is_linear(c::Convexity_wrapper) = c.status == linear || is_constant(c)

@inline is_convex(status::Convexity_type) = (status == convex) || is_linear(status)
@inline is_convex(c::Convexity_wrapper) = (c.status == convex) || is_linear(c)

@inline is_concave(status::Convexity_type) = (status == concave) || is_linear(status)
@inline is_concave(c::Convexity_wrapper) = (c.status == concave) || is_linear(c)

@inline is_unknown(status::Convexity_type) = status == unknown
@inline is_unknown(c::Convexity_wrapper) = (c.status == unknown)

end
