module M_trait_expr_tree

using ModelingToolkit
using Base.Threads
using ..M_abstract_expr_tree,
  ..implementation_expr_tree,
  ..implementation_complete_expr_tree,
  ..implementation_pre_compiled_tree
using ..implementation_pre_n_compiled_tree
using ..implementation_expression_tree_Expr

import ..interface_expr_tree._get_expr_node,
  ..interface_expr_tree._get_expr_children, ..interface_expr_tree._inverse_expr_tree
import ..implementation_expr_tree.t_expr_tree, ..interface_expr_tree._get_real_node
import ..interface_expr_tree._transform_to_expr_tree, ..interface_expr_tree._expr_tree_to_create
import Base.==

export is_expr_tree, get_expr_node, get_expr_children, inverse_expr_tree

struct Type_expr_tree end
struct Type_not_expr_tree end

@inline is_expr_tree(a::M_abstract_expr_tree.AbstractExprTree) = Type_expr_tree()
@inline is_expr_tree(a::t_expr_tree) = Type_expr_tree()
@inline is_expr_tree(a::Expr) = Type_expr_tree()
@inline is_expr_tree(a::Number) = Type_expr_tree()
@inline is_expr_tree(::Number) = Type_expr_tree()
@inline is_expr_tree(
  a::implementation_complete_expr_tree.complete_expr_tree{T},
) where {T <: Number} = Type_expr_tree()

@inline is_expr_tree(a::implementation_pre_compiled_tree.pre_compiled_tree{T}) where {T <: Number} =
  Type_expr_tree()

@inline is_expr_tree(
  a::implementation_pre_n_compiled_tree.pre_n_compiled_tree{T},
) where {T <: Number} = Type_expr_tree()

@inline is_expr_tree(a::ModelingToolkit.Operation) = Type_expr_tree()
@inline is_expr_tree(a::ModelingToolkit.Constant) = Type_expr_tree()
@inline is_expr_tree(a::ModelingToolkit.Variable) = Type_expr_tree()
@inline is_expr_tree(a::Any) = Type_not_expr_tree()
function is_expr_tree(t::DataType)
  if t == M_abstract_expr_tree.AbstractExprTree || t == t_expr_tree || t == Expr || t == Number
    Type_expr_tree()
  else
    Type_not_expr_tree()
  end
end

@inline get_expr_node(a) = _get_expr_node(a, is_expr_tree(a))
@inline _get_expr_node(a, ::Type_not_expr_tree) = error(" This is not an expr tree")
@inline _get_expr_node(a, ::Type_expr_tree) = _get_expr_node(a)

@inline get_expr_children(a) = _get_expr_children(a, is_expr_tree(a))
@inline _get_expr_children(a, ::Type_not_expr_tree) = error("This is not an expr tree")
@inline _get_expr_children(a, ::Type_expr_tree) = _get_expr_children(a)

@inline inverse_expr_tree(a) = _inverse_expr_tree(a, is_expr_tree(a))
@inline _inverse_expr_tree(a, ::Type_not_expr_tree) = error("This is not an expr tree")
@inline _inverse_expr_tree(a, ::Type_expr_tree) = _inverse_expr_tree(a)

@inline expr_tree_equal(a, b, eq::Atomic{Bool} = Atomic{Bool}(true)) =
  hand_expr_tree_equal(a, b, is_expr_tree(a), is_expr_tree(b), eq)

@inline hand_expr_tree_equal(a, b, ::Type_not_expr_tree, ::Any, eq) =
  error("we can't compare if these two tree are not expr tree")

@inline hand_expr_tree_equal(a, b, ::Any, ::Type_not_expr_tree, eq) =
  error("we can't compare if these two tree are not expr tree")

function hand_expr_tree_equal(a, b, ::Type_expr_tree, ::Type_expr_tree, eq::Atomic{Bool})
  if eq[]
    if _get_expr_node(a) == _get_expr_node(b)
      ch_a = _get_expr_children(a)
      ch_b = _get_expr_children(b)
      if length(ch_a) != length(ch_b)
        Threads.atomic_and!(eq, false)
      elseif ch_a == []
      else
        Threads.@threads for i = 1:length(ch_a)
          expr_tree_equal(ch_a[i], ch_b[i], eq)
        end
      end
    else
      Threads.atomic_and!(eq, false)
    end
    return eq[]
  end
  return false
end

"""
  get_real_node(a)
Fonction à prendre avec des pincettes, pour le moment utiliser seulement sur les feuilles.
"""
@inline get_real_node(a) = _get_real_node(is_expr_tree(a), a)

@inline _get_real_node(::Type_not_expr_tree, ::Any) =
  error("nous ne traitons pas un arbre d'expression")

@inline _get_real_node(::Type_expr_tree, a::Any) = _get_real_node(a)

"""
  transform_to_expr_tree(expression_tree)
This function takes an argument expression_tree satisfying the trait is_expr_tree and return an expression tree of the type t_expr_tree.
This function is usefull in our algorithms to synchronise all the types satisfying the trait is_expr_tree (like Expr) to the type t_expr_tree.
"""
@inline transform_to_expr_tree(a::T) where {T} =
  _transform_to_expr_tree(is_expr_tree(a), a)::implementation_expr_tree.t_expr_tree

@inline _transform_to_expr_tree(::Type_not_expr_tree, ::T) where {T} =
  error("nous ne traitons pas un arbre d'expression")

@inline _transform_to_expr_tree(::Type_expr_tree, a::T) where {T} =
  _transform_to_expr_tree(a)::implementation_expr_tree.t_expr_tree

"""
  transform_to_Expr(ex)
This function transform an expr_tree and transform it in Expr.
  #Deprecated
"""
@inline transform_to_Expr(ex) = _transform_to_Expr(M_trait_expr_tree.is_expr_tree(ex), ex)

@inline _transform_to_Expr(::M_trait_expr_tree.Type_expr_tree, ex) = _transform_to_Expr(ex)

@inline _transform_to_Expr(::M_trait_expr_tree.Type_not_expr_tree, ex) =
  error("notre parametre n'est pas un arbre d'expression")

@inline _transform_to_Expr(ex) = M_abstract_expr_tree.create_Expr(ex)

@inline transform_to_Expr2(ex) = _transform_to_Expr2(M_trait_expr_tree.is_expr_tree(ex), ex)

@inline _transform_to_Expr2(::M_trait_expr_tree.Type_expr_tree, ex) = _transform_to_Expr2(ex)
@inline _transform_to_Expr2(::M_trait_expr_tree.Type_not_expr_tree, ex) =
  error("notre parametre n'est pas un arbre d'expression")
@inline _transform_to_Expr2(ex) = M_abstract_expr_tree.create_Expr2(ex)

"""
  expr_tree_to_create(arbre créé, arbre d'origine)
fonction ayant pour but d'homogénéiser 2 arbres quelconque peut importe leurs types.
"""
@inline expr_tree_to_create(expr_tree_to_create, expr_tree_of_good_type) = _expr_tree_to_create(
  expr_tree_to_create,
  expr_tree_of_good_type,
  is_expr_tree(expr_tree_to_create),
  is_expr_tree(expr_tree_of_good_type),
)

@inline _expr_tree_to_create(a, b, ::Type_not_expr_tree, ::Any) =
  error("le type de l'arbre d'origine ne satisfait pas le trait")

@inline _expr_tree_to_create(a, b, ::Any, ::Type_not_expr_tree) =
  error("le type de l'arbre que l'on cherche à créer ne satisfait pas le trait")

function _expr_tree_to_create(a, b, ::Type_expr_tree, ::Type_expr_tree)
  uniformized_a = transform_to_expr_tree(a) # :: implementation_expr_tree.t_expr_tree
  _expr_tree_to_create(uniformized_a, b)
end

end  # module M_trait_expr_tree