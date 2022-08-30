using LinearAlgebra
using Test
@static if isdefined(Main, :TestLocal)
    include("../src/PWARegression.jl")
else
    using PWARegression
end
PWAR = PWARegression

MT = PWAR.Model{Matrix{Float64},PWAR.Rectangle{Vector{Int}}}
sys = PWAR.System(MT[])
PWAR.add_model!(sys, PWAR.Model([1.0 2.0], PWAR.Rectangle([1, 2], [3, 4])))
PWAR.add_model!(sys, PWAR.Model([3.0 5.0], PWAR.Rectangle([2, 3], [4, 5])))

NT = PWAR.Node{Vector{Float64},Vector{Int}}
graph = PWAR.Graph(NT[])
PWAR.add_node!(graph, PWAR.Node([2.0, 0.0], [4]))
PWAR.add_node!(graph, PWAR.Node([3.0, 4.0], [29]))
PWAR.add_node!(graph, PWAR.Node([5.0, 2.0], [20]))
PWAR.add_node!(graph, PWAR.Node([9.0, 9.0], [200]))

subgraph = PWAR.Subgraph(graph, BitSet([1, 2, 3]))

inode, res, D, imodel = PWAR.verify(sys, subgraph)

@testset "verify" begin
    @test inode == 3
    @test res ≈ 5
    @test D ≈ 1
    @test imodel == 2
end

graph.nodes[1].y[1] = 30

inode, res, D, imodel = PWAR.verify(sys, subgraph)

@testset "verify" begin
    @test inode == 1
    @test res ≈ 28
    @test D ≈ 2
    @test imodel == 1
end

MT = PWAR.Model{Matrix{Float64},PWAR.Rectangle{Vector{Float64}}}
sys = PWAR.System(MT[])
PWAR.add_model!(sys, PWAR.Model(zeros(1, 1), PWAR.Rectangle([1e9], [-1e9])))
PWAR.add_model!(sys, PWAR.Model(zeros(1, 1), PWAR.Rectangle([1e9], [-1e9])))

NT = PWAR.Node{Vector{Int},Vector{Int}}
graph = PWAR.Graph(NT[])
PWAR.add_node!(graph, PWAR.Node([2], [4]))
PWAR.add_node!(graph, PWAR.Node([3], [29]))
PWAR.add_node!(graph, PWAR.Node([5], [20]))
PWAR.add_node!(graph, PWAR.Node([9], [200]))

subgraph = PWAR.Subgraph(graph, BitSet(1:4))

inode, res, D, imodel = PWAR.verify(sys, subgraph)

@testset "verify" begin
    @test inode == 4
    @test res ≈ 200
    @test D ≈ 1e9
    @test imodel == 1
end