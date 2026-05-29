module ExpressionTreeForgeADNLPModelsExt

import ExpressionTreeForge
import ADNLPModels
import Symbolics

function ExpressionTreeForge.get_expression_tree(adnlp::ADNLPModels.ADNLPModel)
  n = adnlp.meta.nvar
  Symbolics.@variables x[1:n]
  fun = adnlp.f(x)
  obj_Expr = Symbolics.toexpr(fun)
  expr_tree = ExpressionTreeForge.transform_to_expr_tree(obj_Expr)::ExpressionTreeForge.Type_expr_tree
  return expr_tree
end

end
