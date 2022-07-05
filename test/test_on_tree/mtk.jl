@testset "MTK modelisation" begin
  n = 5
  function f(x)
    n = length(x)
    return sum(x[n - i + 1] - x[i] for i = 1:length(x))
  end

  ModelingToolkit.@variables x[1:n]

  fun_tree = f(x)
  expr_tree = transform_to_expr_tree(fun_tree)

  @test expr_tree == CalculusTreeTools.M_implementation_tree.Type_node{
    CalculusTreeTools.M_abstract_expr_node.Abstract_expr_node,
  }(
    CalculusTreeTools.M_plus_operator.Plus_operator(),
    CalculusTreeTools.M_implementation_tree.Type_node{CalculusTreeTools.M_abstract_expr_node.Abstract_expr_node}[
      CalculusTreeTools.M_implementation_tree.Type_node{CalculusTreeTools.M_abstract_expr_node.Abstract_expr_node}(
        CalculusTreeTools.M_plus_operator.Plus_operator(),
        CalculusTreeTools.M_implementation_tree.Type_node{
          CalculusTreeTools.M_abstract_expr_node.Abstract_expr_node,
        }[
          CalculusTreeTools.M_implementation_tree.Type_node{
            CalculusTreeTools.M_abstract_expr_node.Abstract_expr_node,
          }(
            CalculusTreeTools.M_plus_operator.Plus_operator(),
            CalculusTreeTools.M_implementation_tree.Type_node{
              CalculusTreeTools.M_abstract_expr_node.Abstract_expr_node,
            }[
              CalculusTreeTools.M_implementation_tree.Type_node{
                CalculusTreeTools.M_abstract_expr_node.Abstract_expr_node,
              }(
                CalculusTreeTools.M_plus_operator.Plus_operator(),
                CalculusTreeTools.M_implementation_tree.Type_node{
                  CalculusTreeTools.M_abstract_expr_node.Abstract_expr_node,
                }[
                  CalculusTreeTools.M_implementation_tree.Type_node{
                    CalculusTreeTools.M_abstract_expr_node.Abstract_expr_node,
                  }(
                    CalculusTreeTools.M_minus_operator.Minus_operator(),
                    CalculusTreeTools.M_implementation_tree.Type_node{
                      CalculusTreeTools.M_abstract_expr_node.Abstract_expr_node,
                    }[
                      CalculusTreeTools.M_implementation_tree.Type_node{
                        CalculusTreeTools.M_abstract_expr_node.Abstract_expr_node,
                      }(
                        CalculusTreeTools.M_variable.Variable(:x, 5),
                        CalculusTreeTools.M_implementation_tree.Type_node{
                          CalculusTreeTools.M_abstract_expr_node.Abstract_expr_node,
                        }[],
                      ),
                      CalculusTreeTools.M_implementation_tree.Type_node{
                        CalculusTreeTools.M_abstract_expr_node.Abstract_expr_node,
                      }(
                        CalculusTreeTools.M_variable.Variable(:x, 1),
                        CalculusTreeTools.M_implementation_tree.Type_node{
                          CalculusTreeTools.M_abstract_expr_node.Abstract_expr_node,
                        }[],
                      ),
                    ],
                  ),
                  CalculusTreeTools.M_implementation_tree.Type_node{
                    CalculusTreeTools.M_abstract_expr_node.Abstract_expr_node,
                  }(
                    CalculusTreeTools.M_minus_operator.Minus_operator(),
                    CalculusTreeTools.M_implementation_tree.Type_node{
                      CalculusTreeTools.M_abstract_expr_node.Abstract_expr_node,
                    }[
                      CalculusTreeTools.M_implementation_tree.Type_node{
                        CalculusTreeTools.M_abstract_expr_node.Abstract_expr_node,
                      }(
                        CalculusTreeTools.M_variable.Variable(:x, 4),
                        CalculusTreeTools.M_implementation_tree.Type_node{
                          CalculusTreeTools.M_abstract_expr_node.Abstract_expr_node,
                        }[],
                      ),
                      CalculusTreeTools.M_implementation_tree.Type_node{
                        CalculusTreeTools.M_abstract_expr_node.Abstract_expr_node,
                      }(
                        CalculusTreeTools.M_variable.Variable(:x, 2),
                        CalculusTreeTools.M_implementation_tree.Type_node{
                          CalculusTreeTools.M_abstract_expr_node.Abstract_expr_node,
                        }[],
                      ),
                    ],
                  ),
                ],
              ),
              CalculusTreeTools.M_implementation_tree.Type_node{
                CalculusTreeTools.M_abstract_expr_node.Abstract_expr_node,
              }(
                CalculusTreeTools.M_minus_operator.Minus_operator(),
                CalculusTreeTools.M_implementation_tree.Type_node{
                  CalculusTreeTools.M_abstract_expr_node.Abstract_expr_node,
                }[
                  CalculusTreeTools.M_implementation_tree.Type_node{
                    CalculusTreeTools.M_abstract_expr_node.Abstract_expr_node,
                  }(
                    CalculusTreeTools.M_variable.Variable(:x, 3),
                    CalculusTreeTools.M_implementation_tree.Type_node{
                      CalculusTreeTools.M_abstract_expr_node.Abstract_expr_node,
                    }[],
                  ),
                  CalculusTreeTools.M_implementation_tree.Type_node{
                    CalculusTreeTools.M_abstract_expr_node.Abstract_expr_node,
                  }(
                    CalculusTreeTools.M_variable.Variable(:x, 3),
                    CalculusTreeTools.M_implementation_tree.Type_node{
                      CalculusTreeTools.M_abstract_expr_node.Abstract_expr_node,
                    }[],
                  ),
                ],
              ),
            ],
          ),
          CalculusTreeTools.M_implementation_tree.Type_node{
            CalculusTreeTools.M_abstract_expr_node.Abstract_expr_node,
          }(
            CalculusTreeTools.M_minus_operator.Minus_operator(),
            CalculusTreeTools.M_implementation_tree.Type_node{
              CalculusTreeTools.M_abstract_expr_node.Abstract_expr_node,
            }[
              CalculusTreeTools.M_implementation_tree.Type_node{
                CalculusTreeTools.M_abstract_expr_node.Abstract_expr_node,
              }(
                CalculusTreeTools.M_variable.Variable(:x, 2),
                CalculusTreeTools.M_implementation_tree.Type_node{
                  CalculusTreeTools.M_abstract_expr_node.Abstract_expr_node,
                }[],
              ),
              CalculusTreeTools.M_implementation_tree.Type_node{
                CalculusTreeTools.M_abstract_expr_node.Abstract_expr_node,
              }(
                CalculusTreeTools.M_variable.Variable(:x, 4),
                CalculusTreeTools.M_implementation_tree.Type_node{
                  CalculusTreeTools.M_abstract_expr_node.Abstract_expr_node,
                }[],
              ),
            ],
          ),
        ],
      ),
      CalculusTreeTools.M_implementation_tree.Type_node{CalculusTreeTools.M_abstract_expr_node.Abstract_expr_node}(
        CalculusTreeTools.M_minus_operator.Minus_operator(),
        CalculusTreeTools.M_implementation_tree.Type_node{
          CalculusTreeTools.M_abstract_expr_node.Abstract_expr_node,
        }[
          CalculusTreeTools.M_implementation_tree.Type_node{
            CalculusTreeTools.M_abstract_expr_node.Abstract_expr_node,
          }(
            CalculusTreeTools.M_variable.Variable(:x, 1),
            CalculusTreeTools.M_implementation_tree.Type_node{
              CalculusTreeTools.M_abstract_expr_node.Abstract_expr_node,
            }[],
          ),
          CalculusTreeTools.M_implementation_tree.Type_node{
            CalculusTreeTools.M_abstract_expr_node.Abstract_expr_node,
          }(
            CalculusTreeTools.M_variable.Variable(:x, 5),
            CalculusTreeTools.M_implementation_tree.Type_node{
              CalculusTreeTools.M_abstract_expr_node.Abstract_expr_node,
            }[],
          ),
        ],
      ),
    ],
  )
end
