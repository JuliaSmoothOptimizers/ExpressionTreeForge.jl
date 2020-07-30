module plus_operators

    import ..abstract_expr_node.ab_ex_nd, ..abstract_expr_node.create_node_expr

    import ..interface_expr_node._node_is_plus, ..interface_expr_node._node_is_minus, ..interface_expr_node._node_is_power, ..interface_expr_node._node_is_times
    import ..interface_expr_node._node_is_constant, ..interface_expr_node._node_is_variable,..interface_expr_node._node_is_operator
    import ..interface_expr_node._node_is_sin, ..interface_expr_node._node_is_cos, ..interface_expr_node._node_is_tan
    import ..interface_expr_node._cast_constant!, ..interface_expr_node._node_to_Expr

    import ..implementation_type_expr.t_type_expr_basic
    using ..trait_type_expr

    import ..interface_expr_node._get_type_node, ..interface_expr_node._evaluate_node, ..interface_expr_node._evaluate_node!

    import ..interface_expr_node._node_bound, ..interface_expr_node._node_convexity
    using ..implementation_convexity_type

    using ..abstract_expr_node

    import Base.==

    mutable struct plus_operator <: ab_ex_nd

    end

    my_and(a :: Bool, b :: Bool) = (a && b)
    function _node_convexity(op :: plus_operator,
                             son_cvx :: AbstractVector{implementation_convexity_type.convexity_type},
                             son_bound :: AbstractVector{Tuple{T,T}}
                             ) where T <: Number
        all_constant = mapreduce(x :: implementation_convexity_type.convexity_type -> implementation_convexity_type.is_constant(x), my_and, son_cvx)
        all_linear = mapreduce(x :: implementation_convexity_type.convexity_type -> implementation_convexity_type.is_linear(x), my_and, son_cvx)
        all_convex = mapreduce(x :: implementation_convexity_type.convexity_type -> implementation_convexity_type.is_convex(x), my_and, son_cvx)
        all_concave = mapreduce(x :: implementation_convexity_type.convexity_type -> implementation_convexity_type.is_concave(x), my_and, son_cvx)
        if all_constant
            return implementation_convexity_type.constant_type()
        elseif all_linear
            return implementation_convexity_type.linear_type()
        elseif all_convex
            return implementation_convexity_type.convex_type()
        elseif all_concave
            return implementation_convexity_type.concave_type()
        else
            return implementation_convexity_type.unknown_type()
        end
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

    @inline _evaluate_node(op :: plus_operator, value_ch :: AbstractVector{T}) where T <: Number = @fastmath sum(value_ch)
    @inline _evaluate_node!(op :: plus_operator, value_ch :: AbstractVector{abstract_expr_node.myRef{T}}, ref :: abstract_expr_node.myRef{T} ) where T <: Number = @fastmath abstract_expr_node.set_myRef!(ref, sum(value_ch))


    function _node_to_Expr(op :: plus_operator)
        return [:+]
    end

    export operator
end
