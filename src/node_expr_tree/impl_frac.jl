module frac_operators

    import ..abstract_expr_node.ab_ex_nd, ..abstract_expr_node.create_node_expr

    import ..interface_expr_node._node_is_plus, ..interface_expr_node._node_is_minus, ..interface_expr_node._node_is_power, ..interface_expr_node._node_is_times
    import ..interface_expr_node._node_is_constant, ..interface_expr_node._node_is_variable,..interface_expr_node._node_is_operator
    import ..interface_expr_node._node_is_sin, ..interface_expr_node._node_is_cos, ..interface_expr_node._node_is_tan
    import ..interface_expr_node._cast_constant!, ..interface_expr_node._node_to_Expr

    import ..implementation_type_expr.t_type_expr_basic
    using ..trait_type_expr

    import ..interface_expr_node._get_type_node, ..interface_expr_node._evaluate_node
    import ..interface_expr_node._evaluate_node2

    import ..interface_expr_node._node_bound, ..interface_expr_node._node_convexity
    using ..implementation_convexity_type

    import Base.==

    mutable struct frac_operator <: ab_ex_nd

    end

    function _node_convexity(op :: frac_operator,
                             son_cvx :: AbstractVector{implementation_convexity_type.convexity_type},
                             son_bound :: AbstractVector{Tuple{T,T}}
                             ) where T <: Number
        length(son_cvx) == length(son_bound) || error("unsuitable parameter _node_convexity : minus_operator")
        st_denom = son_cvx[2]
        st_num = son_cvx[1]
        (bi_num, bs_num) = son_bound[1]
        (bi_denom, bs_denom) = son_bound[2]
        if implementation_convexity_type.is_constant(st_denom) && implementation_convexity_type.is_constant(st_num)
            return implementation_convexity_type.constant_type()
        elseif implementation_convexity_type.is_constant(st_denom) && implementation_convexity_type.is_linear(st_num)
            return implementation_convexity_type.linear_type()
        elseif implementation_convexity_type.is_constant(st_denom) && ((bi_denom > 0 && implementation_convexity_type.is_convex(st_num)) || (bi_denom < 0 && implementation_convexity_type.is_concave(st_num)) )
            return implementation_convexity_type.convex_type()
        elseif implementation_convexity_type.is_constant(st_denom) && ((bs_denom < 0 && implementation_convexity_type.is_convex(st_num)) || (bi_denom > 0 && implementation_convexity_type.is_concave(st_num)) )
            return implementation_convexity_type.concave_type()
        elseif !(check_0_in(bi_denom, bs_denom)) && implementation_convexity_type.is_constant(st_num) && (((bi_num >= 0) && (bi_denom > 0) && implementation_convexity_type.is_concave(st_denom)) || ((bs_num <= 0) && (bs_denom < 0) && implementation_convexity_type.is_convex(st_denom)))
            return implementation_convexity_type.convex_type()
        elseif !(check_0_in(bi_denom, bs_denom)) && implementation_convexity_type.is_constant(st_num) && (((bi_num >= 0) && (bs_denom < 0) && implementation_convexity_type.is_convex(st_denom)) || ((bs_num <= 0) && (bi_denom > 0) && implementation_convexity_type.is_concave(st_denom)))
            return implementation_convexity_type.concave_type()
        else
            return implementation_convexity_type.unknown_type()
        end
    end

    check_0_in(bi :: T, bs :: T) where T <: Number = (bi <= 0) && (bs >= 0)
    check_0_plus(bi :: T, bs :: T) where T <: Number = (bi <= 0) && (bs > 0)
    check_0_minus(bi :: T, bs :: T) where T <: Number = (bi < 0) && (bs >= 0)
    check_positive(bi :: T, bs :: T) where T <: Number = (bi >= 0)
    check_negative(bi :: T, bs :: T) where T <: Number = (bs <= 0)
    check_positive_negative(bi :: T, bs :: T) where T <: Number = (bi < 0) && (bs > 0)
    function _node_bound(op :: frac_operator, son_bound :: AbstractVector{Tuple{T,T}}, t :: DataType) where T <: Number
        (bi_num, bs_num) = son_bound[1]
        (bi_denom, bs_denom) = son_bound[2]
        (length(son_bound) == 2 ) || error("error bound minus operator")
        if (check_0_in(bi_denom, bs_denom) && check_positive_negative(bi_num, bs_num)) || (check_0_plus(bi_denom, bs_denom) && check_0_minus(bi_denom, bs_denom) ) || (check_positive_negative(bi_num, bs_num) && (check_0_plus(bi_denom, bs_denom) || check_0_minus(bi_denom, bs_denom)))
            return (t(-Inf),t(Inf))
        elseif check_positive(bi_denom, bs_denom) || check_negative(bi_denom, bs_denom)
            brut_force_bound_frac(bi_num, bs_num, bi_denom, bs_denom)
        else
            println("non traité _node_bound frac")
            return (t(-Inf),t(Inf))
        end

    end

    function brut_force_bound_frac(bi1 :: T, bs1 :: T, bi2 :: T, bs2 :: T) where T <: Number
        products = [bi1 / bi2, bi1 / bs2, bs1 / bi2, bs1 / bs2]
        filtered_products = filter( (x -> isnan(x) == false), products)
        # @show filtered_products, products, bi1,bs1,bi2,bs2
        bi = min(filtered_products...)
        bs = max(filtered_products...)
        return (bi,bs)
    end


    function create_node_expr( op :: frac_operator)
        return frac_operator()
    end


    _node_is_operator( op :: frac_operator ) = true
    _node_is_plus( op :: frac_operator ) = false
    _node_is_minus(op :: frac_operator ) = false
    _node_is_times(op :: frac_operator ) = false
    _node_is_power(op :: frac_operator ) = false
    _node_is_sin(op :: frac_operator) = false
    _node_is_cos(op :: frac_operator) = false
    _node_is_tan(op :: frac_operator) = false
    _node_is_frac(op :: frac_operator) = true

    _node_is_variable(op :: frac_operator ) = false

    _node_is_constant(op :: frac_operator ) = false

    function _get_type_node(op :: frac_operator, type_ch :: Vector{t_type_expr_basic})
        t_denom = type_ch[2]
        if trait_type_expr._is_constant(t_denom)
            return type_ch[1]
        else
            implementation_type_expr.return_more()
        end
    end

    (==)(a :: frac_operator, b :: frac_operator) = true

    function _evaluate_node(op :: frac_operator, value_ch :: AbstractVector{T}) where T <: Number
        return value_ch[1] / value_ch[2]
    end

    function _node_to_Expr(op :: frac_operator)
        return [:/]
    end

    export operator
end
