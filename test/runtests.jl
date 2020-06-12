using Revise
using Test
using CalculusTreeTools

#= include pour pouvoir utiliser les modules locaux dans les tests =#
root_src = "../"*"src/"
include(root_src*"type_expr/ordered_include.jl")
include(root_src*"node_expr_tree/ordered_include.jl")
include(root_src*"tree/ordered_include.jl")
include(root_src*"expr_tree/ordered_include.jl")


#= include des tests=#
include("test_on_tree/ordered_include.jl")
include("unitary_test/ordered_include.jl")
include("premier_test.jl")
