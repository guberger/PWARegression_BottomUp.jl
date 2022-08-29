function expand_bounds!(lb, ub, subgraph::Subgraph)
    ks = eachindex(lb, ub)
    for inode in subgraph.inodes
        for k in ks
            lb[k] = min(lb[k], subgraph.graph.nodes[inode].x[k])
            ub[k] = max(ub[k], subgraph.graph.nodes[inode].x[k])
        end
    end    
end

function generate!(lb, ub, inodes, subgraph::Subgraph, nx, ny)
    expand_bounds!(lb, ub, subgraph)
    for (inode, node) in enumerate(subgraph.graph.nodes)
        if all(z -> z[1] ≤ z[2] ≤ z[3], zip(lb, node.x, ub))
            push!(inodes, inode)
        end
    end
    M = fill(NaN, nx, length(inodes))
    N = fill(NaN, ny, length(inodes))
    for (t, inode) in enumerate(inodes)
        for k in 1:nx
            M[k, t] = subgraph.graph.nodes[inode].x[k]
        end
        for k in 1:ny
            N[k, t] = subgraph.graph.nodes[inode].y[k]
        end
    end
    return N / M
end