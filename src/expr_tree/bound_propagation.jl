module bound_propagations


    using ..abstract_expr_tree
    using ..trait_tree
    using  ..implementation_tree



    struct bounds{T <: Number}
        inf_bound :: T
        sup_bound :: T
    end

    bound_tree{T} = implementation_tree.type_node{bounds{T}}

    function create_bound_tree( tree :: implementation_tree.type_node, type=Flaot64 :: DataType)
        return bound_tree{type}( bounds{type}(0,0), create_bound_tree.(trait_tree.get_children(tree)))
    end 

end
