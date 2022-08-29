using LinearAlgebra
using Test
@static if isdefined(Main, :TestLocal)
    include("../src/PWARegression.jl")
else
    using PWARegression
end
PWAR = PWARegression

NT = PWAR.Node{Vector{Float64},Vector{Float64}}
graph = PWAR.Graph{NT}()
Aref = [1 2 1]
for xt in Iterators.product(0:0.1:1, 0:0.2:2)
    local x = vcat(collect(xt), 1.0)
    local y = Aref*x
    PWAR.add_node!(graph, PWAR.Node(x, y))
end
x = [-0.1, 2.2, 1.0]
PWAR.add_node!(graph, PWAR.Node(x, Aref*x .- 1.0))
x = [1.1, -0.2, 1.0]
PWAR.add_node!(graph, PWAR.Node(x, Aref*x .- 1.0))
PWAR.add_node!(graph, PWAR.Node([5.0, 5.0, 1.0], [100.0]))
PWAR.add_node!(graph, PWAR.Node([-5.0, -5.0, 1.0], [100.0]))

@testset "length graph" begin
    @test length(graph) == 125
end

subgraph = PWAR.Subgraph(graph, BitSet([length(graph) - 3, length(graph) - 2]))

lb = [Inf, Inf, Inf]
ub = [-Inf, -Inf, -Inf]

PWAR.expand_bounds!(lb, ub, subgraph)

@testset "expand bounds" begin
    @test lb ≈ [-0.1, -0.2, 1.0]
    @test ub ≈ [1.1, 2.2, 1.0]
end

lb = [Inf, Inf, Inf]
ub = [-Inf, -Inf, -Inf]
inodes = Int[]
A = PWAR.generate!(lb, ub, inodes, subgraph, 3, 1)

@testset "generate" begin
    @test lb ≈ [-0.1, -0.2, 1.0]
    @test ub ≈ [1.1, 2.2, 1.0]
    @test inodes == 1:length(graph)-2
    @test A ≈ [1 2 1-2/(length(graph) - 2)]
end


