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

  @test bree == M_trait_expr_tree.sum_expr_trees([b1, b2])

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

using ExpressionTreeForge

@testset "merge expression trees" begin
  expr1 = :(5 * x[1] + 3 * x[2] + 3)
  expr_tree1 = transform_to_expr_tree(expr1)
  complete_tree1 = complete_tree(expr_tree1)

  expr2 = :((x[3] + 2)^2)
  expr_tree2 = transform_to_expr_tree(expr2)
  complete_tree2 = complete_tree(expr_tree2)

  sum_expr = ExpressionTreeForge.sum_expr_trees([expr1, expr2])
  sum_expr_tree = ExpressionTreeForge.sum_expr_trees([expr_tree1, expr_tree2])
  sum_complete_tree = ExpressionTreeForge.sum_expr_trees([complete_tree1, complete_tree2])

  expr_summed = :((5 * x[1] + 3 * x[2] + 3) + (x[3] + 2)^2)
  expr_tree_summed = transform_to_expr_tree(expr_summed)
  complete_tree_summed = complete_tree(expr_tree_summed)

  @test sum_expr == expr_summed
  @test sum_expr_tree == expr_tree_summed
  @test sum_complete_tree == complete_tree_summed
end
