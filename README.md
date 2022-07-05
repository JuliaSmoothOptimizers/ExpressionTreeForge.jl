# ExpressionTreeForge: A manipulator of expression graph

| **Documentation** | **Linux/macOS/Windows/FreeBSD** | **Coverage** | **DOI** |
|:-----------------:|:-------------------------------:|:------------:|:-------:|
| [![docs-stable][docs-stable-img]][docs-stable-url] [![docs-dev][docs-dev-img]][docs-dev-url] | [![build-gh][build-gh-img]][build-gh-url] [![build-cirrus][build-cirrus-img]][build-cirrus-url] | [![codecov][codecov-img]][codecov-url] | [![doi][doi-img]][doi-url] |

[docs-stable-img]: https://img.shields.io/badge/docs-stable-blue.svg
[docs-stable-url]: https://paraynaud.github.io/ExpressionTreeForge.jl/stable
[docs-dev-img]: https://img.shields.io/badge/docs-dev-purple.svg
[docs-dev-url]: https://paraynaud.github.io/ExpressionTreeForge.jl/dev
[build-gh-img]: https://github.com/paraynaud/ExpressionTreeForge.jl/workflows/CI/badge.svg?branch=master
[build-gh-url]: https://github.com/paraynaud/ExpressionTreeForge.jl/actions
[build-cirrus-img]: https://img.shields.io/cirrus/github/paraynaud/ExpressionTreeForge.jl?logo=Cirrus%20CI
[build-cirrus-url]: https://cirrus-ci.com/github/paraynaud/ExpressionTreeForge.jl
[codecov-img]: https://codecov.io/gh/paraynaud/ExpressionTreeForge.jl/branch/master/graph/badge.svg
[codecov-url]: https://app.codecov.io/gh/paraynaud/ExpressionTreeForge.jl
[doi-img]: https://img.shields.io/badge/DOI-10.5281%2Fzenodo.822073-blue.svg
[doi-url]: https://doi.org/10.5281/zenodo.822073

ExpressionTreeForge.jl is made to detect automatically the partially separable structure of a function
$$
f(x) = \sum_{=1}^N \hat{f}_i (U_i x), \quad f \in \R^n \to \R, \quad \hat f_i:\R^{n_i} \to \R, \quad U_i \in \R^{n_i \times n}.
$$
$f$ is a sum of element functions $\hat{f}_i$, and usually $n_i \ll n$. $U_i$ is a linear operator, it selects the variables used by $\hat{f}_i$.

The derivatives of partially separable function are partitioned, the gradient
$$
\nabla f(x) = \sum_{i=1}^N U_i^\top \nabla \hat{f}_i (U_i x),
$$
and the hessian
$$
\nabla^2 f(x) = \sum_{i=1}^N U_i^\top \nabla^2 \hat{f_i} (U_i x) U_i,
$$
are the sum of the element derivatives $\nabla \hat{f}_i,  \nabla^2\hat{f}_i$.
This structure allows to define a partitioned quasi-Newton approximation of $\nabla^2 f$
$$
B = \sum_{i=1}^N U_i^\top \hat{B}_{i} U_i
$$
such that each $\hat{B}_i \approx \nabla^2 \hat{f}_i$.
By using this structure [PartiallySeparableSolvers.jl](https://github.com/paraynaud/PartiallySeparableSolvers.jl) define a trust region method dedicated to the partially separable functions.

#### Reference
* A. Griewank and P. Toint, [*Partitioned variable metric updates for large structured optimization problems*](10.1007/BF01399316), Numerische Mathematik volume, 39, pp. 119--137, 1982.

## Content
ExpressionTreeForge.jl analyse the expression tree of $f$	to define automatically : every $\hat{f}_i$ and every $U_i$.
Moreover, it performs a bound propagation over any expression tree supported, and it can detect if $f$ is strongly convex.
In practice, it applies these analyses after the detection of the $\hat{f}_i$.

ExpressionTreeForge develop its own representation of an expression graph, it supports also two other types of expression trees: the ones from the type julia `Expr`
```julia
expr_julia = :(x[1] + x[2]) # ::Expr
expr = ExpressionTreeForge.transform_to_expr_tree(expr_julia)
```
 and those extract from a `JuMP` model
```julia
using JuMP, MathOptInterface
using ExpressionTreeForge

m = Model()
n = 10
@variable(m, x[1:n])
@NLobjective(m, Min, sum(x[j] * x[j+1] for j in 1:n-1 ) + (sin(x[1]))^2 + x[n-1]^3  + 5 )
evaluator = JuMP.NLPEvaluator(m)
MathOptInterface.initialize(evaluator, [:ExprGraph])
expr_jump = MathOptInterface.objective_expr(evaluator)
expr = ExpressionTreeForge.transform_to_expr_tree(expr_jump)
```

You detect the element functions with `delete_imbricated_plus`
```julia
element_functions = delete_imbricated_plus(expr)
```
and you extract the $U_i$ with `get_elemental_variable`
```julia
element_Ui = get_elemental_variable.(element_functions)
```

To detect the bounds and the convexity you have to define a `complete_tree`
```julia
complete_tree = ExpressionTreeForge.create_complete_tree(expr)
```
and retrieve the bounds and the convexity status afterward
```julia
set_bounds!(complete_tree)
bounds = get_bound(complete_tree)
set_convexity!(complete_tree)
convexity_status = get_convexity_status(complete_tree)
```


## Dependencies
This module is use in addition of [PartitionedStructures.jl](https://github.com/paraynaud/PartitionedStructures.jl)
to define a trust-region method exploiting the partial separabiliy through partitioned quasi-Newton approximation by:
 [PartiallySeparableNLPModels.jl](https://github.com/paraynaud/PartiallySeparableNLPModels.jl) and [PartiallySeparableSolvers.jl](https://github.com/paraynaud/PartiallySeparableSolvers.jl).


## How to install
```
julia> ]
pkg> add https://github.com/paraynaud/ExpressionTreeForge.jl
pkg> test ExpressionTreeForge
```
