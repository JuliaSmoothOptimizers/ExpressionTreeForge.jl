# Developer note


## How to add a new operator
Should be defined in `src/node_expr_tree/YourOperator.jl` alongside the other possible nodes.
Should overload every method of `src/node_expr_tree/itf_expr_node.jl`.