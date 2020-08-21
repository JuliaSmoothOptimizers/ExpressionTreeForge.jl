module implementation_tree

    import ..abstract_tree.ab_tree, ..abstract_tree.create_tree

    import ..interface_tree._get_node, ..interface_tree._get_children

    import Base.==
    using Base.Threads

    mutable struct type_node{T} <: ab_tree
        field :: T
        children :: Vector{type_node{T}}
    end

    @inline create_tree( field :: T, children :: Vector{type_node{T}}) where T = type_node{T}(field,children)
    @inline create_tree( field :: T, children :: Array{Any,1}) where T = type_node{T}(field,children)

    @inline _get_node(tree :: type_node{T}) where T = tree.field

    @inline _get_children(tree :: type_node{T} ) where T = tree.children
    @inbounds @inline _get_children(tree :: type_node{T}, i :: Int ) where T = tree.children[i]
    @inline _get_length_children(tree :: type_node{T}) where T = length(_get_children(tree))

    @inline (==)(a :: type_node{T}, b :: type_node{T}) where T = equal_tree(a,b)
    @inline my_and(x,y) = x && y
    @inline equal_tree(a :: type_node{T}, b :: type_node{T}) where T = begin ca =_get_children(a); cb =_get_children(b); la = length(ca); lb = length(cb); _get_node(a) == _get_node(b) && la == lb ? (la > 0 ? mapreduce(equal_tree, my_and, ca, cb) : true) : false end


end  # module implementation_tree



#= ancien code =#

# function equal_tree2(a :: type_node{T}, b :: type_node{T}, eq :: Atomic{Bool}=Atomic{Bool}(true)) where T
#     if eq[]
#         if _get_node(a) == _get_node(b)
#             ch_a = _get_children(a)
#             ch_b = _get_children(b)
#             if length(ch_a) != length(ch_b)
#                 Threads.atomic_and!(eq, false )
#             elseif ch_a == []
#             else
#                 Threads.@threads for i in 1:length(ch_a)
#                     equal_tree2(ch_a[i], ch_b[i], eq)
#                 end
#             end
#         else
#             Threads.atomic_and!(eq, false)
#         end
#         return eq[]
#     end
#     return false
# end
#
# equal_tree3(a :: type_node{T}, b :: type_node{T}, eq :: Atomic{Bool}=Atomic{Bool}(true)) where T = begin _equal_tree3(a,b,eq) ; return eq[] end
# function _equal_tree3(a :: type_node{T}, b :: type_node{T}, eq :: Atomic{Bool}=Atomic{Bool}(true)) where T
#     Threads.atomic_and!(eq, (_get_node(a) == _get_node(b) && _get_length_children(a) == _get_length_children(b)))
#     if eq[]
#         Threads.@threads for i in 1:_get_length_children(b)
#             _equal_tree3( _get_children(a, i), _get_children(b, i), eq)
#         end
#     end
# end
