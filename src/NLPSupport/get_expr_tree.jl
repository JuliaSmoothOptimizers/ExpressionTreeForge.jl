using JuMP, MathOptInterface
using Symbolics
using NLPModelsJuMP, ADNLPModels

"""
    expr = get_expression_tree(monlp::MathOptNLPModel)
    expr = get_expression_tree(adnlp::ADNLPModel)
    expr = get_expression_tree(model::JuMP.Model)
    expr = get_expression_tree(evaluator::MOI.Nonlinear.Evaluator)

Return the objective function as a `Type_expr_tree` for: a `MathOptNLPModel`, a `ADNLPModel`, a `JuMP.Model` or a `MOI.Nonlinear.Evaluator`.
"""
function get_expression_tree(model::JuMP.Model)
  nlp = JuMP.nonlinear_model(model; force=true)
  evaluator = MOI.Nonlinear.Evaluator(nlp)
  F = MOI.get(model, MOI.ObjectiveFunctionType())
  MOI.get(model, MOI.ObjectiveFunction{F}())
  if F <: MOI.ScalarNonlinearFunction
      MOI.Nonlinear.set_objective(nlp, MOI.get(model, MOI.ObjectiveFunction{F}()))
      # has_nonlinear = true
  end
  return get_expression_tree(evaluator)
end

get_expression_tree(nlp::MathOptNLPModel) = get_expression_tree(nlp.eval)
get_expression_tree(model::MathOptInterface.Nonlinear.Model) = get_expression_tree(MathOptInterface.Nonlinear.Evaluator(model))

function get_expression_tree(evaluator::MOI.Nonlinear.Evaluator)
  MathOptInterface.initialize(evaluator, [:ExprGraph])
  obj_Expr = MathOptInterface.objective_expr(evaluator)::Expr
  expr_tree = 
    ExpressionTreeForge.transform_to_expr_tree(obj_Expr)::ExpressionTreeForge.Type_expr_tree
  return expr_tree
end

function get_expression_tree(adnlp::ADNLPModel)
  n = adnlp.meta.nvar
  Symbolics.@variables x[1:n]
  fun = adnlp.f(x)
  obj_Expr = Symbolics._toexpr(fun)
  expr_tree =
    ExpressionTreeForge.transform_to_expr_tree(obj_Expr)::ExpressionTreeForge.Type_expr_tree
  return expr_tree
end
