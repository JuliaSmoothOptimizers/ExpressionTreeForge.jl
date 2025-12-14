import MathOptInterface as MOI

"""
    expr = get_expression_tree(monlp::MathOptNLPModel)
    expr = get_expression_tree(adnlp::ADNLPModel)
    expr = get_expression_tree(model::JuMP.Model)
    expr = get_expression_tree(evaluator::MOI.Nonlinear.Evaluator)

Return the objective function as a `Type_expr_tree` for: a `MathOptNLPModel`, a `ADNLPModel`, a `JuMP.Model` or a `MOI.Nonlinear.Evaluator`.
"""
function get_expression_tree end

function get_expression_tree(evaluator::MOI.Nonlinear.Evaluator)
  MOI.initialize(evaluator, [:ExprGraph])
  obj_Expr = MOI.objective_expr(evaluator)::Expr
  expr_tree = ExpressionTreeForge.transform_to_expr_tree(obj_Expr)::ExpressionTreeForge.Type_expr_tree
  return expr_tree
end

function ExpressionTreeForge.get_expression_tree(model::MOI.Nonlinear.Model)
  evaluator = MOI.Nonlinear.Evaluator(model)
  return ExpressionTreeForge.get_expression_tree(evaluator)
end
