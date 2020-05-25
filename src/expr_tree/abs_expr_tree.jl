module abstract_expr_tree

    import ..abstract_tree.ab_tree

    abstract type ab_ex_tr <: ab_tree end

    create_expr_tree() = ()

    create_Expr() = ()
    create_Expr2() = ()


    export ab_ex_tr

end  # module abstract_expr_tree
