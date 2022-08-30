using LinearAlgebra
using Test
@static if isdefined(Main, :TestLocal)
    include("../src/PWARegression.jl")
else
    using PWARegression
end
PWAR = PWARegression

MT = PWAR.Model{Matrix{Int},PWAR.Rectangle{Vector{Int}}}
sys = PWAR.System(MT[])

@testset "length #0" begin
    @test length(sys) == 0
    @test isempty(sys)
end

PWAR.add_model!(sys, PWAR.Model([1 2], PWAR.Rectangle([1, 2], [3, 4])))
PWAR.add_model!(sys, PWAR.Model([3 5], PWAR.Rectangle([2, 3], [4, 5])))

@testset "length #1" begin
    @test length(sys) == 2
end

res, D, imodel = PWAR.get_residual(sys, [2, 3], [0])

@testset "values 1" begin
    @test D ≈ -1
    @test imodel == 1
    @test res ≈ 8
end

res, D, imodel = PWAR.get_residual(sys, [2.5, 3.5], [0])

@testset "values 1 and 2 -> 1" begin
    @test D ≈ -0.5
    @test imodel == 1
    @test res ≈ 9.5
end

res, D, imodel = PWAR.get_residual(sys, [1.5, 2.5], [6.5])

@testset "values 1" begin
    @test D ≈ -0.5
    @test imodel == 1
    @test res ≈ 0
end

res, D, imodel = PWAR.get_residual(sys, [3.5, 5], [0])

@testset "values 2" begin
    @test D ≈ 0
    @test imodel == 2
    @test res ≈ 35.5
end

res, D, imodel = PWAR.get_residual(sys, [3, 1], [5])

@testset "values 1 and 2 -> 1" begin
    @test D ≈ 1
    @test imodel == 1
    @test res ≈ 0
end

res, D, imodel = PWAR.get_residual(sys, [1.5, 5], [29.5])

@testset "values 2" begin
    @test D ≈ 0.5
    @test imodel == 2
    @test res ≈ 0
end

res, D, imodel = PWAR.get_residual(sys, [4, 2], [0])

@testset "values 1 and 2 -> 1" begin
    @test D ≈ 1
    @test imodel == 1
    @test res ≈ 8
end