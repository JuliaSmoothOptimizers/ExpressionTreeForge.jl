module abstract_expr_node

    abstract type ab_ex_nd end

    create_node_expr() = error("c'est une erreur ")

    export ab_ex_nd, create_node_expr

end
