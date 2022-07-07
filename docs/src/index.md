# ExpressionTreeForge.jl

## Compatibility
Julia ≥ 1.6.

## How to install
```
julia> ]
pkg> add https://github.com/paraynaud/ExpressionTreeForge.jl
pkg> test ExpressionTreeForge
```

## Philosophy
ExpressionTreeForge.jl is a manipulator of expression tree.
It supports several expression tree implementations and define methods to analyze and manipulate them such as:
- detection of the partially separable structure ;
- bounds propagations;
- strict convexity detection.

## How to use 
See the [tutorial](https://paraynaud.github.io/ExpressionTreeForge.jl/dev/tutorial/).

## Dependencies
This module is use in addition of [PartitionedStructures.jl](https://github.com/paraynaud/PartitionedStructures.jl) by: [PartiallySeparableNLPModels.jl](https://github.com/paraynaud/PartiallySeparableNLPModels.jl) and [PartiallySeparableSolvers.jl](https://github.com/paraynaud/PartiallySeparableSolvers.jl) to define a trust-region method exploiting the partial separability through partitioned quasi-Newton approximations.