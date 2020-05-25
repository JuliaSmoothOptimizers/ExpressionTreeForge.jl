module implementation_tree

    import ..abstract_tree.ab_tree, ..abstract_tree.create_tree

    import ..interface_tree._get_node, ..interface_tree._get_children

    import Base.==
    using Base.Threads

    mutable struct type_node{T} <: ab_tree
        field :: T
        children :: Vector{type_node{T}}
    end

    create_tree( field :: T, children :: Vector{type_node{T}}) where T = type_node{T}(field,children)
    create_tree( field :: T, children :: Array{Any,1}) where T = type_node{T}(field,children)

    _get_node(tree :: type_node{T}) where T = tree.field

    _get_children(tree :: type_node{T} ) where T = tree.children

    (==)(a :: type_node{T}, b :: type_node{T}) where T = equal_tree(a,b)

    function equal_tree(a :: type_node{T}, b :: type_node{T}, eq :: Atomic{Bool}=Atomic{Bool}(true)) where T
        if eq[]
            if _get_node(a) == _get_node(b)
                ch_a = _get_children(a)
                ch_b = _get_children(b)
                if length(ch_a) != length(ch_b)
                    Threads.atomic_and!(eq, false )
                elseif ch_a == []
                else
                    Threads.@threads for i in 1:length(ch_a)
                        equal_tree(ch_a[i], ch_b[i], eq)
                    end
                end
            else
                Threads.atomic_and!(eq, false)
            end
            return eq[]
        end
        return false
    end



end  # module implementation_tree
