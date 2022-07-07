# Developer note

## Flexibility of the code
The code architecture is developed such that every structure can be replaced by a new one as long as the new `struct` keep satisfying the mandatory methods of the interface (see the files `itf_<behavior>.jl`).
The source code dynamically checks that the parameters of the interface methods are one of the expected expression trees.
This mechanism is called a [Holy traits](https://ahsmart.com/pub/holy-traits-design-patterns-and-best-practice-book/#implementing_the_holy_traits_pattern), implemented in the several `tr_<behavior>.jl` files.
These files indicate the supported `struct`ures and gather the methods that can be applied indistinctly on it(mainly those of the interface).
In consequence, if all the methods required by an algorithm are from the trait, the algorithm will work for every supported `struct`ures.
That way, we don't rely on `abstract type` hierarchy, and we can apply algorithms to types that can't be a subtype of our `abstract type`s (ex: `Expr`).
This interface-trait philosophy is applied on the:
- operator/variable/constant nodes;
- implementations of tree;
- implementations of expression tree.

### Issue of interface/trait approach
The issue is that you have to implement for every supported `struct`ures ell the interface methods which growth with time.
To keep the code consistent there are some internal structures that are certified for the interface-trait methods (ex: `Type_expr_tree`, `Complete_expr_tree`).
In the worst case, you can interface your structure with `Type_expr_tree` and apply the methods directly on the results of the interfacing.

## Organization of the code
The source code is divided in four sub-repository:
- `src/type_expr/` gather types about the nodes of an expression tree.
  It implements:
  - internal types: `constant, linear, quadratic, cubic` or `more` non-linear;
  - the convexity status: `constant, linear`, strictly `convex`, strictly `concave` or `unknown`.
- `src/tree/` is about classic tree behavior:
  - implement `Type_node<:AbstractTree`, a node structure which can be used to build a tree;
  - the expected methods that every tree should satisfy (interface `src/tree/itf_tree.jl, `);
  - an implementation of the interface for `Expr` (which can't be a subtype of `AbstractTree`);
  - an algorithm printing every structure satisfying the tree interface.
- `src/node_expr_tree/` implement the supported operator nodes which are part of an expression tree:
  - implement `plus, power, times, minus, constant, variable, sin, cos, tan` node operators;
  - the expected methods that every node should satisfy (interface `src/tree/itf_expr_node.jl`);
  - methods to evaluate a node, its bounds or its convexity status.
- `src/expr_tree/` implements the supported expression tree and the methods that can be applied on it:
  - the expected methods that every expression tree should satisfy (interface `src/tree/itf_expr_tree.jl`);
  - some implementation of expression trees;
  - bounds propagation and convexity detection;
  - algorithms applied onto expression trees.

### How to add a new tree implementation
You must define your tree `src/tree/YourTree.jl` alongside the other possible tree interfaces.
You also have to overload most of the method of `src/tree/itf_tree.jl`.

### How to add a new operator node
You must define your operator `src/node_expr_tree/YourOperator.jl` alongside the other operator node interfaces.
You also have to overload most of the method of `src/node_expr_tree/itf_expr_node.jl`.

### How to add a new expression tree implementation
You must define your tree `src/expr_tree/YourExpressionTree.jl` alongside the other possible tree interfaces.
You also have to overload most of the method of `src/expr_tree/itf_expr_tree.jl`.

## Limits
For now, the main internal structures `Type_expr_tree` and `Complete_expr_tree` representing expression trees are not directed acyclic graphs, but trees.