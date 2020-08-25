module sinus_operators

    import ..abstract_expr_node.ab_ex_nd, ..abstract_expr_node.create_node_expr

    import ..interface_expr_node._node_is_plus, ..interface_expr_node._node_is_minus, ..interface_expr_node._node_is_power, ..interface_expr_node._node_is_times
    import ..interface_expr_node._node_is_constant, ..interface_expr_node._node_is_variable,..interface_expr_node._node_is_operator
    import ..interface_expr_node._node_is_sin, ..interface_expr_node._node_is_cos, ..interface_expr_node._node_is_tan
    import ..interface_expr_node._cast_constant!, ..interface_expr_node._node_to_Expr

    import ..implementation_type_expr.t_type_expr_basic
    using ..trait_type_expr

    import ..interface_expr_node._get_type_node, ..interface_expr_node._evaluate_node, ..interface_expr_node._evaluate_node!

    using ..implementation_type_expr
    import ..interface_expr_node._node_bound, ..interface_expr_node._node_convexity
    using ..implementation_convexity_type
    using ..abstract_expr_node


    import Base.==

    mutable struct sinus_operator <: ab_ex_nd

    end

    function _node_convexity(op :: sinus_operator,
                             son_cvx :: AbstractVector{implementation_convexity_type.convexity_type},
                             son_bound :: AbstractVector{Tuple{T,T}}
                             ) where T <: Number
        (length(son_cvx) == length(son_bound) && length(son_cvx) == 1) || error("unsuitable length of parameters _node_convexity : exp_operator")
        status = son_cvx[1]
        (bi,bs) = son_bound[1]
        if implementation_convexity_type.is_constant(status)
            return implementation_convexity_type.constant_type()
        elseif (bs - bi > π) || (sin(bi) * sin(bs) < 0)
            return implementation_convexity_type.unknown_type()
        elseif ((bs - bi <= π) && (sin(bi) >= 0) && (sin(bs) >= 0)) && (implementation_convexity_type.is_linear(status) || (implementation_convexity_type.is_convex(status) && cos(bi) <= 0 && cos(bs <= 0 )) || (implementation_convexity_type.is_concave(status) && cos(bi) >= 0 && cos( bs >= 0 )) )
            return implementation_convexity_type.concave_type()
        elseif ((bs - bi <= π) && (sin(bi) <= 0) && (sin(bs) <= 0)) && (implementation_convexity_type.is_linear(status) || (implementation_convexity_type.is_convex(status) && cos(bi) >= 0 && cos(bs >= 0 )) || (implementation_convexity_type.is_concave(status) && cos(bi) <= 0 && cos( bs <= 0 )) )
            return implementation_convexity_type.convex_type()
        else
            return implementation_convexity_type.unknown_type()
        end
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

    @inline belong(bi ,bs, x ) = (bi<= x) && (bs >= x)


    @inline create_node_expr( op :: sinus_operator) = sinus_operator()



    @inline _node_is_operator( op :: sinus_operator ) = true
        @inline _node_is_plus( op :: sinus_operator ) = false
        @inline _node_is_minus(op :: sinus_operator ) = false
        @inline _node_is_times(op :: sinus_operator ) = false
        @inline _node_is_power(op :: sinus_operator ) = false
        @inline _node_is_sin(op :: sinus_operator) = true
        @inline _node_is_cos(op :: sinus_operator) = false
        @inline _node_is_tan(op :: sinus_operator) = false

    @inline _node_is_variable(op :: sinus_operator ) = false

    @inline _node_is_constant(op :: sinus_operator ) = false

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

    @inline (==)(a :: sinus_operator, b :: sinus_operator) = true

    @inline function _evaluate_node(op :: sinus_operator, value_ch :: AbstractVector{T}) where T <: Number
        length(value_ch) == 1 || error("more than one argument for sin")
        return sin(value_ch[1])
    end

    @inline function _evaluate_node!(op :: sinus_operator, value_ch :: AbstractVector{myRef{Y}}, ref :: abstract_expr_node.myRef{Y}) where Y <: Number
        length(value_ch) == 1 || error("power has more than one argument")
        @inbounds @fastmath abstract_expr_node.set_myRef!(ref, sin(value_ch[1]) )
    end

    @inline function _evaluate_node!(op :: sinus_operator, vec_value_ch :: Vector{Vector{myRef{Y}}}, vec_ref :: Vector{abstract_expr_node.myRef{Y}}) where Y <: Number
        for i in 1:length(vec_value_ch)
             _evaluate_node!(op, vec_value_ch[i], vec_ref[i])
        end
    end

    @inline _node_to_Expr(op :: sinus_operator) = [:sin]

end
