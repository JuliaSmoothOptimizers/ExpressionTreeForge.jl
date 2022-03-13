m = Model()
n = 100
@variable(m, x[1:n])
@NLobjective(m, Min, sum( (x[j] + tan(x[j+1]))^2  +(x[j]*(1/2) + (2 * exp(x[j]))/exp(x[j+1]) + x[j+1]*4 + sin(x[j]/5))^2 for j in 1:n-1 ) - (tan(x[6])) )
evaluator = JuMP.NLPEvaluator(m)
MathOptInterface.initialize(evaluator, [:ExprGraph])
Expr_j = MathOptInterface.objective_expr(evaluator)

expr_tree = CalculusTreeTools.transform_to_expr_tree(Expr_j)
expr_tree_j = copy(expr_tree)
complete_tree = CalculusTreeTools.create_complete_tree(expr_tree_j)

x = ones(Float64, n)
compiled_tree = CalculusTreeTools.create_pre_compiled_tree(expr_tree, x)
@show CalculusTreeTools.trait_expr_tree.is_expr_tree(compiled_tree)

t = Float64
n_eval = 200
f(n,i,t) = (v -> i*v).(ones(t,n))
all_x = map( i -> f(n,i,t), [1:n_eval;])
resx = Vector{Float64}(undef,n_eval)
all_x_views = map( x -> view(x, [1:length(x);]), all_x)
n_compiled_tree = CalculusTreeTools.create_pre_n_compiled_tree(expr_tree, all_x)
n_compiled_tree_views = CalculusTreeTools.create_pre_n_compiled_tree(expr_tree, all_x_views)

obj_expr_tree = CalculusTreeTools.evaluate_expr_tree(expr_tree, x)
obj_complete_tree = CalculusTreeTools.evaluate_expr_tree(complete_tree, x)
obj_compiled_tree = CalculusTreeTools.evaluate_expr_tree(compiled_tree,x )
obj_JuMP = MathOptInterface.eval_objective(evaluator, x)

obj_all_x = CalculusTreeTools.evaluate_expr_tree_multiple_points(n_compiled_tree, all_x)
obj_all_x_views = CalculusTreeTools.evaluate_expr_tree_multiple_points(n_compiled_tree_views, all_x_views)
map!(x ->  CalculusTreeTools.evaluate_expr_tree(expr_tree, x), resx, all_x )
obj_all_without_x = CalculusTreeTools.evaluate_expr_tree_multiple_points(n_compiled_tree_views)

@testset "égalité obj" begin
    @test obj_expr_tree ≈ obj_compiled_tree
    @test obj_complete_tree ≈ obj_compiled_tree
    @test obj_JuMP ≈ obj_compiled_tree
    @test sum(resx) ≈ obj_all_x
    @test sum(resx) ≈ obj_all_x_views
    @test obj_all_without_x ≈obj_all_x_views
end
