# Hungarian

[![Build Status](https://travis-ci.org/Gnimuc/Hungarian.jl.svg?branch=master)](https://travis-ci.org/Gnimuc/Hungarian.jl)
[![Build status](https://ci.appveyor.com/api/projects/status/8ym5dy9navw9hmd8?svg=true)](https://ci.appveyor.com/project/Gnimuc/hungarian-jl)
[![codecov.io](http://codecov.io/github/Gnimuc/Hungarian.jl/coverage.svg?branch=master)](http://codecov.io/github/Gnimuc/Hungarian.jl?branch=master)
[![Coverage Status](https://coveralls.io/repos/github/Gnimuc/Hungarian.jl/badge.svg?branch=master)](https://coveralls.io/github/Gnimuc/Hungarian.jl?branch=master)

The package provides one implementation of the **[Hungarian algorithm](https://en.wikipedia.org/wiki/Hungarian_algorithm)**(*Kuhn-Munkres algorithm*) based on its matrix interpretation.

This implementation uses a sparse matrix to track marked zeros, so it costs less
time and memory when dealing with large scale assignment problems(e.g. a `1000x1000`
cost matrix as input). Another Julia implementation of Hungarian algorithm is [Munkres.jl](https://github.com/FugroRoames/Munkres.jl) which is faster when solving
small assignment problems(e.g. `50x50`). Some benchmarks can be found [here](https://github.com/Gnimuc/Hungarian.jl/tree/master/benchmark).

## Installation
```julia
Pkg.clone("https://github.com/Gnimuc/Hungarian.jl.git")
```

## Example
Assume we have 3 workers and 5 jobs with the following cost matrix:
```julia
weights = [ 24     1     8;
             5     7    14;
             6    13    20;
            12    19    21;
            18    25     2]
```
Then solve the assignment problem using Hungarian algorithm:
```julia
# task 1 => worker 2 with cost 1
# task 2 => worker 1 with cost 5
# task 5 => worker 3 with cost 2
# the minimal cost is 1 + 5 + 2 = 8  
julia> assignment, cost = hungarian(weights)
([2,1,0,0,3],8)
```
Since each worker can perform only one job and each job can be assigned to only one worker, those `0`s in `assignment` represent the corresponding un-assigned tasks.
## Reference
1. J. Munkres, "Algorithms for the Assignment and Transportation Problems", Journal of the Society for Industrial and Applied Mathematics, 5(1):32–38, 1957 March.

2. http://csclab.murraystate.edu/bob.pilgrim/445/munkres.html
