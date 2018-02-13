# Benchmark
The following snippets can be used for generating benchmarks on your own machine.

## Generate benchmark report
```julia
# note that, you may need to checkout PkgBenchmark's master(version number > 0.0.2)
using PkgBenchmark

# run benchmarks
results = benchmarkpkg("Hungarian", "master")

# show results in REPL
julia> showall(results.benchmarkgroup["square"])
2-element BenchmarkTools.BenchmarkGroup:
  tags: ["square-matrix"]
  "Float64" => 8-element BenchmarkTools.BenchmarkGroup:
	  tags: ["float"]
	  "10 x 10" => Trial(7.290 μs)
	  "100 x 100" => Trial(1.269 ms)
	  "50 x 50" => Trial(157.023 μs)
	  "200 x 200" => Trial(5.556 ms)
	  "1000 x 1000" => Trial(551.200 ms)
	  "400 x 400" => Trial(35.454 ms)
	  "800 x 800" => Trial(276.863 ms)
	  "2000 x 2000" => Trial(4.910 s)
  "UInt16" => 7-element BenchmarkTools.BenchmarkGroup:
	  tags: ["integer"]
	  "8000 x 8000" => Trial(4.146 s)
	  "100 x 100" => Trial(1.008 ms)
	  "4000 x 4000" => Trial(1.386 s)
	  "500 x 500" => Trial(53.403 ms)
	  "1000 x 1000" => Trial(172.513 ms)
	  "16000 x 16000" => Trial(13.847 s)
	  "2000 x 2000" => Trial(476.905 ms)

# generate a detailed report in `benchmark` folder
export_markdown(joinpath(Pkg.dir("Hungarian"), "benchmark", "benchmark.md"), results)

# or upload to Gist
using GitHub
gist_json = JSON.parse(
                   """
                   {
                   "description": "A benchmark for PkgBenchmark",
                   "public": true,
                   "files": {
                       "benchmark.md": {
                       "content": "$(escape_string(sprint(export_markdown, results)))"
                       }
                   }
                   }
                   """
               )
posted_gist = create_gist(params = gist_json);

url = get(posted_gist.html_url)
```

## Generate judgement report
```julia
# note that, you may need to checkout PkgBenchmark's master(version number > 0.0.2)
using PkgBenchmark

# run benchmarks
results = judge("Hungarian", "target-branch", "master")

# generate a detailed report in `benchmark` folder
export_markdown(joinpath(Pkg.dir("Hungarian"), "benchmark", "judgement.md"), results)

```


## Comparing with Munkres.jl
```julia
# note that, you may need to checkout PkgBenchmark's master(version number > 0.0.2)
using PkgBenchmark

# run benchmarks
results = benchmarkpkg("Hungarian", "master", script = "$(Pkg.dir("Hungarian"))/benchmark/vsMunkres.jl")
hungarianResult = results.benchmarkgroup["Hungarian.jl"]
munkresResult = results.benchmarkgroup["Munkres.jl"]

# judge the results using Munkres.jl as a baseline
julia> judge(mean(hungarianResult), mean(munkresResult))
8-element BenchmarkTools.BenchmarkGroup:
  tags: []
  "10 x 10" => TrialJudgement(-95.07% => improvement)
  "100 x 100" => TrialJudgement(-71.36% => improvement)
  "50 x 50" => TrialJudgement(-81.13% => improvement)
  "200 x 200" => TrialJudgement(-77.27% => improvement)
  "1000 x 1000" => TrialJudgement(-85.69% => improvement)
  "400 x 400" => TrialJudgement(-82.28% => improvement)
  "800 x 800" => TrialJudgement(-85.22% => improvement)
  "2000 x 2000" => TrialJudgement(-85.80% => improvement)
```

## Table: the average elapsed time
| rand(n,n)  | Hungarian.jl| [Munkres.jl](https://github.com/FugroRoames/Munkres.jl) |  [Matlab(R2016a) Implementation by Yi Cao](http://cn.mathworks.com/matlabcentral/fileexchange/20652-hungarian-algorithm-for-linear-assignment-problems--v2-3-)|
|:-:|:-:|:-:|:-:|
| 10x10 | **7.289 μs**  | 100.227 μs   | 284.57 μs |
| 50x50 | **157.364 μs**  | 811.633 μs  | 6.167 ms |
| 100x100|**1.263 ms** | 4.254 ms   | 22.5 ms |
| 200x200|**5.543 ms**  | 26.014 ms   | 110.2 ms |
| 400x400|**35.033 ms** | 230.995 ms   | 518.7 ms|
| 800x800|**285.036 ms**   | 2.056 s  | 2.726 s |
| 1000x1000| **557.108 ms**| 3.988 s  | 5.071 s |
| 2000x2000| **4.960 s**| 35.633 s | 52.0212 s |

A Matlab implementation of the algorithm is shown here as a rough baseline.

(This table might be outdated, so don't take it so seriously, just treat it as a vague reference.
I don't wanna keep updating these figures in the future, cause users can reproduce it with the above mentioned snippets on their own machine.)
