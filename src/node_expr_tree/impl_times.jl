module times_operators

    import ..abstract_expr_node.ab_ex_nd, ..abstract_expr_node.create_node_expr

    import ..interface_expr_node._node_is_plus, ..interface_expr_node._node_is_minus, ..interface_expr_node._node_is_power, ..interface_expr_node._node_is_times
    import ..interface_expr_node._node_is_constant, ..interface_expr_node._node_is_variable,..interface_expr_node._node_is_operator
    import ..interface_expr_node._node_is_sin, ..interface_expr_node._node_is_cos, ..interface_expr_node._node_is_tan
    import ..interface_expr_node._cast_constant!, ..interface_expr_node._node_to_Expr

    import ..implementation_type_expr.t_type_expr_basic
    using ..trait_type_expr

    import ..interface_expr_node._get_type_node, ..interface_expr_node._evaluate_node

    import  ..interface_expr_node._evaluate_node2
    import  ..interface_expr_node._node_bound

    import Base.==

    mutable struct time_operator <: ab_ex_nd

    end

    # remarque le produit doit-être au moins binaire
    function _node_bound(op :: time_operator , son_bound :: AbstractVector{Tuple{T,T}}, t :: DataType) where Y <: Number where T <: Number
        vector_inf_bound = [p[1] for p in son_bound]
        vector_sup_bound = [p[2] for p in son_bound]
        bi = - (T)(vector_inf_bound[1]) :: T
        bs = (T)(vector_sup_bound[1]) :: T
        n = length(vector_inf_bound)
        for i in 2:n
            (bi,bs) = bound_binary_times(bi,bs, vector_inf_bound[i], vector_sup_bound[i])
        end
        return (bi,bs)
    end

    function bound_binary_times(bi1 :: T, bs1 :: T, bi2 :: T, bs2 :: T) where T <: Number
        products = [bi1 * bi2, bi1 * bs2, bs1 * bi2, bs1 * bs2]
        filtered_products = filter( (x -> isnan(x) == false), products)
        # @show filtered_products, products, bi1,bs1,bi2,bs2
        bi = min(filtered_products...)
        bs = max(filtered_products...)
        return (bi,bs)
    end


    function create_node_expr(op :: time_operator)
        return time_operator()
    end

    _node_is_operator( op :: time_operator ) = true
    _node_is_plus( op :: time_operator ) = false
    _node_is_minus(op :: time_operator ) = false
    _node_is_times(op :: time_operator ) = true
    _node_is_power(op :: time_operator ) = false
    _node_is_sin(op :: time_operator) = false
    _node_is_cos(op :: time_operator) = false
    _node_is_tan(op :: time_operator) = false

    _node_is_variable(op :: time_operator ) = false

    _node_is_constant(op :: time_operator ) = false

    function _get_type_node(op :: time_operator, type_ch :: Vector{t_type_expr_basic})
        foldl(trait_type_expr.type_product, type_ch)
    end

    (==)(a :: time_operator, b :: time_operator) = true

    function _evaluate_node(op :: time_operator, value_ch :: AbstractVector{T}) where T <: Number
        return foldl(*,value_ch)
    end

    function _evaluate_node2(op :: time_operator, value_ch :: AbstractVector{T}) where T <: Number
        return foldl(*,value_ch)
    end

    function _node_to_Expr(op :: time_operator)
        return [:*]
    end

    export operator
end
