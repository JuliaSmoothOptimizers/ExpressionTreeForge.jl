module implementation_convexity_type

    # définition of all distinct properties that can have a calculus tree
    @enum convexity_type not_treated=0 constant=1 linear=2 convex=3 concave=4 unknown=5

    mutable struct convexity_wrapper
        status :: convexity_type
    end

    @inline get_convexity_wrapper(c :: convexity_wrapper) = c.status
    @inline set_convexity_wrapper!(c :: convexity_wrapper, t :: convexity_type) = c.status = t

    @inline init_conv_status() = convexity_wrapper(not_treated)
    @inline constant_wrapper() = convexity_wrapper(constant)
    @inline linear_wrapper() = convexity_wrapper(linear)
    @inline convex_wrapper() = convexity_wrapper(convex)
    @inline concave_wrapper() = convexity_wrapper(concave)
    @inline unknown_wrapper() = convexity_wrapper(unknown)

    @inline not_treated_type() = not_treated
    @inline constant_type() = constant
    @inline linear_type() = linear
    @inline convex_type() = convex
    @inline concave_type() = concave
    @inline unknown_type() = unknown

    @inline is_treated(status :: convexity_type) = status != not_treated
    @inline is_treated(c :: convexity_wrapper) = c.status != not_treated

    @inline is_not_treated(status :: convexity_type) = status == not_treated
    @inline is_not_treated(c :: convexity_wrapper) = c.status == not_treated

    @inline is_constant(status :: convexity_type) = status == constant
    @inline is_constant(c :: convexity_wrapper) = c.status == constant

    @inline is_linear(status :: convexity_type) = (status == linear) || is_constant(status)
    @inline is_linear(c :: convexity_wrapper) = c.status == linear || is_constant(c)

    @inline is_convex(status :: convexity_type) = (status == convex) || is_linear(status)
    @inline is_convex(c :: convexity_wrapper) = (c.status == convex) || is_linear(c)

    @inline is_concave(status :: convexity_type) = (status == concave) || is_linear(status)
    @inline is_concave(c :: convexity_wrapper) = (c.status == concave) || is_linear(c)

    @inline is_unknown(status :: convexity_type) = status == unknown
    @inline is_unknown(c :: convexity_wrapper) = (c.status == unknown)



end
