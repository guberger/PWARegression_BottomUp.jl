module PWARegression

using LinearAlgebra
using StaticArrays
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

Graph{NT}() where NT = Graph(NT[])
add_node!(graph::Graph, node::Node) = push!(graph.nodes, node)
Base.length(graph::Graph) = length(graph.nodes)

struct Model{AT<:AbstractMatrix,RT<:Rectangle}
    A::AT
    rect::RT
end

struct System{MT<:Model}
    models::Vector{MT}
end

System{MT}() where MT = System(MT[])
add_model!(sys::System, model::Model) = push!(sys.models, model)
Base.length(sys::System) = length(sys.models)

#=
function learn_pwar(
        graph::Graph{NT}, nsubs::NTuple{NX,Int}
    ) where {NX,NY,NT<:Node{NX,NY}}
    @assert all(nsub -> nsub ≥ 1, nsubs)
    xmin, xmax = get_xlims(graph)
    nsubs_ = map(nsub -> 1:nsub, nsubs)
    indexes = Iterators.product(nsubs_...)
    clusters = Dict{NTuple{NX,Int},Graph{NT}}()
    models = Dict{NTuple{NX,Int},SMatrix{NY,NX,Float64}}()
    for idx in indexes
        clusters[idx] = Graph{NT}()
        models[idx] = zeros(SMatrix{NY,NX})
    end
    est_tilings = ntuple(k -> Tiling(), Val(NX))
    out_tilings = ntuple(k -> Tiling(), Val(NX))
    for (k, nsub) in enumerate(nsubs)
        seps = range(xmin[k], xmax[k], length=nsub + 1)
        for isub = 1:nsub
            add_segment!(est_tilings[k], Segment(seps[isub], seps[isub + 1]))
        end
        add_segment!(out_tilings[k], Segment(xmin[k], xmax[k]))
    end
        
    cand = Candidate(
        clusters, models, est_tilings, out_tilings, Set{Int}(1:length(graph))
    )
    pq = PriorityQueue(cand => 0.0)

    while !isempty(pq)
        cand = dequeue!(pq)
        isubs = ntuple(k -> Int[], Val(NX))
        for node in graph.nodes
            is_explained = false
            empty!.(isubs)
            for idx in indexes
                !all(
                    k -> node.x[k] ∈ est_tilings[k].segs[idx[k]],
                    1:NX
                ) && continue



                    
                    est_tilings[k][idx[k]]))
                for (isub, lim) in enumerate(lims)
                    if lim[1] ≤ node.x[k] ≤ lim[2]





end
=#

end # module
