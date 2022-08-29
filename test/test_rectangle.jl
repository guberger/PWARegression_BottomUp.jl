using Test
@static if isdefined(Main, :TestLocal)
    include("../src/PWARegression.jl")
else
    using PWARegression
end
PWAR = PWARegression
Rectangle = PWAR.Rectangle

rect = Rectangle([1, 2], [3, 4])

@testset "rect in and distance" begin
    @test [1.5, 2.5] ∈ rect
    @test [3.5, 2.5] ∉ rect
    @test PWAR.distance(rect, [5, 6]) ≈ 2
    @test PWAR.distance(rect, [0, 0]) ≈ 2
    @test PWAR.distance(rect, [2.7, 3.7]) ≈ -0.3
end