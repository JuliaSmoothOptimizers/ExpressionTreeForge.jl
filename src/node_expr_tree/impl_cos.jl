module cos_operators

    import ..abstract_expr_node.ab_ex_nd, ..abstract_expr_node.create_node_expr

    import ..interface_expr_node._node_is_plus, ..interface_expr_node._node_is_minus, ..interface_expr_node._node_is_power, ..interface_expr_node._node_is_times
    import ..interface_expr_node._node_is_constant, ..interface_expr_node._node_is_variable,..interface_expr_node._node_is_operator
    import ..interface_expr_node._node_is_sin, ..interface_expr_node._node_is_cos, ..interface_expr_node._node_is_tan
    import ..interface_expr_node._cast_constant!, ..interface_expr_node._node_to_Expr

    import ..implementation_type_expr.t_type_expr_basic
    using ..trait_type_expr

    import ..interface_expr_node._get_type_node, ..interface_expr_node._evaluate_node

    import  ..interface_expr_node._evaluate_node2

    using ..implementation_type_expr


    import Base.==

    mutable struct cos_operator <: ab_ex_nd

    end


    function create_node_expr( op :: cos_operator)
        return cos_operator()
    end


    _node_is_operator( op :: cos_operator ) = true
    _node_is_plus( op :: cos_operator ) = false
    _node_is_minus(op :: cos_operator ) = false
    _node_is_times(op :: cos_operator ) = false
    _node_is_power(op :: cos_operator ) = false
    _node_is_sin(op :: cos_operator) = false
    _node_is_cos(op :: cos_operator) = true
    _node_is_tan(op :: cos_operator) = false

    _node_is_variable(op :: cos_operator ) = false

    _node_is_constant(op :: cos_operator ) = false

    function _get_type_node(op :: cos_operator, type_ch :: Vector{t_type_expr_basic})
        if length(type_ch) == 1
            t_child = type_ch[1]
            if trait_type_expr._is_constant(t_child)
                return t_child
            else
                return implementation_type_expr.return_more()
            end
        end
    end

    (==)(a :: cos_operator, b :: cos_operator) = true

    function _evaluate_node(op :: cos_operator, value_ch :: AbstractVector{T}) where T <: Number
        length(value_ch) == 1 || error("more than one argument for tan")
        return cos(value_ch[1]) 
    end

    function _evaluate_node2(op :: cos_operator, value_ch :: AbstractVector{T}) where T <: Number
        length(value_ch) == 1 || error("more than one argument for tan")
        return cos(value_ch[1]) :: T
    end

    function _node_to_Expr(op :: cos_operator)
        return [:cos]
    end

    export operator
end
