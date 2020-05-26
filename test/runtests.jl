using Test
using CalculusTreeTools


@test true
@test CalculusTreeTools.return2() == 2

include("premier_test.jl")
