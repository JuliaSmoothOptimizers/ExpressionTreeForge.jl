@testset "Trait methods" begin
  using ExpressionTreeForge.M_trait_expr_node

  mutable struct NotNode
    c
  end

  x = []
  dic = Dict{Int, Float64}()

  not_node = NotNode(5)
  @test_throws UndefVarError node_bound(not_node, Float64)
  @test_throws UndefVarError node_bound(not_node, [], Float64)

  @test_throws UndefVarError node_convexity(not_node)
  @test_throws UndefVarError node_convexity(not_node, [], [])

  @test_throws UndefVarError node_is_operator(not_node)
  @test_throws UndefVarError node_is_plus(not_node)
  @test_throws UndefVarError node_is_times(not_node)
  @test_throws UndefVarError node_is_minus(not_node)
  @test_throws UndefVarError node_is_power(not_node)
  @test_throws UndefVarError node_is_sin(not_node)
  @test_throws UndefVarError node_is_cos(not_node)
  @test_throws UndefVarError node_is_tan(not_node)
  @test_throws UndefVarError node_is_variable(not_node)
  @test_throws UndefVarError get_var_index(not_node)
  @test_throws UndefVarError node_is_constant(not_node)
  @test_throws UndefVarError get_type_node(not_node)
  @test_throws UndefVarError node_to_Expr(not_node)
  @test_throws UndefVarError node_to_Expr2(not_node)
  @test_throws UndefVarError evaluate_node(not_node, x)
  @test_throws UndefVarError evaluate_node(not_node, dic)

  @test M_trait_expr_node.is_expr_node(5) == M_trait_expr_node.is_expr_node(:(x[1]))
end
