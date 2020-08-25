module implementation_tree_Expr

    import ..interface_tree._get_node, ..interface_tree._get_children

    import ..abstract_tree.create_tree


    create_tree(ex :: Expr) = ex

    function _get_node(ex :: Expr)
        hd = ex.head
        args = ex.args
        if  hd == :call
            op = args[1]
            if op != :^
                return args[1]
            else
                return vcat(args[1],args[end])
            end
        elseif hd == :ref
            return args
        end
    end

    @inline _get_node(ex :: Number ) = ex


    function _get_children(ex :: Expr )
        hd = ex.head
        args = ex.args
        if hd == :call
            op = args[1]
            if op != :^
                return args[2:end]
            else
                return args[2:end-1]
            end
        elseif hd == :ref
            return []
        end
    end

    @inline _get_children(ex :: Number) = []



end  # module implementation_Expr
