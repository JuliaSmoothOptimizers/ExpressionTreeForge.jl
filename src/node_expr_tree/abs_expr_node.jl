module abstract_expr_node

import Base.+, Base.-
import Base.*, Base./
import Base.^
import Base.sin, Base.tan, Base.cos, Base.exp

export ab_ex_nd, create_node_expr
export MyRef, new_ref, create_new_vector_myRef, set_myRef!, get_myRef

""" Supertype of every node. """
abstract type ab_ex_nd end

"""
    create_node_expr(arg::UnionAll)

Create a node from `arg`.
See the different implementation in the `src/node_expr_tree/impl_operaotrs.jl`.
"""
create_node_expr(node::ab_ex_nd) = error("error in the create of a node")

"""
    MyRef{Y <: Number}

Sort of pointer.
Contien the field:

* `value` pointing to the desired structure.
"""
mutable struct MyRef{Y <: Number}
  value::Y
end

"""
    new_ref(value::Y) where {Y <: Number}
    new_ref(type::DataType)

Create a new reference `myRef` from `value` or `type`.
"""
@inline new_ref(value::Y) where {Y <: Number} = MyRef{Y}(value)
@inline new_ref(type::DataType) = MyRef{type}((type)(-1))

"""
    create_new_vector_myRef(n::Int, type::DataType = Float64)

Create a vector of `n` `myRef{type}`
"""
@inline create_new_vector_myRef(n::Int, type::DataType = Float64) =
  Vector{MyRef{type}}(map(i -> new_ref(type), [1:n;]))

@inline create_undef_array_myRef(line::Int, column::Int, type::DataType = Float64) =
  Array{MyRef{type}, 2}(map(x -> MyRef{type}((type)(-1)), ones(line, column)))

@inline create_vector_of_vector_myRef(l::Int, c::Int, type::DataType = Float64) =
  Vector{Vector{MyRef{type}}}(map(i -> create_new_vector_myRef(c, type), [1:l;]))

function equalize_vec_vec_myRef!(
  a::Vector{Vector{MyRef{T}}},
  b::Vector{Vector{MyRef{T}}},
) where {T <: Number}
  for i = 1:length(a)
    for j = 1:length(a[i])
      b[j][i] = a[i][j]
    end
  end
end

@inline set_myRef!(ref::MyRef{Y}, value::Y) where {Y <: Number} = ref.value = value
@inline get_myRef(ref::MyRef{Y}) where {Y <: Number} = ref.value::Y

@inline +(ref1::MyRef{Y}, ref2::MyRef{Y}) where {Y <: Number} =
  get_myRef(ref1) + get_myRef(ref2)::Y
@inline +(value::Y, ref::MyRef{Y}) where {Y <: Number} = value + get_myRef(ref)::Y
@inline +(ref::MyRef{Y}, value::Y) where {Y <: Number} = value + get_myRef(ref)::Y
@inline +(ref::MyRef{Y}) where {Y <: Number} = get_myRef(ref)::Y

@inline -(ref1::MyRef{Y}, ref2::MyRef{Y}) where {Y <: Number} =
  get_myRef(ref1) - get_myRef(ref2)::Y
@inline -(value::Y, ref::MyRef{Y}) where {Y <: Number} = value - get_myRef(ref)::Y
@inline -(ref::MyRef{Y}, value::Y) where {Y <: Number} = get_myRef(ref) - value::Y
@inline -(ref::MyRef{Y}) where {Y <: Number} = -get_myRef(ref)::Y

@inline *(ref1::MyRef{Y}, ref2::MyRef{Y}) where {Y <: Number} =
  get_myRef(ref1) * get_myRef(ref2)::Y
@inline *(value::Y, ref::MyRef{Y}) where {Y <: Number} = value * get_myRef(ref)::Y
@inline *(ref::MyRef{Y}, value::Y) where {Y <: Number} = value * get_myRef(ref)::Y
@inline *(ref::MyRef{Y}) where {Y <: Number} = get_myRef(ref)::Y

@inline /(ref1::MyRef{Y}, ref2::MyRef{Y}) where {Y <: Number} =
  get_myRef(ref1) / get_myRef(ref2)::Y
@inline /(value::Y, ref::MyRef{Y}) where {Y <: Number} = value / get_myRef(ref)::Y
@inline /(ref::MyRef{Y}, value::Y) where {Y <: Number} = get_myRef(ref) / value::Y

@inline ^(ref1::MyRef{Y}, ref2::MyRef{Y}) where {Y <: Number} =
  get_myRef(ref1)^get_myRef(ref2)::Y
@inline ^(value::Y, ref::MyRef{Y}) where {Y <: Number} = value^get_myRef(ref)::Y
@inline ^(ref::MyRef{Y}, value::Y) where {Y <: Number} = get_myRef(ref)^value::Y

@inline sin(ref::MyRef{Y}) where {Y <: Number} = sin(get_myRef(ref))::Y
@inline tan(ref::MyRef{Y}) where {Y <: Number} = tan(get_myRef(ref))::Y
@inline cos(ref::MyRef{Y}) where {Y <: Number} = cos(get_myRef(ref))::Y
@inline exp(ref::MyRef{Y}) where {Y <: Number} = exp(get_myRef(ref))::Y

end
