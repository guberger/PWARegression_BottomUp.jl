using Random
using PyPlot

Random.seed!(0)

include("../src/PWARegression.jl")
PWAR = PWARegression

np = 1000
x_list = [vcat(rand(2) .- 0.5, 1) for t = 1:np]
pwa_func(x) = x[1] > 0 ? [x[3] + x[2]] + randn(1)*0.1 :
    x[2] > 0 ? [x[3] + x[1]] : [- x[1] - x[2]]
pwa_func(x) = [sin(x[1]*5) + x[3]]
y_list = map(pwa_func, x_list)

fig = figure(0)
ax = fig.add_subplot(projection="3d")
ax.set_zlim(0, 2.1)
ax.plot(
    getindex.(x_list, 1), getindex.(x_list, 2), getindex.(y_list, 1),
    ls="none", marker="."
)

NT = PWAR.Node{Vector{Float64},Vector{Float64}}
graph = PWAR.Graph(NT[])
for (x, y) in zip(x_list, y_list)
    PWAR.add_node!(graph, PWAR.Node(x, y))
end

cluster = PWAR.learn_system(graph, 3, 3, 1)

for model in cluster.sys.models
    x1_ = range(model.rect.lb[1], model.rect.ub[1], length=10)
    x2_ = range(model.rect.lb[2], model.rect.ub[2], length=10)
    X_ = collect(
        (collect(xt) for xt in Iterators.product(x1_, x2_, [1]))
    )[:, :, 1]
    X1_ = getindex.(X_, 1)
    X2_ = getindex.(X_, 2)
    Y_ = map(x -> model.A*x, X_)
    Y1_ = getindex.(Y_, 1)
    ax.plot_surface(X1_, X2_, Y1_)
end

ax.view_init(elev=22., azim=-90)
fig.savefig("./examples/figures/sine.png", bbox_inches="tight", dpi=100)
