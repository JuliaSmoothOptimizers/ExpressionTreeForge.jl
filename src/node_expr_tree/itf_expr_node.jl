module interface_expr_node

  _node_is_operator() = ()
    _node_is_plus() = ()
    _node_is_minus() = ()
    _node_is_times() = ()
    _node_is_power() = ()
    _node_is_sin() = ()
    _node_is_cos() = ()
    _node_is_tan() = ()

  _node_is_variable() = ()
     _get_var_index() = ()

  _node_is_constant() = ()

  _get_type_node() = ()

  _evaluate_node() = ()
  _evaluate_node!() = ()

  _change_from_N_to_Ni!() = ()

  _cast_constant!() = ()

  _node_to_Expr() = ()
  _node_to_Expr2() = ()

  _node_bound() = ()
  _node_convexity() = ()

end
