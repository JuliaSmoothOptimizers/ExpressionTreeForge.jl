module M_implementation_pre_compiled_tree
# à supprimer
using ..M_abstract_expr_node, ..M_trait_tree, ..M_implementation_expr_tree, ..M_trait_expr_node, ..M_abstract_expr_tree

mutable struct New_field
  op::M_abstract_expr_node.Abstract_expr_node
end

@inline create_New_field(op::M_abstract_expr_node.Abstract_expr_node) = New_field(op)

@inline get_op_from_field(field::New_field) = field.op

"""
    New_node{Y <: Number}

Represent a node with:

* `field::New_field` representing an operator;
* `tmp::Vector{M_abstract_expr_node.MyRef{Y}}` representing the value of the children;
* `children::Vector{New_node{Y}}` the collection of the children;
* `length_children::Int` the number of children.
"""
mutable struct New_node{Y <: Number}
  field::New_field
  tmp::Vector{M_abstract_expr_node.MyRef{Y}}
  children::Vector{New_node{Y}}
  length_children::Int
end

"""
    Pre_compiled_tree{T} <: AbstractExprTree

Implementation of an expression tree where the value of the children is accessible from the parent using `MyRef`.
A `Pre_compiled_tree` has fields:

* `root::New_node{Y}` representing an expression tree;
* `x::AbstractVector{Y}` the vector evaluating `root`.
"""
mutable struct Pre_compiled_tree{Y <: Number} <: AbstractExprTree
  root::New_node{Y}
  x::AbstractVector{Y}
end

@inline get_x(tree::Pre_compiled_tree{Y}) where {Y <: Number} = tree.x

@inline get_root(tree::Pre_compiled_tree{Y}) where {Y <: Number} = tree.root

@inline get_field_from_node(node::New_node{Y}) where {Y <: Number} = node.field

@inline get_children_vector_from_node(node::New_node{Y}) where {Y <: Number} = node.children

@inline get_children_from_node(node::New_node{Y}, i::Int) where {Y <: Number} = node.children[i]

@inline get_tmp_vector_from_node(node::New_node{Y}) where {Y <: Number} = node.tmp

@inline get_tmp_from_node(node::New_node{Y}, i::Int) where {Y <: Number} = node.tmp[i]

@inline get_op_from_node(node::New_node{Y}) where {Y <: Number} =
  get_op_from_field(get_field_from_node(node))

@inline get_length_children(node::New_node{Y}) where {Y <: Number} = node.length_children

@inline create_new_node(
  field::New_field,
  tmp::Vector{MyRef{Y}},
  children::Vector{New_node{Y}},
) where {Y <: Number} = New_node{Y}(field, tmp, children, length(children))

@inline create_new_node(field::New_field, children::Vector{New_node{Y}}) where {Y <: Number} =
  create_new_node(field, M_abstract_expr_node.create_new_vector_myRef(length(children), Y), children)

@inline create_new_node(field::New_field, type::DataType = Float64) =
  create_new_node(field, Vector{New_node{type}}(undef, 0))

@inline create_pre_compiled_tree(tree::Pre_compiled_tree{T}) where {T <: Number} = tree

function create_pre_compiled_tree(tree::M_implementation_expr_tree.Type_expr_tree, t::DataType = Float64)
  nd = M_trait_tree.get_node(tree)
  ch = M_trait_tree.get_children(tree)
  if isempty(ch)
    New_field = create_New_field(nd)
    new_node = create_new_node(New_field, t)
    return new_node
  else
    new_ch = create_pre_compiled_tree.(ch)
    New_field = create_New_field(nd)
    return create_new_node(New_field, new_ch)
  end
end

create_pre_compiled_tree(
  tree::M_implementation_expr_tree.Type_expr_tree,
  x::AbstractVector{T},
) where {T <: Number} = Pre_compiled_tree{T}(_create_pre_compiled_tree(tree, x), x)
function _create_pre_compiled_tree(
  tree::M_implementation_expr_tree.Type_expr_tree,
  x::AbstractVector{T},
) where {T <: Number}
  nd = M_trait_tree.get_node(tree)
  ch = M_trait_tree.get_children(tree)
  if isempty(ch)
    new_op = M_abstract_expr_node.create_node_expr(nd, x)
    New_field = create_New_field(new_op)
    new_node = create_new_node(New_field, T)
    return new_node
  else
    new_ch = map(child -> _create_pre_compiled_tree(child, x), ch)
    New_field = create_New_field(nd)
    return create_new_node(New_field, new_ch)
  end
end

function evaluate_new_tree(tree::Pre_compiled_tree{T}, x::AbstractVector{T}) where {T <: Number}
  res = M_abstract_expr_node.new_ref(T)
  evaluate_new_node!(tree, x, res)
  return M_abstract_expr_node.get_myRef(res)
end

function evaluate_pre_compiled_tree(
  tree::Pre_compiled_tree{T},
  v::AbstractVector{T},
) where {T <: Number}
  res = M_abstract_expr_node.new_ref(T)
  tree.x .= v
  root = get_root(tree)
  evaluate_new_node!(root, res)
  return M_abstract_expr_node.get_myRef(res)
end

function evaluate_new_node(
  node::New_node{T},
  x::AbstractVector{T},
  tmp::MyRef{T},
) where {T <: Number}
  op = get_op_from_node(node)
  if M_trait_expr_node.node_is_operator(op)::Bool == false
    M_abstract_expr_node.set_myRef!(tmp, M_trait_expr_node._evaluate_node(op, x))
  else
    n = get_length_children(node)
    for i = 1:n
      child = get_children_from_node(node, i)
      ref = get_tmp_from_node(node, i)
      evaluate_new_node(child, x, ref)
    end
    M_abstract_expr_node.set_myRef!(
      tmp,
      M_trait_expr_node._evaluate_node(op, get_myRef.(get_tmp_vector_from_node(node))),
    )
  end
end

function evaluate_new_node!(
  node::New_node{T},
  x::AbstractVector{T},
  tmp::MyRef{T},
) where {T <: Number}
  op = get_op_from_node(node)
  if M_trait_expr_node.node_is_operator(op)::Bool == false
    M_trait_expr_node._evaluate_node!(op, x, tmp)
  else
    n = get_length_children(node)
    for i = 1:n
      child = get_children_from_node(node, i)
      ref = get_tmp_from_node(node, i)
      evaluate_new_node!(child, x, ref)
    end
    M_trait_expr_node._evaluate_node!(op, get_tmp_vector_from_node(node), tmp)
  end
end

function evaluate_new_node!(node::New_node{T}, tmp::MyRef{T}) where {T <: Number}
  op = get_op_from_node(node)
  if M_trait_expr_node.node_is_operator(op)::Bool == false
    M_trait_expr_node._evaluate_node!(op, tmp)
  else
    n = get_length_children(node)
    for i = 1:n
      child = get_children_from_node(node, i)
      ref = get_tmp_from_node(node, i)
      evaluate_new_node!(child, ref)
    end
    M_trait_expr_node._evaluate_node!(op, get_tmp_vector_from_node(node), tmp)
  end
end

end
