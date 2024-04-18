module M_implementation_type_expr

import ..M_interface_type_expr:
  _is_constant, _is_linear, _is_quadratic, _is_more, _is_cubic, _type_product, _type_power

export Type_expr_basic,
  _is_constant,
  _is_linear,
  _is_quadratic,
  _is_more,
  _is_cubic,
  return_constant,
  return_linear,
  return_quadratic,
  return_cubic,
  return_more

@enum Type_expr_basic constant = 0 linear = 1 quadratic = 2 cubic = 3 more = 4

"""
    bool = _is_constant(type::Type_expr_basic)

Check if `type` equals `constant`.
"""
@inline _is_constant(type::Type_expr_basic) = (type == constant)

"""
    bool = _is_linear(type::Type_expr_basic)

Check if `type` equals `linear`.
"""
@inline _is_linear(type::Type_expr_basic) = (type == linear)

"""
    bool = _is_quadratic(type::Type_expr_basic)

Check if `type` equals `quadratic`.
"""
@inline _is_quadratic(type::Type_expr_basic) = (type == quadratic)

"""
    bool = _is_cubic(type::Type_expr_basic)

Check if `type` equals `cubic`.
"""
@inline _is_cubic(type::Type_expr_basic) = (type == cubic)

"""
    bool = _is_more(type::Type_expr_basic)

Check if `type` equals `more`.
"""
@inline _is_more(type::Type_expr_basic) = (type == more)

"""
    constant = return_constant()

Return `constantype::Type_expr_basic`.
"""
@inline return_constant() = Type_expr_basic(0)

"""
    linear = return_linear()

Return `linear::Type_expr_basic`.
"""
@inline return_linear() = Type_expr_basic(1)

"""
    quadratic = return_quadratic()

Return `quadratic::Type_expr_basic`.
"""
@inline return_quadratic() = Type_expr_basic(2)

"""
    cubic = return_cubic()

Return `cubic::Type_expr_basic`.
"""
@inline return_cubic() = Type_expr_basic(3)

"""
    more = return_more()

Return `more::Type_expr_basic`.
"""
@inline return_more() = Type_expr_basic(4)

"""
    result_type = _type_product(a::Type_expr_basic, b::Type_expr_basic)

Return `result_type::Type_expr_basic`, the type resulting of the product `a*b`.
"""
function _type_product(typea::Type_expr_basic, typeb::Type_expr_basic)
  if _is_constant(typea)
    return typeb
  elseif _is_linear(typea)
    if _is_constant(typeb)
      return linear
    elseif _is_linear(typeb)
      return quadratic
    elseif _is_quadratic(typeb)
      return cubic
    else
      return more
    end
  elseif _is_quadratic(typea)
    if _is_constant(typeb)
      return quadratic
    elseif _is_linear(typeb)
      return cubic
    else
      return more
    end
  elseif _is_cubic(typea)
    if _is_constant(typeb)
      return cubic
    else
      return more
    end
  elseif _is_more(typea)
    return more
  end
end

"""
    result_type = _type_power(index_power::Number, b::Type_expr_basic)

Return `result_type::Type_expr_basic`, resulting of `b^(index_power)`.
"""
function _type_power(index_power::Number, type::Type_expr_basic)
  if index_power == 0
    return constant
  elseif index_power == 1
    return type
  else
    if _is_constant(type)
      return constant
    elseif _is_linear(type)
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

end
