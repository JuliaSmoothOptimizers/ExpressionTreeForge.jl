# ExpressionTreeForge: A manipulator of expression tree

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

## Compatibility
Julia ≥ 1.6.

## How to install
```
pkg> add https://github.com/paraynaud/ExpressionTreeForge.jl
pkg> test ExpressionTreeForge
```

## Philosophy
ExpressionTreeForge.jl is a manipulator of expression tree.
It supports several expression tree implementations and define methods to analyze and manipulate them such as:
- partial separability detection;
- evaluation of $f(x), \nabla f(x), \nabla^2 f(x)$;
- bounds propagations;
- strict convexity detection.

## How to use 
See the [tutorial](https://paraynaud.github.io/ExpressionTreeForge.jl/dev/tutorial/).

## Dependencies
This module is use in addition of [PartitionedStructures.jl](https://github.com/paraynaud/PartitionedStructures.jl) by: [PartiallySeparableNLPModels.jl](https://github.com/paraynaud/PartiallySeparableNLPModels.jl) and [PartiallySeparableSolvers.jl](https://github.com/paraynaud/PartiallySeparableSolvers.jl) to define a trust-region method exploiting the partial separability through partitioned quasi-Newton approximations. 