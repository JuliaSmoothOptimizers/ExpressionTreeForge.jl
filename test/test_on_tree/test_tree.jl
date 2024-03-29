using ExpressionTreeForge.M_trait_tree,
  ExpressionTreeForge.M_abstract_tree,
  ExpressionTreeForge.M_implementation_tree,
  ExpressionTreeForge.M_implementation_tree_Expr

@testset "test on tree/tr_tree" begin
  t1 = M_abstract_tree.create_tree(5, [])
  @test M_trait_tree.get_node(t1) == 5
  @test M_trait_tree.get_children(t1) == []

  t2_expr = M_abstract_tree.create_tree(:(5 + 6))
  @test M_trait_tree.get_node(t2_expr) == :+
  @test M_trait_tree.get_children(t2_expr) == [5, 6]

  @test M_trait_tree.is_type_trait_tree(t2_expr) == M_trait_tree.Type_trait_tree()
  @test M_trait_tree.is_type_trait_tree(:(x[5] + x[4])) == M_trait_tree.Type_trait_tree()
  @test M_trait_tree.is_type_trait_tree(4) == M_trait_tree.Type_trait_tree()
  @test M_trait_tree.is_type_trait_tree(ones(5)) == M_trait_tree.Type_not_trait_tree()
end

@testset " test on tree/impl_tree " begin
  tree1 = M_implementation_tree.create_tree(5, [])
  @test tree1 == M_implementation_tree.Type_node{Int64}(5, [])
  @test M_implementation_tree._get_node(tree1) == 5
  @test M_implementation_tree._get_children(tree1) == []

  tree2 = M_implementation_tree.create_tree(6, [tree1, tree1])
  @test tree2 == M_implementation_tree.Type_node{Int64}(6, [tree1, tree1])
  @test M_implementation_tree._get_node(tree2) == 6
  @test M_implementation_tree._get_children(tree2) == [tree1, tree1]

  @test tree2 == M_implementation_tree.Type_node{Int64}(
    6,
    [M_implementation_tree.Type_node{Int64}(5, []), M_implementation_tree.Type_node{Int64}(5, [])],
  )
end

@testset " test on tree/impl_tree_Expr " begin
  tree1 = M_implementation_tree_Expr.create_tree(:(x[5]))
  @test tree1 == :(x[5])
  @test M_implementation_tree._get_node(tree1) == [:x, 5]

  tree2 = M_implementation_tree_Expr.create_tree(:(x[5]^2))
  @test tree2 == :(x[5]^2)
  @test M_implementation_tree._get_node(tree2) == [:^, 2]
  @test M_implementation_tree._get_children(tree2) == [tree1]

  tree2 = M_implementation_tree_Expr.create_tree(:(x[5] + x[3]))
  @test tree2 == :(x[5] + x[3])
  @test M_implementation_tree._get_node(tree2) == :+
  @test M_implementation_tree._get_children(tree2) == [:(x[5]), :(x[3])]
end
