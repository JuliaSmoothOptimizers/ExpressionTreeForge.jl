module M_interface_expr_node

using ..M_abstract_expr_node
# This module define the interface that every node must support.
# All methods are not needed for all nodes.

"""
    bool = _node_is_operator(node::Abstract_expr_node)

Check if `node` is an operator.
It could be also a variable or a constant.
"""
_node_is_operator(node::Abstract_expr_node) = false

"""
    bool = _node_is_plus(node::Abstract_expr_node)

Check if `node` is a `+` operator or not.
"""
_node_is_plus(node::Abstract_expr_node) = false

"""
    bool = _node_is_minus(node::Abstract_expr_node)

Check if `node` is a `-` operator or not.
"""
_node_is_minus(node::Abstract_expr_node) = false

"""
    bool = _node_is_times(node::Abstract_expr_node)

Check if `node` is a `*` operator or not.
"""
_node_is_times(node::Abstract_expr_node) = false

"""
    bool = _node_is_power(node::Abstract_expr_node)

Check if `node` is a `^` operator or not.
"""
_node_is_power(node::Abstract_expr_node) = false

"""
    bool = _node_is_sin(node::Abstract_expr_node)

Check if `node` is a `sin` operator.
"""
_node_is_sin(node::Abstract_expr_node) = false

"""
    bool = _node_is_cos(node::Abstract_expr_node)

Check if `node` is a `cos` operator.
"""
_node_is_cos(node::Abstract_expr_node) = false

"""
    bool = _node_is_tan(node::Abstract_expr_node)

Check if `node` is a `tan` operator.
"""
_node_is_tan(node::Abstract_expr_node) = false

"""
    bool = _node_is_variable(node::Abstract_expr_node)

Check if `node` is a variable.
It could be also an operator or a constant.
"""
_node_is_variable(node::Abstract_expr_node) = false

"""
    index = _get_var_index(variable::Abstract_expr_node)

Return the `index` of the `variable`.
"""
_get_var_index(node::Abstract_expr_node) = ()

"""
    bool = _node_is_constant(node::Abstract_expr_node)

Check if `node` is a constant.
"""
_node_is_constant(node::Abstract_expr_node) = false

"""
    type = _get_type_node(node::Abstract_expr_node, children_types::AbstractVector{Type_expr_basic})

Return the type of `node` given the type of its children `children_types`.
The types available are `constant, linear, quadratic, cubic` or `more`.
"""
_get_type_node(node::Abstract_expr_node) = error("Should not be called")

"""
    value = _evaluate_node(node::Abstract_expr_node, value_children::AbstractVector{T}) where T<:Number

Evaluate `node` depending `value_children`.
"""
_evaluate_node(node::Abstract_expr_node) = error("Should not be called")

"""
    _evaluate_node!(node::Abstract_expr_node, value_children::AbstractVector{T}, ref::MyRef{T}) where T<:Number

Evaluate `node` depending `value_children` and store the result in `ref`.
"""
_evaluate_node!(node::Abstract_expr_node) = error("Should not be called")

"""
    _change_from_N_to_Ni!(node::Abstract_expr_node, dic_new_indices::Dict{Int, Int})

Change the index of the variables following the index given by `dic_new_indices`.
Must be implemented for leaf nodes.
"""
_change_from_N_to_Ni!(node::Abstract_expr_node) = error("Should not be called")

"""
    bool = _cast_constant!(node::Abstract_expr_node, type::Datatype)

Rewrite the `Number`s composing `node` as `type`.
"""
_cast_constant!(node::Abstract_expr_node) = error("Should not be called")

"""
    [symbols] = _node_to_Expr(node::Abstract_expr_node)

Return the information required to build later on a julia `Expr`.
An `operator` return the operator symbol (ex: `+` -> `:+`).
A `variable` return a variable as a `MathOptInterface` variable.
A `constant` return its value.
"""
_node_to_Expr(node::Abstract_expr_node) = error("Should not be called")

"""
    [symbols] = _node_to_Expr2(node::Abstract_expr_node)

Return the information required to build later on a julia `Expr`.
An `operator` return the operator symbol (ex: `+` -> `:+`).
A `variable` return a variable.
A `constant` return its value.
"""
_node_to_Expr2(node::Abstract_expr_node) = error("Should not be called")

"""
    [symbols] = _node_to_Expr2(node::Abstract_expr_node)

Return the information required to build later on a julia `Expr`.
An `operator` return the operator symbol (ex: `+` -> `:+`).
A `variable` return a `MathOptInterface.VariableIndex()`.
A `constant` return its value.
"""
_node_to_Expr_JuMP(node::Abstract_expr_node) = error("Should not be called")

"""
    (lowerbound, upper_bound) = _node_bound(node::Abstract_expr_node, children_bounds::AbstractVector{Tuple{T, T}}, type::DataType)

Return the bounds of `node` given the `children_bounds`.
"""
_node_bound(node::Abstract_expr_node) = error("Should not be called")

"""
    bool = _node_is_operator(node::Abstract_expr_node, children_convex_status::AbstractVector{M_implementation_convexity_type.Convexity_type})

Return the convexity status of `node` given the `children_convex_status`.
"""
_node_convexity(node::Abstract_expr_node) = error("Should not be called")

end
