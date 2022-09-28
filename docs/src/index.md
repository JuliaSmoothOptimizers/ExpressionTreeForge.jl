# ExpressionTreeForge.jl


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

# Bug reports and discussions

If you think you found a bug, feel free to open an [issue](https://github.com/JuliaSmoothOptimizers/ExpressionTreeForge.jl/issues).
Focused suggestions and requests can also be opened as issues. Before opening a pull request, start an issue or a discussion on the topic, please.

If you want to ask a question not suited for a bug report, feel free to start a discussion [here](https://github.com/JuliaSmoothOptimizers/Organization/discussions). This forum is for general discussion about this repository and the [JuliaSmoothOptimizers](https://github.com/JuliaSmoothOptimizers), so questions about any of our packages are welcome.
