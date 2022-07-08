# ExpressionTreeForge.jl Tutorial

ExpressionTreeForge.jl is a manipulator of expression tree.
It supports several expression trees and define methods to analyze and manipulate them.
It interfaces to `Type_expr_tree` by using `transform_to_expr_tree()` several expression trees:
- julia `Expr`
```@example ExpressionTreeForge
using ExpressionTreeForge
expr_julia = :(x[1]^2 + x[2]^2)
expr_tree_Expr = transform_to_expr_tree(expr_julia)
```
- `Expr` from [JuMP](https://github.com/jump-dev/JuMP.jl) model (with `MathOptInterface`)
```@example ExpressionTreeForge
using JuMP, MathOptInterface
m = Model()
n = 2
@variable(m, x[1:n])
@NLobjective(m, Min, x[1]^2 + x[2]^2)
evaluator = JuMP.NLPEvaluator(m)
MathOptInterface.initialize(evaluator, [:ExprGraph])
expr_jump = MathOptInterface.objective_expr(evaluator)
expr_tree_JuMP = transform_to_expr_tree(expr_jump)
```
- expression tree from a julia function created by [ModelingToolKit.jl](https://github.com/SciML/ModelingToolkit.jl/) (v3.21.0)
```@example ExpressionTreeForge
using ModelingToolkit
function f(y)    
  return sum(y[i]^2 for i = 1:length(y))
end
n = 2
ModelingToolkit.@variables x[1:n] # must be x

fun_tree = f(x)
expr_tree_MTK = transform_to_expr_tree(fun_tree)
```

It produces the sames `expr_tree::Type_expr_tree`
```@example ExpressionTreeForge
expr_tree_MTK == expr_tree_JuMP
```

```@example ExpressionTreeForge
expr_tree_MTK == expr_tree_Expr
```

From any expression tree `Type_expr_tree`, you can achieve:
- partial separability detection;
- evaluation of $f(x), \nabla f(x), \nabla^2 f(x)$.
- bounds propagations;
- strict convexity detection;


### Detection of the partially separable structure
It is the original purpose of `ExpressionTreeForge.jl` to detect the partially separable structure of a function $f : \R^n \to \R$
```math
f(x) = \sum_{=1}^N \hat{f}_i (U_i x), \quad \hat f_i:\R^{n_i} \to \R, \quad U_i \in \R^{n_i \times n}, \quad n_i \ll n.
```
which means `ExpressionTreeForge.jl` detects that $f$ is a sum, and return:
- the element functions $\hat{f}_i$
- the variables appearing in $\hat{f}_i$ (i.e. *elemental variables*) which are concretely $U_i$

You detect the element functions (i.e. the terms of the sum) with `delete_imbricated_plus()`, which return a vector of terms `Type_expr_tree`
```@example ExpressionTreeForge
element_functions = delete_imbricated_plus(expr_tree_Expr)
```
You extract the elemental variables by applying `get_elemental_variable()` on every element function expression tree
```@example ExpressionTreeForge
elemental_Ui = get_elemental_variable.(element_functions)
```

Then you can change the indices of an element-function expression tree with:
```@example ExpressionTreeForge
element_fun_from_N_to_Ni!(element_functions[2], elemental_Ui[2])
```
which rewrite the expression with variables of index in the range `1:length(Ui)`.

### Evaluate $f, \nabla f, \nabla^2 f$
The evaluation of any `Type_expr_tree` at a given point is done with `evaluate_expr_tree()`
```@example ExpressionTreeForge
y = rand(n)
fx = evaluate_expr_tree(expr_tree_Expr, y)
```
The gradient computation, using `ForwardDiff` and `ReverseDiff`, is respectively
```@example ExpressionTreeForge
gradient_forward = gradient_expr_tree_forward(expr_tree_Expr, y)
gradient_reverse = gradient_expr_tree_reverse(expr_tree_Expr, y)
```
and the Hessian is
```@example ExpressionTreeForge
hessian = hessian_expr_tree(expr_tree_Expr, y)
```
All these methods can be applied on the expression tree of the element functions.
See [PartitionedStructures.jl](https://github.com/JuliaSmoothOptimizers/PartitionedStructures.jl) to see more details about partial separability and how to store the derivatives of the element functions.

### Bounds and convexity
To detect the bounds and the convexity you have to define a `Complete_expr_tree`, a richer structure than `Type_expr_tree`.
A `Complete_expr_tree` is similar to `expr_tree_Expr`, but in addition it stores for each node its bounds and its convexity status.
You define it any `expr_tree::Type_expr_tree`
```@example ExpressionTreeForge
complete_tree = screate_complete_tree(expr_tree_Expr)
```
and compute the bounds and the convexity status afterward
```@example ExpressionTreeForge
set_bounds!(complete_tree)
set_convexity!(complete_tree)

# get the root bounds
bounds = get_bound(complete_tree)
# get the root convexity status
convexity_status = get_convexity_status(complete_tree)
```

## Tools 
If you need to visualize a tree, use `print_tree()` to get a better output on the terminal
```@example ExpressionTreeForge
print_tree(expr_tree_Expr)
```