module abstract_tree

export create_tree

"""
  Define the abstrait type ab_tree
"""
abstract type ab_tree end

"""
create_tree()
    Define a tree, the implementation of the function must be done by the subtype of ab_tree
"""
create_tree() = @error("Should not be called (abstract_tree)")

end  # module abstract_tree
