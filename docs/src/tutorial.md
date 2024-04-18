# ExpressionTreeForge.jl Tutorial

ExpressionTreeForge.jl analyzes and manipulates expression trees.
It interfaces several implementations of expression trees to the internal type `Type_expr_tree` (with `transform_to_expr_tree()`).

The main expression trees supported are:
- Julia `Expr`
```@example ExpressionTreeForge
using ExpressionTreeForge
expr_Julia = :((x[1]+x[2])^2 + (x[2]+x[3])^2)
expr_tree_Expr = transform_to_expr_tree(expr_Julia)
```

- `Expr` from [JuMP](https://github.com/jump-dev/JuMP.jl) model (with `MathOptInterface`)
```@example ExpressionTreeForge
using JuMP, MathOptInterface
m = Model()
n = 3
@variable(m, x[1:n])
@NLobjective(m, Min, (x[1]+x[2])^2 + (x[2]+x[3])^2)
evaluator = JuMP.NLPEvaluator(m)
MathOptInterface.initialize(evaluator, [:ExprGraph])
expr_jump = MathOptInterface.objective_expr(evaluator)
expr_tree_JuMP = transform_to_expr_tree(expr_jump)
```

- an `Expr` which is the result of `@variables` from [Symbolics.jl](https://github.com/JuliaSymbolics/Symbolics.jl) to a Julia function:
```@example ExpressionTreeForge
using Symbolics
function f(y)    
  return sum((y[i] + y[i+1])^2 for i = 1:(length(y)-1))
end
n = 3
Symbolics.@variables x[1:n] # must be x

fun = f(x)
mtk_tree = Symbolics._toexpr(fun)
expr_tree_Symbolics = transform_to_expr_tree(mtk_tree)
```
Note that depending on the library used, the expression tree may be simplified and/or have reordered terms.
However, `expr_tree_Expr`, `expr_tree_JuMP` and `expr_tree_Symbolics` share the same type `::Type_expr_tree`:
```@example ExpressionTreeForge
(typeof(expr_tree_Expr) == typeof(expr_tree_JuMP)) && (typeof(expr_tree_Expr) == typeof(expr_tree_Symbolics))
```

With a `Type_expr_tree`, you can:
- detect partial separability;
- evaluate the expression, and its first and second derivatives;
- propagate bounds;
- detect convexity.

### Detection of the partially separable structure
The original purpose of `ExpressionTreeForge.jl` is to detect the partially-separable structure of a function $f : \R^n \to \R$
```math
f(x) = \sum_{=1}^N \hat{f}_i (U_i x), \quad \hat f_i:\R^{n_i} \to \R, \quad U_i \in \R^{n_i \times n}, \quad n_i \ll n,
```
which means `ExpressionTreeForge.jl` detects that $f$ is a sum, and returns:
- the element functions $\hat{f}_i$;
- the variables appearing in $\hat{f}_i$ (i.e. *elemental variables*), which are selected with $U_i$.

The method `extract_element_functions()` detects the element functions and returns a vector of `Type_expr_tree`s:
```@example ExpressionTreeForge
expr_tree = copy(expr_tree_Expr)
element_functions = extract_element_functions(expr_tree)
show(element_functions[2])
```
**Warning**: the `element_functions` are pointers to nodes of `expr_tree`. 
Any modification to `element_functions` will be applied to `expr_tree` !!

The elemental variables are retrieved by applying `get_elemental_variables()` to every element function expression tree
```@example ExpressionTreeForge
Us = get_elemental_variables.(element_functions)
```

Then you can replace the index variables of an element function expression tree so they stay in the range `1:length(Us[i])`, i.e. $1$ to $n_i$:
```@example ExpressionTreeForge
# change the indices of the second element function
normalize_indices!(element_functions[2], Us[2])
```

### Evaluate a `Type_expr_tree` and its derivatives
ExpressionTreeForge.jl offers methods to evaluate an expression tree and its derivatives.
`evaluate_expr_tree()` evaluates a `Type_expr_tree` at a point `y` of suitable size:
```@example ExpressionTreeForge
y = ones(n)
fx = expr_tree_Expr(y)
```
The gradient computation of an expression tree can either use `ForwardDiff` or `ReverseDiff`
```@example ExpressionTreeForge
∇f_forward = gradient_forward(expr_tree_Expr, y)
∇f_reverse = gradient_reverse(expr_tree_Expr, y)
```
```@example ExpressionTreeForge
∇f_forward == ∇f_reverse
```
and the Hessian is computed with
```@example ExpressionTreeForge
hess = hessian(expr_tree_Expr, y)
```

Automatic differentiation methods can be applied directly to the element-function expression trees:
```
y1 = ones(length(Us[1]))
f1 = element_functions[1]
f1x = evaluate_expr_tree(f1, y1)

∇f1_forward = gradient_forward(f1, y1)
∇f1_reverse = gradient_reverse(f1, y1)

hess1 = hessian(f1, y1)
```
See [PartitionedStructures.jl](https://github.com/JuliaSmoothOptimizers/PartitionedStructures.jl) for more details about partial separability and how the partitioned derivatives of the element functions are stored.

### Bounds and convexity
To compute bounds and convexity we use a `Complete_expr_tree`, a richer structure than `Type_expr_tree`.
`Complete_expr_tree` is similar to `Type_expr_tree`, but in addition it stores: the lower bound, the upper bound and the convexity status of each node.
You can define a `Complete_expr_tree` for any `Type_expr_tree`:
```@example ExpressionTreeForge
complete_tree = complete_tree(expr_tree_Expr)
```
The bounds and convexity status are then propagated using the methods:
```@example ExpressionTreeForge
# propagate the bounds from the variables
set_bounds!(complete_tree)
# deduce the convexity status of each node
set_convexity!(complete_tree)
```
```@example ExpressionTreeForge
# get the root bounds
bounds = get_bounds(complete_tree)
```

```@example ExpressionTreeForge
# get the root convexity status
convexity_status = get_convexity_status(complete_tree)
is_convex(convexity_status)
```

You can observe the bounds and convexity status of each node of `complete_tree` by walking the graph
```@example ExpressionTreeForge
# convexity statuses of the root's children
statuses = get_convexity_status.(complete_tree.children) 
```

```@example ExpressionTreeForge
# bounds of the root's children
bounds = get_bounds.(complete_tree.children)
```