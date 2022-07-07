using Documenter
using ExpressionTreeForge

using ExpressionTreeForge:
  M_abstract_expr_tree,
  M_trait_expr_tree,
  M_interface_expr_tree,
  M_implementation_expression_tree_Expr,
  M_implementation_expr_tree_Expr,
  M_implementation_expr_tree,
  M_implementation_complete_expr_tree,
  M_evaluation_expr_tree,
  M_bound_propagations,
  M_convexity_detection,
  algo_expr_tree,
  M_trait_expr_node,
  M_interface_expr_node,
  M_variable,
  M_variables_view,
  M_variables_n_view,
  M_times_operator,
  M_tan_operator,
  M_sinus_operator,
  M_simple_operator,
  M_power_operator,
  M_plus_operator,
  M_minus_operator,
  M_frac_operator,
  M_exp_operator,
  M_cos_operator,
  M_constant,
  M_abstract_expr_node,
  M_trait_tree,
  algo_tree,
  M_interface_tree,
  M_implementation_tree,
  M_implementation_tree_Expr,
  M_abstract_tree,
  M_trait_type_expr,
  M_interface_type_expr,
  M_implementation_type_expr,
  M_implementation_convexity_type

makedocs(
  modules = [
    ExpressionTreeForge,
    M_abstract_expr_tree,
    M_trait_expr_tree,
    M_interface_expr_tree,
    M_implementation_expression_tree_Expr,
    M_implementation_expr_tree_Expr,
    M_implementation_expr_tree,
    M_implementation_complete_expr_tree,
    M_evaluation_expr_tree,
    M_bound_propagations,
    M_convexity_detection,
    algo_expr_tree,
    M_trait_expr_node,
    M_interface_expr_node,
    M_variable,
    M_variables_view,
    M_variables_n_view,
    M_times_operator,
    M_tan_operator,
    M_sinus_operator,
    M_simple_operator,
    M_power_operator,
    M_plus_operator,
    M_minus_operator,
    M_frac_operator,
    M_exp_operator,
    M_cos_operator,
    M_constant,
    M_abstract_expr_node,
    M_trait_tree,
    algo_tree,
    M_interface_tree,
    M_implementation_tree,
    M_implementation_tree_Expr,
    M_abstract_tree,
    M_trait_type_expr,
    M_interface_type_expr,
    M_implementation_type_expr,
    M_implementation_convexity_type,
  ],
  doctest = true,
  # linkcheck = true,
  strict = true,
  format = Documenter.HTML(
    assets = ["assets/style.css"],
    prettyurls = get(ENV, "CI", nothing) == "true",
  ),
  sitename = "ExpressionTreeForge.jl",
  pages = Any["Home" => "index.md", "Tutorial" => "tutorial.md", "Reference" => "reference.md", "Developper note" => "developer_note.md"],
)

deploydocs(repo = "github.com/paraynaud/ExpressionTreeForge.jl.git",push_preview = true, devbranch = "master")
