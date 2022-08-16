using ExpressionTreeForge.M_abstract_expr_node
using ExpressionTreeForge.M_interface_expr_node
using ExpressionTreeForge.M_trait_expr_node

@testset "MyRef" begin
  ref1 = new_ref(5.0)
  ref2 = new_ref(Float64)

  @test get_myRef(ref1) == 5.0
  @test get_myRef(ref2) == -1.0

  @test ref1 + ref2 == 4.0
  @test ref1 + 1.0 == 6.0
  @test 1.0 + ref1 == 6.0
  @test +ref1 == 5.0

  @test ref1 - ref2 == 6.0
  @test ref1 - 1.0 == 4.0
  @test 1.0 - ref1 == -4.0
  @test -ref1 == -5.0

  @test ref1 * ref2 == -5.0
  @test ref1 * 1.0 == 5.0
  @test 1.0 * ref1 == 5.0

  @test ref1 / ref2 == -5.0
  @test ref1 / 2.0 == 2.5
  @test 2.0 / ref1 == 2 / 5

  @test sin(ref1) == sin(5)
  @test tan(ref1) == tan(5)
  @test cos(ref1) == cos(5)
  @test exp(ref1) == exp(5)

  n = 5
  m = 6
  vec_ref = create_new_vector_myRef(n)
  array_ref = create_undef_array_myRef(n, m)
  nested_vector_ref1 = create_vector_of_vector_myRef(n, m)
  nested_vector_ref2 = create_vector_of_vector_myRef(m, n)

  equalize_vec_vec_myRef!(nested_vector_ref1, nested_vector_ref2)

  for i = 1:n, j = 1:m
    @test nested_vector_ref1[i][j] == nested_vector_ref2[j][i]
  end
end

@testset "numerical errors" begin
  mutable struct Ab <: Abstract_expr_node
    field::Int
  end

  ab_node = Ab(5)

  @test M_interface_expr_node._node_is_operator(ab_node) == false
  @test M_interface_expr_node._node_is_plus(ab_node) == false
  @test M_interface_expr_node._node_is_minus(ab_node) == false
  @test M_interface_expr_node._node_is_times(ab_node) == false
  @test M_interface_expr_node._node_is_sin(ab_node) == false
  @test M_interface_expr_node._node_is_cos(ab_node) == false
  @test M_interface_expr_node._node_is_tan(ab_node) == false
  @test M_interface_expr_node._node_is_power(ab_node) == false
  @test M_interface_expr_node._node_is_constant(ab_node) == false
  @test M_interface_expr_node._node_is_variable(ab_node) == false

  @test M_interface_expr_node._get_var_index(ab_node) == ()

  @test_throws ErrorException M_interface_expr_node._get_type_node(ab_node)
  @test_throws ErrorException M_interface_expr_node._evaluate_node(ab_node)
  @test_throws ErrorException M_interface_expr_node._evaluate_node(ab_node)
  @test_throws UndefVarError M_interface_expr_node._change_from_N_to_Ni(ab_node)
  @test_throws UndefVarError M_interface_expr_node._cast_constant(ab_node)
  @test_throws ErrorException M_interface_expr_node._node_to_Expr(ab_node)
  @test_throws ErrorException M_interface_expr_node._node_to_Expr2(ab_node)
  @test_throws ErrorException M_interface_expr_node._node_bound(ab_node)
  @test_throws ErrorException M_interface_expr_node._node_convexity(ab_node)
end
