# ExpressionTreeForge.jl Tutorial

ExpressionTreeForge.jl is a manipulator of expression tree.
It supports several expression trees and define methods to analyze and manipulate them.

It interfaces to the internal expression tree structure `Type_expr_tree` several implementations of expression tree with `transform_to_expr_tree`:
- julia `Expr`
```@example ExpressionTreeForge
using ExpressionTreeForge
expr_julia = :(x[1]^2 + x[2]^2) # ::Expr
expr_tree_Expr = transform_to_expr_tree(expr_julia)
```
- `Expr` from `JuMP` model (with `MathOptInterface`)
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

Which produce the sames `expr_tree::Type_expr_tree`
```@example ExpressionTreeForge
expr_tree_MTK == expr_tree_JuMP
```

```@example ExpressionTreeForge
expr_tree_MTK == expr_tree_Expr
```

From any expression tree `Type_expr_tree`, you can achieve:
- partial separability detection;
- bounds propagations;
- strict convexity detection.

### Detection of the partially separable structure
Originally, it is made to detect automatically the partially separable structure of a function $f : \R^n \to \R$
$$
f(x) = \sum_{=1}^N \hat{f}_i (U_i x), \quad \hat f_i:\R^{n_i} \to \R, \quad U_i \in \R^{n_i \times n}, \; n_i \ll n.
$$
`ExpressionTreeForge.jl` detects that $f$ is a sum, and return:
- the element functions $\hat{f}_i$
- the variables appearing in $\hat{f}_i$ (i.e. *elemental variables*) which concretely $U_i$

You detect the element functions (i.e. the terms of the sum) with `delete_imbricated_plus()`, which return a vector of `Type_expr_tree`
```@example ExpressionTreeForge
element_functions = delete_imbricated_plus(expr_tree_Expr)
```
and you extract the elemental variables by applying `get_elemental_variable()` on every element function expression tree
```@example ExpressionTreeForge
element_Ui = get_elemental_variable.(element_functions)
```

### Bounds and convexity
To detect the bounds and the convexity you have to define a `Complete_tree` a richer structure than `Type_expr_tree`.
A `Complete_tree` is similar `expr_tree_Expr` but in addition it stores for each node its bounds and its convexity status.
You must define it from `expr_tree_Expr`
```julia
complete_tree = ExpressionTreeForge.create_complete_tree(expr_tree_Expr)
```
and compute the bounds and the convexity status afterward
```julia
set_bounds!(complete_tree)
set_convexity!(complete_tree)

# get the root bounds
bounds = get_bound(complete_tree)
# get the root convexity status
convexity_status = get_convexity_status(complete_tree)
```



# Tools 
If you need to visualize a tree, use `print_tree()`
```@example ExpressionTreeForge
print_tree(expr_tree_MTK)
```