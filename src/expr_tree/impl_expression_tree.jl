module implementation_expression_tree_Expr

    using ModelingToolkit
		# using SymbolicUtils

    using ..abstract_expr_node
    using ..abstract_expr_tree
    using ..implementation_expr_tree

    import ..abstract_expr_tree.create_expr_tree, ..abstract_expr_tree.create_Expr

    import ..interface_expr_tree._get_expr_node, ..interface_expr_tree._get_expr_children, ..interface_expr_tree._inverse_expr_tree
    import ..interface_expr_tree._get_real_node, ..interface_expr_tree._transform_to_expr_tree
 		
    

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

		@inline decimal_basis(a :: Int, b :: Int) = a*10+b

		# _get_expr_node(add :: SymbolicUtils.Add; type=Float64) = abstract_expr_node.create_node_expr(:+)
		# _get_expr_children(add :: SymbolicUtils.Add) = Base.RefValue(add.sorted_args_cache[])
		# _get_expr_node(mul :: SymbolicUtils.Mul) = abstract_expr_node.create_node_expr(:*)
		# _get_expr_children(mul :: SymbolicUtils.Mul) = copy(mul.sorted_args_cache[])
		# _get_expr_node(pow :: SymbolicUtils.Pow) = abstract_expr_node.create_node_expr(:^, pow.exp, true)
		# _get_expr_children(pow :: SymbolicUtils.Pow) = pow.base

		# _get_expr_children(sym :: SymbolicUtils.Sym) = []
		# function _get_expr_node(sym :: SymbolicUtils.Sym)
		# 	name_variable = sym.name
		# 	name_variable_string = String(name_variable) # Symbol -> String
		# 	chains = split(name_variable_string,"x") # split from the "x"
		# 	str = string(chains[2]) # get the indices
		# 	int_str = Vector(undef, length(str)) # 
		# 	for (id,v) in enumerate(str)
		# 		int_str[id] = Int(v) # transform unicode to Int
		# 	end 				
		# 	dec_basis = (x -> x - 8320).(int_str) # Int('₁') = 8321
		# 	index_variable = mapreduce(x -> x, decimal_basis, dec_basis) # calcul le nombre à parti de la base décimal.
		# 	return abstract_expr_node.create_node_expr(name_variable, index_variable)
		# 	# index_variable = get_index(name_variable) #ancienne alternative, ne préserve pas l
		# end 




		# _get_expr_children(term :: SymbolicUtils.Term) = term.arguments
		# function _get_expr_node(term :: SymbolicUtils.Term)
		# 	fun = term.f
		# 	if f == tan 
		# 		return abstract_expr_node.create_node_expr(:tan)
		# 	elseif f == sin 
		# 		return abstract_expr_node.create_node_expr(:sin)
		# 	elseif f == cos
		# 		return abstract_expr_node.create_node_expr(:cos)
		# 	elseif f == exp 
		# 		return abstract_expr_node.create_node_expr(:exp)
		# 	end
		# end 

		# function _transform_to_expr_tree(ex :: ModelingToolkit.Num; type=Float64)
		# 	reset_vc!()
		# 	_transform_to_expr_tree2(ex.val; type=type)		
		# end 

		# _transform_to_expr_tree2(cst:: T; type=Float64) where T <: Number = abstract_expr_tree.create_expr_tree(abstract_expr_node.create_node_expr(type(cst)))
		# function _transform_to_expr_tree2(ex :: T; type=Float64) where T <: Union{SymbolicUtils.Add, SymbolicUtils.Mul, SymbolicUtils.Term, SymbolicUtils.Sym}	
		# 	n_node = _get_expr_node(ex) :: abstract_expr_node.ab_ex_nd
		# 	if T <: SymbolicUtils.Add || T <: SymbolicUtils.Mul
		# 		children = ex.sorted_args_cache #Problème Base.RefValue{Any}(Any[5, tan(x₁), exp(x₄)^2, (sin(x₂)^2)*(cos(x₃)^2)]) qui rend Nothing ...
		# 		@show children
		# 	else
		# 		children = _get_expr_children(ex)
		# 	end  
		# 	if isempty(children)
		# 		return abstract_expr_tree.create_expr_tree(n_node) :: implementation_expr_tree.t_expr_tree
		# 	else
		# 		n_children = Vector{implementation_expr_tree.t_expr_tree}(undef,0)
		# 		for child in children
		# 			@show child
		# 			push!(_children, _transform_to_expr_tree2(child; type=type))
		# 		end 
		# 		return abstract_expr_tree.create_expr_tree(n_node, n_children) :: implementation_expr_tree.t_expr_tree
		# 	end
    # end

		@inline create_expr_tree( ex :: ModelingToolkit.Operation) = ex
    @inline create_Expr(ex :: ModelingToolkit.Operation) = ex
		# ancienne version de Modelingtoolkit@3.20.1
    function _get_expr_node(ex :: ModelingToolkit.Operation )
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
				return abstract_expr_node.create_node_expr(:x, index_variable)
				# index_variable = get_index(name_variable) #ancienne alternative, ne préserve pas le nom des variables.
				# return abstract_expr_node.create_node_expr(name_variable, index_variable)
			else
				error("partie non traite des Expr pour le moment ")
			end
    end

		

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
