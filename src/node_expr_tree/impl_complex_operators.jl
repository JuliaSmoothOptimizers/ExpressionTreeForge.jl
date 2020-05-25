module complex_operators

    import ..abstract_expr_node.ab_ex_nd, ..abstract_expr_node.create_node_expr

    import ..interface_expr_node._node_is_plus, ..interface_expr_node._node_is_minus, ..interface_expr_node._node_is_power, ..interface_expr_node._node_is_times
    import ..interface_expr_node._node_is_constant, ..interface_expr_node._node_is_variable,..interface_expr_node._node_is_operator
    import ..interface_expr_node._node_is_sin, ..interface_expr_node._node_is_cos, ..interface_expr_node._node_is_tan
    import ..interface_expr_node._cast_constant!, ..interface_expr_node._node_to_Expr

    import ..implementation_type_expr.t_type_expr_basic
    import ..trait_type_expr.type_power

    import ..interface_expr_node._get_type_node, ..interface_expr_node._evaluate_node

    import Base.==

    mutable struct complex_operator <: ab_ex_nd
        op :: Symbol
        args :: Array
    end


    function create_node_expr(op :: Symbol, args_sup :: Array)
        return complex_operator(op, args_sup)
    end

    function create_node_expr(cp :: complex_operator)
        return complex_operator(cp.op, cp.args)
    end

    _node_is_operator( op :: complex_operator ) = true
    _node_is_plus( op :: complex_operator ) = (op.op == :+)
    _node_is_minus(op :: complex_operator ) = (op.op == :-)
    _node_is_times(op :: complex_operator ) = (op.op == :*)
    _node_is_power(op :: complex_operator ) = false
    _node_is_sin(op :: complex_operator) = (op.op == :sin)
    _node_is_cos(op :: complex_operator) = (op.op == :cos)
    _node_is_tan(op :: complex_operator) = (op.op == :tan)

    _node_is_variable(op :: complex_operator ) = false

    _node_is_constant(op :: complex_operator ) = false

    function _get_type_node(op :: complex_operator, type_ch :: Vector{t_type_expr_basic})
        if _node_is_power(op)
            index_power = op.args[1]
            return type_power(index_power, type_ch[1])
        else
            error("non fait pour le moment car uniquement pour la puissance actuellement ")
        end
    end

    (==)(a :: complex_operator, b :: complex_operator) = ( (a.op == b.op ) && (a.args == b.args) )

    function _evaluate_node(op :: complex_operator, value_ch :: Vector{})
        if _node_is_power(op)
            length(value_ch) == 1 || error("power has more than one argument")
            return value_ch[1]^(op.args[1]) :: Number
        else
            error("non traité pour le moment impl_complex_operator/_evaluate_node")
        end
    end


    function _node_to_Expr(op :: complex_operator)
        return [op.op, op.args...]
    end


    export operator
end
