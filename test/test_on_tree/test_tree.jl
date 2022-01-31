using CalculusTreeTools.trait_tree, CalculusTreeTools.abstract_tree, CalculusTreeTools.implementation_tree, CalculusTreeTools.implementation_tree_Expr

@testset "test on tree/tr_tree" begin
	t1 = abstract_tree.create_tree(5 , [] )
	@test trait_tree.get_node(t1) == 5
	@test trait_tree.get_children(t1) == []

	t2_expr = abstract_tree.create_tree( :( 5 + 6 ) )
	@test trait_tree.get_node(t2_expr) == :+
	@test trait_tree.get_children(t2_expr) == [5,6]

	@test trait_tree.is_type_trait_tree(t2_expr) == trait_tree.type_trait_tree()
	@test trait_tree.is_type_trait_tree( :(x[5] + x[4])) == trait_tree.type_trait_tree()
	@test trait_tree.is_type_trait_tree( 4) == trait_tree.type_trait_tree()
	@test trait_tree.is_type_trait_tree( ones(5) ) == trait_tree.type_not_trait_tree()
end

@testset " test on tree/impl_tree " begin
	tree1 = implementation_tree.create_tree(5, [])
	@test tree1 == implementation_tree.type_node{Int64}(5,[])
	@test implementation_tree._get_node(tree1) == 5
	@test implementation_tree._get_children(tree1) == []

	tree2 = implementation_tree.create_tree(6, [tree1,tree1])
	@test tree2 == implementation_tree.type_node{Int64}(6,[tree1,tree1])
	@test implementation_tree._get_node(tree2) == 6
	@test implementation_tree._get_children(tree2) == [tree1,tree1]

	@test tree2 == implementation_tree.type_node{Int64}(6,[implementation_tree.type_node{Int64}(5,[]), implementation_tree.type_node{Int64}(5,[])])
end

@testset " test on tree/impl_tree_Expr " begin
	tree1 = implementation_tree_Expr.create_tree( :(x[5]))
	@test tree1 == :(x[5])
	@test implementation_tree._get_node(tree1) == [:x, 5]

	tree2 = implementation_tree_Expr.create_tree( :(x[5]^2))
	@test tree2 == :(x[5]^2)
	@test implementation_tree._get_node(tree2) == [:^, 2]
	@test implementation_tree._get_children(tree2) == [tree1]

	tree2 = implementation_tree_Expr.create_tree( :(x[5] + x[3]))
	@test tree2 == :(x[5]+ x[3])
	@test implementation_tree._get_node(tree2) == :+
	@test implementation_tree._get_children(tree2) == [:(x[5]), :(x[3])]
end
