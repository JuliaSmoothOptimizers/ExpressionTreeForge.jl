using ExpressionTreeForge.M_abstract_expr_tree

@testset "M_abstract_expr_tree" begin
  mutable struct AbTree <: AbstractExprTree
    field::Int
  end

  abtree = AbTree
  @test_throws MethodError M_abstract_expr_tree.create_expr_tree(abtree)
  @test_throws MethodError M_abstract_expr_tree.create_Expr(abtree)
  @test_throws MethodError M_abstract_expr_tree.create_Expr2(abtree)

end