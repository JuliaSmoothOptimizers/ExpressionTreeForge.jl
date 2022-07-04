using ..trait_expr_tree, ..abstract_expr_tree, ..trait_tree, ..M_abstract_expr_node
using ..implementation_expr_tree

@testset " Unitary tests about expr_tree" begin
  @test abstract_expr_tree.create_expr_tree(:(x[5] + 4)) == :(x[5] + 4)
  @test abstract_expr_tree.create_expr_tree(M_abstract_expr_node.create_node_expr(:x, 5)) ==
        implementation_expr_tree.t_expr_tree(M_abstract_expr_node.create_node_expr(:x, 5), [])
  @test abstract_expr_tree.create_expr_tree(M_abstract_expr_node.create_node_expr(4)) ==
        implementation_expr_tree.t_expr_tree(M_abstract_expr_node.create_node_expr(4), [])

  tree = abstract_expr_tree.create_expr_tree(:(x[5] + 4))
  b1 = abstract_expr_tree.create_expr_tree(M_abstract_expr_node.create_node_expr(:x, 5))
  b2 = abstract_expr_tree.create_expr_tree(M_abstract_expr_node.create_node_expr(4))
  bree = abstract_expr_tree.create_expr_tree(M_abstract_expr_node.create_node_expr(:+), [b1, b2])

  @test trait_expr_tree.get_expr_children(bree) == [b1, b2]

  @test trait_expr_tree.get_expr_node(tree) == trait_expr_tree.get_expr_node(bree)
  @test trait_expr_tree.get_expr_children.(trait_expr_tree.get_expr_children(tree)) ==
        trait_expr_tree.get_expr_children.(trait_expr_tree.get_expr_children(bree))
  @test trait_expr_tree.expr_tree_equal(tree, bree)
  @test trait_expr_tree.transform_to_expr_tree(tree) == bree

  m_bree = abstract_expr_tree.create_expr_tree(M_abstract_expr_node.create_node_expr(:-), [bree])
  @test trait_expr_tree.inverse_expr_tree(bree) == m_bree
  @test trait_expr_tree.inverse_expr_tree(:(x[5] + 4)) == :(-(x[5] + 4))
end
