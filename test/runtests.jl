using Test
using CalculusTreeTools


root_src = "../"*"src/"

include(root_src*"type_expr/ordered_include.jl")
include(root_src*"node_expr_tree/ordered_include.jl")
include(root_src*"tree/ordered_include.jl")
include(root_src*"expr_tree/ordered_include.jl")

include("unitary_test/ordered_include.jl")
include("premier_test.jl")
