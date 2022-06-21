using Test
using Test
using CalculusTreeTools
using JuMP, LinearAlgebra, MathOptInterface, ModelingToolkit, SparseArrays

# root_src = "../"*"src/"

# include(root_src*"type_expr/ordered_include.jl")
# include(root_src*"node_expr_tree/ordered_include.jl")
# include(root_src*"tree/ordered_include.jl")
# include(root_src*"expr_tree/ordered_include.jl")

#= include des tests=#
include("test_on_tree/ordered_include.jl")
include("unitary_test/ordered_include.jl")
include("premier_test.jl")

# using ADNLPModels, ForwardDiff, JuMP, MathOptInterface, ReverseDiff, LinearAlgebra, SparseArrays, Test, ModelingToolkit
