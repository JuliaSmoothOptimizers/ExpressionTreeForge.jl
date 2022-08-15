@testset "general tree" begin
  using ExpressionTreeForge.M_evaluation_expr_tree

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
    x[5]^2 * sin(exp(x[6]))/(7 + x[7]^2.5) +
    (-x[6]^2)^2 +
    5^3 +
    x[6]^0 +
    x[3]^1 +
    (x[4]^2)^(-1) + 
    cos(x[1])^-2 +
    x[2]^(-3) + 
    (x[1]^2 + 1)^2 +
    (-x[1]^2 - 1)^2
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
  @test evaluate_expr_tree(cex, x) == 150.01824939332715
  res = show(cex)
  @test res == nothing

  xs = map(i -> i*ones(n), 1:5)
  ExpressionTreeForge.evaluate_expr_tree_multiple_points(cex, xs)
end


@testset "create_node_expr" begin
  using ExpressionTreeForge.M_abstract_expr_node
  using ExpressionTreeForge.M_simple_operator
  using ExpressionTreeForge.M_constant
  using ExpressionTreeForge.M_variable
  using ExpressionTreeForge.M_interface_expr_node

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
  x = ones(2)
  xdic = Dict{Int,Float64}(1=>1., 2=>1.)
  @test map(variable -> create_node_expr(variable...), variables) == map(variable -> create_node_expr(variable..., x), variables)
  var = create_node_expr(variables[1]...)
  @test M_interface_expr_node._evaluate_node(var, x) == M_interface_expr_node._evaluate_node(var, xdic)

  variable_expr = :(x[1])
  n_to_ni = Dict{Int,Int}(1=>2)
  M_interface_expr_node._change_from_N_to_Ni!(variable_expr, n_to_ni)
  @test variable_expr == :(x[2])
  M_interface_expr_node._node_to_Expr(var)
end