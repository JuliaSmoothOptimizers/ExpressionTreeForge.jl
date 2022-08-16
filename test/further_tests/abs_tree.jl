
@testset "abstract trees" begin
  using ExpressionTreeForge.M_abstract_tree
  using ExpressionTreeForge.M_trait_tree

  mutable struct NotTri <: AbstractTree
    c::Int
  end

  not_tree = NotTri(5)

  @test_throws ErrorException create_tree(not_tree)

  @test_throws ErrorException get_node(not_tree)
  @test_throws ErrorException get_children(not_tree)
end
