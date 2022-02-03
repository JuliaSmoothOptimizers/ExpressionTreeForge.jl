module implementation_expression_tree_Expr

  using ModelingToolkit

  using ..abstract_expr_node, ..abstract_expr_tree
  using ..implementation_expr_tree

  import ..abstract_expr_tree.create_expr_tree, ..abstract_expr_tree.create_Expr

  import ..interface_expr_tree._get_expr_node, ..interface_expr_tree._get_expr_children, ..interface_expr_tree._inverse_expr_tree
  import ..interface_expr_tree._get_real_node, ..interface_expr_tree._transform_to_expr_tree
   
  mutable struct Variable_counter
    current_var :: Int
    dic_var :: Dict{Symbol,Int64}
  end
  Variable_counter(;index=0, dic_var=Dict{Symbol,Int64}()) = Variable_counter{index, dic_var}
  
  @inline zero_vc() = Variable_counter()
  @inline increase!(vc :: Variable_counter) = vc.current_var += 1
  @inline get_value(vc :: Variable_counter, s :: Symbol) = get(vc.dic_var, s, vc.current_var + 1)
  @inline add_dic_var!(vc :: Variable_counter, s :: Symbol, index :: Int64) = vc.dic_var[s] = index
  @inline is_next(vc :: Variable_counter) = vc.current_var + 1

  @inline create_expr_tree( ex :: ModelingToolkit.Operation) = ex
  @inline create_Expr(ex :: ModelingToolkit.Operation) = ex
  function _get_expr_node(ex :: ModelingToolkit.Operation; vc :: Variable_counter=Variable_counter() )
    op = ex.op
    if op == +
      return abstract_expr_node.create_node_expr(:+)
    elseif op == -
      return abstract_expr_node.create_node_expr(:-)
    elseif op == * 
      return abstract_expr_node.create_node_expr(:*)
    elseif op == /
      return abstract_expr_node.create_node_expr(:/)				
    elseif op == ^
      power_value = ex.args[end].value
      return abstract_expr_node.create_node_expr(:^, power_value, true )
    elseif op == tan 
      return abstract_expr_node.create_node_expr(:tan)
    elseif op == cos
      return abstract_expr_node.create_node_expr(:cos)
    elseif op == sin
      return abstract_expr_node.create_node_expr(:sin)
    elseif op == exp
      return abstract_expr_node.create_node_expr(:exp)
    elseif typeof(op) == ModelingToolkit.Variable
      symbol = op.name
      index = get_value(vc, symbol)
      index == is_next(vc) && increase!(vc)				
      add_dic_var!(vc, symbol, index)
      abstract_expr_node.create_node_expr(:x, index)
    else
      @error("unsurpported operator (ModelingToolKit Interface)")
    end
  end		

  @inline _get_expr_node(ex :: ModelingToolkit.Constant ) = abstract_expr_node.create_node_expr(ex.value)
  @inline _get_expr_children(ex :: ModelingToolkit.Operation) = (ex.op == ^) ? ex.args[1:end-1] : ex.args
  @inline _get_expr_children(c :: ModelingToolkit.Constant) = []

  function _transform_to_expr_tree(ex :: ModelingToolkit.Operation)
    vc = zero_vc()
    _transform_to_expr_tree2(ex :: ModelingToolkit.Operation; vc)		
  end 

  function _transform_to_expr_tree2(ex :: ModelingToolkit.Operation; vc :: Variable_counter)		
    n_node = _get_expr_node(ex; vc) :: abstract_expr_node.ab_ex_nd
    children = _get_expr_children(ex)
    if isempty(children)
      return abstract_expr_tree.create_expr_tree(n_node) :: implementation_expr_tree.t_expr_tree
    else
      n_children = _transform_to_expr_tree2.(children; vc) :: Vector{implementation_expr_tree.t_expr_tree}
      return abstract_expr_tree.create_expr_tree(n_node, n_children) :: implementation_expr_tree.t_expr_tree
    end
  end

  _transform_to_expr_tree2(ex ::  ModelingToolkit.Constant; vc) = abstract_expr_tree.create_expr_tree(abstract_expr_node.create_node_expr(ex.value)) :: implementation_expr_tree.t_expr_tree

end
