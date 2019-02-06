# Benchmark Report for *Hungarian*

## Job Properties
* Time of benchmark: 6 Feb 2019 - 22:17
* Package commit: 9d9ca1
* Julia commit: 80516c
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
| `["non-square", "Float64", "10 x 20"]`     |  12.588 μs (5%) |            |   6.56 KiB (1%) |          68 |
| `["non-square", "Float64", "100 x 200"]`   |   2.552 ms (5%) |            | 181.14 KiB (1%) |          83 |
| `["non-square", "Float64", "100 x 50"]`    | 412.895 μs (5%) |            |  56.47 KiB (1%) |          81 |
| `["non-square", "Float64", "1000 x 2000"]` |    2.038 s (5%) |            |  15.49 MiB (1%) |          97 |
| `["non-square", "Float64", "1000 x 800"]`  | 648.016 ms (5%) |            |   6.30 MiB (1%) |          99 |
| `["non-square", "Float64", "20 x 10"]`     |   9.684 μs (5%) |            |   6.34 KiB (1%) |          67 |
| `["non-square", "Float64", "200 x 100"]`   |   2.307 ms (5%) |            | 181.78 KiB (1%) |          83 |
| `["non-square", "Float64", "200 x 400"]`   |  14.935 ms (5%) |            | 682.19 KiB (1%) |          87 |
| `["non-square", "Float64", "2000 x 1000"]` |    2.072 s (5%) |            |  15.50 MiB (1%) |          98 |
| `["non-square", "Float64", "400 x 200"]`   |  15.461 ms (5%) |            | 683.69 KiB (1%) |          88 |
| `["non-square", "Float64", "400 x 800"]`   | 129.009 ms (5%) |            |   2.53 MiB (1%) |          89 |
| `["non-square", "Float64", "50 x 100"]`    | 384.230 μs (5%) |            |  56.06 KiB (1%) |          80 |
| `["non-square", "Float64", "800 x 1000"]`  | 645.023 ms (5%) |            |   6.29 MiB (1%) |          98 |
| `["non-square", "Float64", "800 x 400"]`   | 133.638 ms (5%) |            |   2.53 MiB (1%) |          90 |
| `["square", "Float64", "10 x 10"]`         |   9.087 μs (5%) |            |   5.41 KiB (1%) |          76 |
| `["square", "Float64", "100 x 100"]`       |   1.384 ms (5%) |            | 101.22 KiB (1%) |          94 |
| `["square", "Float64", "1000 x 1000"]`     | 815.554 ms (5%) |            |   7.84 MiB (1%) |         110 |
| `["square", "Float64", "200 x 200"]`       |   7.373 ms (5%) |            | 366.17 KiB (1%) |          99 |
| `["square", "Float64", "2000 x 2000"]`     |    6.374 s (5%) | 238.308 μs |  30.84 MiB (1%) |         112 |
| `["square", "Float64", "400 x 400"]`       |  54.179 ms (5%) |            |   1.30 MiB (1%) |         102 |
| `["square", "Float64", "50 x 50"]`         | 301.392 μs (5%) |            |  36.55 KiB (1%) |          92 |
| `["square", "Float64", "800 x 800"]`       | 386.477 ms (5%) |            |   5.08 MiB (1%) |         110 |
| `["square", "UInt16", "100 x 100"]`        |   1.353 ms (5%) |            |  40.91 KiB (1%) |          91 |
| `["square", "UInt16", "1000 x 1000"]`      | 273.474 ms (5%) |            |   2.11 MiB (1%) |         110 |
| `["square", "UInt16", "16000 x 16000"]`    |   13.090 s (5%) |  10.173 ms | 491.95 MiB (1%) |         147 |
| `["square", "UInt16", "2000 x 2000"]`      | 651.013 ms (5%) |            |   7.93 MiB (1%) |         114 |
| `["square", "UInt16", "4000 x 4000"]`      |    1.622 s (5%) |   4.020 ms |  31.29 MiB (1%) |         128 |
| `["square", "UInt16", "500 x 500"]`        |  84.062 ms (5%) |            | 571.88 KiB (1%) |         102 |
| `["square", "UInt16", "8000 x 8000"]`      |    4.538 s (5%) | 302.167 μs | 123.27 MiB (1%) |         133 |

## Benchmark Group List
Here's a list of all the benchmark groups executed by this job:

- `["non-square", "Float64"]`
- `["square", "Float64"]`
- `["square", "UInt16"]`

## Julia versioninfo
```
Julia Version 1.1.0
Commit 80516ca202 (2019-01-21 21:24 UTC)
Platform Info:
  OS: macOS (x86_64-apple-darwin14.5.0)
  uname: Darwin 18.2.0 Darwin Kernel Version 18.2.0: Mon Nov 12 20:24:46 PST 2018; root:xnu-4903.231.4~2/RELEASE_X86_64 x86_64 i386
  CPU: Intel(R) Core(TM) i5-6267U CPU @ 2.90GHz: 
              speed         user         nice          sys         idle          irq
       #1  2900 MHz     394200 s          0 s     251679 s    1476390 s          0 s
       #2  2900 MHz     198670 s          0 s      99173 s    1824385 s          0 s
       #3  2900 MHz     389734 s          0 s     210979 s    1521515 s          0 s
       #4  2900 MHz     184573 s          0 s      85414 s    1852241 s          0 s
       
  Memory: 16.0 GB (486.328125 MB free)
  Uptime: 352411.0 sec
  Load Avg:  2.99560546875  3.11181640625  3.07666015625
  WORD_SIZE: 64
  LIBM: libopenlibm
  LLVM: libLLVM-6.0.1 (ORCJIT, skylake)
```