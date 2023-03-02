"""
    Type_node{T} <: AbstractTree

Basic implementation of a tree.
A Type_node has fields:

* `field` gathering the informations about the current node;
* `children` a vector of children, each of them being a `Type_node`.
"""
Type_node = M_implementation_tree.Type_node

"""
    Type_expr_tree{T} <: AbstractTree

Basic implementation of an expression tree.
Every expression tree supported must be able to return `Type_expr_tree`.
A `Type_expr_tree` has fields:

* `field::Abstract_expr_node` representing an operator, a constant or a variable;
* `children::Vector{Type_expr_tree{T}}` a vector of children, each of them being a `Type_expr_tree{T}`.
"""
Type_expr_tree = M_implementation_expr_tree.Type_expr_tree

"""
    Complete_expr_tree{T} <: AbstractTree

Implementation of an expression tree.
`Complete_expr_tree` is the same than `Type_expr_tree` with the additions in each node of a `Bounds` and `Convexity_wrapper`.
A `Complete_expr_tree` has fields:

* `field::Complete_node{T}` representing an operator, a constant or a variable alongide its bounds and its convexity status;
* `children::Vector{Complete_expr_tree{T}}` a vector of children, each of them being a `Complete_expr_tree{T}`.
"""
Complete_expr_tree{T <: Number} = M_implementation_complete_expr_tree.Complete_expr_tree{T}

"""
    Type_calculus_tree

Represent the different types that a expression can be :

* `constant`
* `linear`
* `quadratic`
* `cubic`
* `more` which means non-linear, non-quadratic and non-cubic. 
"""
Type_calculus_tree = M_implementation_type_expr.Type_expr_basic

"""
    bound_tree = create_bounds_tree(tree)

Return a `similar` expression tree to `tree`, where each node has an undefined bounds.
"""
@inline create_bounds_tree(t) = M_bound_propagations.create_bounds_tree(t)

"""
    set_bounds!(tree::Type_expr_tree, bound_tree::Bound_tree)
    set_bounds!(complete_tree::Complete_expr_tree)

Set the bounds of `bound_tree` by walking `tree` and propagate the computation from the leaves to the root.
A `Complete_expr_tree` contains a precompiled `bound_tree`, and then can be use alone.
"""
@inline set_bounds!(tree, bound_tree) = M_bound_propagations.set_bounds!(tree, bound_tree)

@inline set_bounds!(complete_tree) = M_bound_propagations.set_bounds!(complete_tree)

"""
    (inf_bound, sup_bound) = get_bounds(bound_tree::Bound_tree)

Retrieve the bounds of the root of `bound_tree`, the bounds of expression tree.
"""
@inline get_bounds(bound_tree) = M_bound_propagations.get_bounds(bound_tree)

"""
    convex_tree = create_convex_tree(tree::Type_expr_tree)

Return a `similar` expression tree to `tree`, where each node has an undefined convexity status.
"""
@inline create_convex_tree(tree) = M_convexity_detection.create_convex_tree(tree)

"""
    set_convexity!(tree::Type_expr_tree, convexity_tree::Convexity_tree, bound_tree::Bound_tree)
    set_convexity!(complete_tree::Complete_expr_tree)

Deduce from elementary rules the convexity status of `tree` nodes or `complete_tree` nodes.
`complete_tree` integrate a bounds tree and can run alone the convexity detection whereas `tree`
 require the `bound_tree` (see `create_bounds_tree`) and `convexity_tree` (see `create_convex_tree`).
"""
@inline set_convexity!(tree, convexity_tree, bound_tree) =
  M_convexity_detection.set_convexity!(tree, convexity_tree, bound_tree)

@inline set_convexity!(complete_tree) = M_convexity_detection.set_convexity!(complete_tree)

"""
    convexity_status = get_convexity_status(convexity_tree::M_convexity_detection.Convexity_tree)
    convexity_status = get_convexity_status(complete_tree::Complete_expr_tree)

Return the convexity status of either `convexity_tree` or `complete_tree`.
The status can be:
* `constant`
* `linear`
* `convex`
* `concave`
* `unknown`
"""
@inline get_convexity_status(convexity_tree::M_convexity_detection.Convexity_tree) =
  M_convexity_detection.get_convexity_status(convexity_tree)

@inline get_convexity_status(
  complete_tree::M_implementation_complete_expr_tree.Complete_expr_tree,
) = M_convexity_detection.get_convexity_status(complete_tree)

"""
    constant = constant_type() 

Return the value of `constant` from the enumerative type `M_implementation_convexity_type.Convexity_type`.
"""
@inline constant_type() = M_implementation_convexity_type.constant_type()

"""
    linear = linear_type() 

Return the value of `linear` from the enumerative type `M_implementation_convexity_type.Convexity_type`.
"""
@inline linear_type() = M_implementation_convexity_type.linear_type()

"""
    convex = convex_type() 

Return the value of `convex` from the enumerative type `M_implementation_convexity_type.Convexity_type`.
"""
@inline convex_type() = M_implementation_convexity_type.convex_type()

"""
    concave = concave_type() 

Return the value of `concave` from the enumerative type `M_implementation_convexity_type.Convexity_type`.
"""
@inline concave_type() = M_implementation_convexity_type.concave_type()

"""
    unknown = unknown_type() 

Return the value of `unknown` from the enumerative type `M_implementation_convexity_type.Convexity_type`.
"""
@inline unknown_type() = M_implementation_convexity_type.unknown_type()

"""
    bool = is_treated(status::Convexity_type)
    bool = is_treated(convexity::Convexity_wrapper)

Check if `convexity_status` is different of `not_treated`.
"""
@inline is_treated(convexity_status) = M_implementation_convexity_type.is_treated(convexity_status)

"""
    bool = is_not_treated(status::Convexity_type)
    bool = is_not_treated(convexity::Convexity_wrapper)

Check if `convexity_status` is `not_treated`.
"""
@inline is_not_treated(convexity_status) =
  M_implementation_convexity_type.is_not_treated(convexity_status)

"""
    bool = is_constant(status::Convexity_type)
    bool = is_constant(convexity::Convexity_wrapper)

Check if `convexity_status` is `constant`.
"""
@inline is_constant(convexity_status) =
  M_implementation_convexity_type.is_constant(convexity_status)

"""
    bool = is_linear(status::Convexity_type)
    bool = is_linear(convexity::Convexity_wrapper)

Check if `convexity_status` is `linear`.
"""
@inline is_linear(convexity_status) = M_implementation_convexity_type.is_linear(convexity_status)

"""
    bool = is_convex(status::Convexity_type)
    bool = is_convex(convexity::Convexity_wrapper)

Check if `convexity_status` is `convex`.
"""
@inline is_convex(convexity_status) = M_implementation_convexity_type.is_convex(convexity_status)

"""
    bool = is_concave(status::Convexity_type)
    bool = is_concave(convexity::Convexity_wrapper)

Check if `convexity_status` is `concave`.
"""
@inline is_concave(convexity_status) = M_implementation_convexity_type.is_concave(convexity_status)

"""
    bool = is_unknown(status::Convexity_type)
    bool = is_unknown(convexity::Convexity_wrapper)

Check if `convexity_status` is `unknown`.
"""
@inline is_unknown(convexity_status) = M_implementation_convexity_type.is_unknown(convexity_status)

"""
    complete_tree = complete_tree(expression_tree::Type_expr_tree)

Create a `complete_tree::Complete_expr_tree` from `expression_tree`.
"""
@inline complete_tree(tree) = M_implementation_complete_expr_tree.create_complete_expr_tree(tree)

"""
    bool = is_constant(type::Type_calculus_tree)

Check if `type` have the value `constant` from the enumerative type `Type_calculus_tree`.
"""
@inline is_constant(type::Type_calculus_tree) = type == Type_calculus_tree(0)

"""
    bool = is_linear(type::Type_calculus_tree)

Check if `type` have the value `linear` from the enumerative type `Type_calculus_tree`.
"""
@inline is_linear(type::Type_calculus_tree) = type == Type_calculus_tree(1)

"""
    bool = is_quadratic(type::Type_calculus_tree)

Check if `type` have the value `quadratic` from the enumerative type `Type_calculus_tree`.
"""
@inline is_quadratic(type::Type_calculus_tree) = type == Type_calculus_tree(2)

"""
    bool = is_cubic(type::Type_calculus_tree)

Check if `type` have the value `cubic` from the enumerative type `Type_calculus_tree`.
"""
@inline is_cubic(type::Type_calculus_tree) = type == Type_calculus_tree(3)

"""
    bool = is_more(type::Type_calculus_tree)

Check if `type` have the value `more` from the enumerative type `Type_calculus_tree`.
"""
@inline is_more(type::Type_calculus_tree) = type == Type_calculus_tree(4)

"""
    print_tree(tree::AbstractTree)

Print a tree as long as it satisfies the interface `M_interface_tree`.
"""
@inline print_tree(t) = algo_tree.printer_tree(t)

"""
    expr = transform_to_Expr(expr_tree)

Transform `expr_tree` into an `Expr`.
`expr_tree` may be a `Type_expr_tree` or a `Complete_expr_tree`.
Warning: This function return an `Expr` with variables as `MathOptInterface.VariableIndex`.
In order to get an standard `Expr` use `transform_to_Expr_julia`.
"""
@inline transform_to_Expr(e::Any) = M_trait_expr_tree.transform_to_Expr(e::Any)

"""
    expr = transform_to_Expr_julia(expr_tree)

Transform `expr_tree` into an `Expr`.
`expr_tree` may be a `Type_expr_tree` or a `Complete_expr_tree`.
"""
@inline transform_to_Expr_julia(e::Any) = M_trait_expr_tree.transform_to_Expr2(e::Any)

"""
    expr = transform_to_Expr_JuMP(expr_tree)

Transform `expr_tree` into an `Expr`.
`expr_tree` may be a `Type_expr_tree` or a `Complete_expr_tree`.
"""
@inline transform_to_Expr_JuMP(e::Any) = M_trait_expr_tree.transform_to_Expr_JuMP(e::Any)

"""
    expr_tree = transform_to_expr_tree(expr::Expr)

Transform `expr` into an `expr_tree::Type_expr_tree`.
"""
@inline transform_to_expr_tree(e::Any) = M_trait_expr_tree.transform_to_expr_tree(e)::Type_expr_tree

"""
    separated_terms = extract_element_functions(expr_tree)

Return the element functions of `expr_tree` as a vector of its subexpression.
`expr_tree` may be an `Expr`, a `Type_expr_tree` or a `Complete_expr_tree`.

Example:
```julia
julia> extract_element_functions(:(x[1] + x[2] + x[3]*x[4] ) )
3-element Vector{Expr}:
 :(x[1])
 :(x[2])
 :(x[3] * x[4])
```
"""
@inline extract_element_functions(a::Any) = M_algo_expr_tree.extract_element_functions(a)

"""
    type = get_type_tree(expr_tree)

Return the type of `expr_tree`.
It can either be: `constant`, `linear`, `quadratic`, `cubic` or `more`.
`expr_tree` may be an `Expr`, a `Type_expr_tree` or a `Complete_expr_tree`.

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
@inline get_type_tree(a::Any) = M_algo_expr_tree.get_type_tree(a)

"""
    indices = get_elemental_variables(expr_tree)

Return the `indices` of the variable appearing in `expr_tree`.
This function is used to find the elemental variables from the expression tree of an element function.
`expr_tree` may be an `Expr`, a `Type_expr_tree` or a `Complete_expr_tree`.

Example:
```julia
julia> get_elemental_variables(:(x[1] + x[3]) )
[1, 3]
julia> get_elemental_variables(:(x[1]^2 + x[6] + x[2]) )
[1, 6, 2]
```
"""
@inline get_elemental_variables(a::Any) = M_algo_expr_tree.get_elemental_variables(a)

"""
    Ui = get_Ui(indices::Vector{Int}, n::Int)

Create a sparse matrix `Ui` from `indices` computed by `get_elemental_variables`.
Every index `i` (of `indices`) form a line of `Ui` corresponding to `i`-th Euclidian vector.
"""
@inline get_Ui(indices::Vector{Int}, n::Int) = M_algo_expr_tree.get_Ui(indices, n)

"""
    normalize_indices!(expr_tree, vector_indices::Vector{Int})

Change the indices of the variables of `expr_tree` given the order given by `vector_indices`.
It it paired with `get_elemental_variables` to define the elemental element functions expression tree.
`expr_tree` may be an `Expr`, a `Type_expr_tree` or a `Complete_expr_tree`.

Example:
```julia
julia> normalize_indices!(:(x[4] + x[5]), [4,5])
:(x[1] + x[2])
```
"""
@inline normalize_indices!(a::Any, v::AbstractVector{Int}) = M_algo_expr_tree.normalize_indices!(a, v)

"""
    cast_type_of_constant(expr_tree, type::DataType)

Cast to `type` the constants of `expr_tree`.
`expr_tree` may be an `Expr`, a `Type_expr_tree` or a `Complete_expr_tree`.
"""
@inline cast_type_of_constant(ex::Any, t::DataType) = M_algo_expr_tree.cast_type_of_constant(ex, t)

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
@inline non_linear_JuMP_model_evaluator(ex::Any) = M_algo_expr_tree.non_linear_JuMP_model_evaluator(ex)

"""
    evaluate_expr_tree(expr_tree::Type_expr_tree, x::AbstractVector)
    evaluate_expr_tree(expr_tree::Complete_expr_tree, x::AbstractVector)

Evaluate the `expr_tree` given the vector `x`.

Example:
```julia
julia> evaluate_expr_tree(:(x[1] + x[2]), ones(2))
2.
```
"""
@inline evaluate_expr_tree(expr_tree::Any, x::AbstractVector{T}) where {T <: Number} =
  M_evaluation_expr_tree.evaluate_expr_tree(expr_tree, x)

@inline evaluate_expr_tree(e::Any, x::AbstractVector) =
  M_evaluation_expr_tree.evaluate_expr_tree(e, x)

@inline evaluate_expr_tree(e::Any) = (x::AbstractVector{} -> evaluate_expr_tree(e, x))

"""
    evaluate_expr_tree_multiple_points(expression_tree::Any, x::AbstractVector{AbstractVector}})
    evaluate_expr_tree_multiple_points(expression_tree::Any)

Evaluate the `expression_tree` with several points, represented as `x`.
"""
@inline evaluate_expr_tree_multiple_points(expression_tree::Any, x::AbstractVector) =
  M_evaluation_expr_tree.evaluate_expr_tree_multiple_points(expression_tree, x)

"""
    gradient = gradient_forward(expr_tree, x)

Evaluate the `gradient` of `expr_tree` at the point `x` with a forward automatic differentiation method.

Example:
```julia
julia> gradient_forward(:(x[1] + x[2]), rand(2))
[1.0 1.0]
```
"""
@inline gradient_forward(e::Any, x::AbstractVector) = M_evaluation_expr_tree.gradient_forward(e, x)

"""
    gradient = gradient_reverse(expr_tree, x)

Evaluate the `gradient` of `expr_tree` at the point `x` with a reverse automatic differentiation method.

Example:
```julia
julia> gradient_reverse(:(x[1] + x[2]), rand(2))
[1.0 1.0]
```
"""
@inline gradient_reverse(e::Any, x::AbstractVector) = M_evaluation_expr_tree.gradient_reverse(e, x)

"""
    hess = hessian(expr_tree, x)

Evaluate the Hessian of `expr_tree` at the point `x` with forward automatic differentiation.

Example:
```julia
julia> hessian(:(x[1]^2 + x[2]), rand(2))
[2.0 0.0; 0.0 0.0]
```
"""
@inline hessian(e::Any, x::AbstractVector) = M_evaluation_expr_tree.hessian(e, x)

"""
    eval_expression_tree = get_function_of_evaluation(expression_tree::Type_expr_tree)

Return and evaluation function of `expression_tree` with better performance than the actual `evaluate_expr_tree`.
"""
@inline get_function_of_evaluation(expression_tree::Type_expr_tree) =
  M_algo_expr_tree.get_function_of_evaluation(expression_tree)

"""
    summed_tree = sum_expr_trees(trees::Vector{::AbstractExprTree})

Sum every `trees`.
"""
@inline sum_expr_trees(trees::Vector) = M_trait_expr_tree.sum_expr_trees(trees)
