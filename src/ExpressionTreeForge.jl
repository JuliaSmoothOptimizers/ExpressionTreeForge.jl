module ExpressionTreeForge

include("type_expr/ordered_include.jl")
include("node_expr_tree/ordered_include.jl")
include("tree/ordered_include.jl")
include("expr_tree/ordered_include.jl")

using .M_algo_expr_tree, .M_evaluation_expr_tree, .M_trait_expr_tree, .M_implementation_type_expr
using .algo_tree
using .M_implementation_complete_expr_tree
using .M_bound_propagations, .M_convexity_detection

include("export.jl")

include("NLPSupport/ordered_include.jl")

export create_bounds_tree, get_bounds, set_bounds!
export Type_node, Complete_expr_tree, Pre_compiled_tree, Pre_n_compiled_tree, Type_calculus_tree
export concave_type, constant_type, convex_type, linear_type, not_treated_type, unknown_type
export is_concave, is_constant, is_convex, is_linear, is_not_treated, is_treated, is_unknown
export get_convexity_status, set_convexity!, create_convex_tree
export is_constant, is_linear, is_quadratic, is_cubic, is_more
export transform_to_Expr, transform_to_Expr_julia, transform_to_Expr_JuMP, transform_to_expr_tree, complete_tree
export extract_element_functions,
  get_type_tree, get_elemental_variables, normalize_indices!, cast_type_of_constant!, sum_expr_trees
export non_linear_JuMP_model_evaluator, sparse_jacobian_JuMP_model
export evaluate_expr_tree, gradient_forward, gradient_reverse, hessian
export print_tree
export get_expression_tree

end
