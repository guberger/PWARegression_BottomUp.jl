function generate(subgraph::Subgraph, nx, ny)
    M = fill(NaN, nx, length(subgraph))
    N = fill(NaN, ny, length(subgraph))
    for (t, inode) in enumerate(subgraph.inodes)
        for k in 1:nx
            M[k, t] = subgraph.graph.nodes[inode].x[k]
        end
        for k in 1:ny
            N[k, t] = subgraph.graph.nodes[inode].y[k]
        end
    end
    try
        A = N / M
        return A, norm(A*M - N)^2
    catch
        @warn("Catching SingularException")
        A = (N*M') / (M*M' + 1e-6*I)
        return A, norm(A*M - N)^2
    end    
end
