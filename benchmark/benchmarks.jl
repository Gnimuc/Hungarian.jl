using PkgBenchmark
using Hungarian
using Munkres

@benchgroup "utf8" ["string", "unicode"] begin
    RNG = srand(7)
    for n in [10, 50, 100, 200, 400, 800, 1000, 2000]
        A = rand(RNG, n, n)
        @bench "Hungarian.jl" hungarian($A)
        @bench "Munkres.jl" munkres($A)
    end
end
