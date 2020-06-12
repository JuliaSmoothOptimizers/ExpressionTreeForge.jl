module implementation_type_expr

    import ..interface_type_expr._is_constant, ..interface_type_expr._is_linear, ..interface_type_expr._is_quadratic,
    ..interface_type_expr._is_more, ..interface_type_expr._is_cubic
    import ..interface_type_expr._type_product, ..interface_type_expr._type_power


############## définition du type ###################
    @enum t_type_expr_basic constant=0 linear=1 quadratic=2 cubic=3 more=4


############## définition des fonctions de l'interface ###################
    _is_constant(t :: t_type_expr_basic) = (t == constant)

    _is_linear(t :: t_type_expr_basic) = ( t == linear)

    _is_quadratic(t :: t_type_expr_basic) = (t == quadratic)

    _is_cubic(t :: t_type_expr_basic) = (t == cubic)

    _is_more(t :: t_type_expr_basic) = (t == more)

    return_constant() = t_type_expr_basic(0)

    return_linear() = t_type_expr_basic(1)

    return_quadratic() = t_type_expr_basic(2)

    return_cubic() = t_type_expr_basic(3)

    return_more() = t_type_expr_basic(4)

############## définition de fonctions nécessaires dans des algorithmes ###################

    function _type_product(a  :: t_type_expr_basic,b :: t_type_expr_basic)
        if _is_constant(a)
            return b
        elseif _is_linear(a)
            if _is_constant(b)
                return linear
            elseif _is_linear(b)
                return quadratic
            elseif _is_quadratic(b)
                return cubic
            else
                return more
            end
        elseif _is_quadratic(a)
            if _is_constant(b)
                return quadratic
            elseif _is_linear(b)
                return cubic
            else
                return more
            end
        elseif _is_cubic(a)
            if _is_constant(b)
                return cubic
            else
                return more
            end 
        elseif _is_more(a)
            return more
        end
    end

    function _type_power(index_power :: Number, b :: t_type_expr_basic)
        if index_power == 0
            return constant
        elseif index_power == 1
            return b
        else
            if _is_constant(b)
                return constant
            elseif _is_linear(b)
                if index_power == 2
                    return quadratic
                elseif index_power == 3
                    return cubic
                else
                    return more
                end
            else
                return more
            end
        end
    end

    export t_type_expr_basic, _is_constant, _is_linear, _is_quadratic, _is_more_than_quadratic,
    _is_cubic, return_constant, return_linear, return_quadratic, return_cubic, return_more

end  # module implementation_type_expr
