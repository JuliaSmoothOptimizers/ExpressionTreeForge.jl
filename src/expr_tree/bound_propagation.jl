module bound_propagations


    using ..abstract_expr_tree
    using ..trait_tree
    using ..implementation_tree
    using ..trait_expr_node


    mutable struct bounds{T <: Number}
        inf_bound :: T
        sup_bound :: T
    end

    bound_tree{T} = implementation_tree.type_node{bounds{T}}

    create_bound_tree( tree :: implementation_tree.type_node, type=Float64 :: DataType) = return bound_tree{type}( bounds{type}((type)(0),(type)(0)), create_bound_tree.(trait_tree.get_children(tree)))
    create_bound_tree( cst :: T, type=Float64 :: DataType) where T <: Number = return bound_tree{type}( bounds{type}((type)(0),(type)(0)),[])


    function set_bounds!(  tree :: implementation_tree.type_node, bounds_tree :: bound_tree{T}) where T <: Number
        node = trait_tree.get_node(tree)
        if trait_expr_node.node_is_operator(node) == false
            (inf_bound_node ,sup_bound_node) = trait_expr_node.node_bound(node,T)
            bound = trait_tree.get_node(bounds_tree)
            bound.inf_bound = inf_bound_node
            bound.sup_bound = sup_bound_node
        else
            children_tree = trait_tree.get_children(tree)
            children_bound_tree = trait_tree.get_children(bounds_tree)
            n = length(children_tree)
            n == length(children_bound_tree) || error("different shape between trees")
            for i in 1:n
                set_bounds!(children_tree[i], children_bound_tree[i])
            end
            son_bounds = (x :: bound_tree -> bound_to_tuple(trait_tree.get_node(x))).(children_bound_tree)
            (inf_bound_node ,sup_bound_node) = trait_expr_node.node_bound(node, son_bounds, T)
            bound = trait_tree.get_node(bounds_tree)
            bound.inf_bound = inf_bound_node
            bound.sup_bound = sup_bound_node
        end
    end

    bound_to_tuple(b :: bounds{T}) where T <: Number = (b.inf_bound, b.sup_bound)

end
