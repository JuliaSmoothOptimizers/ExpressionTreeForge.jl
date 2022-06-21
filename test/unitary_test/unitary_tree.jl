using CalculusTreeTools.abstract_tree, CalculusTreeTools.trait_tree

@testset "test sur les arbre Expr" begin
  @test abstract_tree.create_tree(:(x[2] + 5 * x[3])) == :(x[2] + 5 * x[3])
  @test trait_tree.get_children(:(x[2] + 5 * x[3])) == [:(x[2]), :(5 * x[3])]
  @test trait_tree.get_node(:(x[2] + 5 * x[3])) == :+
  @test trait_tree.get_node(:(x[2] * 5 * x[3])) == :*

  c1 = abstract_tree.create_tree(5, [])
  c2 = abstract_tree.create_tree(6, [])
  tree = abstract_tree.create_tree(7, [c1, c2])
  @test trait_tree.get_children(tree) == [c1, c2]
  @test trait_tree.get_node(tree) == 7

  b1 = abstract_tree.create_tree(5.0, [])
  b2 = abstract_tree.create_tree(6.0, [])
  bree = abstract_tree.create_tree(7.0, [b1, b2])
  @test trait_tree.get_children(bree) == [b1, b2]
  @test trait_tree.get_node(bree) == 7.0

  @test bree != tree
end
