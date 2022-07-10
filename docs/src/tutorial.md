# ExpressionTreeForge.jl Tutorial

ExpressionTreeForge.jl analyzes and manipulates expression trees.
It interfaces several implementations of expression trees to the internal expression tree `Type_expr_tree` (with `transform_to_expr_tree()`).

The main expression trees supported are:
- julia `Expr`
```@example ExpressionTreeForge
using ExpressionTreeForge
expr_julia = :((x[1]+x[2])^2 + (x[2]+x[3])^2)
expr_tree_Expr = transform_to_expr_tree(expr_julia)
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
- expression tree from a julia function created by [ModelingToolKit.jl](https://github.com/SciML/ModelingToolkit.jl/) (v3.21.0)
```@example ExpressionTreeForge
using ModelingToolkit
function f(y)    
  return sum((y[i] + y[i+1])^2 for i = 1:(length(y)-1))
end
n = 3
ModelingToolkit.@variables x[1:n] # must be x

mtk_tree = f(x)
expr_tree_MTK = transform_to_expr_tree(mtk_tree)
```

It produces the sames `expr_tree::Type_expr_tree`
```@example ExpressionTreeForge
expr_tree_MTK == expr_tree_JuMP
```

```@example ExpressionTreeForge
expr_tree_MTK == expr_tree_Expr
```

With an expression tree `Type_expr_tree`, you can:
- detect partial separability;
- evaluate the expression, and its first and second derivatives;
- propagate bounds;
- detect convexity.


### Detection of the partially separable structure
The original purpose of `ExpressionTreeForge.jl` is to detect the partially-separable structure of a function $f : \R^n \to \R$
```math
f(x) = \sum_{=1}^N \hat{f}_i (U_i x), \quad \hat f_i:\R^{n_i} \to \R, \quad U_i \in \R^{n_i \times n}, \quad n_i \ll n,
```
which means `ExpressionTreeForge.jl` detects that $f$ is a sum, and return:
- the element functions $\hat{f}_i$;
- the variables appearing in $\hat{f}_i$ (i.e. *elemental variables*) which are represented via $U_i$.

You detect the element functions with `delete_imbricated_plus()`, which returns a vector of `Type_expr_tree`s:
```@example ExpressionTreeForge
expr_tree = copy(expr_tree_Expr)
element_functions = delete_imbricated_plus(expr_tree)
```
**Warning**: the `element_functions` are pointers to nodes of `expr_tree`. Any modification on `element_functions` will be applied on `expr_tree`!

You extract the elemental variables by applying `get_elemental_variable()` on every element function expression tree
```@example ExpressionTreeForge
Us = get_elemental_variable.(element_functions)
```

Then you can replace the index variables of an element-function expression tree such they stay in the range `1:length(elemental_Ui[i])`:
```@example ExpressionTreeForge
# change the indices of the second element function
element_fun_from_N_to_Ni!(element_functions[2], Us[2])
```

### Evaluate a `Type_expr_tree` and its derivatives
ExpressionTreeForge.jl offers methods to evaluate an expression tree and its derivatives.
`evaluate_expr_tree()` evaluates any `Type_expr_tree` at a point `y` of suitable size:
```@example ExpressionTreeForge
y = ones(n)
fx = evaluate_expr_tree(expr_tree_Expr, y)
```
The gradient computation of an expression tree can either use `ForwardDiff` or `ReverseDiff`
```@example ExpressionTreeForge
gradient_forward = gradient_expr_tree_forward(expr_tree_Expr, y)
gradient_reverse = gradient_expr_tree_reverse(expr_tree_Expr, y)
```
```@example ExpressionTreeForge
gradient_forward == gradient_reverse
```
and the Hessian is computed with
```@example ExpressionTreeForge
hessian = hessian_expr_tree(expr_tree_Expr, y)
```

These methods can be applied to the element-function expression trees:
```
y1 = ones(length(Us[1]))
f1 = element_functions[1]
f1x = evaluate_expr_tree(f1, y1)

∇f1_forward = gradient_forward(f1, y1)
∇f1_reverse = gradient_reverse(f1, y1)

hessian1 = hessian_forward(f1, y1)
```
See [PartitionedStructures.jl](https://github.com/JuliaSmoothOptimizers/PartitionedStructures.jl) for more details about partial separability and how the partitioned derivatives of the element functions are stored.

### Bounds and convexity
To compute bounds and convexity we use a `Complete_expr_tree`, a richer structure than `Type_expr_tree`.
A `Complete_expr_tree` is similar to `Type_expr_tree`, but in addition it stores: the lower bound, the upper bound and the convexity status of each node.
You can define a `Complete_expr_tree` for any `Type_expr_tree`:
```@example ExpressionTreeForge
complete_tree = create_complete_tree(expr_tree_Expr)
```
and compute the bounds and the convexity status afterward
```@example ExpressionTreeForge
# propagate the bounds from the variables
set_bounds!(complete_tree)
# deduce the convexity status of each node
set_convexity!(complete_tree)
# get the root bounds
bounds = get_bound(complete_tree)
```

```@example ExpressionTreeForge
# get the root convexity status
convexity_status = get_convexity_status(complete_tree)
is_convex(convexity_status)
```

## Tools 
If you need to visualize a tree, use `print_tree()` to get a better output on the julia console
```julia
print_tree(expr_tree_Expr)
```