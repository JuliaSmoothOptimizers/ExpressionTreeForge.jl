module M_abstract_expr_tree
import ..M_abstract_tree.AbstractTree
import Base.copy

export AbstractExprTree
export create_expr_tree, create_Expr, create_Expr2, create_Expr_JuMP

""" Supertype of every expression tree. """
abstract type AbstractExprTree <: AbstractTree end

""" 
    Bounds{T <: Number}

Structure representing the upper-bound and the lower-bound of a node. 
"""
mutable struct Bounds{T <: Number}
  inf_bound::T
  sup_bound::T
end

copy(bounds::Bounds{T}) where {T} = Bounds{T}(bounds.inf_bound, bounds.sup_bound)

"""
    bound = create_empty_bounds(type::DataType)

Create a `Bounds` structure of `type`.
"""
create_empty_bounds(type::DataType) = Bounds{type}((type)(-Inf), (type)(Inf))

"""
    (inf_bound, sup_bound) = get_bounds(bound::Bounds{T}) where {T <: Number}

Retrieve both `inf_bound` and `sup_bound` from `bound`.
"""
get_bounds(bound::Bounds{T}) where {T <: Number} = (bound.inf_bound, bound.sup_bound)

"""
    set_bound!(bound::Bounds{T}, inf_bound::T, sup_bound::T) where {T <: Number}
  
Set `bound` to `inf_bound` and `sup_bound`.
"""
function set_bound!(bound::Bounds{T}, inf_bound::T, sup_bound::T) where {T <: Number}
  bound.inf_bound = inf_bound
  bound.sup_bound = sup_bound
end

"""
    expr_tree = create_expr_tree(tree)

Create an `Type_expr_tree` from `tree`.
Several types of tree are supported.
For now, it supports `Expr` and `ModelingToolkit.Operation`, as well as the internal expression trees defined.
"""
create_expr_tree(tree::AbstractExprTree) = error("Should not be called, create_expr_tree")

"""
    expr = create_expr_tree(tree)

Create an `Expr` from `tree`.
Several types of tree are supported.
For now, it supports `Expr` and `ModelingToolkit.Operation`, as well as the internal expression trees defined.
The variables of the `Expr` use `MathOptInterface` variables.
"""
create_Expr(tree::AbstractExprTree) = error("Should not be called, create_Expr")

"""
    expr = create_expr_tree(tree)

Create a Julia `Expr` from `tree`.
Several types of tree are supported.
For now, it supports `Expr` and `ModelingToolkit.Operation`, as well as the internal expression trees defined.
"""
create_Expr2(tree::AbstractExprTree) = error("Should not be called, create_Expr2")

"""
    expr = create_expr_tree(tree)

Create an `Expr` from `tree`.
Several types of tree are supported.
For now, it supports `Expr` and `ModelingToolkit.Operation`, as well as the internal expression trees defined.
The variables of the `Expr` use `MathOptInterface.VariableIndex(i)`.
"""
create_Expr_JuMP(tree::AbstractExprTree) = error("Should not be called, create_Expr_JuMP")

end
