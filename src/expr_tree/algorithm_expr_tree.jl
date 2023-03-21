module M_algo_expr_tree
using SparseArrays
using MathOptInterface

using ..M_trait_expr_node, ..M_trait_expr_tree, ..M_trait_tree
using ..M_abstract_expr_tree, ..M_abstract_expr_node, ..M_abstract_tree
using ..M_implementation_tree, ..M_implementation_type_expr
using ..M_hl_trait_expr_tree
using ..M_implementation_expr_tree

"""
    separated_terms = extract_element_functions(expr_tree)

Divide the expression tree as a terms of a sum if possible.
It returns a vector where each component is a subexpression tree of `expr_tree`.

Example:
```julia
julia> extract_element_functions(:(x[1] + x[2] + x[3]*x[4] ) )
3-element Vector{Expr}:
 :(x[1])
 :(x[2])
 :(x[3] * x[4])
```
"""
@inline extract_element_functions(a::Any) =
  _extract_element_functions(a, M_trait_expr_tree.is_expr_tree(a))

@inline _extract_element_functions(a, ::M_trait_expr_tree.Is_not_expr_tree) =
  error(" This is not an expr tree")

@inline _extract_element_functions(a, ::M_trait_expr_tree.Is_expr_tree) =
  _extract_element_functions(a)

function _extract_element_functions(expr_tree::T) where {T}
  nd = M_trait_expr_tree.get_expr_node(expr_tree)
  if M_trait_expr_node.node_is_operator(nd)
    if M_trait_expr_node.node_is_plus(nd)
      ch = M_trait_expr_tree.get_expr_children(expr_tree)
      n = length(ch)
      res = Vector{}(undef, n)
      Threads.@threads for i = 1:n
        res[i] = extract_element_functions(ch[i])
      end
      return vcat(res...)
    elseif M_trait_expr_node.node_is_minus(nd)
      ch = M_trait_expr_tree.get_expr_children(expr_tree)
      if length(ch) == 1 # unary minus
        temp = extract_element_functions(ch[1])
        res = M_trait_expr_tree.inverse_expr_tree.(temp)
        return vcat(res...)
      else
        length(ch) == 2 # binary minus
        res1 = extract_element_functions(ch[1])
        temp = extract_element_functions(ch[2])
        res2 = M_trait_expr_tree.inverse_expr_tree.(temp)
        return vcat(vcat(res1...), vcat(res2...))
      end
    else
      return [expr_tree]
    end
  else
    return [expr_tree]
  end
end

"""
    type = get_type_tree(expr_tree)

Return the type of `expr_tree`.
It can either be: `constant`, `linear`, `quadratic`, `cubic` or `more`.

Example:
```julia
julia> get_type_tree(:(5+4)) == constant
true
julia> get_type_tree(:(x[1])) == linear
true
julia> get_type_tree(:(x[1]* x[2])) == quadratic
true
```
"""
@inline get_type_tree(a::Any) = _get_type_tree(a, M_trait_expr_tree.is_expr_tree(a))
@inline _get_type_tree(a, ::M_trait_expr_tree.Is_not_expr_tree) = error(" This is not an Expr tree")
@inline _get_type_tree(a, ::M_trait_expr_tree.Is_expr_tree) = _get_type_tree(a)

function _get_type_tree(expr_tree)
  ch = M_trait_expr_tree.get_expr_children(expr_tree)
  if isempty(ch)
    nd = M_trait_expr_tree.get_expr_node(expr_tree)
    type_node = M_trait_expr_node.get_type_node(nd)
    return type_node
  else
    n = length(ch)
    ch_type = Vector{M_implementation_type_expr.Type_expr_basic}(undef, n)
    for i = 1:n
      ch_type[i] = _get_type_tree(ch[i])
    end
    nd_op = M_trait_expr_tree.get_expr_node(expr_tree)
    type_node = M_trait_expr_node.get_type_node(nd_op, ch_type)
    return type_node
  end
end

"""
    indices = get_elemental_variables(expr_tree)

Return the `indices` of the variable appearing in `expr_tree`.
This function find the elemental variables from the expression tree of an element function.

Example:
```julia
julia> get_elemental_variables(:(x[1] + x[3]) )
[1, 3]
julia> get_elemental_variables(:(x[1]^2 + x[6] + x[2]) )
[1, 6, 2]
```
"""
@inline get_elemental_variables(a::Any) =
  _get_elemental_variables(a, M_trait_expr_tree.is_expr_tree(a))

@inline _get_elemental_variables(a, ::M_trait_expr_tree.Is_not_expr_tree) =
  error(" This is not an Expr tree")

@inline _get_elemental_variables(a, ::M_trait_expr_tree.Is_expr_tree) = _get_elemental_variables(a)

function _get_elemental_variables(expr_tree)
  nd = M_trait_expr_tree.get_expr_node(expr_tree)
  if M_trait_expr_node.node_is_operator(nd)
    ch = M_trait_expr_tree.get_expr_children(expr_tree)
    n = length(ch)
    list_var = map(get_elemental_variables, ch)
    res = unique!(vcat(list_var...))
    return res::Vector{Int}
  elseif M_trait_expr_node.node_is_variable(nd)
    return [M_trait_expr_node.get_var_index(nd)]::Vector{Int}
  elseif M_trait_expr_node.node_is_constant(nd)
    return Vector{Int}([])
  else
    error("the node is neither operator/variable or constant")
  end
end

"""
    Ui = get_Ui(indices::Vector{Int}, n::Int)

Create a sparse matrix `Ui` from `indices` computed by `get_elemental_variables`.
Every index `i` (of `indices`) form a line of `Ui` corresponding to `i`-th Euclidian vector.
"""
function get_Ui(index_vars::Vector{Int}, n::Int)
  m = length(index_vars)
  U = sparse(
    [1:m;]::Vector{Int},
    index_vars,
    ones(Int, length(index_vars)),
    m,
    n,
  )::SparseMatrixCSC{Int, Int}
  return U
end

"""
    normalize_indices!(expr_tree, vector_indices; initial_index=0)

Change the indices of the variables of `expr_tree` given the order given by `vector_indices`.
It it paired with `get_elemental_variables` to define the elemental element functions expression tree.

Example:
```julia
julia> normalize_indices!(:(x[4] + x[5]), [4,5]; initial_index::Int)
:(x[1+initial_index] + x[2+initial_index])
```
"""
@inline normalize_indices!(expr_tree, a::Vector{Int}; kwargs...) =
  _normalize_indices!(expr_tree, M_trait_expr_tree.is_expr_tree(expr_tree), a; kwargs...)

@inline _normalize_indices!(expr_tree, ::M_trait_expr_tree.Is_not_expr_tree, a::Vector{Int}) =
  error(" This is not an Expr tree")

@inline _normalize_indices!(expr_tree, ::M_trait_expr_tree.Is_expr_tree, a::Vector{Int}; kwargs...) =
  _normalize_indices!(expr_tree, a; kwargs...)

@inline normalize_indices!(expr_tree, a::Dict{Int, Int}; kwargs...) =
  _normalize_indices!(expr_tree, M_trait_expr_tree.is_expr_tree(expr_tree), a; kwargs...)

@inline _normalize_indices!(expr_tree, ::M_trait_expr_tree.Is_not_expr_tree, a::Dict{Int, Int}) =
  error(" This is not an Expr tree")

@inline _normalize_indices!(expr_tree, ::M_trait_expr_tree.Is_expr_tree, a::Dict{Int, Int}; kwargs...) =
  _normalize_indices!(expr_tree, a; kwargs...)

"""
    dic = N_to_Ni(elemental_var::Vector{Int}; initial_index=0)

Return a dictionnary informing the index changes of an element expression tree.
If `element_var = [4,5]` then `dic == Dict([4=>initial_index+1, 5=>initial_index+2])`.
"""
function N_to_Ni(elemental_var::Vector{Int}; initial_index=0, kwargs...)
  dic_var_value = Dict{Int, Int}()
  for i = 1:length(elemental_var)
    dic_var_value[elemental_var[i]] = initial_index+i
  end
  return dic_var_value
end

function _normalize_indices!(expr_tree, elmt_var::Vector{Int}; kwargs...)
  new_var = N_to_Ni(elmt_var; kwargs...)::Dict{Int, Int}
  normalize_indices!(expr_tree, new_var; kwargs...)
end

function _normalize_indices!(expr_tree, dic_new_var::Dict{Int, Int}; kwargs...)
  ch = M_trait_expr_tree.get_expr_children(expr_tree)
  if isempty(ch) # expr is a leaf
    r_node = M_trait_expr_tree.get_real_node(expr_tree)
    M_trait_expr_node.change_from_N_to_Ni!(r_node, dic_new_var)
  else
    n = length(ch)
    for i = 1:n
      _normalize_indices!(ch[i], dic_new_var)
    end
  end
  return expr_tree
end

"""
    cast_type_of_constant(expr_tree, type::DataType)

Cast to `type` the constants of `expr_tree`.
"""
@inline cast_type_of_constant(expr_tree, t::DataType) =
  _cast_type_of_constant(expr_tree, M_trait_expr_tree.is_expr_tree(expr_tree), t)

@inline _cast_type_of_constant(expr_tree, ::M_trait_expr_tree.Is_not_expr_tree, t::DataType) =
  error("this is not an expr tree")

@inline _cast_type_of_constant(expr_tree, ::M_trait_expr_tree.Is_expr_tree, t::DataType) =
  _cast_type_of_constant(expr_tree, t)

# Cast the type t by walking into the expr_tree
@inline _cast_type_of_constant(expr_tree, t::DataType) =
  M_hl_trait_expr_tree._cast_type_of_constant(expr_tree, t)

struct function_wrapper{T <: Number}
  my_fun::Function
  x::Vector{T}
end

@inline get_fun(fw::function_wrapper{T}) where {T <: Number} = fw.my_fun

@inline get_x(fw::function_wrapper{T}) where {T <: Number} = fw.x

@inline set_x!(fw::function_wrapper{T}, v::AbstractVector{T}) where {T <: Number} = fw.x .= v

@inline eval_function_wrapper(fw::function_wrapper{T}) where {T <: Number} =
  (T)(Base.invokelatest(get_fun(fw), get_x(fw)...))

@inline eval_function_wrapper(fw::function_wrapper{T}, v::AbstractVector{T}) where {T <: Number} =
  begin
    set_x!(fw, v)
    return eval_function_wrapper(fw)
  end

@inline eval_function_wrapper(
  fw::function_wrapper{T},
  v::AbstractVector{N},
) where {N <: Number} where {T <: Number} = begin
  set_x!(fw, Vector{T}(v))
  return (N)(eval_function_wrapper(fw))
end

@inline fun_eval(symbol_x::Vector{Symbol}, expr::Expr) = (@eval f($(symbol_x...)) = $expr)::Function
@inline fun_eval(symbol_x::Vector{Symbol}, expr::Float64) =
  (@eval f($(symbol_x...)) = $expr)::Function

@inline get_function_of_evaluation(expr_tree) =
  _get_function_of_evaluation(expr_tree, M_trait_expr_tree.is_expr_tree(expr_tree))

@inline _get_function_of_evaluation(expr_tree, ::M_trait_expr_tree.Is_not_expr_tree) =
  error("this is not an expr tree")

@inline _get_function_of_evaluation(expr_tree, ::M_trait_expr_tree.Is_expr_tree) =
  _get_function_of_evaluation(expr_tree)

function _get_function_of_evaluation(
  ex::M_implementation_expr_tree.Type_expr_tree,
  t::DataType = Float64;
  n::Int = -1,
)
  ex_Expr = M_trait_expr_tree.transform_to_Expr2(ex)
  if n == -1
    vars_ex_Expr = M_algo_expr_tree.get_elemental_variables(ex)
    sort!(vars_ex_Expr)
    nᵢ = length(vars_ex_Expr)
    x = Vector{t}(undef, nᵢ)
  else
    vars_ex_Expr = [1:n;]
    nᵢ = length(vars_ex_Expr)
    x = Vector{t}(undef, nᵢ)
  end
  vars_x_ex_Expr = map(i::Int -> Symbol("x" * string(i)), vars_ex_Expr)
  @eval f($(vars_x_ex_Expr...)) = $ex_Expr
  fw = function_wrapper{t}(f, x)
  return fw
end

"""
    evaluator = non_linear_JuMP_model_evaluator(expr_tree; variables::Vector{Int})

Return a `MathOptInterface.Nonlinear.Model` and its initialized evaluator for any `expr_tree` supported.
`variables` informs the indices of the variables appearing in `expr_tree`.
If `variables` is not provided, it is determined automatically through `sort!(get_elemental_variables(expr_tree))`.
Warning: `variables` must be sorted!
Example:
```julia
expr_tree = :(x[1]^2 + x[3]^3)
variables = [1,3]
evaluator = non_linear_JuMP_model_evaluator(expr_tree; variables)
```
Afterward, you may evaluate the function and the gradient from `expr_tree` with:
```julia
x = rand(2)
MOI.eval_objective(evaluator, x)
grad = similar(x)
MOI.eval_objective_gradient(evaluator, grad, x)
```
Warning: The size of `x` depends on the number of variables of `expr_tree` and not from the highest variable's index.
"""
function non_linear_JuMP_model_evaluator(expr_tree; variables=sort!(M_algo_expr_tree.get_elemental_variables(expr_tree)))
  model = MathOptInterface.Nonlinear.Model()
  _variables = (index -> MathOptInterface.VariableIndex(index)).(variables)
  ex_jump = M_trait_expr_tree.transform_to_Expr_JuMP(expr_tree)
  ex = MathOptInterface.Nonlinear.add_expression(model, ex_jump)

  MathOptInterface.Nonlinear.set_objective(model, ex)
  evaluator = MathOptInterface.Nonlinear.Evaluator(model, MathOptInterface.Nonlinear.SparseReverseMode(), _variables)
  MathOptInterface.initialize(evaluator, [:Grad, :HessVec])
  
  return evaluator
end

end