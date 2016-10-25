using Hungarian
using Base.Test

# test for simple examples
println("Simple examples:")

A = [ 0.891171  0.0320582   0.564188  0.8999    0.620615;
      0.166402  0.861136    0.201398  0.911772  0.0796335;
      0.77272   0.782759    0.905982  0.800239  0.297333;
      0.561423  0.170607    0.615941  0.960503  0.981906;
      0.748248  0.00799335  0.554215  0.745299  0.42637]

assign, cost = hungarian(A)
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

assign, cost = hungarian(ones(5,5) - eye(5))
@test assign == [1, 2, 3, 4, 5]
@test cost == 0

println("Passed!")

# test for random examples with Munkres.jl
using Munkres

println("Random examples:")
println("  rand(300,300):")
A = rand(300,300)
@time assignH, costH = hungarian(A)
@time assignM = munkres(A)
@test assignH == assignM

println("  rand(200,400):")
A = rand(200,400)
@time assignH, costH = hungarian(A)
@time assignM = munkres(A)
@test assignH == assignM

println("  rand(500,250):")
A = rand(300,150)
@time assignH, costH = hungarian(A)
@time assignM = munkres(A)
@test assignH == assignM

for i = 1:100
    A = rand(50,50)
    assignH, costH = hungarian(A)
    assignM = munkres(A)

    costM = 0
    for i in zip(1:size(A,1), assignM)
        if i[2] != 0
            costM += A[i...]
        end
    end

    @test assignH == assignM
    @test costH == costM
end

println("Passed!")
println("All tests passed!")
