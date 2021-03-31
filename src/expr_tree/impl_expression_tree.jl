module implementation_expression_tree_Expr

    using ModelingToolkit

    using ..abstract_expr_node
    using ..abstract_expr_tree
    using ..implementation_expr_tree

    import ..abstract_expr_tree.create_expr_tree, ..abstract_expr_tree.create_Expr

    import ..interface_expr_tree._get_expr_node, ..interface_expr_tree._get_expr_children, ..interface_expr_tree._inverse_expr_tree
    import ..interface_expr_tree._get_real_node, ..interface_expr_tree._transform_to_expr_tree

    @inline create_expr_tree( ex :: ModelingToolkit.Operation) = ex

    @inline create_Expr(ex :: ModelingToolkit.Operation) = ex

		mutable struct Variable_counter
			current_var :: Int
			sym_vector :: Vector{Symbol}
		end

		global vc = Variable_counter(0, Vector{Symbol}(undef,0))

		reset_vc!() = global vc = Variable_counter(0, Vector{Symbol}(undef,0))

		function increase_vc!(s :: Symbol) 
			vc.current_var += 1
			push!(vc.sym_vector, s)
		end

		function get_index(s :: Symbol)
			for (id,sym) in enumerate(vc.sym_vector)
				if sym == s
					return id 
				end 
			end 		
			#on sort de la boucle le symbol n'est pas connu
			increase_vc!(s)
			return vc.current_var		
		end 

    function _get_expr_node(ex :: ModelingToolkit.Operation )
			op = ex.op
			if op == +
				return abstract_expr_node.create_node_expr(:+)
			elseif op == -
				return abstract_expr_node.create_node_expr(:-)
			elseif op == * 
				return abstract_expr_node.create_node_expr(:*)
			elseif op == ^
				index_power = ex.args[end].value
				return abstract_expr_node.create_node_expr(:^, index_power, true )
			elseif op == tan 
				return abstract_expr_node.create_node_expr(:tan)
			elseif op == cos
				return abstract_expr_node.create_node_expr(:cos)
			elseif op == sin
				return abstract_expr_node.create_node_expr(:sin)
			elseif op == exp
				return abstract_expr_node.create_node_expr(:exp)
			elseif length(_get_expr_children(ex)) == 0 # variables
				name_variable = Symbol(ex)
				name_variable_string = String(name_variable) # Symbol -> String
				chains = split(name_variable_string,"x") # split from the "x"
				str = string(chains[2]) # get the indices
				int_str = Vector(undef, length(str)) # 
				for (id,v) in enumerate(str)
					int_str[id] = Int(v) # transform unicode to Int
				end 				
				dec_basis = (x -> x - 8320).(int_str) # Int('₁') = 8321
				index_variable = mapreduce(x -> x, decimal_basis, dec_basis) # calcul le nombre à parti de la base décimal.
				return abstract_expr_node.create_node_expr(name_variable, index_variable)
				# index_variable = get_index(name_variable) #ancienne alternative, ne préserve pas le nom des variables.
				# return abstract_expr_node.create_node_expr(name_variable, index_variable)
			else
				error("partie non traite des Expr pour le moment ")
			end
    end

		@inline decimal_basis(a :: Int, b :: Int) = a*10+b

    @inline _get_expr_node(ex :: ModelingToolkit.Constant ) = abstract_expr_node.create_node_expr(ex.value)

    @inline _get_expr_children(ex :: ModelingToolkit.Operation) = (ex.op == ^) ? ex.args[1:end-1] : ex.args

    @inline _get_expr_children(t :: Number) = []

    function _transform_to_expr_tree(ex :: ModelingToolkit.Operation)
			reset_vc!()
			_transform_to_expr_tree2(ex :: ModelingToolkit.Operation)		
		end 



		function _transform_to_expr_tree2(ex :: ModelingToolkit.Operation)		
			n_node = _get_expr_node(ex) :: abstract_expr_node.ab_ex_nd
			children = _get_expr_children(ex)
			if isempty(children)
				return abstract_expr_tree.create_expr_tree(n_node) :: implementation_expr_tree.t_expr_tree
			else
				n_children = _transform_to_expr_tree2.(children) :: Vector{implementation_expr_tree.t_expr_tree}
				return abstract_expr_tree.create_expr_tree(n_node, n_children) :: implementation_expr_tree.t_expr_tree
			end
    end

    _transform_to_expr_tree2(ex ::  ModelingToolkit.Constant) = abstract_expr_tree.create_expr_tree(abstract_expr_node.create_node_expr(ex.value)) :: implementation_expr_tree.t_expr_tree

end
