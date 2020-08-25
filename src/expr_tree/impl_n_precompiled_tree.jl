module implementation_pre_n_compiled_tree

    using ..abstract_expr_node, ..trait_tree, ..implementation_expr_tree, ..trait_expr_node

    mutable struct new_field
        op :: abstract_expr_node.ab_ex_nd
    end

    @inline create_new_field(op :: abstract_expr_node.ab_ex_nd) = new_field(op)
    @inline get_op_from_field(field :: new_field) = field.op


    mutable struct eval_n_node{Y <: Number}
        field :: new_field
        vec_tmp_children :: Vector{Vector{abstract_expr_node.myRef{Y}}}
        vec_tmp_n_eval :: Vector{Vector{abstract_expr_node.myRef{Y}}}
        children :: Vector{eval_n_node{Y}}
        length_children :: Int
        length_n_eval :: Int
    end


    mutable struct pre_n_compiled_tree{Y <: Number}
        racine :: eval_n_node{Y}
        multiple_x :: Vector{ AbstractVector{Y} }
        multiple :: Int
        vec_tmp :: Vector{abstract_expr_node.myRef{Y}}
    end


    @inline get_racine(tree :: pre_n_compiled_tree{Y}) where Y <: Number = tree.racine
    @inline get_multiple(tree :: pre_n_compiled_tree{Y}) where Y <: Number = tree.multiple
    @inline get_multiple_x(tree :: pre_n_compiled_tree{Y}) where Y <: Number = tree.multiple_x
    function set_multiple_x!(tree :: pre_n_compiled_tree{Y}, new_multiple_x :: Vector{Vector{Y}}) where Y <: Number
        n = length(new_multiple_x)
        n == length(tree.multiple_x) || error("error set_multiple_x!")
        for i in 1:n
             tree.multiple_x[i] .= new_multiple_x[i]
        end
    end
    function set_multiple_x!(tree :: pre_n_compiled_tree{T}, new_multiple_x :: Vector{SubArray{T,1,Array{T,1},N,false}} ) where N where T <: Number
        n = length(new_multiple_x)
        n == length(tree.multiple_x) || error("error set_multiple_x!")
        for i in 1:n
             tree.multiple_x[i] .= new_multiple_x[i]
        end
    end
    @inline get_vec_tmp(tree :: pre_n_compiled_tree{Y}) where Y <: Number = tree.vec_tmp

    @inline get_field_from_node(node :: eval_n_node{Y}) where Y <: Number = node.field
    @inline get_children_vector_from_node(node :: eval_n_node{Y}) where Y <: Number = node.children
    @inline get_children_from_node(node :: eval_n_node{Y}, i :: Int) where Y <: Number = node.children[i]
    @inline get_vec_tmp_children(node :: eval_n_node{Y}) where Y <: Number = node.vec_tmp_children
    @inline get_vec_tmp_n_eval(node :: eval_n_node{Y}) where Y <: Number = node.vec_tmp_n_eval
    @inline get_tmp_for_n_eval_child(node :: eval_n_node{Y}, i :: Int) where Y <: Number = get_vec_tmp_n_eval(node)[i]
    @inline get_tmp_eval_node(node :: eval_n_node{Y}, i :: Int) where Y <: Number = get_vec_tmp_children(node)[i]
    @inline get_op_from_node(node :: eval_n_node{Y}) where Y <: Number = get_op_from_field(get_field_from_node(node))
    @inline get_length_children(node :: eval_n_node{Y}) where Y <: Number = node.length_children
    @inline get_length_n_eval(node :: eval_n_node{Y}) where Y <: Number = node.length_n_eval


    @inline create_eval_n_node(field :: new_field, vec_tmp_children :: Vector{Vector{myRef{Y}}}, vec_tmp_n_eval :: Vector{Vector{myRef{Y}}}, children :: Vector{eval_n_node{Y}}, n_children :: Int, n_eval :: Int) where Y <: Number = eval_n_node{Y}(field, vec_tmp_children, vec_tmp_n_eval, children, n_children, n_eval)
    function create_eval_n_node(field :: new_field, children :: Vector{eval_n_node{Y}}, n_eval :: Int) where Y <: Number
        n_children = length(children)
        vec_tmp_children = abstract_expr_node.create_vector_of_vector_myRef(n_eval, n_children, Y)
        vec_tmp_n_eval = abstract_expr_node.create_vector_of_vector_myRef(n_children, n_eval, Y)
        abstract_expr_node.equalize_vec_vec_myRef!(vec_tmp_n_eval, vec_tmp_children)
        return create_eval_n_node(field, vec_tmp_children, vec_tmp_n_eval, children, n_children, n_eval)
    end
    @inline create_eval_n_node(field :: new_field, n_eval :: Int, type :: DataType = Float64 ) = create_eval_n_node(field, Vector{eval_n_node{type}}(undef,0), n_eval )


    function create_pre_n_compiled_tree(tree :: implementation_expr_tree.t_expr_tree, multiple_x_view :: Vector{SubArray{T,1,Array{T,1},N,false}} ) where N where T <: Number
        view_of_view = big_view(multiple_x_view)
        compiled_tree = _create_pre_n_compiled_tree(tree, view_of_view)
        tmp = create_new_vector_myRef(length(view_of_view), T)

        pre_n_compiled_tree{T}(compiled_tree, view_of_view, length(multiple_x_view), tmp)
    end


    function big_view( multiple_x_view :: Vector{SubArray{T,1,Array{T,1},N,false}} ) where N where T <: Number
        n = length(multiple_x_view)
        res = Vector{SubArray{T,1,Array{T,1},N,false}}(undef, n)
        for i in 1:n
            nᵢ = length(multiple_x_view[i])
            res[i] = view(multiple_x_view[i], [1:nᵢ;]) :: SubArray{T,1,Array{T,1},N,false}
        end
        return res
    end

    function _create_pre_n_compiled_tree(tree :: implementation_expr_tree.t_expr_tree, multiple_x_view :: Vector{SubArray{T,1,Array{T,1},N,false}} ) where N where T <: Number
        nd = trait_tree.get_node(tree)
        ch = trait_tree.get_children(tree)
        n_eval = length(multiple_x_view)
        if isempty(ch)
            new_op = abstract_expr_node.create_node_expr(nd, multiple_x_view)
            new_field = create_new_field(new_op)
            new_node = create_eval_n_node(new_field, n_eval, T)
            return new_node
        else
            new_ch = map( child -> _create_pre_n_compiled_tree(child, multiple_x_view), ch)
            new_field = create_new_field(nd)
            return create_eval_n_node(new_field, new_ch, n_eval)
        end
    end


    function create_pre_n_compiled_tree(tree :: implementation_expr_tree.t_expr_tree, multiple_x :: Vector{Vector{T}}) where T <: Number
        new_multiple_x = copy(multiple_x)
        compiled_tree = _create_pre_n_compiled_tree(tree, new_multiple_x)
        tmp = create_new_vector_myRef(length(new_multiple_x), T)
        pre_n_compiled_tree{T}(compiled_tree, new_multiple_x, length(new_multiple_x), tmp)
    end

    function _create_pre_n_compiled_tree(tree :: implementation_expr_tree.t_expr_tree, multiple_x :: Vector{Vector{T}}) where T <: Number
        nd = trait_tree.get_node(tree)
        ch = trait_tree.get_children(tree)
        n_eval = length(multiple_x)
        if isempty(ch)
            new_op = abstract_expr_node.create_node_expr(nd, multiple_x)
            new_field = create_new_field(new_op)
            new_node = create_eval_n_node(new_field, n_eval, T)
            return new_node
        else
            new_ch = map( child -> _create_pre_n_compiled_tree(child, multiple_x), ch)
            new_field = create_new_field(nd)
            return create_eval_n_node(new_field, new_ch, n_eval)
        end
    end


    function evaluate_pre_n_compiled_tree(tree :: pre_n_compiled_tree{T}, multiple_x_view :: Vector{SubArray{T,1,Array{T,1},N,false}} ) where N where T <: Number
        n_eval = length(multiple_x_view)
        n_eval == get_multiple(tree) || error("mismatch of the vector of point and the pre_compilation of the tree")
        set_multiple_x!(tree, multiple_x_view)
        racine = get_racine(tree)
        vec_tmp = get_vec_tmp(tree)
        evaluate_eval_n_node!(racine, vec_tmp)
        length(vec_tmp) == 1 ? res = abstract_expr_node.get_myRef(vec_tmp[1]) :: T  : res = sum(vec_tmp) :: T
        return res :: T
    end


    function evaluate_pre_n_compiled_tree(tree :: pre_n_compiled_tree{T}, multiple_v :: Vector{Vector{T}}) where T <: Number
        n_eval = length(multiple_v)
        n_eval == get_multiple(tree) || error("mismatch of the vector of point and the pre_compilation of the tree")
        set_multiple_x!(tree, multiple_v)
        racine = get_racine(tree)
        vec_tmp = get_vec_tmp(tree)
        evaluate_eval_n_node!(racine, vec_tmp)
        length(vec_tmp) == 1 ? res = abstract_expr_node.get_myRef(vec_tmp[1]) :: T  : res = sum(vec_tmp) :: T
        return res :: T
    end


    function evaluate_pre_n_compiled_tree(tree :: pre_n_compiled_tree{T}) where T <: Number
        racine = get_racine(tree)
        vec_tmp = get_vec_tmp(tree)
        evaluate_eval_n_node!(racine, vec_tmp)
        length(vec_tmp) == 1 ? res = abstract_expr_node.get_myRef(vec_tmp[1]) :: T  : res = sum(vec_tmp) :: T
        return res :: T
    end

    function evaluate_eval_n_node!(node :: eval_n_node{T}, tmp :: AbstractVector{myRef{T}}) where T <: Number
        op = get_op_from_node(node)
        if trait_expr_node.node_is_operator(op) :: Bool == false
            trait_expr_node._evaluate_node!(op, tmp)
        else
            n = get_length_children(node)
            for i in 1:n
                child = get_children_from_node(node, i )
                vector_ref = get_tmp_for_n_eval_child(node,i)
                evaluate_eval_n_node!(child, vector_ref)
            end
            vec_values_children = get_vec_tmp_children(node)
            trait_expr_node._evaluate_node!(op, vec_values_children, tmp)
        end
    end

end
