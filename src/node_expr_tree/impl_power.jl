module power_operators

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

    mutable struct power_operator{T <: Number} <: ab_ex_nd
        index :: T
    end

    my_and(a :: Bool, b :: Bool) = (a && b)
    function _node_convexity(op :: power_operator{Y},
                             son_cvx :: AbstractVector{implementation_convexity_type.convexity_type},
                             son_bound :: AbstractVector{Tuple{T,T}}
                             ) where Y <: Number where T <: Number
        (length(son_cvx) == 1 && length(son_bound) == 1) || error("non-valide length of argument _node_convexity power operator")
        st_ch = son_cvx[1]
        (bi,bs) = son_bound[1]
        if (op.index == 0 || implementation_convexity_type.is_constant(st_ch))
            return implementation_convexity_type.constant_type()
        elseif op.index == 1
            return st_ch
        elseif op.index %2 == 0
            if implementation_convexity_type.is_linear(st_ch)
                return implementation_convexity_type.convex_type()
            elseif op.index > 0
                if (implementation_convexity_type.is_convex(st_ch) && bi >= 0) || (implementation_convexity_type.is_concave(st_ch) && bs <= 0)
                    return implementation_convexity_type.convex_type()
                else
                    return implementation_convexity_type.unknown_type()
                end
            else # op.index < 0
                if (implementation_convexity_type.is_convex(st_ch) && bs <= 0) || (implementation_convexity_type.is_concave(st_ch) && bi >= 0)
                    return implementation_convexity_type.convex_type()
                elseif (implementation_convexity_type.is_convex(st_ch) && bi >= 0) || (implementation_convexity_type.is_concave(st_ch) && bs <= 0)
                    return implementation_convexity_type.concave_type()
                else
                    return implementation_convexity_type.unknown_type()
                end
            end
        elseif op.index %2 == 1  #op.indxx is odd
            if op.index > 0
                if implementation_convexity_type.is_convex(st_ch) && bi >= 0
                    return implementation_convexity_type.convex_type()
                elseif implementation_convexity_type.is_concave(st_ch) && bs <= 0
                    return implementation_convexity_type.concave_type()
                else
                    return implementation_convexity_type.unknown_type()
                end
            else #op.indxx is odd and <0
                if implementation_convexity_type.is_concave(st_ch) && bi >= 0
                    return implementation_convexity_type.convex_type()
                elseif implementation_convexity_type.is_convex(st_ch) && bs <= 0
                    return implementation_convexity_type.concave_type()
                else
                    return implementation_convexity_type.unknown_type()
                end
            end
        else
            return implementation_convexity_type.unknown_type()
        end
    end

    # on est sensé avoir en paramètre le liste des bornes des fils. dans le cas de l'opération puissance il n'y a qu'un seul fils.
    # les 6 premières lignes de la fonction ont pour objectif de récupérer ces 2 bornes
    function _node_bound(op :: power_operator{Y} , son_bound :: AbstractVector{Tuple{T,T}}, t :: DataType) where Y <: Number where T <: Number
        vector_inf_bound = [p[1] for p in son_bound]
        vector_sup_bound = [p[2] for p in son_bound]
        length(vector_inf_bound) == 1 || error("puissance non unaire")
        length(vector_sup_bound) == 1 || error("puissance non unaire")
        bi = vector_inf_bound[1]
        bs = vector_sup_bound[1]
        if op.index % 2 == 0
            if bi > 0  # bs aussi
                return (bi^(op.index), bs^(op.index))
            elseif bs < 0 #bi aussi
                return (bs^(op.index), bi^(op.index))
            else
                return ((t)(0) , max( abs(bi), abs(bs))^(op.index) )
            end
        else
            return (bi^(op.index), bs^(op.index))
        end
    end


    @inline create_node_expr(op :: Symbol, arg :: T , ::Bool) where T <: Number = power_operator{T}(arg)
    @inline create_node_expr(op :: power_operator{T} ) where T <: Number= power_operator{T}(op.index)
    @inline create_node_expr(op :: Symbol, arg :: T , x :: AbstractVector{T}, ::Bool) where T <: Number = power_operator{T}(arg)
    @inline create_node_expr(op :: power_operator{T}, x :: AbstractVector{T} ) where T <: Number= power_operator{T}(op.index)


    _node_is_operator( op :: power_operator{T} ) where T <: Number= true
    _node_is_plus( op :: power_operator{T} ) where T <: Number = false
    _node_is_minus(op :: power_operator{T} ) where T <: Number = false
    _node_is_times(op :: power_operator{T} ) where T <: Number = false
    _node_is_power(op :: power_operator{T} ) where T <: Number = true
    _node_is_sin(op :: power_operator{T}) where T <: Number = false
    _node_is_cos(op :: power_operator{T}) where T <: Number = false
    _node_is_tan(op :: power_operator{T}) where T <: Number = false

    _node_is_variable(op :: power_operator{T} ) where T <: Number = false

    _node_is_constant(op :: power_operator{T} ) where T <: Number = false

    function _get_type_node(op :: power_operator{T}, type_ch :: Vector{t_type_expr_basic}) where T <: Number
        length(type_ch) == 1 || error("power has more than one argument")
        return trait_type_expr.type_power(op.index, type_ch[1])
    end

    (==)(a :: power_operator{T}, b :: power_operator{T}) where T <: Number = ( a.index == b.index)

    @inline function _evaluate_node(op :: power_operator{Z}, value_ch :: AbstractVector{T}) where T <: Number where Z <: Number
        length(value_ch) == 1 || error("power has more than one argument")
        return value_ch[1]^(op.index)
    end

    @inline function _evaluate_node(op :: power_operator{T}, value_ch :: AbstractVector{T}) where T <: Number
        length(value_ch) == 1 || error("power has more than one argument")
        @inbounds @fastmath return value_ch[1]^(op.index) :: T
    end

    @inline function _evaluate_node!(op :: power_operator{Y}, value_ch :: AbstractVector{myRef{Y}}, ref :: abstract_expr_node.myRef{Y}) where Y <: Number
        length(value_ch) == 1 || error("power has more than one argument")
        @inbounds @fastmath abstract_expr_node.set_myRef!(ref, value_ch[1]^(op.index) :: Y)
    end

    @inline function _evaluate_node!(op :: power_operator{Y}, vec_value_ch :: Vector{Vector{myRef{Y}}}, vec_ref :: Vector{abstract_expr_node.myRef{Y}}) where Y <: Number
        for i in 1:length(vec_value_ch)
             _evaluate_node!(op, vec_value_ch[i], vec_ref[i])
        end
    end


    @inline _evaluate_node(op :: power_operator{Z}, value_ch :: T) where T <: Number where Z <: Number = @fastmath (T)( value_ch^(op.index) ) :: T
    @inline _evaluate_node(op :: power_operator{T}, value_ch :: T) where T <: Number where Z <: Number = @fastmath  value_ch^(op.index) :: T

    @inline _evaluate_node!(op :: power_operator{Y}, value_ch :: Y, ref :: abstract_expr_node.myRef{Y}) where Y <: Number = @fastmath abstract_expr_node.set_myRef!(ref, value_ch^(op.index) :: Y)

    function _node_to_Expr(op :: power_operator{T}) where T <: Number
        return [:^, op.index]
    end

    function _cast_constant!(op :: power_operator{T}, t :: DataType) where T <: Number
        new_index = (t)(op.index)
        return power_operator{t}(new_index)
    end

    export operator
end
