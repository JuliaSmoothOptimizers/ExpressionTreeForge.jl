module M_abstract_expr_tree
import ..M_abstract_tree.AbstractTree

export AbstractExprTree
export create_expr_tree, create_Expr, create_Expr2

abstract type AbstractExprTree <: AbstractTree end

mutable struct Bounds{T <: Number}
  inf_bound::T
  sup_bound::T
end

create_empty_bounds(t::DataType) = Bounds{t}((t)(-Inf), (t)(Inf))

get_bounds(b::Bounds{T}) where {T <: Number} = (b.inf_bound, b.sup_bound)

function set_bound!(b::Bounds{T}, bi::T, bs::T) where {T <: Number}
  b.inf_bound = bi
  b.sup_bound = bs
end

create_expr_tree() = ()
create_Expr() = ()
create_Expr2() = ()

end
