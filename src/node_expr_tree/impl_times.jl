module times_operators

    import ..abstract_expr_node.ab_ex_nd, ..abstract_expr_node.create_node_expr

    import ..interface_expr_node._node_is_plus, ..interface_expr_node._node_is_minus, ..interface_expr_node._node_is_power, ..interface_expr_node._node_is_times
    import ..interface_expr_node._node_is_constant, ..interface_expr_node._node_is_variable,..interface_expr_node._node_is_operator
    import ..interface_expr_node._node_is_sin, ..interface_expr_node._node_is_cos, ..interface_expr_node._node_is_tan
    import ..interface_expr_node._cast_constant!, ..interface_expr_node._node_to_Expr

    import ..implementation_type_expr.t_type_expr_basic
    using ..trait_type_expr

    import ..interface_expr_node._get_type_node, ..interface_expr_node._evaluate_node

    import  ..interface_expr_node._node_bound, ..interface_expr_node._node_convexity
    using ..implementation_convexity_type

    import Base.==

    mutable struct time_operator <: ab_ex_nd

    end

    function _node_convexity(op :: time_operator,
                             son_cvx :: AbstractVector{implementation_convexity_type.convexity_type},
                             son_bound :: AbstractVector{Tuple{T,T}}
                             ) where T <: Number

        length(son_cvx) == length(son_bound) || error("mismatch length parameter, _node_convexity : times operator")
        current_st = son_cvx[1]
        current_bounds = son_bound[1]
        for i in 2:length(son_cvx)
            current_st = node_convexity_binary_time(current_st, son_cvx[i], current_bounds, son_bound[i])
            current_bouds = bound_binary_times(current_bounds[1], current_bounds[2], son_bound[i][1], son_bound[i][2])
        end
        return current_st
    end

    function node_convexity_binary_time(status1 :: implementation_convexity_type.convexity_type,
                                        status2 :: implementation_convexity_type.convexity_type,
                                        bounds1 :: Tuple{T,T},
                                        bounds2 :: Tuple{T,T}) where T <: Number
        cste_exist = implementation_convexity_type.is_constant(status1) || implementation_convexity_type.is_constant(status2)
        check_all =  implementation_convexity_type.is_constant(status1) && implementation_convexity_type.is_constant(status2)
        if check_all # les 2 sont constants
            return implementation_convexity_type.constant_type()
        elseif (implementation_convexity_type.is_constant(status2) && implementation_convexity_type.is_linear(status1)) || (implementation_convexity_type.is_constant(status1) && implementation_convexity_type.is_linear(status2))
            return implementation_convexity_type.linear_type()
        elseif cste_exist #un seul statut est constant
            if implementation_convexity_type.is_constant(status1) # les 2 éléments du tuples sont égaux
                cst = bounds1[1]
                if implementation_convexity_type.is_convex(status2)
                    cst >= 0 ? implementation_convexity_type.convex_type() : implementation_convexity_type.concave_type()
                elseif implementation_convexity_type.is_concave(status2)
                    cst >= 0 ? implementation_convexity_type.concave_type() : implementation_convexity_type.convex_type()
                else
                    return implementation_convexity_type.unknown_type()
                end
            else # c'est le deuxième terme qui est constant
                cst = bounds2[1]
                if implementation_convexity_type.is_convex(status1)
                    cst >= 0 ? implementation_convexity_type.convex_type() : implementation_convexity_type.concave_type()
                elseif implementation_convexity_type.is_concave(status1)
                    cst >= 0 ? implementation_convexity_type.concave_type() : implementation_convexity_type.convex_type()
                else
                    return implementation_convexity_type.unknown_type()
                end
            end
        else
            return implementation_convexity_type.unknown_type()
        end
    end


    # remarque le produit doit-être au moins binaire
    function _node_bound(op :: time_operator , son_bound :: AbstractVector{Tuple{T,T}}, t :: DataType) where Y <: Number where T <: Number
        vector_inf_bound = [p[1] for p in son_bound]
        vector_sup_bound = [p[2] for p in son_bound]
        bi = (T)(vector_inf_bound[1]) :: T
        bs = (T)(vector_sup_bound[1]) :: T
        n = length(vector_inf_bound)
        for i in 2:n
            (bi,bs) = bound_binary_times(bi,bs, vector_inf_bound[i], vector_sup_bound[i])
        end
        return (bi,bs)
    end

    function bound_binary_times(bi1 :: T, bs1 :: T, bi2 :: T, bs2 :: T) where T <: Number
        products = [bi1 * bi2, bi1 * bs2, bs1 * bi2, bs1 * bs2]
        filtered_products = filter( (x -> isnan(x) == false), products)
        # @show filtered_products, products, bi1,bs1,bi2,bs2
        bi = min(filtered_products...)
        bs = max(filtered_products...)
        return (bi,bs)
    end


    function create_node_expr(op :: time_operator)
        return time_operator()
    end

    _node_is_operator( op :: time_operator ) = true
    _node_is_plus( op :: time_operator ) = false
    _node_is_minus(op :: time_operator ) = false
    _node_is_times(op :: time_operator ) = true
    _node_is_power(op :: time_operator ) = false
    _node_is_sin(op :: time_operator) = false
    _node_is_cos(op :: time_operator) = false
    _node_is_tan(op :: time_operator) = false

    _node_is_variable(op :: time_operator ) = false

    _node_is_constant(op :: time_operator ) = false

    function _get_type_node(op :: time_operator, type_ch :: Vector{t_type_expr_basic})
        foldl(trait_type_expr.type_product, type_ch)
    end

    (==)(a :: time_operator, b :: time_operator) = true

    function _evaluate_node(op :: time_operator, value_ch :: AbstractVector{T}) where T <: Number
        return foldl(*,value_ch)
    end


    function _node_to_Expr(op :: time_operator)
        return [:*]
    end

    export operator
end
