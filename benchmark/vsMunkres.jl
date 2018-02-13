using BenchmarkTools
using Hungarian
using Munkres

const seed = srand(7)
const SUITE = BenchmarkGroup()

SUITE["Hungarian.jl"] = BenchmarkGroup()
SUITE["Munkres.jl"] = BenchmarkGroup()

for n in [10, 50, 100, 200, 400, 800, 1000, 2000]
    A = rand(seed, n, n)
    SUITE["Hungarian.jl"]["$n x $n"] = @benchmarkable hungarian($A)
    SUITE["Munkres.jl"]["$n x $n"] = @benchmarkable munkres($A)
end
