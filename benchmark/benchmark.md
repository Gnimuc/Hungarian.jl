# Benchmark Report for *Hungarian*

## Job Properties
* Time of benchmark: 5 Mar 2020 - 23:24
* Package commit: a57bb9
* Julia commit: 46ce4d
* Julia command flags: None
* Environment variables: None

## Results
Below is a table of this job's results, obtained by running the benchmarks.
The values listed in the `ID` column have the structure `[parent_group, child_group, ..., key]`, and can be used to
index into the BaseBenchmarks suite to retrieve the corresponding benchmarks.
The percentages accompanying time and memory values in the below table are noise tolerances. The "true"
time/memory value for a given benchmark is expected to fall within this percentage of the reported value.
An empty cell means that the value was zero.

| ID                                         | time            | GC time | memory          | allocations |
|--------------------------------------------|----------------:|--------:|----------------:|------------:|
| `["non-square", "Float64", "10 x 20"]`     |  10.864 μs (5%) |         |   4.19 KiB (1%) |          52 |
| `["non-square", "Float64", "100 x 200"]`   |   2.862 ms (5%) |         |  23.48 KiB (1%) |          66 |
| `["non-square", "Float64", "100 x 50"]`    | 492.065 μs (5%) |         |  55.52 KiB (1%) |          65 |
| `["non-square", "Float64", "1000 x 2000"]` |    2.982 s (5%) |         | 226.28 KiB (1%) |          80 |
| `["non-square", "Float64", "1000 x 800"]`  | 731.947 ms (5%) |         |   6.29 MiB (1%) |          83 |
| `["non-square", "Float64", "20 x 10"]`     |   6.823 μs (5%) |         |   5.72 KiB (1%) |          51 |
| `["non-square", "Float64", "200 x 100"]`   |   2.658 ms (5%) |         | 180.44 KiB (1%) |          67 |
| `["non-square", "Float64", "200 x 400"]`   |  16.479 ms (5%) |         |  54.89 KiB (1%) |          70 |
| `["non-square", "Float64", "2000 x 1000"]` |    2.595 s (5%) |         |  15.49 MiB (1%) |          82 |
| `["non-square", "Float64", "400 x 200"]`   |  17.147 ms (5%) |         | 681.45 KiB (1%) |          72 |
| `["non-square", "Float64", "400 x 800"]`   | 132.396 ms (5%) |         |  82.83 KiB (1%) |          72 |
| `["non-square", "Float64", "50 x 100"]`    | 441.309 μs (5%) |         |  15.98 KiB (1%) |          63 |
| `["non-square", "Float64", "800 x 1000"]`  | 720.159 ms (5%) |         | 189.03 KiB (1%) |          81 |
| `["non-square", "Float64", "800 x 400"]`   | 137.056 ms (5%) |         |   2.53 MiB (1%) |          74 |
| `["square", "Float64", "10 x 10"]`         |   6.007 μs (5%) |         |   3.56 KiB (1%) |          50 |
| `["square", "Float64", "100 x 100"]`       |   1.551 ms (5%) |         |  20.61 KiB (1%) |          67 |
| `["square", "Float64", "1000 x 1000"]`     | 896.550 ms (5%) |         | 198.44 KiB (1%) |          83 |
| `["square", "Float64", "200 x 200"]`       |   8.275 ms (5%) |         |  49.41 KiB (1%) |          72 |
| `["square", "Float64", "2000 x 2000"]`     |    7.552 s (5%) |         | 297.63 KiB (1%) |          85 |
| `["square", "Float64", "400 x 400"]`       |  57.587 ms (5%) |         |  72.09 KiB (1%) |          75 |
| `["square", "Float64", "50 x 50"]`         | 327.488 μs (5%) |         |  15.28 KiB (1%) |          65 |
| `["square", "Float64", "800 x 800"]`       | 440.901 ms (5%) |         | 185.88 KiB (1%) |          83 |
| `["square", "UInt16", "100 x 100"]`        |   1.336 ms (5%) |         |  18.89 KiB (1%) |          66 |
| `["square", "UInt16", "1000 x 1000"]`      | 211.711 ms (5%) |         | 187.19 KiB (1%) |          83 |
| `["square", "UInt16", "16000 x 16000"]`    |   23.434 s (5%) |         |   3.43 MiB (1%) |         118 |
| `["square", "UInt16", "2000 x 2000"]`      | 555.510 ms (5%) |         | 279.22 KiB (1%) |          87 |
| `["square", "UInt16", "4000 x 4000"]`      |    2.150 s (5%) |         | 729.36 KiB (1%) |          99 |
| `["square", "UInt16", "500 x 500"]`        |  66.783 ms (5%) |         |  74.70 KiB (1%) |          75 |
| `["square", "UInt16", "8000 x 8000"]`      |    9.220 s (5%) |         |   3.55 MiB (1%) |       52902 |

## Benchmark Group List
Here's a list of all the benchmark groups executed by this job:

- `["non-square", "Float64"]`
- `["square", "Float64"]`
- `["square", "UInt16"]`

## Julia versioninfo
```
Julia Version 1.3.0
Commit 46ce4d7933 (2019-11-26 06:09 UTC)
Platform Info:
  OS: macOS (x86_64-apple-darwin19.0.0)
  uname: Darwin 19.3.0 Darwin Kernel Version 19.3.0: Thu Jan  9 20:58:23 PST 2020; root:xnu-6153.81.5~1/RELEASE_X86_64 x86_64 i386
  CPU: Intel(R) Core(TM) i5-6267U CPU @ 2.90GHz: 
              speed         user         nice          sys         idle          irq
       #1  2900 MHz     172453 s          0 s      76004 s     680106 s          0 s
       #2  2900 MHz      67884 s          0 s      35385 s     825282 s          0 s
       #3  2900 MHz     176104 s          0 s      66927 s     685521 s          0 s
       #4  2900 MHz      54629 s          0 s      27814 s     846108 s          0 s
       
  Memory: 16.0 GB (303.921875 MB free)
  Uptime: 99777.0 sec
  Load Avg:  2.46484375  2.73388671875  2.63818359375
  WORD_SIZE: 64
  LIBM: libopenlibm
  LLVM: libLLVM-6.0.1 (ORCJIT, skylake)
```