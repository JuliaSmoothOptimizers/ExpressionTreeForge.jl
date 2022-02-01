using Documenter
using CalculusTreeTools

using CalculusTreeTools.abstract_expr_tree, CalculusTreeTools.trait_expr_tree, CalculusTreeTools.interface_expr_tree, CalculusTreeTools.implementation_pre_compiled_tree, CalculusTreeTools.implementation_pre_n_compiled_tree, CalculusTreeTools.implementation_expression_tree_Expr, CalculusTreeTools.implementation_expr_tree_Expr, CalculusTreeTools.implementation_expr_tree, CalculusTreeTools.implementation_complete_expr_tree, CalculusTreeTools.M_evaluation_expr_tree, CalculusTreeTools.bound_propagations, CalculusTreeTools.convexity_detection, CalculusTreeTools.algo_expr_tree, CalculusTreeTools.trait_expr_node, CalculusTreeTools.interface_expr_node, CalculusTreeTools.variables, CalculusTreeTools.variables_view, CalculusTreeTools.variables_n_view, CalculusTreeTools.times_operators, CalculusTreeTools.tan_operators, CalculusTreeTools.sinus_operators, CalculusTreeTools.simple_operators, CalculusTreeTools.power_operators, CalculusTreeTools.plus_operators, CalculusTreeTools.minus_operators, CalculusTreeTools.frac_operators, CalculusTreeTools.exp_operators, CalculusTreeTools.cos_operators, CalculusTreeTools.constants, CalculusTreeTools.abstract_expr_node, CalculusTreeTools.trait_tree, CalculusTreeTools.algo_tree, CalculusTreeTools.interface_tree, CalculusTreeTools.implementation_tree, CalculusTreeTools.implementation_tree_Expr, CalculusTreeTools.abstract_tree, CalculusTreeTools.trait_type_expr, CalculusTreeTools.interface_type_expr, CalculusTreeTools.implementation_type_expr, CalculusTreeTools.implementation_convexity_type

makedocs(
  modules = [CalculusTreeTools, abstract_expr_tree, trait_expr_tree, interface_expr_tree, implementation_pre_compiled_tree, implementation_pre_n_compiled_tree, implementation_expression_tree_Expr, implementation_expr_tree_Expr, implementation_expr_tree, implementation_complete_expr_tree, M_evaluation_expr_tree, bound_propagations, convexity_detection, algo_expr_tree, trait_expr_node, interface_expr_node, variables, variables_view, variables_n_view, times_operators, tan_operators, sinus_operators, simple_operators, power_operators, plus_operators, minus_operators, frac_operators, exp_operators, cos_operators, constants, abstract_expr_node, trait_tree, algo_tree, interface_tree, implementation_tree, implementation_tree_Expr, abstract_tree, trait_type_expr, interface_type_expr, implementation_type_expr, implementation_convexity_type],
  doctest = true,
  # linkcheck = true,
  strict = true,
  format = Documenter.HTML(
    assets = ["assets/style.css"],
    prettyurls = get(ENV, "CI", nothing) == "true",
  ),
  sitename = "CalculusTreeTools.jl",
  pages = Any["Home" => "index.md", "Tutorial" => "tutorial.md", "Reference" => "reference.md"],
)

deploydocs(repo = "github.com/paraynaud/CalculusTreeTools.jl.git", devbranch = "main")


# abstract_expr_tree
# trait_expr_tree
# interface_expr_tree
# implementation_pre_compiled_tree
# implementation_pre_n_compiled_tree
# implementation_expression_tree_Expr
# implementation_expr_tree_Expr
# implementation_expr_tree
# implementation_complete_expr_tree
# M_evaluation_expr_tree
# bound_propagations
# convexity_detection
# algo_expr_tree
# trait_expr_node
# interface_expr_node
# variables
# variables_view
# variables_n_view
# times_operators
# tan_operators
# sinus_operators
# simple_operators
# power_operators
# plus_operators
# minus_operators
# frac_operators
# exp_operators
# cos_operators
# constants
# abstract_expr_node
# trait_tree
# algo_tree
# interface_tree
# implementation_tree
# implementation_tree_Expr
# abstract_tree
# trait_type_expr
# interface_type_expr
# implementation_type_expr
# implementation_convexity_type


