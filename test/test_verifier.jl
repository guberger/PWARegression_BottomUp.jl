using LinearAlgebra
using Test
@static if isdefined(Main, :TestLocal)
    include("../src/PWARegression.jl")
else
    using PWARegression
end
PWAR = PWARegression

MT = PWAR.Model{Matrix{Float64},PWAR.Rectangle{Vector{Int}}}
sys = PWAR.System{MT}()
PWAR.add_model!(sys, PWAR.Model([1.0 2.0], PWAR.Rectangle([1, 2], [3, 4])))
PWAR.add_model!(sys, PWAR.Model([3.0 5.0], PWAR.Rectangle([2, 3], [4, 5])))

NT = PWAR.Node{Vector{Float64},Vector{Int}}
graph = PWAR.Graph{NT}()
PWAR.add_node!(graph, PWAR.Node([2.0, 0.0], [4]))
PWAR.add_node!(graph, PWAR.Node([3.0, 4.0], [29]))
PWAR.add_node!(graph, PWAR.Node([5.0, 2.0], [20]))
PWAR.add_node!(graph, PWAR.Node([9.0, 9.0], [200]))

subgraph = PWAR.Subgraph(graph, BitSet([1, 2, 3]))

ys = Vector{Float64}[]
imodels = Int[]

verif = PWAR.Verifier(sys, subgraph)

inode, err = PWAR.verify!(ys, imodels, verif)

@testset "verify" begin
    @test inode == 2
    @test err ≈ 18
end

graph.nodes[2].x[1] = 3.001

inode, err = PWAR.verify!(ys, imodels, verif)

@testset "verify" begin
    @test inode == 3
    @test err ≈ 5
end