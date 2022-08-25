using LinearAlgebra, SparseArrays, Test
using JuMP, MathOptInterface, Symbolics
using ExpressionTreeForge

include("first_test.jl")
include("test_on_tree/ordered_include.jl")
include("unitary_test/ordered_include.jl")
include("NLPSupport.jl")
include("further_tests/_include.jl")
