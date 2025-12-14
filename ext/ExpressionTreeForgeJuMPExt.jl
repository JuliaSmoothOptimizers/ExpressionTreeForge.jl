module ExpressionTreeForgeJuMPExt

import ExpressionTreeForge
import JuMP
import MathOptInterface as MOI

function ExpressionTreeForge.get_expression_tree(model::JuMP.Model)
  nlp = JuMP.nonlinear_model(model; force = true)
  evaluator = MOI.Nonlinear.Evaluator(nlp)
  F = MOI.get(model, MOI.ObjectiveFunctionType())
  MOI.get(model, MOI.ObjectiveFunction{F}())
  if F <: MOI.ScalarNonlinearFunction
    MOI.Nonlinear.set_objective(nlp, MOI.get(model, MOI.ObjectiveFunction{F}()))
  end
  return ExpressionTreeForge.get_expression_tree(evaluator)
end

end
