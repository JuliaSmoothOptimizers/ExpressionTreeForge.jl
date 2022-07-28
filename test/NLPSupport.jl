using NLPModelsJuMP
using ADNLPModels
using OptimizationProblems, OptimizationProblems.PureJuMP, OptimizationProblems.ADNLPProblems

@testset "get_expression_tree" begin
  n = 10
  jump_model = PureJuMP.arwhead(; n)
  nlp_mo = MathOptNLPModel(jump_model)
  nlp_ad = ADNLPProblems.arwhead(; n)

  expr_jump = get_expression_tree(jump_model)
  expr_mo = get_expression_tree(nlp_mo)
  expr_ad = get_expression_tree(nlp_ad)

  @test expr_jump == expr_mo

  x = ones(n)

  @test evaluate_expr_tree(expr_jump, x) == evaluate_expr_tree(expr_mo, x)
  @test evaluate_expr_tree(expr_jump, x) == evaluate_expr_tree(expr_ad, x)
end
