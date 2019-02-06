using BenchmarkTools
using Random, Statistics
using Hungarian

const seed = Random.seed!(7)
const SUITE = BenchmarkGroup()

SUITE["square"] = BenchmarkGroup(["square-matrix"])
SUITE["square"]["Float64"] = BenchmarkGroup(["float"])
SUITE["square"]["UInt16"] = BenchmarkGroup(["integer"])

for n in [10, 50, 100, 200, 400, 800, 1000, 2000]
    A = rand(seed, n, n)
    SUITE["square"]["Float64"]["$n x $n"] = @benchmarkable hungarian($A)
end

for n in [100, 500, 1000, 2000, 4000, 8000, 16000]
    A = rand(seed, UInt16, n, n)
    SUITE["square"]["UInt16"]["$n x $n"] = @benchmarkable hungarian($A)
end

SUITE["non-square"] = BenchmarkGroup(["non-square-matrix"])
SUITE["non-square"]["Float64"] = BenchmarkGroup(["float"])

for (n, m) in zip([10, 50, 100, 200, 400, 800, 1000], [20, 100, 200, 400, 800, 1000, 2000])
    A = rand(seed, n, m)
    SUITE["non-square"]["Float64"]["$n x $m"] = @benchmarkable hungarian($A)
    A = rand(seed, m, n)
    SUITE["non-square"]["Float64"]["$m x $n"] = @benchmarkable hungarian($A)
end
