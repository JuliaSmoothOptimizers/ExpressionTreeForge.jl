module abstract_expr_node

    abstract type ab_ex_nd end



    create_node_expr() = error("c'est une erreur ")


    import Base.+, Base.-
    import Base.*, Base./
    import Base.^
    import Base.sin, Base.tan, Base.cos, Base.exp


    mutable struct myRef{Y <: Number}
        value :: Y
    end

    @inline new_ref(value :: Y ) where Y <: Number= myRef{Y}(value)
    @inline new_ref(type :: DataType) = myRef{type}((type)(-1))
    @inline create_new_vector_myRef(n :: Int, type :: DataType=Float64) = Vector{myRef{type}}(map(i -> new_ref(type) , [1:n;]))
    @inline create_undef_array_myRef(line :: Int, column ::Int, type :: DataType=Float64) = Array{myRef{type},2}( map( x -> myRef{type}((type)(-1)), ones(line, column)) )
    @inline create_vector_of_vector_myRef(l :: Int, c :: Int, type ::DataType=Float64) = Vector{Vector{myRef{type}}}(map( i -> create_new_vector_myRef(c,type), [1:l;])  )
    function equalize_vec_vec_myRef!(a :: Vector{Vector{myRef{T}}}, b :: Vector{Vector{myRef{T}}}) where T <: Number
        for i in 1:length(a)
            for j in 1:length(a[i])
                b[j][i] = a[i][j]
            end
        end
    end

    @inline set_myRef!(ref :: myRef{Y}, value :: Y) where Y <: Number = ref.value = value
    @inline get_myRef(ref :: myRef{Y}) where Y <: Number = ref.value :: Y

    @inline +(ref1 :: myRef{Y}, ref2 :: myRef{Y}) where Y <: Number = @fastmath get_myRef(ref1) + get_myRef(ref2)
    @inline +(value :: Y, ref :: myRef{Y}) where Y <: Number = @fastmath value + get_myRef(ref)
    @inline +(ref :: myRef{Y}, value :: Y) where Y <: Number = @fastmath value + get_myRef(ref)
    @inline +(ref :: myRef{Y}) where Y <: Number = get_myRef(ref)

    @inline -(ref1 :: myRef{Y}, ref2 :: myRef{Y}) where Y <: Number = @fastmath  get_myRef(ref1) - get_myRef(ref2)
    @inline -(value :: Y, ref :: myRef{Y}) where Y <: Number = @fastmath value - get_myRef(ref)
    @inline -(ref :: myRef{Y}, value :: Y) where Y <: Number =  @fastmath get_myRef(ref) - value
    @inline -(ref :: myRef{Y}) where Y <: Number =  @fastmath - get_myRef(ref)

    @inline *(ref1 :: myRef{Y}, ref2 :: myRef{Y}) where Y <: Number = @fastmath get_myRef(ref1) * get_myRef(ref2)
    @inline *(value :: Y, ref :: myRef{Y}) where Y <: Number = @fastmath value * get_myRef(ref)
    @inline *(ref :: myRef{Y}, value :: Y) where Y <: Number = @fastmath value * get_myRef(ref)
    @inline *(ref :: myRef{Y}) where Y <: Number = get_myRef(ref)

    @inline /(ref1 :: myRef{Y}, ref2 :: myRef{Y}) where Y <: Number = @fastmath get_myRef(ref1) / get_myRef(ref2)
    @inline /(value :: Y, ref :: myRef{Y}) where Y <: Number = @fastmath value / get_myRef(ref)
    @inline /(ref :: myRef{Y}, value :: Y) where Y <: Number = @fastmath get_myRef(ref) / value

    @inline ^(ref1 :: myRef{Y}, ref2 :: myRef{Y}) where Y <: Number = @fastmath get_myRef(ref1) ^ get_myRef(ref2)
    @inline ^(value :: Y, ref :: myRef{Y}) where Y <: Number = @fastmath value ^ get_myRef(ref)
    @inline ^(ref :: myRef{Y}, value :: Y) where Y <: Number =  @fastmath get_myRef(ref) ^ value

    @inline sin( ref :: myRef{Y}) where Y <: Number = @fastmath sin(get_myRef(ref))
    @inline tan( ref :: myRef{Y}) where Y <: Number = @fastmath tan(get_myRef(ref))
    @inline cos( ref :: myRef{Y}) where Y <: Number = @fastmath cos(get_myRef(ref))
    @inline exp( ref :: myRef{Y}) where Y <: Number = @fastmath exp(get_myRef(ref))

    export ab_ex_nd, create_node_expr

    export myRef, new_ref, create_new_vector_myRef, set_myRef!, get_myRef

end
