@testset "MTK modelisation" begin
  n = 5
  function f(x)
    n = length(x)
    return sum(x[n - i + 1] - x[i] for i = 1:length(x))
  end

  ModelingToolkit.@variables x[1:n]

  fun_tree = f(x)
  expr_tree = transform_to_expr_tree(fun_tree)

  @test expr_tree == ExpressionTreeForge.M_implementation_tree.Type_node{
    ExpressionTreeForge.M_abstract_expr_node.Abstract_expr_node,
  }(
    ExpressionTreeForge.M_plus_operator.Plus_operator(),
    ExpressionTreeForge.M_implementation_tree.Type_node{
      ExpressionTreeForge.M_abstract_expr_node.Abstract_expr_node,
    }[
      ExpressionTreeForge.M_implementation_tree.Type_node{
        ExpressionTreeForge.M_abstract_expr_node.Abstract_expr_node,
      }(
        ExpressionTreeForge.M_plus_operator.Plus_operator(),
        ExpressionTreeForge.M_implementation_tree.Type_node{
          ExpressionTreeForge.M_abstract_expr_node.Abstract_expr_node,
        }[
          ExpressionTreeForge.M_implementation_tree.Type_node{
            ExpressionTreeForge.M_abstract_expr_node.Abstract_expr_node,
          }(
            ExpressionTreeForge.M_plus_operator.Plus_operator(),
            ExpressionTreeForge.M_implementation_tree.Type_node{
              ExpressionTreeForge.M_abstract_expr_node.Abstract_expr_node,
            }[
              ExpressionTreeForge.M_implementation_tree.Type_node{
                ExpressionTreeForge.M_abstract_expr_node.Abstract_expr_node,
              }(
                ExpressionTreeForge.M_plus_operator.Plus_operator(),
                ExpressionTreeForge.M_implementation_tree.Type_node{
                  ExpressionTreeForge.M_abstract_expr_node.Abstract_expr_node,
                }[
                  ExpressionTreeForge.M_implementation_tree.Type_node{
                    ExpressionTreeForge.M_abstract_expr_node.Abstract_expr_node,
                  }(
                    ExpressionTreeForge.M_minus_operator.Minus_operator(),
                    ExpressionTreeForge.M_implementation_tree.Type_node{
                      ExpressionTreeForge.M_abstract_expr_node.Abstract_expr_node,
                    }[
                      ExpressionTreeForge.M_implementation_tree.Type_node{
                        ExpressionTreeForge.M_abstract_expr_node.Abstract_expr_node,
                      }(
                        ExpressionTreeForge.M_variable.Variable(:x, 5),
                        ExpressionTreeForge.M_implementation_tree.Type_node{
                          ExpressionTreeForge.M_abstract_expr_node.Abstract_expr_node,
                        }[],
                      ),
                      ExpressionTreeForge.M_implementation_tree.Type_node{
                        ExpressionTreeForge.M_abstract_expr_node.Abstract_expr_node,
                      }(
                        ExpressionTreeForge.M_variable.Variable(:x, 1),
                        ExpressionTreeForge.M_implementation_tree.Type_node{
                          ExpressionTreeForge.M_abstract_expr_node.Abstract_expr_node,
                        }[],
                      ),
                    ],
                  ),
                  ExpressionTreeForge.M_implementation_tree.Type_node{
                    ExpressionTreeForge.M_abstract_expr_node.Abstract_expr_node,
                  }(
                    ExpressionTreeForge.M_minus_operator.Minus_operator(),
                    ExpressionTreeForge.M_implementation_tree.Type_node{
                      ExpressionTreeForge.M_abstract_expr_node.Abstract_expr_node,
                    }[
                      ExpressionTreeForge.M_implementation_tree.Type_node{
                        ExpressionTreeForge.M_abstract_expr_node.Abstract_expr_node,
                      }(
                        ExpressionTreeForge.M_variable.Variable(:x, 4),
                        ExpressionTreeForge.M_implementation_tree.Type_node{
                          ExpressionTreeForge.M_abstract_expr_node.Abstract_expr_node,
                        }[],
                      ),
                      ExpressionTreeForge.M_implementation_tree.Type_node{
                        ExpressionTreeForge.M_abstract_expr_node.Abstract_expr_node,
                      }(
                        ExpressionTreeForge.M_variable.Variable(:x, 2),
                        ExpressionTreeForge.M_implementation_tree.Type_node{
                          ExpressionTreeForge.M_abstract_expr_node.Abstract_expr_node,
                        }[],
                      ),
                    ],
                  ),
                ],
              ),
              ExpressionTreeForge.M_implementation_tree.Type_node{
                ExpressionTreeForge.M_abstract_expr_node.Abstract_expr_node,
              }(
                ExpressionTreeForge.M_minus_operator.Minus_operator(),
                ExpressionTreeForge.M_implementation_tree.Type_node{
                  ExpressionTreeForge.M_abstract_expr_node.Abstract_expr_node,
                }[
                  ExpressionTreeForge.M_implementation_tree.Type_node{
                    ExpressionTreeForge.M_abstract_expr_node.Abstract_expr_node,
                  }(
                    ExpressionTreeForge.M_variable.Variable(:x, 3),
                    ExpressionTreeForge.M_implementation_tree.Type_node{
                      ExpressionTreeForge.M_abstract_expr_node.Abstract_expr_node,
                    }[],
                  ),
                  ExpressionTreeForge.M_implementation_tree.Type_node{
                    ExpressionTreeForge.M_abstract_expr_node.Abstract_expr_node,
                  }(
                    ExpressionTreeForge.M_variable.Variable(:x, 3),
                    ExpressionTreeForge.M_implementation_tree.Type_node{
                      ExpressionTreeForge.M_abstract_expr_node.Abstract_expr_node,
                    }[],
                  ),
                ],
              ),
            ],
          ),
          ExpressionTreeForge.M_implementation_tree.Type_node{
            ExpressionTreeForge.M_abstract_expr_node.Abstract_expr_node,
          }(
            ExpressionTreeForge.M_minus_operator.Minus_operator(),
            ExpressionTreeForge.M_implementation_tree.Type_node{
              ExpressionTreeForge.M_abstract_expr_node.Abstract_expr_node,
            }[
              ExpressionTreeForge.M_implementation_tree.Type_node{
                ExpressionTreeForge.M_abstract_expr_node.Abstract_expr_node,
              }(
                ExpressionTreeForge.M_variable.Variable(:x, 2),
                ExpressionTreeForge.M_implementation_tree.Type_node{
                  ExpressionTreeForge.M_abstract_expr_node.Abstract_expr_node,
                }[],
              ),
              ExpressionTreeForge.M_implementation_tree.Type_node{
                ExpressionTreeForge.M_abstract_expr_node.Abstract_expr_node,
              }(
                ExpressionTreeForge.M_variable.Variable(:x, 4),
                ExpressionTreeForge.M_implementation_tree.Type_node{
                  ExpressionTreeForge.M_abstract_expr_node.Abstract_expr_node,
                }[],
              ),
            ],
          ),
        ],
      ),
      ExpressionTreeForge.M_implementation_tree.Type_node{
        ExpressionTreeForge.M_abstract_expr_node.Abstract_expr_node,
      }(
        ExpressionTreeForge.M_minus_operator.Minus_operator(),
        ExpressionTreeForge.M_implementation_tree.Type_node{
          ExpressionTreeForge.M_abstract_expr_node.Abstract_expr_node,
        }[
          ExpressionTreeForge.M_implementation_tree.Type_node{
            ExpressionTreeForge.M_abstract_expr_node.Abstract_expr_node,
          }(
            ExpressionTreeForge.M_variable.Variable(:x, 1),
            ExpressionTreeForge.M_implementation_tree.Type_node{
              ExpressionTreeForge.M_abstract_expr_node.Abstract_expr_node,
            }[],
          ),
          ExpressionTreeForge.M_implementation_tree.Type_node{
            ExpressionTreeForge.M_abstract_expr_node.Abstract_expr_node,
          }(
            ExpressionTreeForge.M_variable.Variable(:x, 5),
            ExpressionTreeForge.M_implementation_tree.Type_node{
              ExpressionTreeForge.M_abstract_expr_node.Abstract_expr_node,
            }[],
          ),
        ],
      ),
    ],
  )
end
