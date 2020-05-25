module simple_operators

    import ..abstract_expr_node.ab_ex_nd, ..abstract_expr_node.create_node_expr

    import ..interface_expr_node._node_is_plus, ..interface_expr_node._node_is_minus, ..interface_expr_node._node_is_power, ..interface_expr_node._node_is_times
    import ..interface_expr_node._node_is_constant, ..interface_expr_node._node_is_variable,..interface_expr_node._node_is_operator
    import ..interface_expr_node._node_is_sin, ..interface_expr_node._node_is_cos, ..interface_expr_node._node_is_tan

    import ..interface_expr_node._get_type_node, ..interface_expr_node._evaluate_node
    import ..interface_expr_node._cast_constant!, ..interface_expr_node._node_to_Expr
    import Base.==

    using ..implementation_type_expr
    using ..trait_type_expr

    using ..plus_operators, ..minus_operators, ..times_operators, ..sinus_operators, ..tan_operators, ..cos_operators, ..exp_operators

    mutable struct simple_operator <: ab_ex_nd
        op :: Symbol
    end


    function create_node_expr(op :: Symbol)
        if op == :+
            plus_operators.plus_operator()
        elseif op == :-
            minus_operators.minus_operator()
        elseif op ==:*
            times_operators.time_operator()
        elseif op == :sin
            sinus_operators.sinus_operator()
        elseif op == :tan
            tan_operators.tan_operator()
        elseif op == :cos
            cos_operators.cos_operator()
        elseif op == :exp
            exp_operators.exp_operator()
        else
            return simple_operator(op)
        end
    end

    _node_is_operator( op :: simple_operator) = true
    _node_is_plus( op :: simple_operator) = (op.op == :+)
    _node_is_minus(op :: simple_operator) = (op.op == :-)
    _node_is_times(op :: simple_operator) = (op.op == :*)
    _node_is_power(op :: simple_operator) = false
    _node_is_sin(op :: simple_operator) = (op.op == :sin)
    _node_is_cos(op :: simple_operator) = (op.op == :cos)
    _node_is_tan(op :: simple_operator) = (op.op == :tan)

    _node_is_variable(op :: simple_operator) = false

    _node_is_constant(op :: simple_operator) = false


    function _get_type_node(op :: simple_operator, type_ch :: Vector{implementation_type_expr.t_type_expr_basic})
        if _node_is_plus(op) || _node_is_minus(op)
            if length(type_ch) == 1
                return type_ch[1]
            else
                return max(type_ch...)
            end
        elseif _node_is_times(op)
            return foldl(trait_type_expr.type_product, type_ch)
        elseif _node_is_tan(op) || _node_is_cos(op) || _node_is_sin(op)
            if length(type_ch) == 1
                t_child = type_ch[1]
                if trait_type_expr._is_constant(t_child)
                    return t_child
                else
                    return implementation_type_expr.return_more()
                end
            else
                error("trigonometric function should have only one child")
            end
        else
            error("operator undefined")
        end
    end

    (==)(a :: simple_operator, b :: simple_operator) = (a.op == b.op)

    function _evaluate_node(op :: simple_operator, value_ch :: Vector{T}) where T <: Number
        if _node_is_plus(op)
            return sum(value_ch) :: T
        elseif _node_is_minus(op)
            if length(value_ch) == 1
                return - value_ch[1] :: T
            else
                return value_ch[1] - value_ch[2] :: T
            end
        elseif _node_is_cos(op)
            length(value_ch) == 1 || error("more than one argument for cos")
            return cos(value_ch[1]) :: T
        elseif _node_is_sin(op)
            length(value_ch) == 1 || error("more than one argument for sin")
            return sin(value_ch[1]) :: T
        elseif _node_is_tan(op)
            length(value_ch) == 1 || error("more than one argument for tan")
            return tan(value_ch[1]) :: T
        else
            error("non traité pour le moment impl_simple_operator.jl/_eval_node")
        end
    end


    function _evaluate_node(op :: simple_operator, value_ch :: SubArray{T,1,Array{T,1},Tuple{Array{Int64,1}},false} ) where T <: Number
        if _node_is_plus(op)
            return sum(value_ch) :: T
        elseif _node_is_minus(op)
            if length(value_ch) == 1
                return - value_ch[1] :: T
            else
                return value_ch[1] - value_ch[2] :: T
            end
        elseif _node_is_times(op)
            return foldl(*, value_ch) :: T
        elseif _node_is_cos(op)
            length(value_ch) == 1 || error("more than one argument for cos")
            return cos(value_ch[1]) :: T
        elseif _node_is_sin(op)
            length(value_ch) == 1 || error("more than one argument for sin")
            return sin(value_ch[1]) :: T
        elseif _node_is_tan(op)
            length(value_ch) == 1 || error("more than one argument for tan")
            return tan(value_ch[1]) :: T
        else
            error("non traité pour le moment impl_simple_operator.jl/_eval_node")
        end
    end


    function _node_to_Expr(v :: simple_operator)
        return [v.op]
    end


    export operator
end
