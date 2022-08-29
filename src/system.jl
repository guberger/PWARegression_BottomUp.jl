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
Base.isempty(sys::System) = isempty(sys.models)

function get_values!(ys, imodels, sys::System, x)
    dist_min = Inf
    imodel_out = 0
    for (imodel, model) in enumerate(sys.models)
        dist = distance(model.rect, x)
        if dist ≤ 0
            dist_min = 0.0
            imodel_out = 0
            push!(ys, model.A*x)
            push!(imodels, imodel)
        elseif dist < dist_min
            dist_min = dist
            imodel_out = imodel
        end
    end
    if imodel_out != 0
        @assert dist_min > 0
        push!(ys, sys.models[imodel_out].A*x)
        push!(imodels, imodel_out)
    end
    return imodel_out == 0
end