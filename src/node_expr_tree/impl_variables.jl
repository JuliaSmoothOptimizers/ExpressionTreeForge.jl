module variables
    using MathOptInterface

    import ..abstract_expr_node.ab_ex_nd, ..abstract_expr_node.create_node_expr

    import ..interface_expr_node._node_is_plus, ..interface_expr_node._node_is_minus, ..interface_expr_node._node_is_power, ..interface_expr_node._node_is_times
    import ..interface_expr_node._node_is_constant, ..interface_expr_node._node_is_variable,..interface_expr_node._node_is_operator
    import ..interface_expr_node._node_is_sin, ..interface_expr_node._node_is_cos, ..interface_expr_node._node_is_tan


    import ..implementation_type_expr.t_type_expr_basic
    import ..interface_expr_node._get_type_node, ..interface_expr_node._get_var_index
    import  ..interface_expr_node._evaluate_node, ..interface_expr_node._evaluate_node!, ..interface_expr_node._change_from_N_to_Ni!
    import ..interface_expr_node._cast_constant!, ..interface_expr_node._node_to_Expr, ..interface_expr_node._node_to_Expr2

    import ..interface_expr_node._node_bound, ..interface_expr_node._node_convexity
    using ..implementation_convexity_type

    using ..implementation_type_expr

    using  ..abstract_expr_node


    import Base.(==)

    mutable struct variable <: ab_ex_nd
        name :: Symbol
        index :: Int
    end

    @inline get_name(v :: variable) = v.name
    @inline get_index(v :: variable) = v.index
    @inline get_value(v :: variable, x :: AbstractVector{T}) where T <: Number = x[get_index(v)]

    _node_bound(v :: variable, t :: DataType) = ((t)(-Inf), (t)(Inf))

    _node_convexity(v :: variable) = implementation_convexity_type.linear_type()

    create_node_expr(n :: Symbol, id :: Int) = variable(n, id)
    create_node_expr(n :: Symbol, id :: MathOptInterface.VariableIndex) = variable(n, id.value)
    create_node_expr(v :: variable) = variable(v.name, v.index)

    create_node_expr(n :: Symbol, id :: Int, x :: AbstractVector{Y}) where Y <: Number = variable(n, id)
    create_node_expr(n :: Symbol, id :: MathOptInterface.VariableIndex, x :: AbstractVector{Y}) where Y <: Number = variable(n, id.value)
    create_node_expr(v :: variable, x :: AbstractVector{Y}) where Y <: Number = variable(v.name, v.index)

    _node_is_operator( v :: variable) = false
    _node_is_plus( v :: variable) = false
    _node_is_minus(v :: variable) = false
    _node_is_times(v :: variable) = false
    _node_is_power(v :: variable) = false
    _node_is_sin(v :: variable) = false
    _node_is_cos(v :: variable) = false
    _node_is_tan(v :: variable) = false

    _node_is_variable(v :: variable) = true
    _node_is_variable(v :: Symbol) = true

    _node_is_constant(v :: variable) = false

    _get_type_node(v :: variable) = implementation_type_expr.return_linear()

    _get_var_index(v :: variable) = v.index :: Int

    (==)(a :: variable, b :: variable) =  (a.name == b.name) && (a.index == b.index)

    function _evaluate_node(v :: variable, dic :: Dict{Int,T}) where T <: Number
        return dic[v.index] :: T
    end

    @inline _evaluate_node(v :: variable, x :: AbstractVector{T}) where T <: Number = @inbounds x[v.index]

    @inbounds @inline _evaluate_node!(v :: variable, x :: AbstractVector{T}, ref :: myRef{T}) where T <: Number =  abstract_expr_node.set_myRef!(ref, get_value(v,x))


    function change_index( v :: MathOptInterface.VariableIndex, x :: AbstractVector{T}) where T <: Number
        return x[v.value]
    end

    function _change_from_N_to_Ni!(v :: variable, dic_new_var :: Dict{Int,Int})
        v.index = dic_new_var[v.index]
    end

    function _change_from_N_to_Ni!(v :: Expr, dic_new_var :: Dict{Int,Int})
        hd = v.head
        if hd != :ref
            error("on ne traite pas autre chose qu'une variable")
        else
            index_variable = v.args[2]
            v.args[2] = change_index(index_variable, dic_new_var)
        end
    end

    function change_index( x :: Int, dic_new_var :: Dict{Int,Int})
        return dic_new_var[x]
    end
    function change_index( x :: MathOptInterface.VariableIndex, dic_new_var :: Dict{Int,Int})
        return MathOptInterface.VariableIndex(dic_new_var[x.value])
    end

    function _node_to_Expr(v :: variable)
        return Expr(:ref, v.name,  MathOptInterface.VariableIndex(v.index))
    end

    function _node_to_Expr2(v :: variable)
        # return Expr(:ref, v.name,  v.index)
        return Symbol( string(v.name) * string(v.index))
    end

    _cast_constant!(v :: variable, t :: DataType) = v


    export variable
end
