# ExpressionTreeForge: A manipulator of expression tree

| **Documentation** | **Linux/macOS/Windows/FreeBSD** | **Coverage** | **DOI** |
|:-----------------:|:-------------------------------:|:------------:|:-------:|
| [![docs-stable][docs-stable-img]][docs-stable-url] [![docs-dev][docs-dev-img]][docs-dev-url] | [![build-gh][build-gh-img]][build-gh-url] [![build-cirrus][build-cirrus-img]][build-cirrus-url] | [![codecov][codecov-img]][codecov-url] | [![doi][doi-img]][doi-url] |

[docs-stable-img]: https://img.shields.io/badge/docs-stable-blue.svg
[docs-stable-url]: https://JuliaSmoothOptimizers.github.io/ExpressionTreeForge.jl/stable
[docs-dev-img]: https://img.shields.io/badge/docs-dev-purple.svg
[docs-dev-url]: https://JuliaSmoothOptimizers.github.io/ExpressionTreeForge.jl/dev
[build-gh-img]: https://github.com/JuliaSmoothOptimizers/ExpressionTreeForge.jl/workflows/CI/badge.svg?branch=master
[build-gh-url]: https://github.com/JuliaSmoothOptimizers/ExpressionTreeForge.jl/actions
[build-cirrus-img]: https://img.shields.io/cirrus/github/JuliaSmoothOptimizers/ExpressionTreeForge.jl?logo=Cirrus%20CI
[build-cirrus-url]: https://cirrus-ci.com/github/JuliaSmoothOptimizers/ExpressionTreeForge.jl
[codecov-img]: https://codecov.io/gh/JuliaSmoothOptimizers/ExpressionTreeForge.jl/branch/master/graph/badge.svg
[codecov-url]: https://app.codecov.io/gh/JuliaSmoothOptimizers/ExpressionTreeForge.jl
[doi-img]: https://img.shields.io/badge/DOI-10.5281%2Fzenodo.822073-blue.svg
[doi-url]: https://doi.org/10.5281/zenodo.822073

## Philosophy
ExpressionTreeForge.jl is a manipulator of expression trees.
It supports several expression tree implementations and defines methods to analyze and manipulate them, including:
- partial separability detection;
- evaluation of the expression, and its first and second derivatives;
- bound propagation;
- convexity detection.

## Compatibility
Julia ≥ 1.6.

## How to install
```
pkg> add https://github.com/JuliaSmoothOptimizers/ExpressionTreeForge.jl
pkg> test ExpressionTreeForge
```

## How to use 
See the [tutorial](https://JuliaSmoothOptimizers.github.io/ExpressionTreeForge.jl/dev/tutorial/).

## Dependencies
This module is used together with [PartitionedStructures.jl](https://github.com/JuliaSmoothOptimizers/PartitionedStructures.jl) by [PartiallySeparableNLPModels.jl](https://github.com/paraynaud/PartiallySeparableNLPModels.jl) and [PartiallySeparableSolvers.jl](https://github.com/paraynaud/PartiallySeparableSolvers.jl) to define a trust-region method exploiting partial separability through partitioned quasi-Newton approximations. 