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
    import ..interface_expr_node._node_bound
    using ..implementation_type_expr


    import Base.==

    mutable struct cos_operator <: ab_ex_nd

    end


    function _node_bound(op :: cos_operator, son_bound :: AbstractVector{Tuple{T,T}}, t :: DataType) where T <: Number
        vector_inf_bound = [p[1] for p in son_bound]
        vector_sup_bound = [p[2] for p in son_bound]
        length(vector_inf_bound) == 1 || error("sinus non unaire")
        length(vector_sup_bound) == 1 || error("sinus non unaire")
        bi = vector_inf_bound[1]
        bs = vector_sup_bound[1]
        if abs(bs - bi) > 2 * π ||  isinf(bi) ||  isinf(bs)
            return (t(-1),t(1))
        else
            bs_π = max(bs % (2*π), bi % (2*π))
            bi_π = min(bs % (2*π), bi % (2*π))
            # @show "sinus", bi, bs, bi_π, bs_π, inf_bound_sin(bi_π, bs_π), sup_bound_sin(bi_π, bs_π)
            return (inf_bound_cos(bi_π, bs_π, t), sup_bound_cos(bi_π, bs_π, t))
        end
    end

    function sup_bound_cos(bi , bs, t :: DataType )
        if belong(bi, bs, 0)
            return t(1)
        elseif bi > 0 #bi également
            return cos(bi)
        else
            return max(cos(bs), cos(bi))
        end
    end

    function inf_bound_cos(bi , bs, t :: DataType )
        if belong(bi, bs, π)
            return t(-1)
        elseif bs < π #bs également
            return cos(bs) # sin(bs) plus grand
        else
            return min(cos(bs), cos(bi)) #cas bi=0 et bs = 3π/4
        end
    end

    belong(bi ,bs, x ) = (bi<= x) && (bs >= x)


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
