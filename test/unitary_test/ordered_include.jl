root_src = "../../"*"src/"

include(root_src*"type_expr/ordered_include.jl")
include(root_src*"node_expr_tree/ordered_include.jl")
include(root_src*"tree/ordered_include.jl")
include(root_src*"expr_tree/ordered_include.jl")

include("unitary_node.jl")
include("unitary_tree.jl")
include("unitary_expr_tree.jl")
