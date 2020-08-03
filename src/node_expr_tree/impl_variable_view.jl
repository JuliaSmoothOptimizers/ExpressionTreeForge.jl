module variables_view
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
    using ..variables


    import Base.(==)

    mutable struct variable_view{Y <: Number}  <: ab_ex_nd
        name :: Symbol
        index :: Int
        x_view :: SubArray{Y,1,Array{Y,1},Tuple{Array{Int64,1}},false}
    end

    @inline get_name(v :: variable_view{Y}) where Y <: Number = v.name
    @inline get_index(v :: variable_view{Y}) where Y <: Number = v.index
    @inline get_x_view(v :: variable_view{Y}) where Y <: Number = v.x_view
    @inbounds @inline get_value(v :: variable_view{Y}) where Y <: Number = get_x_view(v)[1]

    _node_bound(v :: variable_view{Y}, t :: DataType) where Y <: Number = ((t)(-Inf), (t)(Inf))

    _node_convexity(v :: variable_view{Y}) where Y <: Number = implementation_convexity_type.linear_type()

    @inline create_node_expr(n :: Symbol, id :: Int, x :: AbstractVector{Y}) where Y <: Number = variable_view(n, id, view(x, [id]) )
    @inline create_node_expr(n :: Symbol, id :: MathOptInterface.VariableIndex, x :: AbstractVector{Y}) where Y <: Number = variable_view(n, id.value, view(x, [id.value]) )
    @inline create_node_expr(v :: variable_view{Y}, x :: AbstractVector{Y}) where Y <: Number = variable_view(v.name, v.index, view(x, [v.index]) )
    @inline create_node_expr(v :: variables.variable, x :: AbstractVector{Y}) where Y <: Number = create_node_expr( variables.get_name(v), variables.get_index(v), x)

    # (SubArray{Y,1,Array{Y,1},Tuple{Array{Int64,1}},false} where Y <: Number) <: (AbstractVector{Y} where Y <: Number)

    @inline _node_is_operator( v :: variable_view{Y}) where Y <: Number = false
    @inline _node_is_plus( v :: variable_view{Y}) where Y <: Number = false
    @inline _node_is_minus(v :: variable_view{Y}) where Y <: Number = false
    @inline _node_is_times(v :: variable_view{Y}) where Y <: Number = false
    @inline _node_is_power(v :: variable_view{Y}) where Y <: Number = false
    @inline _node_is_sin(v :: variable_view{Y}) where Y <: Number = false
    @inline _node_is_cos(v :: variable_view{Y}) where Y <: Number = false
    @inline _node_is_tan(v :: variable_view{Y}) where Y <: Number = false

    @inline _node_is_variable(v :: variable_view{Y}) where Y <: Number = true

    @inline _node_is_constant(v :: variable_view{Y}) where Y <: Number = false

    @inline _get_type_node(v :: variable_view{Y}) where Y <: Number = implementation_type_expr.return_linear()

    @inline _get_var_index(v :: variable_view{Y}) where Y <: Number = v.index :: Int

    @inline (==)(a :: variable_view{Y}, b :: variable_view{Y}) where Y <: Number =  (a.name == b.name) && (a.index == b.index) && (a.x_view[1] == b.x_view[1])

    @inline _evaluate_node(v :: variable_view{Y}, dic :: Dict{Int,Y}) where Y <: Number = dic[v.index] :: T
    @inline _evaluate_node(v :: variable_view{Y}, x :: AbstractVector{Y}) where Y <: Number = get_values(v)
    @inline _evaluate_node!(v :: variable_view{Y}, x :: AbstractVector{Y}, ref :: myRef{Y}) where Y <: Number =  abstract_expr_node.set_myRef!(ref, get_value(v,x))
    @inline _evaluate_node(v :: variable_view{Y}) where Y <: Number = get_values(v)
    @inline _evaluate_node!(v :: variable_view{Y}, ref :: myRef{Y}) where Y <: Number =  abstract_expr_node.set_myRef!(ref, get_value(v))


    function change_index( v :: MathOptInterface.VariableIndex, x :: AbstractVector{T}) where T <: Number
        return x[v.value]
    end

    function _change_from_N_to_Ni!(v :: variable_view{Y}, dic_new_var :: Dict{Int,Int}) where Y <: Number
        v.index = dic_new_var[v.index]
        paren_x_view = parent(x_view)
        v.x_view = view(paren_x_view, [v.index])
    end


    function _node_to_Expr(v :: variable_view{Y}) where Y <: Number
        return Expr(:ref, v.name,  MathOptInterface.VariableIndex(v.index))
    end

    function _node_to_Expr2(v :: variable_view{Y}) where Y <: Number
        return Expr(:ref, v.name,  v.index)
    end

    function _cast_constant!(v :: variable_view{Y}, t :: DataType) where Y <: Number
        x_view = get_x_view(v)
        parent = parent(x_view)
        eltype(parent) != t || ("wrong type from the parent of the variable view")
        index = get_index(v)
        name = get_name(v)
        create_node_expr(n, index, parent)
    end


    export variable
end
