module trait_expr_tree

    using ..abstract_expr_tree, ..implementation_expr_tree, ..implementation_complete_expr_tree, ..implementation_pre_compiled_tree

    using ..implementation_pre_n_compiled_tree
    using ..implementation_expression_tree_Expr

    import ..interface_expr_tree._get_expr_node, ..interface_expr_tree._get_expr_children, ..interface_expr_tree._inverse_expr_tree
    import ..implementation_expr_tree.t_expr_tree, ..interface_expr_tree._get_real_node
    import ..interface_expr_tree._transform_to_expr_tree, ..interface_expr_tree._expr_tree_to_create

    import Base.==
    using Base.Threads

    using ModelingToolkit

    struct type_expr_tree end
    struct type_not_expr_tree end

    @inline is_expr_tree(a :: abstract_expr_tree.ab_ex_tr) = type_expr_tree()
    @inline is_expr_tree(a :: t_expr_tree )= type_expr_tree()
    @inline is_expr_tree(a :: Expr) = type_expr_tree()
    @inline is_expr_tree(a :: Number) = type_expr_tree()
    # @inline is_expr_tree(a :: Symbol) = type_expr_tree()
    @inline is_expr_tree(:: Number) = type_expr_tree()
    @inline is_expr_tree(a :: implementation_complete_expr_tree.complete_expr_tree{T}) where T <: Number = type_expr_tree()
    @inline is_expr_tree(a :: implementation_pre_compiled_tree.pre_compiled_tree{T}) where T <: Number = type_expr_tree()
    @inline is_expr_tree(a :: implementation_pre_n_compiled_tree.pre_n_compiled_tree{T}) where T <: Number = type_expr_tree()
    @inline is_expr_tree(a :: ModelingToolkit.Operation) = type_expr_tree()
		@inline is_expr_tree(a :: ModelingToolkit.Constant) = type_expr_tree()
		@inline is_expr_tree(a :: ModelingToolkit.Variable) = type_expr_tree()
    @inline is_expr_tree(a :: Any) = type_not_expr_tree()
    function is_expr_tree(t :: DataType)
        if t == abstract_expr_tree.ab_ex_tr || t == t_expr_tree || t == Expr || t == Number
            type_expr_tree()
        else
            type_not_expr_tree()
        end
    end

    @inline get_expr_node(a) = _get_expr_node(a, is_expr_tree(a))
    @inline _get_expr_node(a, :: type_not_expr_tree) = error(" This is not an expr tree")
    @inline _get_expr_node(a, :: type_expr_tree) = _get_expr_node(a)


    @inline get_expr_children(a) = _get_expr_children(a, is_expr_tree(a))
    @inline _get_expr_children(a, :: type_not_expr_tree) = error("This is not an expr tree")
    @inline _get_expr_children(a, :: type_expr_tree) = _get_expr_children(a)


    @inline inverse_expr_tree(a) = _inverse_expr_tree(a, is_expr_tree(a))
    @inline _inverse_expr_tree(a, ::type_not_expr_tree) = error("This is not an expr tree")
    @inline _inverse_expr_tree(a, ::type_expr_tree) = _inverse_expr_tree(a)


    @inline expr_tree_equal(a,b,eq :: Atomic{Bool}=Atomic{Bool}(true)) = hand_expr_tree_equal(a,b,is_expr_tree(a), is_expr_tree(b),eq)
    @inline hand_expr_tree_equal(a , b, :: type_not_expr_tree, :: Any, eq) = error("we can't compare if these two tree are not expr tree")
    @inline hand_expr_tree_equal(a , b, :: Any, :: type_not_expr_tree, eq) = error("we can't compare if these two tree are not expr tree")
    function hand_expr_tree_equal(a , b, :: type_expr_tree,  :: type_expr_tree, eq :: Atomic{Bool})
        if eq[]
            if _get_expr_node(a) == _get_expr_node(b)
                ch_a = _get_expr_children(a)
                ch_b = _get_expr_children(b)
                if length(ch_a) != length(ch_b)
                    Threads.atomic_and!(eq, false )
                elseif ch_a == []
                else
                    Threads.@threads for i in 1:length(ch_a)
                        expr_tree_equal(ch_a[i],ch_b[i],eq)
                    end
                end
            else
                Threads.atomic_and!(eq, false )
            end
            return eq[]
        end
        return false
    end



"""
    get_real_node(a)
Fonction à prendre avec des pincettes, pour le moment utiliser seulement sur les feuilles.
"""
    @inline get_real_node(a) = _get_real_node(is_expr_tree(a), a)
    @inline _get_real_node(:: type_not_expr_tree, :: Any) = error("nous ne traitons pas un arbre d'expression")
    @inline _get_real_node(:: type_expr_tree, a :: Any) = _get_real_node(a)


"""
    transform_to_expr_tree(expression_tree)
This function takes an argument expression_tree satisfying the trait is_expr_tree and return an expression tree of the type t_expr_tree.
This function is usefull in our algorithms to synchronise all the types satisfying the trait is_expr_tree (like Expr) to the type t_expr_tree.
"""
    @inline transform_to_expr_tree(a :: T ) where T = _transform_to_expr_tree(is_expr_tree(a), a)
    @inline _transform_to_expr_tree(:: type_not_expr_tree, :: T) where T = error("nous ne traitons pas un arbre d'expression")
    @inline _transform_to_expr_tree(:: type_expr_tree, a :: T) where T = _transform_to_expr_tree(a) :: implementation_expr_tree.t_expr_tree



"""
    transform_to_Expr(ex)
This function transform an expr_tree and transform it in Expr.
    #Deprecated
"""
    @inline transform_to_Expr(ex) = _transform_to_Expr( trait_expr_tree.is_expr_tree(ex), ex)
    @inline _transform_to_Expr( :: trait_expr_tree.type_expr_tree, ex) = _transform_to_Expr(ex)
    @inline _transform_to_Expr( :: trait_expr_tree.type_not_expr_tree, ex) = error("notre parametre n'est pas un arbre d'expression")
    @inline _transform_to_Expr(ex) = abstract_expr_tree.create_Expr(ex)

    @inline transform_to_Expr2(ex) = _transform_to_Expr2( trait_expr_tree.is_expr_tree(ex), ex)
    @inline _transform_to_Expr2( :: trait_expr_tree.type_expr_tree, ex) = _transform_to_Expr2(ex)
    @inline _transform_to_Expr2( :: trait_expr_tree.type_not_expr_tree, ex) = error("notre parametre n'est pas un arbre d'expression")
    @inline _transform_to_Expr2(ex) = abstract_expr_tree.create_Expr2(ex)



"""
    expr_tree_to_create(arbre créé, arbre d'origine)
fonction ayant pour but d'homogénéiser 2 arbres quelconque peut importe leurs types.
"""
    @inline expr_tree_to_create(expr_tree_to_create, expr_tree_of_good_type) = _expr_tree_to_create(expr_tree_to_create, expr_tree_of_good_type, is_expr_tree(expr_tree_to_create), is_expr_tree(expr_tree_of_good_type))
    @inline _expr_tree_to_create(a, b, :: type_not_expr_tree, :: Any) = error("le type de l'arbre d'origine ne satisfait pas le trait")
    @inline _expr_tree_to_create(a, b, :: Any, :: type_not_expr_tree) = error("le type de l'arbre que l'on cherche à créer ne satisfait pas le trait")
    function _expr_tree_to_create(a, b, :: type_expr_tree, :: type_expr_tree)
        @show typeof(a), typeof(b)
        uniformized_a = transform_to_expr_tree(a)
        # à priori on est sur que le type de uniformized_a est implementation_expr_tree.t_expr_tree
        # return _expr_tree_to_create(uniformized_a, b)
         _expr_tree_to_create(uniformized_a, b)
    end

    export is_expr_tree, get_expr_node, get_expr_children, inverse_expr_tree

end  # module trait_expr_tree


module hl_trait_expr_tree

    import ..interface_expr_tree._expr_tree_to_create

    using ..trait_expr_tree, ..trait_expr_node
    using ..implementation_expr_tree, ..implementation_expr_tree_Expr, ..implementation_complete_expr_tree

    @inline _expr_tree_to_create(original_ex :: implementation_expr_tree.t_expr_tree,  tree_of_needed_type :: Expr) = trait_expr_tree.transform_to_Expr(original_ex)
    @inline _expr_tree_to_create(original_ex :: implementation_expr_tree.t_expr_tree, tree_of_needed_type :: implementation_expr_tree.t_expr_tree) = original_ex


    function _cast_type_of_constant( ex ::  implementation_expr_tree.t_expr_tree, t :: DataType)
        ch = trait_expr_tree.get_expr_children(ex)
        nd = trait_expr_tree.get_expr_node(ex)
        if isempty(ch)
            node = trait_expr_node._cast_constant!(nd,t)
            return implementation_expr_tree.create_expr_tree(node)
        elseif trait_expr_node.node_is_power(nd)
            new_node = trait_expr_node._cast_constant!(nd,t)
            new_ch = _cast_type_of_constant.(ch,t)
            return implementation_expr_tree.create_expr_tree(new_node, new_ch)
        else
            new_ch = _cast_type_of_constant.(ch,t)
            return implementation_expr_tree.create_expr_tree(nd, new_ch)
        end
    end


    function _cast_type_of_constant( ex :: Expr, t :: DataType)
        ch = trait_expr_tree.get_expr_children(ex)
        for i in 1:length(ch)
            node_i = trait_expr_tree.get_expr_node(ch[i])
            if  trait_expr_node.node_is_constant(node_i)
                ex.args[i+1] = trait_expr_node._cast_constant!(i,t) #manipulation assez bas niveau des Expr
                # @show i, ch[i]
            elseif trait_expr_node.node_is_power(node_i )
                ch[i].args[end] = trait_expr_node._cast_constant!(node_i,t)
            end
        end
    end


    function _cast_type_of_constant( ex ::  implementation_complete_expr_tree.complete_expr_tree, t :: DataType)
        ch = trait_expr_tree.get_expr_children(ex)
        nd = trait_expr_tree.get_expr_node(ex)
        if isempty(ch)
            treated_nd = trait_expr_node._cast_constant!(nd,t)
            new_nd = implementation_complete_expr_tree.create_complete_node(treated_nd,t)
            return implementation_complete_expr_tree.create_complete_expr_tree(new_nd)
        elseif trait_expr_node.node_is_power(nd)
            treated_nd = trait_expr_node._cast_constant!(nd,t)
            new_nd = implementation_complete_expr_tree.create_complete_node(treated_nd,t)
            treated_ch = _cast_type_of_constant.(ch,t)
            new_ch = implementation_complete_expr_tree.create_complete_expr_tree.(treated_ch)
            return implementation_complete_expr_tree.create_complete_expr_tree(new_nd,new_ch)
        else
            new_ch = _cast_type_of_constant.(ch,t)
            new_nd = implementation_complete_expr_tree.create_complete_node(nd,t)
            new_ex = implementation_complete_expr_tree.create_complete_expr_tree(new_nd, new_ch)
            return new_ex
        end
    end


end
