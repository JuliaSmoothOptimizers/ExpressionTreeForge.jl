module ExpressionTreeForgeNLPModelsJuMPExt

import ExpressionTreeForge
import NLPModelsJuMP

ExpressionTreeForge.get_expression_tree(nlp::NLPModelsJuMP.MathOptNLPModel) = ExpressionTreeForge.get_expression_tree(nlp.eval)

end
