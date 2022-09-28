# ExpressionTreeForge: A manipulator of expression trees

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
[doi-img]: https://zenodo.org/badge/266801355.svg
[doi-url]: https://zenodo.org/badge/latestdoi/266801355

## How to cite

If you use ExpressionTreeForge.jl in your work, please cite using the format given in [CITATION.bib](CITATION.bib).

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
pkg> add ExpressionTreeForge
pkg> test ExpressionTreeForge
```

## How to use 
See the [tutorial](https://JuliaSmoothOptimizers.github.io/ExpressionTreeForge.jl/dev/tutorial/).

## Dependencies
This module is used together with [PartitionedStructures.jl](https://github.com/JuliaSmoothOptimizers/PartitionedStructures.jl) by [PartiallySeparableNLPModels.jl](https://github.com/JuliaSmoothOptimizers/PartiallySeparableNLPModels.jl) and [PartiallySeparableSolvers.jl](https://github.com/JuliaSmoothOptimizers/PartiallySeparableSolvers.jl) to define a trust-region method exploiting partial separability through partitioned quasi-Newton approximations.

# Bug reports and discussions

If you think you found a bug, feel free to open an [issue](https://github.com/JuliaSmoothOptimizers/ExpressionTreeForge.jl/issues).
Focused suggestions and requests can also be opened as issues. Before opening a pull request, start an issue or a discussion on the topic, please.

If you want to ask a question not suited for a bug report, feel free to start a discussion [here](https://github.com/JuliaSmoothOptimizers/Organization/discussions). This forum is for general discussion about this repository and the [JuliaSmoothOptimizers](https://github.com/JuliaSmoothOptimizers), so questions about any of our packages are welcome.
