module abstract_expr_node

    abstract type ab_ex_nd end



    create_node_expr() = error("c'est une erreur ")


    import Base.+
    import Base.*
    import Base.^


    mutable struct myRef{Y <: Number}
        value :: Y
    end
    @inline new_ref(value :: Y ) where Y <: Number= myRef{Y}(value)
    @inline new_ref(type :: DataType) = myRef{type}((type)(-1))
    @inline create_new_vector_myRef(n :: Int, type :: DataType=Float64) = Vector{myRef{type}}(map(x -> new_ref(type) , [1:n;]))

    @inline set_myRef!(ref :: myRef{Y}, value :: Y) where Y <: Number = ref.value = value
    @inline get_myRef(ref :: myRef{Y}) where Y <: Number = ref.value :: Y

    @inline +(ref1 :: myRef{Y}, ref2 :: myRef{Y}) where Y <: Number = get_myRef(ref1) + get_myRef(ref2)
    @inline +(value :: Y, ref :: myRef{Y}) where Y <: Number = value + get_myRef(ref)
    @inline +(ref :: myRef{Y}, value :: Y) where Y <: Number = value + get_myRef(ref)

    @inline *(ref1 :: myRef{Y}, ref2 :: myRef{Y}) where Y <: Number = get_myRef(ref1) * get_myRef(ref2)
    @inline *(value :: Y, ref :: myRef{Y}) where Y <: Number = value * get_myRef(ref)
    @inline *(ref :: myRef{Y}, value :: Y) where Y <: Number = value * get_myRef(ref)

    @inline ^(ref1 :: myRef{Y}, ref2 :: myRef{Y}) where Y <: Number = get_myRef(ref1) ^ get_myRef(ref2)
    @inline ^(value :: Y, ref :: myRef{Y}) where Y <: Number = value ^ get_myRef(ref)
    @inline ^(ref :: myRef{Y}, value :: Y) where Y <: Number =  get_myRef(ref) ^ value 


    export ab_ex_nd, create_node_expr

    export myRef, new_ref, create_new_vector_myRef, set_myRef!, get_myRef

end
