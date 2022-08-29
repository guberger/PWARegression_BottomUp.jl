using Test
@static if isdefined(Main, :TestLocal)
    include("../src/PWARegression.jl")
else
    using PWARegression
end
PWAR = PWARegression

MT = PWAR.Model{Matrix{Int},PWAR.Rectangle{Vector{Int}}}
sys = PWAR.System{MT}()

@testset "length #0" begin
    @test length(sys) == 0
end

PWAR.add_model!(sys, PWAR.Model([1 2], PWAR.Rectangle([1], [1, 2])))
PWAR.add_model!(sys, PWAR.Model([1 2], PWAR.Rectangle([1], [1, 2])))

@testset "length #1" begin
    @test length(sys) == 2
end