function verify(sys::System, subgraph::Subgraph)
    res_max = -Inf
    inode_opt = 0
    dist_opt = -Inf
    imodel_opt = 0
    for inode in subgraph.inodes
        node = subgraph.graph.nodes[inode]
        res, D, imodel = get_residual(sys, node.x, node.y)
        if res > res_max
            res_max = res
            inode_opt = inode
            dist_opt = D
            imodel_opt = imodel
        end
    end
    return inode_opt, res_max, dist_opt, imodel_opt
end