using ModelingToolkit
using CalculusTreeTools
using ADNLPModels

function produce_complete_tree_from_ADNLP(adnlp::ADNLPModel)
  f = adnlp.f
  x0 = adnlp.meta.x0
  (ex, complet_ex) = produce_complete_tree_from_julia_function(f, n)
  return (ex, complet_ex)
end

function produce_complete_tree_from_julia_function(f, n)
  ModelingToolkit.@variables x[1:n]
  tmp = f(x)
  ex = CalculusTreeTools.transform_to_expr_tree(tmp)
  complete_ex = CalculusTreeTools.create_complete_tree(ex)
  CalculusTreeTools.set_convexity!(complete_ex)
  CalculusTreeTools.get_convexity_status(complete_ex)
  CalculusTreeTools.set_bounds!(complete_ex)
  CalculusTreeTools.get_bound(complete_ex)

  return ex, complete_ex
end

n = 5
f(x) = sum(x)
x0 = zeros(n)
f_nlp = ADNLPModel(f, x0)
(ex, complete_ex) = produce_complete_tree_from_ADNLP(f_nlp)

# #=function GridapOptimalControlNLPModel(f, con, domain, n;
#                                        x0 = nothing, xf = nothing,
#                                        umin = nothing, umax = nothing) =#
# #
# # n est la taille de la discrétisation (entier)
# n = 100
# # le domain au format (t₀, T)
# domain = (0,1)
# # x0 est la valeur initiale de x (nombre)
# x0 = 0.1
# # umin et umax sont des fonctions qui représentent les bornes:
# umin(t) = 0.
# umax(t) = 1.
# #La fonction objectif sous l'intégrale:
# f(x, u) = - (1.-u)*x
# #Le membre de droite de l'EDO:
# γ = 3
# con(x, u) = γ *u * x

# # nlp = GridapOptimalControlNLPModel(f, con, domain, n; x0 = x0, umin = umin, umax = umax)
