
using CalculusTreeTools
using ModelingToolkit


@variables x y t 
@variables u[1:3]
@variables v[1:3]

_square_sum(x) = mapreduce(x -> x^2 + 1, +, x) #x1^2 +1 + x^2 + 1 + x3^2 + 1
tmp = _square_sum(u)

z = - x^2 + y

ex = CalculusTreeTools.transform_to_expr_tree(z)
complete_ex = CalculusTreeTools.create_complete_tree(ex)
CalculusTreeTools.set_convexity!(complete_ex)
CalculusTreeTools.get_convexity_status(complete_ex)
CalculusTreeTools.set_bounds!(complete_ex)
CalculusTreeTools.get_bound(complete_ex)


ex = CalculusTreeTools.transform_to_expr_tree(tmp)
complete_ex = CalculusTreeTools.create_complete_tree(ex)
CalculusTreeTools.set_convexity!(complete_ex)
CalculusTreeTools.get_convexity_status(complete_ex)
CalculusTreeTools.set_bounds!(complete_ex)
CalculusTreeTools.get_bound(complete_ex)
