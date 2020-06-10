module implementation_convexity_type

    # définition of all distinct properties that can have a calculus tree
    @enum convexity_type not_treated=0 constant=1 linear=2 convex=3 concave=4 unknown=5

    mutable struct convexity_wrapper
        status :: convexity_type
    end

    get_convexity_wrapper(c :: convexity_wrapper) = c.status
    set_convexity_wrapper!(c :: convexity_wrapper, t :: convexity_type) = c.status = t

    init_conv_status() = convexity_wrapper(not_treated)
    constant_wrapper() = convexity_wrapper(constant)
    linear_wrapper() = convexity_wrapper(linear)
    convex_wrapper() = convexity_wrapper(convex)
    concave_wrapper() = convexity_wrapper(concave)
    unknown_wrapper() = convexity_wrapper(unknown)

    constant_type() = constant
    linear_type() = linear
    convex_type() = convex
    concave_type() = concave
    unknown_type() = unknown

    is_treated(status :: convexity_type) = status != not_treated
    is_treated(c :: convexity_wrapper) = c.status != not_treated

    is_not_treated(status :: convexity_type) = status == not_treated
    is_not_treated(c :: convexity_wrapper) = c.status == not_treated

    is_constant(status :: convexity_type) = status == constant
    is_constant(c :: convexity_wrapper) = c.status == constant

    is_linear(status :: convexity_type) = (status == linear) || is_constant(status)
    is_linear(c :: convexity_wrapper) = c.status == linear || is_constant(c)

    is_convex(status :: convexity_type) = (status == convex) || is_linear(status)
    is_convex(c :: convexity_wrapper) = (c.status == convex) || is_linear(c)

    is_concave(status :: convexity_type) = (status == concave) || is_linear(status)
    is_concave(c :: convexity_wrapper) = (c.status == concave) || is_linear(c)

    is_unknown(status :: convexity_type) = status == unknown
    is_unknown(c :: convexity_wrapper) = (c.status == unknown)



end
