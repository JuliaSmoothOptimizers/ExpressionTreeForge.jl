using ExpressionTreeForge.M_abstract_tree, ExpressionTreeForge.M_trait_tree

@testset "test on Expr" begin
  @test M_abstract_tree.create_tree(:(x[2] + 5 * x[3])) == :(x[2] + 5 * x[3])
  @test M_trait_tree.get_children(:(x[2] + 5 * x[3])) == [:(x[2]), :(5 * x[3])]
  @test M_trait_tree.get_node(:(x[2] + 5 * x[3])) == :+
  @test M_trait_tree.get_node(:(x[2] * 5 * x[3])) == :*

  c1 = M_abstract_tree.create_tree(5, [])
  c2 = M_abstract_tree.create_tree(6, [])
  tree = M_abstract_tree.create_tree(7, [c1, c2])
  @test M_trait_tree.get_children(tree) == [c1, c2]
  @test M_trait_tree.get_node(tree) == 7

  b1 = M_abstract_tree.create_tree(5.0, [])
  b2 = M_abstract_tree.create_tree(6.0, [])
  bree = M_abstract_tree.create_tree(7.0, [b1, b2])
  @test M_trait_tree.get_children(bree) == [b1, b2]
  @test M_trait_tree.get_node(bree) == 7.0

  @test bree != tree
end
