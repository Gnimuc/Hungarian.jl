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

julia> results = benchmarkpkg("Hungarian", "master", script = "$(Pkg.dir("Hungarian"))/benchmark/vsMunkres.jl")

julia> showall(ans)
2-element BenchmarkTools.BenchmarkGroup:
  tags: []
  "Munkres" => 8-element BenchmarkTools.BenchmarkGroup:
	  tags: []
	  "10 x 10" => Trial(100.983 μs)
	  "100 x 100" => Trial(4.084 ms)
	  "50 x 50" => Trial(999.093 μs)
	  "200 x 200" => Trial(22.280 ms)
	  "1000 x 1000" => Trial(4.221 s)
	  "400 x 400" => Trial(213.737 ms)
	  "800 x 800" => Trial(2.075 s)
	  "2000 x 2000" => Trial(40.094 s)
  "Hungarian" => 8-element BenchmarkTools.BenchmarkGroup:
	  tags: []
	  "10 x 10" => Trial(7.308 μs)
	  "100 x 100" => Trial(1.326 ms)
	  "50 x 50" => Trial(161.923 μs)
	  "200 x 200" => Trial(5.899 ms)
	  "1000 x 1000" => Trial(555.522 ms)
	  "400 x 400" => Trial(36.309 ms)
	  "800 x 800" => Trial(278.622 ms)
	  "2000 x 2000" => Trial(5.064 s)

julia> judge(mean(results["Hungarian"]), mean(results["Munkres"]))
8-element BenchmarkTools.BenchmarkGroup:
  tags: []
  "10 x 10" => TrialJudgement(-94.44% => improvement)
  "100 x 100" => TrialJudgement(-69.28% => improvement)
  "50 x 50" => TrialJudgement(-84.53% => improvement)
  "200 x 200" => TrialJudgement(-73.00% => improvement)
  "1000 x 1000" => TrialJudgement(-86.55% => improvement)
  "400 x 400" => TrialJudgement(-81.85% => improvement)
  "800 x 800" => TrialJudgement(-86.02% => improvement)
  "2000 x 2000" => TrialJudgement(-87.37% => improvement)
```

### Table: the average elapsed time
| rand(n,n)  | Hungarian.jl| [Munkres.jl](https://github.com/FugroRoames/Munkres.jl) |  [Matlab(R2016a) Implementation by Yi Cao](http://cn.mathworks.com/matlabcentral/fileexchange/20652-hungarian-algorithm-for-linear-assignment-problems--v2-3-)|
|:-:|:-:|:-:|:-:|
| 10x10 | **7.308 μs**  | 193.124 μs   | 284.57 μs |
| 50x50 | **161.923 μs**  | 1.305 ms  | 6.167 ms |
| 100x100|**1.326 ms** | 4.675 ms   | 22.5 ms |
| 200x200|**5.899 ms**  | 24.037 ms   | 110.2 ms |
| 400x400|**36.309 ms** | 209.974 ms   | 518.7 ms|
| 800x800|**278.622 ms**   | 1.923 s  | 2.726 s |
| 1000x1000| **555.522 ms**| 3.826 s  | 5.071 s |
| 2000x2000| **5.064 s**| 37.124 s |52.0212 |

A Matlab implementation of the algorithm is shown here as a rough baseline.
