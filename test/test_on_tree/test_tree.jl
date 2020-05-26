using Test


# include("../../src/tree/ordered_include.jl")

using .trait_tree
using .abstract_tree

t1 = abstract_tree.create_tree(5 , [] )

@test trait_tree.get_node(t1) == 5
@test trait_tree.get_children(t1) == []

t2_expr = abstract_tree.create_tree( :( 5 + 6 ) )
@test trait_tree.get_node(t2_expr) == :+
@test trait_tree.get_children(t2_expr) == [5,6]
