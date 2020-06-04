module minus_operators

    import ..abstract_expr_node.ab_ex_nd, ..abstract_expr_node.create_node_expr

    import ..interface_expr_node._node_is_plus, ..interface_expr_node._node_is_minus, ..interface_expr_node._node_is_power, ..interface_expr_node._node_is_times
    import ..interface_expr_node._node_is_constant, ..interface_expr_node._node_is_variable,..interface_expr_node._node_is_operator
    import ..interface_expr_node._node_is_sin, ..interface_expr_node._node_is_cos, ..interface_expr_node._node_is_tan
    import ..interface_expr_node._cast_constant!, ..interface_expr_node._node_to_Expr

    import ..implementation_type_expr.t_type_expr_basic
    using ..trait_type_expr

    import ..interface_expr_node._get_type_node, ..interface_expr_node._evaluate_node
    import ..interface_expr_node._node_bound
    import ..interface_expr_node._evaluate_node2

    import Base.==

    mutable struct minus_operator <: ab_ex_nd

    end



    function _node_bound(op :: minus_operator, son_bound :: AbstractVector{Tuple{T,T}}, t :: DataType) where T <: Number
        vector_inf_bound = [p[1] for p in son_bound]
        vector_sup_bound = [p[2] for p in son_bound]
        length(vector_inf_bound) == length(vector_sup_bound) || error("error bound minus operator")

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
