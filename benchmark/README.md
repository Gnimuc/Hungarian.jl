## Benchmark Results
```julia
julia> versioninfo()
Julia Version 0.6.1-pre.0
Commit dcf39a1dda* (2017-06-19 13:06 UTC)
Platform Info:
  OS: macOS (x86_64-apple-darwin16.6.0)
  CPU: Intel(R) Core(TM) i5-6267U CPU @ 2.90GHz
  WORD_SIZE: 64
  BLAS: libopenblas (USE64BITINT DYNAMIC_ARCH NO_AFFINITY Haswell)
  LAPACK: libopenblas64_
  LIBM: libopenlibm
  LLVM: libLLVM-3.9.1 (ORCJIT, skylake)

julia> using PkgBenchmark

julia> results = benchmarkpkg("Hungarian", "speedup", script = "$(Pkg.dir("Hungarian"))/benchmark/vsMunkres.jl")
julia> showall(results)
2-element BenchmarkTools.BenchmarkGroup:
  tags: []
  "Munkres" => 8-element BenchmarkTools.BenchmarkGroup:
	  tags: []
	  "10 x 10" => Trial(115.432 μs)
	  "100 x 100" => Trial(3.920 ms)
	  "50 x 50" => Trial(1.036 ms)
	  "200 x 200" => Trial(20.519 ms)
	  "1000 x 1000" => Trial(3.729 s)
	  "400 x 400" => Trial(191.800 ms)
	  "800 x 800" => Trial(1.882 s)
	  "2000 x 2000" => Trial(37.124 s)
  "Hungarian" => 8-element BenchmarkTools.BenchmarkGroup:
	  tags: []
	  "10 x 10" => Trial(12.642 μs)
	  "100 x 100" => Trial(2.703 ms)
	  "50 x 50" => Trial(341.716 μs)
	  "200 x 200" => Trial(15.236 ms)
	  "1000 x 1000" => Trial(2.936 s)
	  "400 x 400" => Trial(129.807 ms)
	  "800 x 800" => Trial(1.438 s)
	  "2000 x 2000" => Trial(25.777 s)

julia> judge(mean(results["Hungarian"]), mean(results["Munkres"]))
8-element BenchmarkTools.BenchmarkGroup:
  tags: []
  "10 x 10" => TrialJudgement(-86.46% => improvement)
  "100 x 100" => TrialJudgement(-33.29% => improvement)
  "50 x 50" => TrialJudgement(-68.69% => improvement)
  "200 x 200" => TrialJudgement(-30.69% => improvement)
  "1000 x 1000" => TrialJudgement(-23.13% => improvement)
  "400 x 400" => TrialJudgement(-34.23% => improvement)
  "800 x 800" => TrialJudgement(-24.00% => improvement)
  "2000 x 2000" => TrialJudgement(-30.57% => improvement)
```

### Table: the average elapsed time
| rand(n,n)  | Hungarian.jl| [Munkres.jl](https://github.com/FugroRoames/Munkres.jl) |  [Matlab(R2016a) Implementation by Yi Cao](http://cn.mathworks.com/matlabcentral/fileexchange/20652-hungarian-algorithm-for-linear-assignment-problems--v2-3-)|
|:-:|:-:|:-:|:-:|
| 10x10 | **26.157 μs**  | 193.124 μs   | 284.57 μs |
| 50x50 | **408.596 μs**  | 1.305 ms  | 6.167 ms |
| 100x100|**3.119 ms** | 4.675 ms   | 22.5 ms |
| 200x200|**16.660 ms**  | 24.037 ms   | 110.2 ms |
| 400x400|**138.096 ms** | 209.974 ms   | 518.7 ms|
| 800x800|**1.461 s**   | 1.923 s  | 2.726 s |
| 1000x1000| **2.941 s**| 3.826 s  | 5.071 s |
| 2000x2000| **25.777 s**| 37.124 s |52.0212 |

A Matlab implementation of the algorithm is shown here as a rough baseline.
