using StaticArrays
using Test
@static if isdefined(Main, :TestLocal)
    include("../src/PWARegression.jl")
else
    using PWARegression
end
PWAR = PWARegression

NT = PWAR.Node{SVector{2,Int},SVector{3,Int}}
graph = PWAR.Graph{NT}()

@testset "length #0" begin
    @test length(graph) == 0
end

PWAR.add_node!(graph, PWAR.Node(SVector(1, 2), SVector(2, 3, 4)))
PWAR.add_node!(graph, PWAR.Node(SVector(0, 5), SVector(2, 3, 4)))

@testset "length #1" begin
    @test length(graph) == 2
end