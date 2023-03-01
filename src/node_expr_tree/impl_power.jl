module M_power_operator

import ..M_abstract_expr_node: Abstract_expr_node, create_node_expr
import ..M_interface_expr_node:
  _node_is_plus,
  _node_is_minus,
  _node_is_power,
  _node_is_times,
  _node_is_constant,
  _node_is_variable,
  _node_is_operator,
  _node_is_sin,
  _node_is_cos,
  _node_is_tan
import ..M_interface_expr_node:
  _get_type_node,
  _get_var_index,
  _evaluate_node,
  _evaluate_node!,
  _cast_constant!,
  _node_to_Expr,
  _node_to_Expr2,
  _node_to_Expr_JuMP,
  _node_bound,
  _node_convexity
import ..M_implementation_type_expr.Type_expr_basic
import Base.(==), Base.string

using ..M_implementation_convexity_type
using ..M_implementation_type_expr
using ..M_trait_type_expr
using ..M_abstract_expr_node

export Power_operator

mutable struct Power_operator{T <: Number} <: Abstract_expr_node
  index::T
end

@inline my_and(a::Bool, b::Bool) = (a && b)
function _node_convexity(
  op::Power_operator{Y},
  son_cvx::AbstractVector{M_implementation_convexity_type.Convexity_type},
  son_bound::AbstractVector{Tuple{T, T}},
) where {Y <: Number} where {T <: Number}
  (length(son_cvx) == 1 && length(son_bound) == 1) ||
    error("unvalid children length of _node_convexity")
  st_ch = son_cvx[1]
  (bi, bs) = son_bound[1]
  if (op.index == 0 || M_implementation_convexity_type.is_constant(st_ch))
    return M_implementation_convexity_type.constant_type()
  elseif op.index == 1
    return st_ch
  elseif op.index % 2 == 0
    if M_implementation_convexity_type.is_linear(st_ch)
      return M_implementation_convexity_type.convex_type()
    elseif op.index > 0
      if (M_implementation_convexity_type.is_convex(st_ch) && bi >= 0) ||
         (M_implementation_convexity_type.is_concave(st_ch) && bs <= 0)
        return M_implementation_convexity_type.convex_type()
      else
        return M_implementation_convexity_type.unknown_type()
      end
    else # op.index < 0
      if (M_implementation_convexity_type.is_convex(st_ch) && bs <= 0) ||
         (M_implementation_convexity_type.is_concave(st_ch) && bi >= 0)
        return M_implementation_convexity_type.convex_type()
      elseif (M_implementation_convexity_type.is_convex(st_ch) && bi >= 0) ||
             (M_implementation_convexity_type.is_concave(st_ch) && bs <= 0)
        return M_implementation_convexity_type.concave_type()
      else
        return M_implementation_convexity_type.unknown_type()
      end
    end
  elseif op.index % 2 == 1 # op.indxx is odd
    if op.index > 0
      if M_implementation_convexity_type.is_convex(st_ch) && bi >= 0
        return M_implementation_convexity_type.convex_type()
      elseif M_implementation_convexity_type.is_concave(st_ch) && bs <= 0
        return M_implementation_convexity_type.concave_type()
      else
        return M_implementation_convexity_type.unknown_type()
      end
    else # op.indxx is odd and <0
      if M_implementation_convexity_type.is_concave(st_ch) && bi >= 0
        return M_implementation_convexity_type.convex_type()
      elseif M_implementation_convexity_type.is_convex(st_ch) && bs <= 0
        return M_implementation_convexity_type.concave_type()
      else
        return M_implementation_convexity_type.unknown_type()
      end
    end
  else
    return M_implementation_convexity_type.unknown_type()
  end
end

function _node_bound(
  op::Power_operator{Y},
  son_bound::AbstractVector{Tuple{T, T}},
  t::DataType,
) where {Y <: Number} where {T <: Number}
  vector_inf_bound = [p[1] for p in son_bound]
  vector_sup_bound = [p[2] for p in son_bound]
  length(vector_inf_bound) != length(vector_sup_bound) && @error("bounds errors") # check that there is only one child
  length(vector_inf_bound) != 1 &&
    length(vector_sup_bound) != 1 &&
    @error("non-unary power operator")
  bi = vector_inf_bound[1]
  bs = vector_sup_bound[1]
  bi <= bs || @error("wrong bounds")
  if op.index - floor(op.index) != 0
    @warn("unsupported case, return (-Inf,Inf), bounds and convexity are unreliable")
    return (-Inf, Inf)
  elseif op.index % 2 == 0
    if bi > 0  # 0 < bi < bs < Inf
      return (bi^(op.index), bs^(op.index))
    elseif bs < 0 # -Inf < bi < bs < 0
      return (bs^(op.index), bi^(op.index))
    else # -Inf < bi < 0 < bs < Inf
      return ((t)(0), max(abs(bi), abs(bs))^(op.index))
    end
  else
    return (bi^(op.index), bs^(op.index))
  end
end

@inline create_node_expr(op::Symbol, arg::T, ::Bool) where {T <: Number} = Power_operator{T}(arg)
@inline create_node_expr(op::Power_operator{T}) where {T <: Number} = Power_operator{T}(op.index)
@inline create_node_expr(op::Symbol, arg::T, x::AbstractVector{T}, ::Bool) where {T <: Number} =
  Power_operator{T}(arg)
@inline create_node_expr(op::Power_operator{T}, x::AbstractVector{T}) where {T <: Number} =
  Power_operator{T}(op.index)

@inline _node_is_operator(op::Power_operator{T}) where {T <: Number} = true
@inline _node_is_plus(op::Power_operator{T}) where {T <: Number} = false
@inline _node_is_minus(op::Power_operator{T}) where {T <: Number} = false
@inline _node_is_times(op::Power_operator{T}) where {T <: Number} = false
@inline _node_is_power(op::Power_operator{T}) where {T <: Number} = true
@inline _node_is_sin(op::Power_operator{T}) where {T <: Number} = false
@inline _node_is_cos(op::Power_operator{T}) where {T <: Number} = false
@inline _node_is_tan(op::Power_operator{T}) where {T <: Number} = false

@inline _node_is_variable(op::Power_operator{T}) where {T <: Number} = false

@inline _node_is_constant(op::Power_operator{T}) where {T <: Number} = false

function _get_type_node(op::Power_operator{T}, type_ch::Vector{Type_expr_basic}) where {T <: Number}
  length(type_ch) == 1 || error("power has more than one argument")
  return M_trait_type_expr.type_power(op.index, type_ch[1])
end

@inline (==)(a::Power_operator{T}, b::Power_operator{T}) where {T <: Number} = (a.index == b.index)
@inline string(a::Power_operator) = "^" * string(a.index)

@inline function _evaluate_node(
  op::Power_operator{Z},
  value_ch::AbstractVector{T},
) where {T <: Number} where {Z <: Number}
  length(value_ch) == 1 || error("power has more than one argument")
  return value_ch[1]^(op.index)
end

@inline function _evaluate_node(
  op::Power_operator{T},
  value_ch::AbstractVector{T},
) where {T <: Number}
  length(value_ch) == 1 || error("power has more than one argument")
  return value_ch[1]^(op.index)::T
end

@inline _evaluate_node(op::Power_operator{Z}, value_ch::T) where {T <: Number} where {Z <: Number} =
  (T)(value_ch^(op.index))::T
@inline _evaluate_node(op::Power_operator{T}, value_ch::T) where {T <: Number} where {Z <: Number} =
  value_ch^(op.index)::T

@inline _node_to_Expr(op::Power_operator{T}) where {T <: Number} = [:^, op.index]
@inline _node_to_Expr_JuMP(op::Power_operator{T}) where {T <: Number} = [:^, op.index]

function _cast_constant!(op::Power_operator{T}, t::DataType) where {T <: Number}
  new_index = (t)(op.index)
  return Power_operator{t}(new_index)
end

end
