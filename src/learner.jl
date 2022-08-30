struct Cluster{GT<:Subgraph,ST<:System}
    subgraphs::Vector{GT}
    out_subgraph::GT
    sys::ST
    res_list::Vector{Float64}
end

function learn_system(graph::Graph, nmodel, nx, ny; rad=1e9)
    subgraphs = [Subgraph(graph, BitSet()) for q = 1:nmodel]
    out_subgraph = Subgraph(graph, BitSet(1:length(graph)))
    res_list = fill(NaN, nmodel)
    sys = System(Model{Matrix{Float64},Rectangle{Vector{Float64}}}[])
    for (q, subgraph) in enumerate(subgraphs)
        rect = Rectangle(fill(rad, nx), fill(-rad, nx))
        A, res = generate(subgraph, nx, ny)
        model = Model(A, rect)
        add_model!(sys, model)
        res_list[q] = res
    end
    cluster = Cluster(subgraphs, out_subgraph, sys, res_list)
    pq = PriorityQueue(cluster => sum(res_list))

    while !isempty(pq)
        cluster = dequeue!(pq)
        inode, res, D, imodel = verify(cluster.sys, cluster.out_subgraph)
        iszero(inode) && return cluster
        @assert D > 0
        @assert !iszero(imodel)
        node = graph.nodes[inode]

        for q = 1:nmodel
            sys = System(copy(cluster.sys.models))
            subgraphs = copy(cluster.subgraphs)
            lb = min.(sys.models[q].rect.lb, node.x)
            ub = max.(sys.models[q].rect.ub, node.x)
            rect = Rectangle(lb, ub)
            inodes = copy(cluster.subgraphs[q].inodes)
            out_subgraph = Subgraph(graph, copy(cluster.out_subgraph.inodes))
            for (inode, node) in enumerate(graph.nodes)
                inode ∈ inodes && continue
                if node.x ∈ rect
                    push!(inodes, inode)
                    delete!(out_subgraph.inodes, inode)
                end
            end
            subgraphs[q] = Subgraph(graph, inodes)
            A, res = generate(subgraphs[q], nx, ny)
            sys.models[q] = Model(A, rect)
            res_list = copy(cluster.res_list)
            res_list[q] = res
            new_cluster = Cluster(subgraphs, out_subgraph, sys, res_list)
            enqueue!(pq, new_cluster => sum(res_list))
        end
    end

    error("Problem...")
end