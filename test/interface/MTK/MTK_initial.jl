#=
https://github.com/SciML/ModelingToolkit.jl/blob/master/docs/src/tutorials/symbolic_functions.md
=#

using ModelingToolkit

@variables x y t
@variables u[1:3]
@variables v[1:3]

function f(u)
  [u[1] - u[3], u[1]^2 - u[2], u[3] + u[2]]
end

z = x^2 + y
dump(z)
# Operation
# 	op: + (function of type typeof(+))
# 	args: Array{Expression}((2,)) Expression[x ^ 2, y]

# Analyse via dump

# Analyse de f en utilisant des variables x,y et z défini à partir de x et y
res_f = f([x, y, z]) # Recall that z = x^2 + y

dump(res_f)
# Array{Operation}((3,)) Operation[x - (x ^ 2 + y), x ^ 2 - y, (x ^ 2 + y) + y]
dump(res_f[1])
# Operation
# 	op: - (function of type typeof(-))
# 	args: Array{Expression}((2,)) Expression[x, x ^ 2 + y]	
dump(res_f[1].args[1])
# Operation
# 	op: x (function of type Variable{Number})
# 		name: Symbol x
# 	args: Array{Expression}((0,)) Expression[]

#= ------------------------------------------------------------------------------------	=#

# Analyse de f en utilisant des variables u définies comme un vecteur
tmp3 = f(u)
# Array{Operation}((3,)) Operation[u₁ - u₃, u₁ ^ 2 - u₂, u₃ + u₂]
dump(tmp3[1])
# Operation
#   op: - (function of type typeof(-))
#   args: Array{Expression}((2,)) Expression[u₁, u₃]
dump(tmp3[1].args[1])
# Operation
#   op: u₁ (function of type Variable{Number})
#     name: Symbol u₁
#   args: Array{Expression}((0,)) Expression[]
dump(tmp3[1].args[1].op.name)
# Symbol u₁

# f_expr = build_function(f,[x,y,t]) # provoque une erreur
# rappel: res_f = f([x,y,z])
# f_expr_of_f = build_function(res_f,[x,y,z]) # provoque une erreur car z n'est pas une variable
f_expr_of_f = build_function(res_f, [x, y, t])

# julia> typeof(f_expr_of_f[1])
# Expr
# dump(f_expr_of_f)
# 2 fonctions sont crées, les 2 fonctions sont des Expr sur lesquel on utilise ensuite eval()
# 	eval(f_expr_of_f[1])([args]) est une fonction renvoyant un résultat
# 	eval(f_expr_of_f)[2](res,[args]) est une fonction ne réalisant pas d'allocations et renvoyant le résultat dans res
# Mon code fonctionne à partir d'Expr qui est un type assez complexe il ne fonctionnera pas à partir des Expr f_expr_of_f[1]
# Exemple:
_args = [1, 2, 3]

_function_of_f = eval(f_expr_of_f[1])
res = _function_of_f(_args)

_function_of_f! = eval(f_expr_of_f[2])
in_place_res = rand(3)
_function_of_f!(in_place_res, _args)

@show res == in_place_res

#= --------------------------------------------------- =#
# Tests sur des fonctions un peu plus compliqués
#= --------------------------------------------------- =#

_scalar_prod(x, y) = transpose(x) * y
tmp4 = _scalar_prod(u, v)
dump(tmp4.args[2].args[1])
# Operation
#   op: transpose (function of type typeof(transpose))
#   args: Array{Expression}((1,)) Expression[u₃]

_square_sum(x) = mapreduce(x -> x^2, +, x)
tmp5 = _square_sum(u)
dump(tmp5)
# Operation
#   op: + (function of type typeof(+))
#   args: Array{Expression}((2,)) Expression[u₁ ^ 2 + u₂ ^ 2, u₃ ^ 2]
# très bon comportement!

#= --------------------------------------------------- =#
# Conclusions
#= --------------------------------------------------- =#
#=
Cool features!! :
	Simplification (t+t -> 2t) and Substitution (x => y^2 ):
		ModelingToolkit interfaces with SymbolicUtils.jl to allow for simplifying symbolic expressions.
	On peut transformer une expression du type Expression au type Expr d'après la doc, j'imagine que ce serai plus proche de l'arbre de la fonction.
		Ce serait une bonne chose car cela ferait une interface directe avec mon travail.
		La fonction mentionnée dans la doc est "toexpr" mais je n'ai pas réussi à la faire fonctionner.

Conclusion:
	Un exemple de ce que l'on pourrait faire:
	@variable x[1:n]
	define its objective function using pure julia code
	function obj_fun(x)
		...
	end
	mon_code(toexpr(obj_fun(x) ) )
=#
