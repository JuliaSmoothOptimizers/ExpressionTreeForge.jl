module plus_operators

    import ..abstract_expr_node.ab_ex_nd, ..abstract_expr_node.create_node_expr

    import ..interface_expr_node._node_is_plus, ..interface_expr_node._node_is_minus, ..interface_expr_node._node_is_power, ..interface_expr_node._node_is_times
    import ..interface_expr_node._node_is_constant, ..interface_expr_node._node_is_variable,..interface_expr_node._node_is_operator
    import ..interface_expr_node._node_is_sin, ..interface_expr_node._node_is_cos, ..interface_expr_node._node_is_tan
    import ..interface_expr_node._cast_constant!, ..interface_expr_node._node_to_Expr

    import ..implementation_type_expr.t_type_expr_basic
    using ..trait_type_expr

    import ..interface_expr_node._get_type_node, ..interface_expr_node._evaluate_node

    import  ..interface_expr_node._evaluate_node2

    import ..interface_expr_node._node_bound


    import Base.==

    mutable struct plus_operator <: ab_ex_nd

    end

    function _node_bound(op :: plus_operator, son_bound :: AbstractVector{Tuple{T,T}}, t :: DataType) where T <: Number
        vector_inf_bound = [p[1] for p in son_bound]
        vector_sup_bound = [p[2] for p in son_bound]
        return (sum(vector_inf_bound), sum(vector_sup_bound))
    end

    function create_node_expr(  op :: plus_operator )
        return plus_operator()
    end

    _node_is_operator( op :: plus_operator ) = true
    _node_is_plus( op :: plus_operator ) = true
    _node_is_minus(op :: plus_operator ) = false
    _node_is_times(op :: plus_operator ) = false
    _node_is_power(op :: plus_operator ) = false
    _node_is_sin(op :: plus_operator) = false
    _node_is_cos(op :: plus_operator) = false
    _node_is_tan(op :: plus_operator) = false

    _node_is_variable(op :: plus_operator ) = false

    _node_is_constant(op :: plus_operator ) = false

    function _get_type_node(op :: plus_operator, type_ch :: Vector{t_type_expr_basic})
        if length(type_ch) == 1
            return type_ch[1]
        else
            return max(type_ch...)
        end
    end

    (==)(a :: plus_operator, b :: plus_operator) = true

    @inline function _evaluate_node(op :: plus_operator, value_ch :: AbstractVector{T}) where T <: Number
        return @fastmath sum(value_ch)
    end

    function _evaluate_node2(op :: plus_operator, value_ch :: AbstractVector{T}) where T <: Number
        return sum(value_ch) :: T
    end

    function _node_to_Expr(op :: plus_operator)
        return [:+]
    end

    export operator
end
