module abstract_expr_node

import Base.+, Base.-
import Base.*, Base./
import Base.^
import Base.sin, Base.tan, Base.cos, Base.exp

export ab_ex_nd, create_node_expr
export myRef, new_ref, create_new_vector_myRef, set_myRef!, get_myRef

abstract type ab_ex_nd end

mutable struct myRef{Y <: Number}
  value::Y
end

create_node_expr() = error("error in the create of a node")

@inline new_ref(value::Y) where {Y <: Number} = myRef{Y}(value)
@inline new_ref(type::DataType) = myRef{type}((type)(-1))
@inline create_new_vector_myRef(n::Int, type::DataType = Float64) =
  Vector{myRef{type}}(map(i -> new_ref(type), [1:n;]))
@inline create_undef_array_myRef(line::Int, column::Int, type::DataType = Float64) =
  Array{myRef{type}, 2}(map(x -> myRef{type}((type)(-1)), ones(line, column)))
@inline create_vector_of_vector_myRef(l::Int, c::Int, type::DataType = Float64) =
  Vector{Vector{myRef{type}}}(map(i -> create_new_vector_myRef(c, type), [1:l;]))
function equalize_vec_vec_myRef!(
  a::Vector{Vector{myRef{T}}},
  b::Vector{Vector{myRef{T}}},
) where {T <: Number}
  for i = 1:length(a)
    for j = 1:length(a[i])
      b[j][i] = a[i][j]
    end
  end
end

@inline set_myRef!(ref::myRef{Y}, value::Y) where {Y <: Number} = ref.value = value
@inline get_myRef(ref::myRef{Y}) where {Y <: Number} = ref.value::Y

@inline +(ref1::myRef{Y}, ref2::myRef{Y}) where {Y <: Number} =
  get_myRef(ref1) + get_myRef(ref2)::Y
@inline +(value::Y, ref::myRef{Y}) where {Y <: Number} = value + get_myRef(ref)::Y
@inline +(ref::myRef{Y}, value::Y) where {Y <: Number} = value + get_myRef(ref)::Y
@inline +(ref::myRef{Y}) where {Y <: Number} = get_myRef(ref)::Y

@inline -(ref1::myRef{Y}, ref2::myRef{Y}) where {Y <: Number} =
  get_myRef(ref1) - get_myRef(ref2)::Y
@inline -(value::Y, ref::myRef{Y}) where {Y <: Number} = value - get_myRef(ref)::Y
@inline -(ref::myRef{Y}, value::Y) where {Y <: Number} = get_myRef(ref) - value::Y
@inline -(ref::myRef{Y}) where {Y <: Number} = -get_myRef(ref)::Y

@inline *(ref1::myRef{Y}, ref2::myRef{Y}) where {Y <: Number} =
  get_myRef(ref1) * get_myRef(ref2)::Y
@inline *(value::Y, ref::myRef{Y}) where {Y <: Number} = value * get_myRef(ref)::Y
@inline *(ref::myRef{Y}, value::Y) where {Y <: Number} = value * get_myRef(ref)::Y
@inline *(ref::myRef{Y}) where {Y <: Number} = get_myRef(ref)::Y

@inline /(ref1::myRef{Y}, ref2::myRef{Y}) where {Y <: Number} =
  get_myRef(ref1) / get_myRef(ref2)::Y
@inline /(value::Y, ref::myRef{Y}) where {Y <: Number} = value / get_myRef(ref)::Y
@inline /(ref::myRef{Y}, value::Y) where {Y <: Number} = get_myRef(ref) / value::Y

@inline ^(ref1::myRef{Y}, ref2::myRef{Y}) where {Y <: Number} =
  get_myRef(ref1)^get_myRef(ref2)::Y
@inline ^(value::Y, ref::myRef{Y}) where {Y <: Number} = value^get_myRef(ref)::Y
@inline ^(ref::myRef{Y}, value::Y) where {Y <: Number} = get_myRef(ref)^value::Y

@inline sin(ref::myRef{Y}) where {Y <: Number} = sin(get_myRef(ref))::Y
@inline tan(ref::myRef{Y}) where {Y <: Number} = tan(get_myRef(ref))::Y
@inline cos(ref::myRef{Y}) where {Y <: Number} = cos(get_myRef(ref))::Y
@inline exp(ref::myRef{Y}) where {Y <: Number} = exp(get_myRef(ref))::Y

end
