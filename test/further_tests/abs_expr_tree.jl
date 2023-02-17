using ExpressionTreeForge.M_abstract_expr_tree

mutable struct AbTree <: AbstractExprTree
  field::Int
end

abtree = AbTree(5)

@testset "Abstract_expr_tree & Interface" begin
  using ExpressionTreeForge.M_interface_expr_tree

  @test_throws ErrorException M_abstract_expr_tree.create_expr_tree(abtree)
  @test_throws ErrorException M_abstract_expr_tree.create_Expr(abtree)
  @test_throws ErrorException M_abstract_expr_tree.create_Expr2(abtree)

  @test_throws ErrorException M_interface_expr_tree._get_expr_node(abtree)
  @test_throws ErrorException M_interface_expr_tree._get_expr_children(abtree)
  @test_throws ErrorException M_interface_expr_tree._inverse_expr_tree(abtree)
  @test_throws ErrorException M_interface_expr_tree._sum_expr_trees([abtree, abtree])
  @test_throws ErrorException M_interface_expr_tree._get_real_node(abtree)
  @test_throws ErrorException M_interface_expr_tree._transform_to_expr_tree(abtree)
  @test_throws MethodError M_interface_expr_tree._expr_tree_to_create(abtree)
end

@testset "trait expr tree" begin
  using ExpressionTreeForge.M_trait_expr_tree

  @test is_expr_tree(4) == M_trait_expr_tree.Is_expr_tree()
  @test is_expr_tree(abtree) == M_trait_expr_tree.Is_expr_tree()

  mutable struct NotTree
    c
  end
  notree = NotTree(5)
  @test_throws UndefVarError M_trait_expr_tree.get_expr_node(a)
  @test_throws ErrorException M_trait_expr_tree.get_expr_children(notree)
  @test_throws ErrorException M_trait_expr_tree.inverse_expr_tree(notree)
  @test_throws MethodError M_trait_expr_tree.expr_tree_equal(notree, notree)
  @test_throws ErrorException M_trait_expr_tree.get_real_node(notree)
  @test_throws ErrorException M_trait_expr_tree.transform_to_expr_tree(notree)
  @test_throws ErrorException M_trait_expr_tree.transform_to_Expr(notree)
  @test_throws ErrorException M_trait_expr_tree.transform_to_Expr2(notree)
  @test_throws MethodError M_trait_expr_tree.expr_tree_to_create(notree)
end
