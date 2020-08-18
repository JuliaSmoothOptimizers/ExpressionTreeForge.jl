using JuMP, MathOptInterface, LinearAlgebra, SparseArrays
using Test
using BenchmarkTools, ProfileView
using CalculusTreeTools

m = Model()


n = 1000

@variable(m, x[1:n])

@NLobjective(m, Min, sum( (x[j]*(1/2) + (2 * exp(x[j]))/exp(x[j+1]) + x[j+1]*4 + sin(x[j]/5))^2 for j in 1:n-1 ) - (tan(x[6])) )
evaluator = JuMP.NLPEvaluator(m)
MathOptInterface.initialize(evaluator, [:ExprGraph])
Expr_j = MathOptInterface.objective_expr(evaluator)

expr_tree = CalculusTreeTools.transform_to_expr_tree(Expr_j)
expr_tree_j = copy(expr_tree)
complete_tree = CalculusTreeTools.create_complete_tree(expr_tree_j)

x = ones(Float64, n)
# x = ones(Float32, n)
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

# @code_warntype CalculusTreeTools.evaluate_expr_tree_multiple_points(n_compiled_tree_views, all_x)
# @profview @benchmark CalculusTreeTools.evaluate_expr_tree_multiple_points(n_compiled_tree, all_x)

ω(a,b) = (a-b) < (max(a,b)*1e6)
@testset "égalité obj" begin
    @test ω(obj_expr_tree, obj_compiled_tree)
    @test ω(obj_complete_tree, obj_compiled_tree)
    @test ω(obj_JuMP, obj_compiled_tree)
    @test ω(sum(resx),obj_all_x)
    @test ω(sum(resx),obj_all_x_views)
end
