function generate(subgraph::Subgraph, nx, ny)
    M = fill(NaN, nx, length(subgraph.inodes))
    N = fill(NaN, ny, length(subgraph.inodes))
    for (t, inode) in enumerate(subgraph.inodes)
        for k in 1:nx
            M[k, t] = subgraph.graph.nodes[inode].x[k]
        end
        for k in 1:ny
            N[k, t] = subgraph.graph.nodes[inode].y[k]
        end
    end
    A = N / M
    return A, norm(A*M - N)^2
end