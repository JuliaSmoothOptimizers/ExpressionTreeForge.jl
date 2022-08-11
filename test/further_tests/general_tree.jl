@testset "general tree" begin
  
  n = 7
  m = Model()
  @variable(m, x[1:n])
  @NLobjective(
    m,
    Min,  
    tan(x[1]) * 1 / x[3] +
    exp(x[2]) -
    cos(cos(x[7])^2) + 
    cos(-cos(cos(x[7])^2)) + 
    sin(cos(cos(x[7])^2)) + 
    tan(cos(cos(x[7])^2)) + 
    sin(- cos(cos(x[7])^2)) + 
    tan(- cos(cos(x[7])^2)) +     
    4 + 
    cos(x[3]^2) +
    1/4 * sin(x[4]) -
    x[5]^2 * sin(exp(x[6]))/(7 + x[7]^2.5)
  )
  
  ex = get_expression_tree(m)

  expr = :(cos(cos(x[7])^2))
  # ex = tranform

  
  cex = complete_tree(ex)
  
  ExpressionTreeForge.set_bounds!(cex)
  ExpressionTreeForge.set_convexity!(cex)
  
  @test get_bounds(cex) == (-Inf, Inf)
  @test is_unknown(get_convexity_status(cex))
  @test ExpressionTreeForge.is_more(get_type_tree(cex))
  
  x = ones(7)
  @test evaluate_expr_tree(cex, x) == 8.59273057251237
  res = show(cex)
  @test res == nothing
end


@testset "create_node_expr" begin
  using ExpressionTreeForge.M_abstract_expr_node
  using ExpressionTreeForge.M_simple_operator
  using ExpressionTreeForge.M_constant
  using ExpressionTreeForge.M_variable
  
  x = rand(5)
  #Operators
  symbol_table = [:+, :-, :*, :/, :cos, :sin, :tan, :exp]

  nodes = create_node_expr.(symbol_table)
  nodes_x = map(symbol -> create_node_expr(symbol, x), symbol_table)
  @test nodes == nodes_x 

  pow2 = create_node_expr(:^, 2)
  pow3 = create_node_expr(:^, 3)
  @test pow2 != pow3

  # Constants
  constantF64 = [3, 5.]
  constantF32 = Vector{Float32}([3, 5.])

  @test create_node_expr.(constantF64) != create_node_expr.(constantF32)
  @test create_node_expr.(constantF64) == map(constant -> create_node_expr(constant, x), constantF64)
  
  # Variables
  variables = [(:x,1), (:x,2)]
  @test map(variable -> create_node_expr(variable...), variables) == map(variable -> create_node_expr(variable..., x), variables)

end