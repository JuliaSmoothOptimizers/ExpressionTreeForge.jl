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
pkg> add https://github.com/paraynaud/ExpressionTreeForge.jl
pkg> test ExpressionTreeForge
```

## How to use 
See the [tutorial](https://paraynaud.github.io/ExpressionTreeForge.jl/dev/tutorial/).

## Dependencies
This module is used together with [PartitionedStructures.jl](https://github.com/paraynaud/PartitionedStructures.jl) by [PartiallySeparableNLPModels.jl](https://github.com/paraynaud/PartiallySeparableNLPModels.jl) and [PartiallySeparableSolvers.jl](https://github.com/paraynaud/PartiallySeparableSolvers.jl) to define a trust-region method exploiting partial separability through partitioned quasi-Newton approximations. 