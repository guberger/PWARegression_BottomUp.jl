struct Model{AT<:AbstractMatrix,RT<:Rectangle}
    A::AT
    rect::RT
end

struct System{MT<:Model}
    models::Vector{MT}
end

add_model!(sys::System, model::Model) = push!(sys.models, model)
Base.length(sys::System) = length(sys.models)
Base.isempty(sys::System) = isempty(sys.models)

function get_residual(sys::System, x, y)
    dist_min = Inf
    imodel_opt = 0
    res = -Inf
    for (imodel, model) in enumerate(sys.models)
        dist = distance(model.rect, x)
        if dist < dist_min
            dist_min = dist
            imodel_opt = imodel
            res = norm(sys.models[imodel_opt].A*x - y)
        end
    end
    return res, dist_min, imodel_opt
end