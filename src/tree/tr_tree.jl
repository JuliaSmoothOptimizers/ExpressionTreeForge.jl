module trait_tree

    import ..abstract_tree.ab_tree

    import ..interface_tree._get_node, ..interface_tree._get_children

    struct type_trait_tree end
    struct type_not_trait_tree end

    is_type_trait_tree( a :: ab_tree) = type_trait_tree()
    is_type_trait_tree( a :: Expr) = type_trait_tree()
    is_type_trait_tree( a :: Number) = type_trait_tree()
    is_type_trait_tree( a :: Any) = type_not_trait_tree()

    get_node(a) = _get_node(a, is_type_trait_tree(a))
    _get_node(a, b :: type_trait_tree) = _get_node(a)
    _get_node(a, b :: type_not_trait_tree) = error(" The parameter is not a Tree")

    get_children(a) = _get_children(a, is_type_trait_tree(a))
    _get_children(a, :: type_trait_tree) = _get_children(a)
    _get_children(a, :: type_not_trait_tree) = error(" The parameter is not a Tree")

    export get_node
    export get_children

end  # module trait_tree




module algo_tree

    using ..trait_tree

    function printer_tree(tree, deepth = 0 )
        ident = "\t"^deepth
        nd = get_node(tree)
        println(ident, nd )
        ch = get_children(tree)
        printer_tree.(ch, deepth + 1)
    end

    export printer_tree

end
