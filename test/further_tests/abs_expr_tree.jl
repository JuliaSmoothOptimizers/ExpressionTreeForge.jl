@testset "Abstract_expr_tree & Interface" begin
  using ExpressionTreeForge.M_abstract_expr_tree
  using ..ExpressionTreeForge.M_interface_expr_tree  

  mutable struct AbTree <: AbstractExprTree
    field::Int
  end

  abtree = AbTree
  @test_throws MethodError M_abstract_expr_tree.create_expr_tree(abtree)
  @test_throws MethodError M_abstract_expr_tree.create_Expr(abtree)
  @test_throws MethodError M_abstract_expr_tree.create_Expr2(abtree)

  @test_throws MethodError M_interface_expr_tree._get_expr_node(abtree)
  @test_throws MethodError M_interface_expr_tree._get_expr_children(abtree)
  @test_throws MethodError M_interface_expr_tree._inverse_expr_tree(abtree)
  @test_throws MethodError M_interface_expr_tree._get_real_node(abtree)
  @test_throws MethodError M_interface_expr_tree._transform_to_expr_tree(abtree)
  @test_throws MethodError M_interface_expr_tree._expr_tree_to_create(abtree)
end