module sinus_operators

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
    import ..interface_expr_node._node_bound



    import Base.==

    mutable struct sinus_operator <: ab_ex_nd

    end

    function _node_bound(op :: sinus_operator, son_bound :: AbstractVector{Tuple{T,T}}, t :: DataType) where T <: Number
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
            return (inf_bound_sin(bi_π, bs_π, t), sup_bound_sin(bi_π, bs_π, t))
        end
    end

    function sup_bound_sin(bi , bs, t :: DataType )
        if belong(bi, bs, π/2)
            return t(1)
        elseif bs < π/2 #bi également
            return sin(bs)
        else
            return max(sin(bs), sin(bi))
        end
    end

    function inf_bound_sin(bi , bs, t :: DataType )
        if belong(bi, bs, -π/2)
            return t(-1)
        elseif bi > -π/2 #bs également
            return sin(bi) # sin(bs) plus grand
        else
            return min(sin(bs), sin(bi)) #cas bi=0 et bs = 3π/4
        end
    end

    belong(bi ,bs, x ) = (bi<= x) && (bs >= x)


    function create_node_expr( op :: sinus_operator)
        return sinus_operator()
    end


    _node_is_operator( op :: sinus_operator ) = true
    _node_is_plus( op :: sinus_operator ) = false
    _node_is_minus(op :: sinus_operator ) = false
    _node_is_times(op :: sinus_operator ) = false
    _node_is_power(op :: sinus_operator ) = false
    _node_is_sin(op :: sinus_operator) = true
    _node_is_cos(op :: sinus_operator) = false
    _node_is_tan(op :: sinus_operator) = false

    _node_is_variable(op :: sinus_operator ) = false

    _node_is_constant(op :: sinus_operator ) = false

    function _get_type_node(op :: sinus_operator, type_ch :: Vector{t_type_expr_basic})
        if length(type_ch) == 1
            t_child = type_ch[1]
            if trait_type_expr._is_constant(t_child)
                return t_child
            else
                return implementation_type_expr.return_more()
            end
        end
    end

    (==)(a :: sinus_operator, b :: sinus_operator) = true

    function _evaluate_node(op :: sinus_operator, value_ch :: AbstractVector{T}) where T <: Number
        length(value_ch) == 1 || error("more than one argument for sin")
        return sin(value_ch[1])
    end

    function _evaluate_node2(op :: sinus_operator, value_ch :: AbstractVector{T}) where T <: Number
        length(value_ch) == 1 || error("more than one argument for sin")
        return sin(value_ch[1]) :: T
    end

    function _node_to_Expr(op :: sinus_operator)
        return [:sin]
    end

    export operator
end
