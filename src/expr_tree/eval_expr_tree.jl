module M_evaluation_expr_tree

    using ..trait_expr_tree, ..trait_expr_node
    using ..implementation_expr_tree, ..implementation_complete_expr_tree
    using ..abstract_expr_node


    using ForwardDiff

    # IMPORTANT La fonction evaluate_expr_tree garde le type des variables,
    # Il faut cependant veiller à modifier les constantes dans les expressions pour qu'elles
    # n'augmentent pas le type
    @inline evaluate_expr_tree(a :: Any) = (x :: AbstractVector{} -> evaluate_expr_tree(a,x) )
    @inline evaluate_expr_tree(a :: Any, elmt_var :: Vector{Int}) = (x :: AbstractVector{} -> evaluate_expr_tree(a,view(x,elmt_var) ) )
    @inline evaluate_expr_tree(a :: Any, x :: AbstractVector{T})  where T <: Number = _evaluate_expr_tree(a, trait_expr_tree.is_expr_tree(a), x)
    @inline evaluate_expr_tree(a :: Any, x :: AbstractVector) = _evaluate_expr_tree(a, trait_expr_tree.is_expr_tree(a), x)
    @inline evaluate_expr_tree(a :: Any, x :: AbstractArray) = _evaluate_expr_tree(a, trait_expr_tree.is_expr_tree(a), x)
    @inline _evaluate_expr_tree(a, :: trait_expr_tree.type_not_expr_tree, x :: AbstractVector{T})  where T <: Number = error(" This is not an Expr tree")
    @inline _evaluate_expr_tree(a, :: trait_expr_tree.type_expr_tree, x :: AbstractVector{T}) where T <: Number = _evaluate_expr_tree(a, x)
    @inline _evaluate_expr_tree(a, :: trait_expr_tree.type_not_expr_tree, x :: AbstractVector) = error(" This is not an Expr tree")
    @inline _evaluate_expr_tree(a, :: trait_expr_tree.type_expr_tree, x :: AbstractVector) = _evaluate_expr_tree(a, x)
    @inline _evaluate_expr_tree(a, :: trait_expr_tree.type_not_expr_tree, x :: AbstractArray) = error(" This is not an Expr tree")
    @inline _evaluate_expr_tree(a, :: trait_expr_tree.type_expr_tree, x :: AbstractArray) = _evaluate_expr_tree(a, x)
    @inline function _evaluate_expr_tree(expr_tree :: Y, x  :: AbstractVector{T}) where T <: Number where Y
        nd = trait_expr_tree._get_expr_node(expr_tree)
        if  trait_expr_node.node_is_operator(nd) == false
            trait_expr_node.evaluate_node(nd, x)
        else
            ch = trait_expr_tree._get_expr_children(expr_tree)
            n = length(ch)
            temp = Vector{T}(undef,n)
            @inbounds map!(y -> evaluate_expr_tree(y,x), temp, ch)
            trait_expr_node.evaluate_node(nd, temp)
        end
    end

    @inline function _evaluate_expr_tree(expr_tree :: implementation_expr_tree.t_expr_tree , x  :: AbstractVector{T}) where T <: Number
        if trait_expr_node.node_is_operator(expr_tree.field :: trait_expr_node.ab_ex_nd) :: Bool == false
            return trait_expr_node._evaluate_node(expr_tree.field, x)
        else
            n = length(expr_tree.children)
            temp = Vector{T}(undef, n)
            map!( y :: implementation_expr_tree.t_expr_tree  -> _evaluate_expr_tree(y,x) , temp, expr_tree.children)
            return trait_expr_node._evaluate_node(expr_tree.field,  temp)
        end
    end


    @inline function _evaluate_expr_tree(expr_tree_cmp :: implementation_complete_expr_tree.complete_expr_tree , x  :: AbstractVector{T}) where T <: Number
        op = trait_expr_tree.get_expr_node(expr_tree_cmp) :: trait_expr_node.ab_ex_nd
        if trait_expr_node.node_is_operator(op) :: Bool == false
            return trait_expr_node._evaluate_node(op, x) 
        else
            children = trait_expr_tree.get_expr_children(expr_tree_cmp)
            n = length(children) :: Int
            temp = Vector{T}(undef, n)
            map!( y :: implementation_complete_expr_tree.complete_expr_tree  -> _evaluate_expr_tree(y,x) :: T , temp, children)
            return trait_expr_node._evaluate_node(op,  temp)
        end
    end



    # temp_aux = Vector{T where T <: Number}(undef, n)
    @inline function _evaluate_expr_tree(expr_tree_cmp :: implementation_complete_expr_tree.complete_expr_tree , xs  :: Array{Array{T,1},1} ) where T <: Number
        op = trait_expr_tree.get_expr_node(expr_tree_cmp) :: trait_expr_node.ab_ex_nd
        number_x = length(xs)
        if trait_expr_node.node_is_operator(op :: trait_expr_node.ab_ex_nd) :: Bool == false
            temp = Vector{T}(undef, number_x)
            map!( x -> trait_expr_node._evaluate_node(op, x), temp, xs)
            return temp
        else
            children = trait_expr_tree.get_expr_children(expr_tree_cmp)
            n = length(children)
            lx = length(xs[1])
            res = Vector{T}(undef,number_x)

            temp = Array{T,2}(undef, n, number_x)

            for i in 1:n
                view(temp, i, :) .= _evaluate_expr_tree(children[i], xs)
            end

            for i in 1:number_x
                res[i] = trait_expr_node._evaluate_node(op,  view(temp,: ,i ) )
            end
            # temp_aux = Vector{T}(undef, number_x)
            # temp = Vector{Vector{T}}( (x -> temp_aux).([1:n;]) )
            # for i in 1:n
            #     temp[i] = _evaluate_expr_tree(children[i], xs)
            # end
            # def_value_children = Vector{T}(undef, n)
            # value_children = Vector{Vector{T}}((x -> def_value_children).(1:lx))
            # for i in 1:number_x
            #     for j in 1:n
            #         value_children[i][j] = temp[j][i]
            #     end
            # end
            # for i in 1:number_x
            #     res[i] = trait_expr_node._evaluate_node(op,  value_children[i])
            # end

            return res
        end
    end


    # A = Array{Int,2}(undef, 2,5)
    # @show length(view(A,1,:))



    calcul_gradient_expr_tree(a :: Any, x :: Vector{}) = _calcul_gradient_expr_tree(a, is_expr_tree(a), x )
    _calcul_gradient_expr_tree(a :: Any,:: trait_expr_tree.type_not_expr_tree, x :: Vector{}) = error("ce n'est pas un arbre d'expression")
    _calcul_gradient_expr_tree(a :: Any,:: trait_expr_tree.type_expr_tree, x :: Vector{}) = _calcul_gradient_expr_tree(a, x)
    calcul_gradient_expr_tree(a :: Any, x :: Vector{}, elmt_var :: Vector{Int}) = _calcul_gradient_expr_tree(a, is_expr_tree(a), x, elmt_var)
    _calcul_gradient_expr_tree(a :: Any,:: trait_expr_tree.type_not_expr_tree, x :: Vector{}, elmt_var :: Vector{Int}) = error("ce n'est pas un arbre d'expression")
    _calcul_gradient_expr_tree(a :: Any,:: trait_expr_tree.type_expr_tree, x :: Vector{}, elmt_var :: Vector{Int}) = _calcul_gradient_expr_tree(a, x, elmt_var)
    function _calcul_gradient_expr_tree(expr_tree, x :: Vector{T}) where T <: Number
        g = ForwardDiff.gradient( evaluate_expr_tree(expr_tree), x)
        return g
    end
    function _calcul_gradient_expr_tree(expr_tree, x :: Vector{}, elmt_var :: Vector{Int})
        g = ForwardDiff.gradient( evaluate_expr_tree(expr_tree, elmt_var), x)
        return g
    end

    using ReverseDiff
    calcul_gradient_expr_tree2(a :: Any, x :: Vector{}, elmt_var :: Vector{Int}) = _calcul_gradient_expr_tree2(a, is_expr_tree(a), x, elmt_var)
    calcul_gradient_expr_tree2(a :: Any, x :: Vector{}) = _calcul_gradient_expr_tree2(a, is_expr_tree(a), x )
    _calcul_gradient_expr_tree2(a :: Any,:: trait_expr_tree.type_not_expr_tree, x :: Vector{}) = error("ce n'est pas un arbre d'expression")
    _calcul_gradient_expr_tree2(a :: Any,:: trait_expr_tree.type_expr_tree, x :: Vector{}) = _calcul_gradient_expr_tree2(a, x)
    _calcul_gradient_expr_tree2(a :: Any,:: trait_expr_tree.type_not_expr_tree, x :: Vector{}, elmt_var :: Vector{Int}) = error("ce n'est pas un arbre d'expression")
    _calcul_gradient_expr_tree2(a :: Any,:: trait_expr_tree.type_expr_tree, x :: Vector{}, elmt_var :: Vector{Int}) = _calcul_gradient_expr_tree2(a, x, elmt_var)
    function _calcul_gradient_expr_tree2(expr_tree, x :: Vector{T}) where T <: Number
        g = ReverseDiff.gradient( evaluate_expr_tree(expr_tree), x)
        return g
    end
    function _calcul_gradient_expr_tree2(expr_tree, x :: Vector{}, elmt_var :: Vector{Int})
        g = ReverseDiff.gradient( evaluate_element_expr_tree(expr_tree, elmt_var), x)
        return g
    end

    calcul_Hessian_expr_tree(a :: Any, x :: Vector{}) = _calcul_Hessian_expr_tree(a, is_expr_tree(a), x )
    _calcul_Hessian_expr_tree(a :: Any,:: trait_expr_tree.type_not_expr_tree, x :: Vector{}) = error("ce n'est pas un arbre d'expression")
    _calcul_Hessian_expr_tree(a :: Any,:: trait_expr_tree.type_expr_tree, x :: Vector{}) = _calcul_Hessian_expr_tree(a, x)
    function _calcul_Hessian_expr_tree(expr_tree, x :: Vector{})
        H = ForwardDiff.hessian( evaluate_expr_tree(expr_tree), x)
        return H
    end



#=-----------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------
Fonction de test pour améliorer
-----------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------=#


# evaluate_expr_tree(a :: Any) = (x :: AbstractVector{} -> evaluate_expr_tree(a,x) )
# evaluate_expr_tree(a :: Any, elmt_var :: Vector{Int}) = (x :: AbstractVector{} -> evaluate_expr_tree(a,view(x,elmt_var) ) )
evaluate_expr_tree2(a :: implementation_expr_tree.t_expr_tree, x :: AbstractVector{T})  where T <: Number = _evaluate_expr_tree2(a, trait_expr_tree.is_expr_tree(a), x)
_evaluate_expr_tree2(a :: implementation_expr_tree.t_expr_tree, :: trait_expr_tree.type_not_expr_tree, x :: AbstractVector{T})  where T <: Number = error(" This is not an Expr tree")
_evaluate_expr_tree2(a :: implementation_expr_tree.t_expr_tree, :: trait_expr_tree.type_expr_tree, x :: AbstractVector{T}) where T <: Number = _evaluate_expr_tree2(a, x)
function _evaluate_expr_tree2(expr_tree :: implementation_expr_tree.t_expr_tree , x  :: AbstractVector{T}) where T <: Number
    n_children = length(expr_tree.children)
    if n_children == 0
        return trait_expr_node._evaluate_node2(expr_tree.field,  x) :: T
    elseif n_children == 1
        temp = Vector{T}(undef,1)
        temp[1] = _evaluate_expr_tree2( expr_tree.children[1],  x) :: T
        return trait_expr_node._evaluate_node2(expr_tree.field, temp) :: T
    else
        field = expr_tree.field
        return mapreduce( y :: implementation_expr_tree.t_expr_tree  -> _evaluate_expr_tree2(y, x) :: T , trait_expr_node._evaluate_node2(field) , expr_tree.children :: Vector{implementation_expr_tree.t_expr_tree} ) :: T
    end
end


end
