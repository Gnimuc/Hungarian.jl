using Hungarian
using Test
using LinearAlgebra
using DelimitedFiles

@testset "simple examples" begin
    A = [ 0.891171  0.0320582   0.564188  0.8999    0.620615;
          0.166402  0.861136    0.201398  0.911772  0.0796335;
          0.77272   0.782759    0.905982  0.800239  0.297333;
          0.561423  0.170607    0.615941  0.960503  0.981906;
          0.748248  0.00799335  0.554215  0.745299  0.42637]

    assign, cost = @inferred hungarian(A)
    @test assign == [2, 3, 5, 1, 4]

    B = [ 24     1     8;
           5     7    14;
           6    13    20;
          12    19    21;
          18    25     2]

    assign, cost = hungarian(B)
    @test assign == [2, 1, 0, 0, 3]
    @test cost == 8

    assign, cost = hungarian(B')
    @test assign == [2, 1, 5]
    @test cost == 8

    assign, cost = hungarian(ones(5,5) - I)
    @test assign == [1, 2, 3, 4, 5]
    @test cost == 0
end

@testset "forbidden edges" begin
    # result checked against Python package munkres: https://github.com/bmc/munkres/blob/master/munkres.py
    # Python code:
    #   m = Munkres()
    #   matrix = [[DISALLOWED, 1, 1], [1, 0, 1], [1, 1, 0]]
    #   m.compute(matrix)
    # Result: [(0, 1), (1, 0), (2, 2)]
    A = Union{Int, Missing}[missing 1 1; 1 0 1; 1 1 0]
    assign, cost = hungarian(A)
    @test assign == [2, 1, 3]
    @test cost == 2
end

@testset "issue #6" begin
    # load the cost matrix produced from the `solve_LSAP` function contained in the
    # [clue package](https://cran.r-project.org/web/packages/clue/index.html) in R.
    costMatrix = readdlm(joinpath(@__DIR__, "R-clue-cost.txt"))
    assignmentH, costH = hungarian(copy(transpose(costMatrix)))
    assignmentR = vec(readdlm(joinpath(@__DIR__, "R-clue-solution.txt"), Int64))
    costR = sum(costMatrix[ii, assignmentR[ii]] for ii in 1:size(costMatrix,1))
    @test costH ≤ costR
end

@testset "UInt16" begin
    M=UInt16[28092 44837 19882 39481 59139; 
             26039 46258 38932 51057 9; 
             11527 59487 61993 29072 8734; 
             10691 16977 12796 16370 14266; 
             5199  42319 34194 41332 16472]
    assign,cost=hungarian(M)
    @test assign == [3, 5, 4, 2, 1]
    @tets cost   == 71139
end

@testset "UInt8" begin
    M=UInt8[67  228 135 197 244; 
            112 44  84  206 31; 
            225 103 231 225 227; 
            170 37  135 9   130; 
            110 22  133 77  96]
    assign,cost=hungarian(M)
    @test assign == [1, 5, 2, 4, 3]
    @tets cost   == 343
end
