# Benchmark Report for *Hungarian*

## Job Properties
* Time of benchmark: 29 Dec 2019 - 14:20
* Package commit: 365509
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

| ID                                         | time            | GC time    | memory          | allocations |
|--------------------------------------------|----------------:|-----------:|----------------:|------------:|
| `["non-square", "Float64", "10 x 20"]`     |  13.295 μs (5%) |            |   6.69 KiB (1%) |          75 |
| `["non-square", "Float64", "100 x 200"]`   |   2.894 ms (5%) |            | 181.27 KiB (1%) |          90 |
| `["non-square", "Float64", "100 x 50"]`    | 482.749 μs (5%) |            |  56.59 KiB (1%) |          88 |
| `["non-square", "Float64", "1000 x 2000"]` |    2.199 s (5%) |            |  15.49 MiB (1%) |         104 |
| `["non-square", "Float64", "1000 x 800"]`  | 708.745 ms (5%) |            |   6.30 MiB (1%) |         106 |
| `["non-square", "Float64", "20 x 10"]`     |   9.040 μs (5%) |            |   6.47 KiB (1%) |          74 |
| `["non-square", "Float64", "200 x 100"]`   |   2.617 ms (5%) |            | 181.91 KiB (1%) |          90 |
| `["non-square", "Float64", "200 x 400"]`   |  16.780 ms (5%) |            | 682.31 KiB (1%) |          94 |
| `["non-square", "Float64", "2000 x 1000"]` |    2.253 s (5%) |            |  15.50 MiB (1%) |         105 |
| `["non-square", "Float64", "400 x 200"]`   |  17.173 ms (5%) |            | 683.81 KiB (1%) |          95 |
| `["non-square", "Float64", "400 x 800"]`   | 134.892 ms (5%) |            |   2.53 MiB (1%) |          96 |
| `["non-square", "Float64", "50 x 100"]`    | 452.652 μs (5%) |            |  56.19 KiB (1%) |          87 |
| `["non-square", "Float64", "800 x 1000"]`  | 700.927 ms (5%) |            |   6.29 MiB (1%) |         105 |
| `["non-square", "Float64", "800 x 400"]`   | 138.166 ms (5%) |            |   2.53 MiB (1%) |          97 |
| `["square", "Float64", "10 x 10"]`         |   8.976 μs (5%) |            |   5.53 KiB (1%) |          83 |
| `["square", "Float64", "100 x 100"]`       |   1.602 ms (5%) |            | 101.34 KiB (1%) |         101 |
| `["square", "Float64", "1000 x 1000"]`     | 894.207 ms (5%) |            |   7.84 MiB (1%) |         117 |
| `["square", "Float64", "200 x 200"]`       |   8.503 ms (5%) |            | 366.30 KiB (1%) |         106 |
| `["square", "Float64", "2000 x 2000"]`     |    6.851 s (5%) |            |  30.84 MiB (1%) |         119 |
| `["square", "Float64", "400 x 400"]`       |  58.939 ms (5%) |            |   1.30 MiB (1%) |         109 |
| `["square", "Float64", "50 x 50"]`         | 336.752 μs (5%) |            |  36.67 KiB (1%) |          99 |
| `["square", "Float64", "800 x 800"]`       | 419.000 ms (5%) |            |   5.08 MiB (1%) |         117 |
| `["square", "UInt16", "100 x 100"]`        |   1.468 ms (5%) |            |  41.03 KiB (1%) |          98 |
| `["square", "UInt16", "1000 x 1000"]`      | 259.878 ms (5%) |            |   2.11 MiB (1%) |         115 |
| `["square", "UInt16", "16000 x 16000"]`    |   12.445 s (5%) | 285.237 μs | 491.95 MiB (1%) |         152 |
| `["square", "UInt16", "2000 x 2000"]`      | 632.310 ms (5%) |            |   7.93 MiB (1%) |         119 |
| `["square", "UInt16", "4000 x 4000"]`      |    1.540 s (5%) |            |  31.29 MiB (1%) |         133 |
| `["square", "UInt16", "500 x 500"]`        |  81.699 ms (5%) |            | 571.97 KiB (1%) |         107 |
| `["square", "UInt16", "8000 x 8000"]`      |    4.234 s (5%) |            | 123.27 MiB (1%) |         138 |

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
  uname: Darwin 19.2.0 Darwin Kernel Version 19.2.0: Sat Nov  9 03:47:04 PST 2019; root:xnu-6153.61.1~20/RELEASE_X86_64 x86_64 i386
  CPU: Intel(R) Core(TM) i5-6267U CPU @ 2.90GHz: 
              speed         user         nice          sys         idle          irq
       #1  2900 MHz      52193 s          0 s      30909 s      90655 s          0 s
       #2  2900 MHz      25283 s          0 s      15544 s     132926 s          0 s
       #3  2900 MHz      49980 s          0 s      30326 s      93446 s          0 s
       #4  2900 MHz      21875 s          0 s      13348 s     138529 s          0 s
       
  Memory: 16.0 GB (552.1875 MB free)
  Uptime: 17375.0 sec
  Load Avg:  2.93798828125  3.51611328125  3.70458984375
  WORD_SIZE: 64
  LIBM: libopenlibm
  LLVM: libLLVM-6.0.1 (ORCJIT, skylake)
```