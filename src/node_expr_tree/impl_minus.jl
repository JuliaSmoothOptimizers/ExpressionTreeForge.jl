module minus_operators

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

    mutable struct minus_operator <: ab_ex_nd

    end

    function _node_convexity(op :: minus_operator,
                             son_cvx :: AbstractVector{implementation_convexity_type.convexity_type},
                             son_bound :: AbstractVector{Tuple{T,T}}
                             ) where T <: Number
        length(son_cvx) == length(son_bound) || error("unsuitable parameter _node_convexity : minus_operator")
        if length(son_cvx) == 1
            st_ch = son_cvx[1]
            if implementation_convexity_type.is_constant(st_ch)
                return implementation_convexity_type.constant_type()
            elseif implementation_convexity_type.is_linear(st_ch)
                return implementation_convexity_type.linear_type()
            elseif implementation_convexity_type.is_convex(st_ch)
                return implementation_convexity_type.concave_type()
            elseif implementation_convexity_type.is_concave(st_ch)
                return implementation_convexity_type.convex_type()
            else
                return implementation_convexity_type.unknown_type()
            end
        else
            res_first_son = son_cvx[1]
            res_second_son = _node_convexity(op, [son_cvx[2]], [son_bound[2]])
            if res_first_son == res_second_son
                return res_first_son #or res_second_son
            elseif (implementation_convexity_type.is_linear(res_first_son) && implementation_convexity_type.is_constant(res_second_son)) || (implementation_convexity_type.is_linear(res_second_son) && implementation_convexity_type.is_constant(res_first_son))
                return implementation_convexity_type.linear_type()
            elseif (implementation_convexity_type.is_linear(res_first_son) || implementation_convexity_type.is_constant(res_first_son)) && (implementation_convexity_type.is_convex(res_second_son) || implementation_convexity_type.is_concave(res_second_son))
                return res_second_son
            elseif (implementation_convexity_type.is_linear(res_second_son) || implementation_convexity_type.is_constant(res_second_son)) && (implementation_convexity_type.is_convex(res_first_son) || implementation_convexity_type.is_concave(res_first_son))
                return res_first_son
            else
                return implementation_convexity_type.unknown_type()
            end
        end
    end

    function _node_bound(op :: minus_operator, son_bound :: AbstractVector{Tuple{T,T}}, t :: DataType) where T <: Number
        vector_inf_bound = [p[1] for p in son_bound]
        vector_sup_bound = [p[2] for p in son_bound]
        (length(vector_inf_bound) == length(vector_sup_bound) || length(vector_sup_bound) <= 2 ) || error("error bound minus operator")
        if length(vector_inf_bound) == 1
            (bi,bs) = (vector_inf_bound[1], vector_sup_bound[1])
             return (-bs,-bi)
        else #binary minus
            (bi1,bs1) = (vector_inf_bound[1], vector_sup_bound[1])
            (bi2,bs2) = (vector_inf_bound[2], vector_sup_bound[2])
            return ( bi1 - bs2, bs1 - bi2)
        end
    end

    function create_node_expr( op :: minus_operator)
        return minus_operator()
    end


    _node_is_operator( op :: minus_operator ) = true
    _node_is_plus( op :: minus_operator ) = false
    _node_is_minus(op :: minus_operator ) = true
    _node_is_times(op :: minus_operator ) = false
    _node_is_power(op :: minus_operator ) = false
    _node_is_sin(op :: minus_operator) = false
    _node_is_cos(op :: minus_operator) = false
    _node_is_tan(op :: minus_operator) = false

    _node_is_variable(op :: minus_operator ) = false

    _node_is_constant(op :: minus_operator ) = false

    function _get_type_node(op :: minus_operator, type_ch :: Vector{t_type_expr_basic})
        if length(type_ch) == 1
            return type_ch[1]
        else
            return max(type_ch...)
        end
    end

    (==)(a :: minus_operator, b :: minus_operator) = true

    function _evaluate_node(op :: minus_operator, value_ch :: AbstractVector{T}) where T <: Number
        if length(value_ch) == 1
            return - value_ch[1]
        else
            return (value_ch[1] - value_ch[2])
        end
    end

    function _evaluate_node2(op :: minus_operator, value_ch :: AbstractVector{T}) where T <: Number
        if length(value_ch) == 1
            return - value_ch[1] :: T
        else
            return (value_ch[1] - value_ch[2]) :: T
        end
    end

    function _node_to_Expr(op :: minus_operator)
        return [:-]
    end

    export operator
end
