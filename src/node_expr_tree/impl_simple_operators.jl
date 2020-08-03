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

    using ..plus_operators, ..minus_operators, ..times_operators, ..sinus_operators, ..tan_operators, ..cos_operators, ..exp_operators, ..frac_operators

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
        elseif op ==:/
            frac_operators.frac_operator()
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



function create_node_expr(op :: Symbol, x :: AbstractVector{Y}) where Y <: Number
        if op == :+
            plus_operators.plus_operator()
        elseif op == :-
            minus_operators.minus_operator()
        elseif op ==:*
            times_operators.time_operator()
        elseif op ==:/
            frac_operators.frac_operator()
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


    export operator
end
