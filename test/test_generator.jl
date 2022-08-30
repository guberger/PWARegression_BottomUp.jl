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

@testset "length graph" begin
    @test length(graph) == 125
end

subgraph = PWAR.Subgraph(graph, BitSet(1:length(graph)-2))
A, res = PWAR.generate(subgraph, 3, 1)

@testset "generate" begin
    @test A ≈ [1 2 1-2/(length(graph) - 2)]
    @test res ≈ (length(graph) - 4)*(2/(length(graph) - 2))^2 +
        2*(1-2/(length(graph) - 2))^2
end


