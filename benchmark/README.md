# Benchmark
The following snippets can be used for generating benchmarks on your own machine.

## Generate benchmark report
```julia
using PkgBenchmark

# run benchmarks
results = benchmarkpkg("Hungarian", "master")

# show results in REPL
julia> show(results.benchmarkgroup["square"])
2-element BenchmarkTools.BenchmarkGroup:
  tags: ["square-matrix"]
  "Float64" => 8-element BenchmarkTools.BenchmarkGroup:
      tags: ["float"]
      "10 x 10" => Trial(9.087 μs)
      "100 x 100" => Trial(1.384 ms)
      "50 x 50" => Trial(301.392 μs)
      "200 x 200" => Trial(7.373 ms)
      "1000 x 1000" => Trial(815.554 ms)
      "400 x 400" => Trial(54.179 ms)
      "800 x 800" => Trial(386.477 ms)
      "2000 x 2000" => Trial(6.374 s)
  "UInt16" => 7-element BenchmarkTools.BenchmarkGroup:
      tags: ["integer"]
      "8000 x 8000" => Trial(4.538 s)
      "100 x 100" => Trial(1.353 ms)
      "4000 x 4000" => Trial(1.622 s)
      "500 x 500" => Trial(84.062 ms)
      "1000 x 1000" => Trial(273.474 ms)
      "16000 x 16000" => Trial(13.090 s)
      "2000 x 2000" => Trial(651.013 ms)

# generate a detailed report in `benchmark` folder
using Pkg
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
using Pkg, PkgBenchmark

# run benchmarks
results = judge("Hungarian", "target-branch", "master")

# generate a detailed report in `benchmark` folder
export_markdown(joinpath(Pkg.dir("Hungarian"), "benchmark", "judgement.md"), results)

```


## Comparing with Munkres.jl
```julia
using PkgBenchmark
using Pkg, Random, Statistics

# run benchmarks
results = benchmarkpkg("Hungarian", "master", script = "$(Pkg.dir("Hungarian"))/benchmark/vsMunkres.jl")
hungarianResult = results.benchmarkgroup["Hungarian.jl"]
munkresResult = results.benchmarkgroup["Munkres.jl"]

# judge the results using Munkres.jl as a baseline
julia> judge(mean(hungarianResult), mean(munkresResult))
8-element BenchmarkTools.BenchmarkGroup:
  tags: []
  "10 x 10" => TrialJudgement(-79.16% => improvement)
  "100 x 100" => TrialJudgement(-69.56% => improvement)
  "50 x 50" => TrialJudgement(-62.03% => improvement)
  "200 x 200" => TrialJudgement(-72.74% => improvement)
  "1000 x 1000" => TrialJudgement(-83.15% => improvement)
  "400 x 400" => TrialJudgement(-79.79% => improvement)
  "800 x 800" => TrialJudgement(-85.31% => improvement)
  "2000 x 2000" => TrialJudgement(-84.81% => improvement)
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
