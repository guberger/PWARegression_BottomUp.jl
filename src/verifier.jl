struct Verifier{ST<:System,GT<:Subgraph}
    sys::ST
    subgraph::GT
end

function verify!(ys, imodels, verif::Verifier)
    err_max = -Inf
    inode_opt = 0
    graph = verif.subgraph.graph
    for inode in verif.subgraph.inodes
        empty!(ys)
        empty!(imodels)
        get_values!(ys, imodels, verif.sys, graph.nodes[inode].x)
        @assert !isempty(ys)
        err = maximum(y -> norm(y - graph.nodes[inode].y), ys)
        if err > err_max
            err_max = err
            inode_opt = inode
        end
    end
    return inode_opt, err_max
end