using LinearAlgebra
using Test
@static if isdefined(Main, :TestLocal)
    include("../src/PWARegression.jl")
else
    using PWARegression
end
PWAR = PWARegression

MT = PWAR.Model{Matrix{Int},PWAR.Rectangle{Vector{Int}}}
sys = PWAR.System{MT}()

@testset "length #0" begin
    @test length(sys) == 0
    @test isempty(sys)
end

PWAR.add_model!(sys, PWAR.Model([1 2], PWAR.Rectangle([1, 2], [3, 4])))
PWAR.add_model!(sys, PWAR.Model([3 5], PWAR.Rectangle([2, 3], [4, 5])))

@testset "length #1" begin
    @test length(sys) == 2
end

ys = Vector{Int}[]
imodels = Int[]

isin = PWAR.get_values!(ys, imodels, sys, [2, 3])

@testset "values 2 in edge" begin
    @test isin
    @test length(ys) == length(imodels) == 2
    @test 1 ∈ imodels
    @test 2 ∈ imodels
    @test minimum(y -> norm(y - [8]), ys) < 1e-6
    @test minimum(y -> norm(y - [21]), ys) < 1e-6
end

ys = Vector{Float64}[]
imodels = Int[]

isin = PWAR.get_values!(ys, imodels, sys, [2.5, 3.5])

@testset "values 2 in interior" begin
    @test isin
    @test length(ys) == length(imodels) == 2
    @test 1 ∈ imodels
    @test 2 ∈ imodels
    @test minimum(y -> norm(y - [9.5]), ys) < 1e-6
    @test minimum(y -> norm(y - [25]), ys) < 1e-6
end

empty!(ys)
empty!(imodels)

isin = PWAR.get_values!(ys, imodels, sys, [1.5, 2.5])

@testset "values 1 in" begin
    @test isin
    @test length(ys) == length(imodels) == 1
    @test 1 ∈ imodels
    @test minimum(y -> norm(y - [6.5]), ys) < 1e-6
end

empty!(ys)
empty!(imodels)

isin = PWAR.get_values!(ys, imodels, sys, [3.5, 5])

@testset "values 1 in edge" begin
    @test isin
    @test length(ys) == length(imodels) == 1
    @test 2 ∈ imodels
    @test minimum(y -> norm(y - [35.5]), ys) < 1e-6
end

empty!(ys)
empty!(imodels)

isin = PWAR.get_values!(ys, imodels, sys, [3, 1])

@testset "values 1 out" begin
    @test !isin
    @test length(ys) == length(imodels) == 1
    @test 1 ∈ imodels
    @test minimum(y -> norm(y - [5]), ys) < 1e-6
end

empty!(ys)
empty!(imodels)

isin = PWAR.get_values!(ys, imodels, sys, [1.5, 5])

@testset "values 1 out" begin
    @test !isin
    @test length(ys) == length(imodels) == 1
    @test 2 ∈ imodels
    @test minimum(y -> norm(y - [29.5]), ys) < 1e-6
end

empty!(ys)
empty!(imodels)

isin = PWAR.get_values!(ys, imodels, sys, [4, 2])

@testset "values 1 out" begin
    @test !isin
    @test length(ys) == length(imodels) == 1
end