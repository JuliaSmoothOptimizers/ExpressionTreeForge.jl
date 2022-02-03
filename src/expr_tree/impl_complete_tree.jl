module implementation_complete_expr_tree

  import Base.==

  using ..abstract_expr_node, ..abstract_expr_tree
  using ..trait_tree, ..trait_expr_node
  using ..implementation_convexity_type, ..implementation_expr_tree
  using ..interface_expr_tree

  import ..abstract_expr_tree: create_expr_tree, create_Expr, create_Expr2
  import ..interface_expr_tree._inverse_expr_tree
  import ..implementation_tree.type_node
  import ..interface_expr_tree: _get_expr_node, _get_expr_children, _inverse_expr_tree, _get_real_node, _transform_to_expr_tree

  export complete_node

  mutable struct complete_node{ T <: Number}
    op :: abstract_expr_node.ab_ex_nd
    bounds  :: abstract_expr_tree.bounds{T}
    convexity_status :: implementation_convexity_type.convexity_wrapper
  end

  @inline create_complete_node(op :: ab_ex_nd, bounds :: abstract_expr_tree.bounds{T}, cvx_st :: implementation_convexity_type.convexity_wrapper) where T <: Number = complete_node{T}(op,bounds, cvx_st)
  @inline create_complete_node(op :: ab_ex_nd, bounds :: abstract_expr_tree.bounds{T}) where T <: Number = create_complete_node(op, bounds, implementation_convexity_type.init_conv_status())
  @inline create_complete_node(op :: ab_ex_nd, bi :: T, bs :: T) where T <: Number = create_complete_node(op, abstract_expr_tree.bounds{T}(bi,bs))
  @inline create_complete_node(op :: ab_ex_nd, t= Float64 :: DataType) = create_complete_node(op, (t)(-Inf), (t)(Inf))

  @inline get_op_from_node(cmp_nope :: complete_node) = cmp_nope.op

  @inline get_bounds_from_node(cmp_nope :: complete_node) = cmp_nope.bounds
  @inline set_bound!(node :: complete_node{T}, bi :: T, bs :: T) where T <: Number = abstract_expr_tree.set_bound!(node.bounds,bi,bs)
  @inline get_bounds(node :: complete_node{T}) where T <: Number = abstract_expr_tree.get_bounds(node.bounds)

  @inline get_convexity_status(node :: complete_node{T}) where T <: Number = implementation_convexity_type.get_convexity_wrapper(node.convexity_status)
  @inline set_convexity_status!(node :: complete_node{T}, t :: implementation_convexity_type.convexity_type) where T <: Number = implementation_convexity_type.set_convexity_wrapper!(node.convexity_status, t)

  complete_expr_tree{T <: Number} = type_node{complete_node{T}}

  @inline create_complete_expr_tree(cn :: complete_node{T}, ch :: AbstractVector{complete_expr_tree{T}}) where T <: Number = complete_expr_tree{T}(cn,ch)
  @inline create_complete_expr_tree(cn :: complete_node{T}) where T <: Number = create_complete_expr_tree(cn, Vector{complete_expr_tree{T}}(undef,0) )
  @inline create_complete_expr_tree(ex :: complete_expr_tree{T}) where T <: Number = ex
  function create_complete_expr_tree(t :: implementation_expr_tree.type_node{T}) where T <: ab_ex_nd
    nd = trait_tree.get_node(t)
    ch = trait_tree.get_children(t)
    if isempty(ch)
      new_nd = create_complete_node(nd)
      return create_complete_expr_tree(new_nd)
    else
      new_ch = create_complete_expr_tree.(ch)
      new_nd = create_complete_node(trait_tree.get_node(t))
      return  create_complete_expr_tree(new_nd, new_ch)
    end
  end

  @inline create_expr_tree( tree :: complete_expr_tree{T} ) where T <: Number = create_expr_tree( trait_tree.get_node(tree), trait_tree.get_children(tree) )
  @inline create_expr_tree( field :: complete_node{T}, children :: Vector{ complete_expr_tree{T}} ) where T <: Number = abstract_expr_tree.create_expr_tree( get_op_from_node(field),  Vector{implementation_expr_tree.t_expr_tree}(create_expr_tree.(children))  )
  @inline create_expr_tree( field :: complete_node{T} ) where T <: Number = abstract_expr_tree.create_expr_tree( get_op_from_node(field)) :: implementation_expr_tree.t_expr_tree

  @inline _get_expr_node( t :: complete_expr_tree ) = get_op_from_node(trait_tree.get_node(t))
  @inline _get_expr_children(t :: complete_expr_tree) = trait_tree.get_children(t)
  @inline _get_real_node(ex :: complete_expr_tree{T}) where T <: Number = _get_expr_node(ex)

  @inline tuple_bound_from_tree(ex :: complete_expr_tree{T} ) where T <: Number = get_bounds(trait_tree._get_node(ex))
  @inline _transform_to_expr_tree(ex :: complete_expr_tree{T}) where T <: Number = create_expr_tree(ex)

  function create_Expr(t :: complete_expr_tree)
    nd = trait_tree.get_node(t)
    ch = trait_tree.get_children(t)
    op = get_op_from_node(nd)
    if isempty(ch)
      return trait_expr_node.node_to_Expr(op)
    else
      children_Expr = create_Expr.(ch)
      node_Expr = trait_expr_node.node_to_Expr(op)
      if length(node_Expr) == 1 # easy case
        return Expr(:call, node_Expr[1], children_Expr...)      
      elseif length(node_Expr) == 2 # :^
        return Expr(:call, node_Expr[1], children_Expr..., node_Expr[2])
      else
        error("non traité")
      end
    end
  end

  function _inverse_expr_tree(t :: complete_expr_tree{T}) where T <: Number
    op_minus = abstract_expr_node.create_node_expr(:-)
    bounds = abstract_expr_tree.create_empty_bounds(T)
    node = create_complete_node(op_minus, bounds)
    return create_complete_expr_tree(node,[t])
  end

  function Base.copy(ex :: complete_expr_tree{T}) where T <: Number
    nd = trait_tree.get_node(ex)
    ch = trait_tree.get_children(ex) :: Vector{complete_expr_tree{T}}
    if isempty(ch)
      leaf = create_complete_expr_tree(nd)
      return leaf
    else
      res_ch = Base.copy.(ch)
      new_node = create_complete_node(get_op_from_node(nd), get_bounds_from_node(nd), nd.convexity_status)
      return create_complete_expr_tree(new_node, res_ch)
    end
  end

  (==)(node1 :: complete_node{T}, node2 :: complete_node{T}) where T <: Number = ( (node1.op == node2.op) && (node1.bounds == node2.bounds) && (node1.convexity_status == node2.convexity_status) )

  function (==)(ex1 :: complete_expr_tree{T}, ex2 :: complete_expr_tree{T}) where T <: Number
    ch1 = trait_tree.get_children(ex1)
    ch2 = trait_tree.get_children(ex2)
    nd1 = _get_expr_node(ex1)
    nd2 = _get_expr_node(ex2)
    if length(ch1) != length(ch2)
      return false
    end
    b = true
    for i in 1:length(ch1)
      b = b && (ch1[i] == ch2[i])
    end
    b = b && (nd1 == nd2)
    return b
  end

end  # moduleimplementation_expr_tree
