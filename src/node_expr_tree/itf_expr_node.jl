module interface_expr_node

# This module define the interface that every node must support.
# All methods are not needed for all nodes.

"""
    bool = _node_is_operator(node::ab_ex_nd)

Check if `node` is an operator.
It could be also a variable or a constant.
"""
_node_is_operator() = ()

"""
    bool = _node_is_plus(node::ab_ex_nd)

Check if `node` is a `+` operator or not.
"""
_node_is_plus() = ()

"""
    bool = _node_is_minus(node::ab_ex_nd)

Check if `node` is a `-` operator or not.
"""
_node_is_minus() = ()

"""
    bool = _node_is_times(node::ab_ex_nd)

Check if `node` is a `*` operator or not.
"""
_node_is_times() = ()

"""
    bool = _node_is_power(node::ab_ex_nd)

Check if `node` is a `^` operator or not.
"""
_node_is_power() = ()

"""
    bool = _node_is_sin(node::ab_ex_nd)

Check if `node` is a `sin` operator.
"""
_node_is_sin() = ()

"""
    bool = _node_is_cos(node::ab_ex_nd)

Check if `node` is a `cos` operator.
"""
_node_is_cos() = ()

"""
    bool = _node_is_tan(node::ab_ex_nd)

Check if `node` is a `tan` operator.
"""
_node_is_tan() = ()

"""
    bool = _node_is_variable(node::ab_ex_nd)

Check if `node` is a variable.
It could be also an operator or a constant.
"""
_node_is_variable() = ()

"""
    bool = _get_var_index(variable::ab_ex_nd)

Return the index of the `variable`.
"""
_get_var_index() = ()

"""
    bool = _node_is_constant(node::ab_ex_nd)

Check if `node` is a constant.
"""
_node_is_constant() = ()

"""
    type = _get_type_node(node::ab_ex_nd, children_types::AbstractVector{t_type_expr_basic})

Return the type of `node` given the type of its children `children_types`.
The types avaible are`constant, linear, quadratic, cubic` or `more`.
"""
_get_type_node() = ()

"""
    value = _evaluate_node(node::ab_ex_nd, value_children::AbstractVector{T}) where T<:Number

Evaluate `node` depending `value_children`.
"""
_evaluate_node() = ()

"""
    _evaluate_node!(node::ab_ex_nd, value_children::AbstractVector{T}, ref::myRef{T}) where T<:Number

Evaluate `node` depending `value_children` and store the result in `ref`.
"""
_evaluate_node!() = ()

"""
    _change_from_N_to_Ni!(node::ab_ex_nd, dic_new_indices::Dict{Int, Int})

Change the index of the variables following the index given by `dic_new_indices`.
"""
_change_from_N_to_Ni!() = ()

"""
    bool = _cast_constant!(node::ab_ex_nd, type::Datatype)

Rewrite the `Number`s composing `node` as `type`.
"""
_cast_constant!() = ()

"""
    bool = _node_is_operator(node::ab_ex_nd)

Check if `node` is an operator.
It could be also a variable or a constant.
"""
_node_to_Expr() = ()

"""
    bool = _node_is_operator(node::ab_ex_nd)

Check if `node` is an operator.
It could be also a variable or a constant.
"""
_node_to_Expr2() = ()

"""
    bool = _node_is_operator(node::ab_ex_nd)

Check if `node` is an operator.
It could be also a variable or a constant.
"""
_node_bound() = ()

"""
    bool = _node_is_operator(node::ab_ex_nd)

Check if `node` is an operator.
It could be also a variable or a constant.
"""
_node_convexity() = ()

end
