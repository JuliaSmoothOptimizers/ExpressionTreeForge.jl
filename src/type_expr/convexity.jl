module implementation_convexity_type

    # définition of all distinct properties that can have a calculus tree
    @enum convexity_type not_treated=0 linear=1 convex=2 concave=3 unknown=4

    mutable struct convexity_wrapper
        status :: convexity_type
    end

    get_convexity_wrapper(c :: convexity_wrapper) = c.status
    set_convexity_wrapper!(c :: convexity_wrapper, t :: convexity_type) = c.status = t 

    init_conv_status() = convexity_wrapper(not_treated)
    linear_wrapper() = convexity_wrapper(linear)
    convex_wrapper() = convexity_wrapper(convex)
    concave_wrapper() = convexity_wrapper(concave)
    unknown_wrapper() = convexity_wrapper(unknown)

    linear_type() = linear
    convex_type() = convex
    concave_type() = concave
    unknown_type() = unknown

    is_treated(c :: convexity_wrapper) = c.status != not_treated
    is_not_treated(c :: convexity_wrapper) = c.status == not_treated
    is_linear(c :: convexity_wrapper) = c.status == linear
    is_convex(c :: convexity_wrapper) = (c.status == linear) || (c.status == convex)
    is_concave(c :: convexity_wrapper) = (c.status == linear) || (c.status == concave)
    is_unknown(c :: convexity_wrapper) = (c.status == unknown)



end
