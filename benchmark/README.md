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
	  "10 x 10" => Trial(6.007 μs)
	  "100 x 100" => Trial(1.551 ms)
	  "50 x 50" => Trial(327.488 μs)
	  "200 x 200" => Trial(8.275 ms)
	  "1000 x 1000" => Trial(896.550 ms)
	  "400 x 400" => Trial(57.587 ms)
	  "800 x 800" => Trial(440.901 ms)
	  "2000 x 2000" => Trial(7.552 s)
  "UInt16" => 7-element BenchmarkTools.BenchmarkGroup:
	  tags: ["integer"]
	  "8000 x 8000" => Trial(9.220 s)
	  "100 x 100" => Trial(1.336 ms)
	  "4000 x 4000" => Trial(2.150 s)
	  "500 x 500" => Trial(66.783 ms)
	  "1000 x 1000" => Trial(211.711 ms)
	  "16000 x 16000" => Trial(23.434 s)
	  "2000 x 2000" => Trial(555.510 ms)

# generate a detailed report in `benchmark` folder
using Pkg, Hungarian
export_markdown(joinpath(dirname(pathof(Hungarian)), "..", "benchmark", "benchmark.md"), results)

# or upload to Gist
using GitHub, JSON
gist_json = JSON.parse(
                   """
                   {
                   "description": "A benchmark for Hungarian",
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
using Pkg, PkgBenchmark, Hungarian

# run benchmarks
results = judge("Hungarian", "target-branch", "master")

# generate a detailed report in `benchmark` folder
export_markdown(joinpath(dirname(pathof(Hungarian)), "..", "benchmark", "judgement.md"), results)

```


## Comparing with Munkres.jl
```julia
using PkgBenchmark
using Pkg, Random, Statistics

# run benchmarks
results = benchmarkpkg("Hungarian", "master", script = joinpath(dirname(pathof(Hungarian)), "..", "benchmark", "vsMunkres.jl"))
hungarianResult = results.benchmarkgroup["Hungarian.jl"]
munkresResult = results.benchmarkgroup["Munkres.jl"]

# judge the results using Munkres.jl as a baseline
julia> judge(mean(hungarianResult), mean(munkresResult))
8-element BenchmarkTools.BenchmarkGroup:
  tags: []
  "10 x 10" => TrialJudgement(-82.74% => improvement)
  "100 x 100" => TrialJudgement(-70.53% => improvement)
  "50 x 50" => TrialJudgement(-58.36% => improvement)
  "200 x 200" => TrialJudgement(-74.47% => improvement)
  "1000 x 1000" => TrialJudgement(-79.98% => improvement)
  "400 x 400" => TrialJudgement(-71.24% => improvement)
  "800 x 800" => TrialJudgement(-78.40% => improvement)
  "2000 x 2000" => TrialJudgement(-85.30% => improvement)
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

(This table ~~might be~~ *is* outdated, so don't take it so seriously, just treat it as a vague reference.
I ~~don't wanna~~ cannot keep updating these figures because I don't have extra money to buy a Matlab license merely for this. Anyway, users can always reproduce these benchmark report using the above mentioned snippets on their own machine.)
