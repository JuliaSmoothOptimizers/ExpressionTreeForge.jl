
module algo_expr_tree

    using ..trait_tree
    using ..trait_expr_tree
    using ..trait_expr_node
    using ..abstract_expr_tree
    using ..abstract_expr_node
    using ..abstract_tree
    using ..implementation_tree
    using ..implementation_type_expr
    using ..hl_trait_expr_tree
    using ..implementation_expr_tree

    using SparseArrays





"""
    delete_imbricated_plus(t)

    t must be a type which satisfies the trait_expr_tree. In that case if
    t represent a function, delete_imbricated_plus(t) will split that function
    into element function if it is possible.

    delete_imbricated_plus(:(x[1] + x[2] + x[3]*x[4] ) )
    [
    x[1],
    x[2],
    x[3] * x[4]
    ]

"""
    @inline delete_imbricated_plus(a :: Any) = _delete_imbricated_plus(a, trait_expr_tree.is_expr_tree(a))
    @inline _delete_imbricated_plus(a, :: trait_expr_tree.type_not_expr_tree) = error(" This is not an expr tree")
    @inline _delete_imbricated_plus(a, :: trait_expr_tree.type_expr_tree) = _delete_imbricated_plus(a)
    function _delete_imbricated_plus( expr_tree :: T ) where T
        nd = trait_expr_tree.get_expr_node(expr_tree)
        if trait_expr_node.node_is_operator(nd)
            if trait_expr_node.node_is_plus(nd)
                ch = trait_expr_tree.get_expr_children(expr_tree)
                n = length(ch)
                res = Vector{}(undef,n)
                Threads.@threads for i in 1:n
                    res[i] = delete_imbricated_plus(ch[i])
                end
                return vcat(res...)
            elseif trait_expr_node.node_is_minus(nd)
                ch = trait_expr_tree.get_expr_children(expr_tree)
                if length(ch) == 1 #moins unaire donc un seul fils
                    temp = delete_imbricated_plus(ch)
                    res = trait_expr_tree.inverse_expr_tree.(temp)
                    return vcat(res...)
                else length(ch) == 2 #2 fils
                    res1 =  delete_imbricated_plus(ch[1])
                    temp =  delete_imbricated_plus(ch[2])
                    res2 = trait_expr_tree.inverse_expr_tree.(temp)
                    return vcat(vcat(res1...),vcat(res2...))
                end
            else
                return [expr_tree]
            end
        else
            return [expr_tree]
        end
    end


"""
    get_type_tree(t)

    Return the type of the expression tree t, whose the type is inside the trait_expr_tree

    get_type_tree( :(5+4)) = constant
    get_type_tree( :(x[1])) = linear
    get_type_tree( :(x[1]* x[2])) = quadratic

"""
    @inline get_type_tree(a :: Any) = _get_type_tree(a, trait_expr_tree.is_expr_tree(a))
    @inline _get_type_tree(a, :: trait_expr_tree.type_not_expr_tree) = error(" This is not an Expr tree")
    @inline _get_type_tree(a, :: trait_expr_tree.type_expr_tree) = _get_type_tree(a)
    function _get_type_tree(expr_tree)
        ch = trait_expr_tree.get_expr_children(expr_tree)
        if isempty(ch)
            nd =  trait_expr_tree.get_expr_node(expr_tree)
            type_node = trait_expr_node.get_type_node(nd)
            return type_node
        else
            n = length(ch)
            ch_type =  Vector{implementation_type_expr.t_type_expr_basic}(undef,n)
            for i in 1:n
                ch_type[i] = _get_type_tree(ch[i])
            end
            nd_op =  trait_expr_tree.get_expr_node(expr_tree)
            type_node = trait_expr_node.get_type_node(nd_op, ch_type)
            return type_node
        end
    end


"""
    get_elemental_variable(expr_tree)

    Return the index of the variable appearing in the expression tree

    get_elemental_variable( :(x[1] + x[3]) )
    > [1, 3]
    get_elemental_variable( :(x[1]^2 + x[6] + x[2]) )
    > [1, 6, 2]
"""
    @inline get_elemental_variable(a :: Any) = _get_elemental_variable(a, trait_expr_tree.is_expr_tree(a))
    @inline _get_elemental_variable(a, :: trait_expr_tree.type_not_expr_tree) = error(" This is not an Expr tree")
    @inline _get_elemental_variable(a, :: trait_expr_tree.type_expr_tree) = _get_elemental_variable(a)
    function _get_elemental_variable(expr_tree)
        nd =  trait_expr_tree.get_expr_node(expr_tree)
        if trait_expr_node.node_is_operator(nd)
            ch = trait_expr_tree.get_expr_children(expr_tree)
            n = length(ch)
            list_var = map(get_elemental_variable, ch)
            res = unique!(vcat(list_var...))
            return res :: Vector{Int}
        elseif trait_expr_node.node_is_variable(nd)
            return [trait_expr_node.get_var_index(nd)] :: Vector{Int}
        elseif trait_expr_node.node_is_constant(nd)
            return  Vector{Int}([])
        else
            error("the node is neither operator/variable or constant")
        end
    end

"""
    get_Ui(index_new_var, n)
Create a the matrix U associated to the variable appearing in index_new_var.
This function create a sparse matrix of size length(index_new_var)×n.
"""
    function get_Ui(index_vars :: Vector{Int}, n :: Int)
        m = length(index_vars)
        U = sparse( [1:m;] :: Vector{Int}, index_vars,  ones(Int,length(index_vars)), m, n) :: SparseMatrixCSC{Int,Int}
        return U
    end

"""
    element_fun_from_N_to_Ni!(expr_tree, vector)
Transform the tree expr_tree, which represent a function from Rⁿ ⇢ R, to an element
function from Rⁱ → R .
This function rename the variable of expr_tree to x₁,x₂,... instead of x₇,x₉ for example

"""
    @inline element_fun_from_N_to_Ni!(expr_tree, a :: Vector{Int}) = _element_fun_from_N_to_Ni!(expr_tree, trait_expr_tree.is_expr_tree(expr_tree),a)
    @inline _element_fun_from_N_to_Ni!(expr_tree, :: trait_expr_tree.type_not_expr_tree, a :: Vector{Int}) = error(" This is not an Expr tree")
    @inline _element_fun_from_N_to_Ni!(expr_tree, :: trait_expr_tree.type_expr_tree, a :: Vector{Int}) = _element_fun_from_N_to_Ni!(expr_tree,a)
    @inline element_fun_from_N_to_Ni!(expr_tree, a :: Dict{Int,Int}) = _element_fun_from_N_to_Ni!(expr_tree, trait_expr_tree.is_expr_tree(expr_tree),a)
    @inline _element_fun_from_N_to_Ni!(expr_tree, :: trait_expr_tree.type_not_expr_tree, a :: Dict{Int,Int}) = error(" This is not an Expr tree")
    @inline _element_fun_from_N_to_Ni!(expr_tree, :: trait_expr_tree.type_expr_tree, a :: Dict{Int,Int}) = _element_fun_from_N_to_Ni!(expr_tree,a)
    # Pour les 2 fonction suivantes.
    #     - La première prend en entrée un vecteur d'entier, la fonction N_to_Ni créé le dictionnaire qui sera nécessaire pour la seconde fonction,
    #     la première fonction défini juste le dictionnaire nécessaire pour la seconde fonction.
    #     - La seconde fonction est la fonction qui va réellement modifier l'arbre d'expression expr_tree, en modifiant les indices des variables
    #     en accord avec les valeurs dans le dictionnaire.
    function _element_fun_from_N_to_Ni!(expr_tree, elmt_var :: Vector{Int})
        function N_to_Ni(elemental_var :: Vector{Int})
            dic_var_value = Dict{Int,Int}()
            for i in 1:length(elemental_var)
                dic_var_value[elemental_var[i]] = i
            end
            return dic_var_value
        end
        new_var = N_to_Ni(elmt_var)
        element_fun_from_N_to_Ni!(expr_tree, new_var)
    end

    function _element_fun_from_N_to_Ni!(expr_tree, dic_new_var :: Dict{Int,Int})
        ch = trait_expr_tree.get_expr_children(expr_tree)
        if isempty(ch) # on est alors dans une feuille
            r_node = trait_expr_tree.get_real_node(expr_tree)
            trait_expr_node.change_from_N_to_Ni!(r_node, dic_new_var)
        else
            n = length(ch)
            for i in 1:n
                _element_fun_from_N_to_Ni!(ch[i], dic_new_var)
            end
        end
    end



"""
    cast_type_of_constant(expr_tree, t)
Cast the constant of the expression tree expr_tree to the type t.
"""
    @inline cast_type_of_constant(expr_tree, t :: DataType) = _cast_type_of_constant(expr_tree, trait_expr_tree.is_expr_tree(expr_tree), t)
    @inline _cast_type_of_constant(expr_tree, :: trait_expr_tree.type_not_expr_tree, t :: DataType) =  error("this is not an expr tree")
    @inline _cast_type_of_constant(expr_tree, :: trait_expr_tree.type_expr_tree, t :: DataType) =  _cast_type_of_constant(expr_tree, t)
# On chercher à caster les constantes de l'arbre au type t, on va donc parcourir l'arbre jusqu'à arriver aux feuilles
# où nous réaliserons l'opération de caster au type t une constante individuellement .
    @inline _cast_type_of_constant(expr_tree, t :: DataType) = hl_trait_expr_tree._cast_type_of_constant(expr_tree,t)



    @inline get_function_of_evaluation(expr_tree) = _get_function_of_evaluation(expr_tree, trait_expr_tree.is_expr_tree(expr_tree))
    @inline _get_function_of_evaluation(expr_tree, :: trait_expr_tree.type_not_expr_tree) = error("this is not an expr tree")
    @inline _get_function_of_evaluation(expr_tree, :: trait_expr_tree.type_expr_tree) = _get_function_of_evaluation(expr_tree)
    function _get_function_of_evaluation(ex :: implementation_expr_tree.t_expr_tree)
        ex_Expr = trait_expr_tree.transform_to_Expr2(ex)
        @show ex_Expr
        vars_ex_Expr = algo_expr_tree.get_elemental_variable(ex)
        sort!(vars_ex_Expr)
        vars_x_ex_Expr = map(i :: Int -> Symbol( "x" * string(i) ), vars_ex_Expr)
        @eval f_evaluation($(vars_x_ex_Expr...)) = $ex_Expr


        f(x :: AbstractVector{T}) where T <: Number =  Base.invokelatest(f_evaluation, x...)
        return Base.invokelatest(f, x) :: Function

        # x_temp = ones(length(vars_ex_Expr))
        # @show f_evaluation(x_temp...)
        # @show f(x_temp)
        # return Base.invokelatest(f) :: Function
    end

end
