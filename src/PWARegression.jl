module PWARegression

using LinearAlgebra
using DataStructures

struct Rectangle{VT<:AbstractVector}
    lb::VT
    ub::VT
end

Base.in(x, rect::Rectangle) = all(
    z -> z[1] ≤ z[2] ≤ z[3],
    zip(rect.lb, x, rect.ub)
)
distance(rect::Rectangle, x) = maximum(
    z -> max(z[1] - z[2], z[2] - z[3]),
    zip(rect.lb, x, rect.ub)
)

struct Node{VTX<:AbstractVector,VTY<:AbstractVector}
    x::VTX
    y::VTY
end

struct Graph{NT<:Node}
    nodes::Vector{NT}
end

add_node!(graph::Graph, node::Node) = push!(graph.nodes, node)
Base.length(graph::Graph) = length(graph.nodes)

struct Subgraph{GT<:Graph,ST<:AbstractSet{Int}}
    graph::GT
    inodes::ST
end

add_inode!(subgraph::Subgraph, inode::Int) = push!(subgraph.inodes, inode)
Base.length(subgraph::Subgraph) = length(subgraph.inodes)

include("system.jl")
include("generator.jl")
include("verifier.jl")
include("learner.jl")

end # module
