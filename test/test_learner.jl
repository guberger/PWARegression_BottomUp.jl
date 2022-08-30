using LinearAlgebra
using Test
@static if isdefined(Main, :TestLocal)
    include("../src/PWARegression.jl")
else
    using PWARegression
end
PWAR = PWARegression

NT = PWAR.Node{Vector{Float64},Vector{Float64}}
graph = PWAR.Graph(NT[])
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

cluster = PWAR.learn_system(graph, 3, 3, 1)

@testset "learn_system" begin
    @test isempty(cluster.out_subgraph.inodes)
    @test Set([subgraph.inodes for subgraph in cluster.subgraphs]) ∈
        (
            Set([
                Set(1:length(graph)-4),
                Set([length(graph) - 3, length(graph) - 1]),
                Set([length(graph)-2, length(graph)])
            ]),
            Set([
                Set(1:length(graph)-4),
                Set([length(graph) - 3, length(graph)]),
                Set([length(graph) - 2, length(graph) - 1])
            ])
        )
    @test sum(cluster.res_list) < 1e-9
    @test any(model -> model.A ≈ Aref, cluster.sys.models)
end