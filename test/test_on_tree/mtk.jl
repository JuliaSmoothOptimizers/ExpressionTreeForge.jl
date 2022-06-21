
@testset "MTK modelisation" begin
  n = 5
  function f(x)
    n = length(x)
    return sum(x[n - i + 1] - x[i] for i = 1:length(x))
  end

  ModelingToolkit.@variables x[1:n]

  fun_tree = f(x)
  expr_tree = transform_to_expr_tree(fun_tree)

  @test expr_tree == CalculusTreeTools.implementation_tree.type_node{
    CalculusTreeTools.abstract_expr_node.ab_ex_nd,
  }(
    CalculusTreeTools.plus_operators.plus_operator(),
    CalculusTreeTools.implementation_tree.type_node{CalculusTreeTools.abstract_expr_node.ab_ex_nd}[
      CalculusTreeTools.implementation_tree.type_node{CalculusTreeTools.abstract_expr_node.ab_ex_nd}(
        CalculusTreeTools.plus_operators.plus_operator(),
        CalculusTreeTools.implementation_tree.type_node{
          CalculusTreeTools.abstract_expr_node.ab_ex_nd,
        }[
          CalculusTreeTools.implementation_tree.type_node{
            CalculusTreeTools.abstract_expr_node.ab_ex_nd,
          }(
            CalculusTreeTools.plus_operators.plus_operator(),
            CalculusTreeTools.implementation_tree.type_node{
              CalculusTreeTools.abstract_expr_node.ab_ex_nd,
            }[
              CalculusTreeTools.implementation_tree.type_node{
                CalculusTreeTools.abstract_expr_node.ab_ex_nd,
              }(
                CalculusTreeTools.plus_operators.plus_operator(),
                CalculusTreeTools.implementation_tree.type_node{
                  CalculusTreeTools.abstract_expr_node.ab_ex_nd,
                }[
                  CalculusTreeTools.implementation_tree.type_node{
                    CalculusTreeTools.abstract_expr_node.ab_ex_nd,
                  }(
                    CalculusTreeTools.minus_operators.minus_operator(),
                    CalculusTreeTools.implementation_tree.type_node{
                      CalculusTreeTools.abstract_expr_node.ab_ex_nd,
                    }[
                      CalculusTreeTools.implementation_tree.type_node{
                        CalculusTreeTools.abstract_expr_node.ab_ex_nd,
                      }(
                        CalculusTreeTools.variables.variable(:x, 5),
                        CalculusTreeTools.implementation_tree.type_node{
                          CalculusTreeTools.abstract_expr_node.ab_ex_nd,
                        }[],
                      ),
                      CalculusTreeTools.implementation_tree.type_node{
                        CalculusTreeTools.abstract_expr_node.ab_ex_nd,
                      }(
                        CalculusTreeTools.variables.variable(:x, 1),
                        CalculusTreeTools.implementation_tree.type_node{
                          CalculusTreeTools.abstract_expr_node.ab_ex_nd,
                        }[],
                      ),
                    ],
                  ),
                  CalculusTreeTools.implementation_tree.type_node{
                    CalculusTreeTools.abstract_expr_node.ab_ex_nd,
                  }(
                    CalculusTreeTools.minus_operators.minus_operator(),
                    CalculusTreeTools.implementation_tree.type_node{
                      CalculusTreeTools.abstract_expr_node.ab_ex_nd,
                    }[
                      CalculusTreeTools.implementation_tree.type_node{
                        CalculusTreeTools.abstract_expr_node.ab_ex_nd,
                      }(
                        CalculusTreeTools.variables.variable(:x, 4),
                        CalculusTreeTools.implementation_tree.type_node{
                          CalculusTreeTools.abstract_expr_node.ab_ex_nd,
                        }[],
                      ),
                      CalculusTreeTools.implementation_tree.type_node{
                        CalculusTreeTools.abstract_expr_node.ab_ex_nd,
                      }(
                        CalculusTreeTools.variables.variable(:x, 2),
                        CalculusTreeTools.implementation_tree.type_node{
                          CalculusTreeTools.abstract_expr_node.ab_ex_nd,
                        }[],
                      ),
                    ],
                  ),
                ],
              ),
              CalculusTreeTools.implementation_tree.type_node{
                CalculusTreeTools.abstract_expr_node.ab_ex_nd,
              }(
                CalculusTreeTools.minus_operators.minus_operator(),
                CalculusTreeTools.implementation_tree.type_node{
                  CalculusTreeTools.abstract_expr_node.ab_ex_nd,
                }[
                  CalculusTreeTools.implementation_tree.type_node{
                    CalculusTreeTools.abstract_expr_node.ab_ex_nd,
                  }(
                    CalculusTreeTools.variables.variable(:x, 3),
                    CalculusTreeTools.implementation_tree.type_node{
                      CalculusTreeTools.abstract_expr_node.ab_ex_nd,
                    }[],
                  ),
                  CalculusTreeTools.implementation_tree.type_node{
                    CalculusTreeTools.abstract_expr_node.ab_ex_nd,
                  }(
                    CalculusTreeTools.variables.variable(:x, 3),
                    CalculusTreeTools.implementation_tree.type_node{
                      CalculusTreeTools.abstract_expr_node.ab_ex_nd,
                    }[],
                  ),
                ],
              ),
            ],
          ),
          CalculusTreeTools.implementation_tree.type_node{
            CalculusTreeTools.abstract_expr_node.ab_ex_nd,
          }(
            CalculusTreeTools.minus_operators.minus_operator(),
            CalculusTreeTools.implementation_tree.type_node{
              CalculusTreeTools.abstract_expr_node.ab_ex_nd,
            }[
              CalculusTreeTools.implementation_tree.type_node{
                CalculusTreeTools.abstract_expr_node.ab_ex_nd,
              }(
                CalculusTreeTools.variables.variable(:x, 2),
                CalculusTreeTools.implementation_tree.type_node{
                  CalculusTreeTools.abstract_expr_node.ab_ex_nd,
                }[],
              ),
              CalculusTreeTools.implementation_tree.type_node{
                CalculusTreeTools.abstract_expr_node.ab_ex_nd,
              }(
                CalculusTreeTools.variables.variable(:x, 4),
                CalculusTreeTools.implementation_tree.type_node{
                  CalculusTreeTools.abstract_expr_node.ab_ex_nd,
                }[],
              ),
            ],
          ),
        ],
      ),
      CalculusTreeTools.implementation_tree.type_node{CalculusTreeTools.abstract_expr_node.ab_ex_nd}(
        CalculusTreeTools.minus_operators.minus_operator(),
        CalculusTreeTools.implementation_tree.type_node{
          CalculusTreeTools.abstract_expr_node.ab_ex_nd,
        }[
          CalculusTreeTools.implementation_tree.type_node{
            CalculusTreeTools.abstract_expr_node.ab_ex_nd,
          }(
            CalculusTreeTools.variables.variable(:x, 1),
            CalculusTreeTools.implementation_tree.type_node{
              CalculusTreeTools.abstract_expr_node.ab_ex_nd,
            }[],
          ),
          CalculusTreeTools.implementation_tree.type_node{
            CalculusTreeTools.abstract_expr_node.ab_ex_nd,
          }(
            CalculusTreeTools.variables.variable(:x, 5),
            CalculusTreeTools.implementation_tree.type_node{
              CalculusTreeTools.abstract_expr_node.ab_ex_nd,
            }[],
          ),
        ],
      ),
    ],
  )
end
