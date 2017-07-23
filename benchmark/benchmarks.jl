using PkgBenchmark
using Hungarian
using Munkres

@benchgroup "square matrix" begin
    seed = srand(7)
    for n in [10, 50, 100, 200, 400, 800, 1000, 2000]
        A = rand(seed, n, n)
        @bench "$n x $n" hungarian($A)
    end
end
