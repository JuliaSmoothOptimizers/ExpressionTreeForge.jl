@testset "general tree" begin
  
  n = 7
  m = Model()
  @variable(m, x[1:n])
  @NLobjective(
    m,
    Min,  
    tan(x[1]) * 1 / x[3] +
    exp(x[2]) -
    4 + 
    cos(x[3]^2) +
    1/4 * sin(x[4]) -
    x[5]^2 * sin(exp(x[6]))/(7 + x[7]^2.5)
  )
  
  ex = get_expression_tree(m)
  
  cex = complete_tree(ex)
  
  ExpressionTreeForge.set_bounds!(cex)
  ExpressionTreeForge.set_convexity!(cex)
  
  @test get_bounds(cex) == (-Inf, Inf)
  @test is_unknown(get_convexity_status(cex))
  @test ExpressionTreeForge.is_more(get_type_tree(cex))
  
  x = ones(7)
  @test evaluate_expr_tree(cex, x) == 0.9750119438711977
  res = show(cex)
  @test res == nothing
end