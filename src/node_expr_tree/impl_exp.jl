module exp_operators

    import ..abstract_expr_node.ab_ex_nd, ..abstract_expr_node.create_node_expr

    import ..interface_expr_node._node_is_plus, ..interface_expr_node._node_is_minus, ..interface_expr_node._node_is_power, ..interface_expr_node._node_is_times
    import ..interface_expr_node._node_is_constant, ..interface_expr_node._node_is_variable,..interface_expr_node._node_is_operator
    import ..interface_expr_node._node_is_sin, ..interface_expr_node._node_is_cos, ..interface_expr_node._node_is_tan
    import ..interface_expr_node._cast_constant!, ..interface_expr_node._node_to_Expr

    import ..implementation_type_expr.t_type_expr_basic
    using ..trait_type_expr

    import ..interface_expr_node._get_type_node, ..interface_expr_node._evaluate_node

    import  ..interface_expr_node._evaluate_node2
    import ..interface_expr_node._node_bound, ..interface_expr_node._node_convexity
    using ..implementation_convexity_type


    using ..implementation_type_expr


    import Base.==

    mutable struct exp_operator <: ab_ex_nd

    end

    function _node_convexity(op :: exp_operator,
                             son_cvx :: AbstractVector{implementation_convexity_type.convexity_type},
                             son_bound :: AbstractVector{Tuple{T,T}}
                             ) where T <: Number
        (length(son_cvx) == length(son_bound) && length(son_cvx) == 1) || error("unsuitable length of parameters _node_convexity : exp_operator")
        status = son_cvx[1]
        if implementation_convexity_type.is_constant(status)
            return implementation_convexity_type.constant_type()
        elseif implementation_convexity_type.is_convex(status)
            return implementation_convexity_type.convex_type()
        else
            return implementation_convexity_type.unknown_type()
        end
    end

    function _node_bound(op :: exp_operator , son_bound :: AbstractVector{Tuple{T,T}}, t :: DataType) where Y <: Number where T <: Number
        vector_inf_bound = [p[1] for p in son_bound]
        vector_sup_bound = [p[2] for p in son_bound]
        length(vector_inf_bound) == 1 || error("puissance non unaire")
        length(vector_sup_bound) == 1 || error("puissance non unaire")
        bi = vector_inf_bound[1]
        bs = vector_sup_bound[1]
        return (exp(bi), exp(bs))
    end


    function create_node_expr( op :: exp_operator)
        return exp_operator()
    end


    _node_is_operator( op :: exp_operator ) = true
    _node_is_plus( op :: exp_operator ) = false
    _node_is_minus(op :: exp_operator ) = false
    _node_is_times(op :: exp_operator ) = false
    _node_is_power(op :: exp_operator ) = false
    _node_is_sin(op :: exp_operator) = false
    _node_is_cos(op :: exp_operator) = false
    _node_is_tan(op :: exp_operator) = false

    _node_is_variable(op :: exp_operator ) = false

    _node_is_constant(op :: exp_operator ) = false

    function _get_type_node(op :: exp_operator, type_ch :: Vector{t_type_expr_basic})
        if length(type_ch) == 1
            t_child = type_ch[1]
            if trait_type_expr._is_constant(t_child)
                return t_child
            else
                return implementation_type_expr.return_more()
            end
        end
    end

    (==)(a :: exp_operator, b :: exp_operator) = true

    function _evaluate_node(op :: exp_operator, value_ch :: AbstractVector{T}) where T <: Number
        length(value_ch) == 1 || error("more than one argument for exp")
        @fastmath return exp(value_ch[1])
    end

    function _evaluate_node2(op :: exp_operator, value_ch :: AbstractVector{T}) where T <: Number
        length(value_ch) == 1 || error("more than one argument for exp")
        return exp(value_ch[1]) :: T
    end


    function _node_to_Expr(op :: exp_operator)
        return [:exp]
    end

    export operator
end
