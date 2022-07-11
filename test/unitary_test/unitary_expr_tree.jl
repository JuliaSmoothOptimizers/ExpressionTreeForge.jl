using ExpressionTreeForge.M_trait_expr_tree,
  ExpressionTreeForge.M_abstract_expr_tree, ExpressionTreeForge.M_abstract_expr_node
using ExpressionTreeForge.M_implementation_expr_tree

@testset " Unitary tests about expr_tree" begin
  @test M_abstract_expr_tree.create_expr_tree(:(x[5] + 4)) == :(x[5] + 4)
  @test M_abstract_expr_tree.create_expr_tree(M_abstract_expr_node.create_node_expr(:x, 5)) ==
        M_implementation_expr_tree.Type_expr_tree(M_abstract_expr_node.create_node_expr(:x, 5), [])
  @test M_abstract_expr_tree.create_expr_tree(M_abstract_expr_node.create_node_expr(4)) ==
        M_implementation_expr_tree.Type_expr_tree(M_abstract_expr_node.create_node_expr(4), [])

  tree = M_abstract_expr_tree.create_expr_tree(:(x[5] + 4))
  b1 = M_abstract_expr_tree.create_expr_tree(M_abstract_expr_node.create_node_expr(:x, 5))
  b2 = M_abstract_expr_tree.create_expr_tree(M_abstract_expr_node.create_node_expr(4))
  bree = M_abstract_expr_tree.create_expr_tree(M_abstract_expr_node.create_node_expr(:+), [b1, b2])

  @test M_trait_expr_tree.get_expr_children(bree) == [b1, b2]

  @test M_trait_expr_tree.get_expr_node(tree) == M_trait_expr_tree.get_expr_node(bree)
  @test M_trait_expr_tree.get_expr_children.(M_trait_expr_tree.get_expr_children(tree)) ==
        M_trait_expr_tree.get_expr_children.(M_trait_expr_tree.get_expr_children(bree))
  @test M_trait_expr_tree.expr_tree_equal(tree, bree)
  @test M_trait_expr_tree.transform_to_expr_tree(tree) == bree

  m_bree = M_abstract_expr_tree.create_expr_tree(M_abstract_expr_node.create_node_expr(:-), [bree])
  @test M_trait_expr_tree.inverse_expr_tree(bree) == m_bree
  @test M_trait_expr_tree.inverse_expr_tree(:(x[5] + 4)) == :(-(x[5] + 4))
end
