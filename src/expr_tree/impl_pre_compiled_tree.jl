module implementation_pre_compiled_tree

using ..abstract_expr_node, ..trait_tree, ..implementation_expr_tree, ..trait_expr_node

mutable struct new_field
  op::abstract_expr_node.ab_ex_nd
end

@inline create_new_field(op::abstract_expr_node.ab_ex_nd) = new_field(op)

@inline get_op_from_field(field::new_field) = field.op

mutable struct new_node{Y <: Number}
  field::new_field
  tmp::Vector{abstract_expr_node.MyRef{Y}}
  children::Vector{new_node{Y}}
  length_children::Int
end

mutable struct pre_compiled_tree{Y <: Number}
  racine::new_node{Y}
  x::AbstractVector{Y}
end

@inline get_x(tree::pre_compiled_tree{Y}) where {Y <: Number} = tree.x

@inline get_racine(tree::pre_compiled_tree{Y}) where {Y <: Number} = tree.racine

@inline get_field_from_node(node::new_node{Y}) where {Y <: Number} = node.field

@inline get_children_vector_from_node(node::new_node{Y}) where {Y <: Number} = node.children

@inline get_children_from_node(node::new_node{Y}, i::Int) where {Y <: Number} = node.children[i]

@inline get_tmp_vector_from_node(node::new_node{Y}) where {Y <: Number} = node.tmp

@inline get_tmp_from_node(node::new_node{Y}, i::Int) where {Y <: Number} = node.tmp[i]

@inline get_op_from_node(node::new_node{Y}) where {Y <: Number} =
  get_op_from_field(get_field_from_node(node))

@inline get_length_children(node::new_node{Y}) where {Y <: Number} = node.length_children

@inline create_new_node(
  field::new_field,
  tmp::Vector{MyRef{Y}},
  children::Vector{new_node{Y}},
) where {Y <: Number} = new_node{Y}(field, tmp, children, length(children))

@inline create_new_node(field::new_field, children::Vector{new_node{Y}}) where {Y <: Number} =
  create_new_node(field, abstract_expr_node.create_new_vector_myRef(length(children), Y), children)

@inline create_new_node(field::new_field, type::DataType = Float64) =
  create_new_node(field, Vector{new_node{type}}(undef, 0))

@inline create_pre_compiled_tree(tree::pre_compiled_tree{T}) where {T <: Number} = tree

function create_pre_compiled_tree(tree::implementation_expr_tree.t_expr_tree, t::DataType = Float64)
  nd = trait_tree.get_node(tree)
  ch = trait_tree.get_children(tree)
  if isempty(ch)
    new_field = create_new_field(nd)
    new_node = create_new_node(new_field, t)
    return new_node
  else
    new_ch = create_pre_compiled_tree.(ch)
    new_field = create_new_field(nd)
    return create_new_node(new_field, new_ch)
  end
end

create_pre_compiled_tree(
  tree::implementation_expr_tree.t_expr_tree,
  x::AbstractVector{T},
) where {T <: Number} = pre_compiled_tree{T}(_create_pre_compiled_tree(tree, x), x)
function _create_pre_compiled_tree(
  tree::implementation_expr_tree.t_expr_tree,
  x::AbstractVector{T},
) where {T <: Number}
  nd = trait_tree.get_node(tree)
  ch = trait_tree.get_children(tree)
  if isempty(ch)
    new_op = abstract_expr_node.create_node_expr(nd, x)
    new_field = create_new_field(new_op)
    new_node = create_new_node(new_field, T)
    return new_node
  else
    # new_ch = create_pre_compiled_tree.(ch, x)
    # new_ch = Vector{new_node{T}}(undef, length(ch))
    new_ch = map(child -> _create_pre_compiled_tree(child, x), ch)
    new_field = create_new_field(nd)
    return create_new_node(new_field, new_ch)
  end
end

function evaluate_new_tree(tree::pre_compiled_tree{T}, x::AbstractVector{T}) where {T <: Number}
  res = abstract_expr_node.new_ref(T)
  evaluate_new_node!(tree, x, res)
  return abstract_expr_node.get_myRef(res)
end

function evaluate_pre_compiled_tree(
  tree::pre_compiled_tree{T},
  v::AbstractVector{T},
) where {T <: Number}
  res = abstract_expr_node.new_ref(T)
  tree.x .= v
  racine = get_racine(tree)
  evaluate_new_node!(racine, res)
  return abstract_expr_node.get_myRef(res)
end

function evaluate_new_node(
  node::new_node{T},
  x::AbstractVector{T},
  tmp::MyRef{T},
) where {T <: Number}
  op = get_op_from_node(node)
  if trait_expr_node.node_is_operator(op)::Bool == false
    abstract_expr_node.set_myRef!(tmp, trait_expr_node._evaluate_node(op, x))
  else
    n = get_length_children(node)
    for i = 1:n
      child = get_children_from_node(node, i)
      ref = get_tmp_from_node(node, i)
      evaluate_new_node(child, x, ref)
    end
    abstract_expr_node.set_myRef!(
      tmp,
      trait_expr_node._evaluate_node(op, get_myRef.(get_tmp_vector_from_node(node))),
    )
  end
end

function evaluate_new_node!(
  node::new_node{T},
  x::AbstractVector{T},
  tmp::MyRef{T},
) where {T <: Number}
  op = get_op_from_node(node)
  if trait_expr_node.node_is_operator(op)::Bool == false
    trait_expr_node._evaluate_node!(op, x, tmp)
  else
    n = get_length_children(node)
    for i = 1:n
      child = get_children_from_node(node, i)
      ref = get_tmp_from_node(node, i)
      evaluate_new_node!(child, x, ref)
    end
    trait_expr_node._evaluate_node!(op, get_tmp_vector_from_node(node), tmp)
  end
end

function evaluate_new_node!(node::new_node{T}, tmp::MyRef{T}) where {T <: Number}
  op = get_op_from_node(node)
  if trait_expr_node.node_is_operator(op)::Bool == false
    trait_expr_node._evaluate_node!(op, tmp)
  else
    n = get_length_children(node)
    for i = 1:n
      child = get_children_from_node(node, i)
      ref = get_tmp_from_node(node, i)
      evaluate_new_node!(child, ref)
    end
    tmp_vector = get_tmp_vector_from_node(node)
    # @show op , tmp, tmp_vector[1] / tmp_vector[2]
    trait_expr_node._evaluate_node!(op, get_tmp_vector_from_node(node), tmp)
  end
end

end
