# Hungarian

[![Build Status](https://travis-ci.org/Gnimuc/Hungarian.jl.svg?branch=master)](https://travis-ci.org/Gnimuc/Hungarian.jl)
[![Build status](https://ci.appveyor.com/api/projects/status/8ym5dy9navw9hmd8?svg=true)](https://ci.appveyor.com/project/Gnimuc/hungarian-jl)
[![codecov.io](http://codecov.io/github/Gnimuc/Hungarian.jl/coverage.svg?branch=master)](http://codecov.io/github/Gnimuc/Hungarian.jl?branch=master)
[![Coverage Status](https://coveralls.io/repos/github/Gnimuc/Hungarian.jl/badge.svg?branch=master)](https://coveralls.io/github/Gnimuc/Hungarian.jl?branch=master)
[![Hungarian](http://pkg.julialang.org/badges/Hungarian_0.6.svg)](http://pkg.julialang.org/detail/Hungarian)

The package provides one implementation of the **[Hungarian algorithm](https://en.wikipedia.org/wiki/Hungarian_algorithm)**(*Kuhn-Munkres algorithm*) based on its matrix interpretation. This implementation uses a sparse matrix to keep tracking those marked zeros, so it costs less time and memory than [Munkres.jl](https://github.com/FugroRoames/Munkres.jl). Benchmark details can be found [here](https://github.com/Gnimuc/Hungarian.jl/tree/master/benchmark).

## Installation
```julia
Pkg.add("Hungarian")
```

## Quick start
Let's say we have 5 workers and 3 tasks with the following cost matrix:
```julia
weights = [ 24     1     8;
             5     7    14;
             6    13    20;
            12    19    21;
            18    25     2]
```
We can solve the assignment problem by:
```julia
julia> using Hungarian

julia> assignment, cost = hungarian(weights)
([2,1,0,0,3],8)

# worker 1 => task 2 with weights[1,2] = 1
# worker 2 => task 1 with weights[2,1] = 5
# worker 5 => task 3 with weights[5,3] = 2
# the minimal cost is 1 + 5 + 2 = 8  
```
Since each worker can perform only one task and each task can be assigned to only one worker, those `0`s in the `assignment` mean that no task is assigned to those workers.

# Usage
When solving a canonical assignment problem, namely, the cost matrix is square, one can directly get the matching via `Hungarian.munkres(x)` instead of `hungarian(x)`:
```julia
julia> using Hungarian

julia> matching = Hungarian.munkres(rand(5,5))
5×5 sparse matrix with 9 Int64 nonzero entries:
	[2, 1]  =  1
	[5, 1]  =  2
	[1, 2]  =  2
	[5, 2]  =  1
	[4, 3]  =  2
	[2, 4]  =  2
	[4, 4]  =  1
	[1, 5]  =  1
	[3, 5]  =  2

# 0 => non-zero
# 1 => zero
# 2 => STAR
julia> full(matching)
5×5 Array{Int64,2}:
 0  2  0  0  1
 1  0  0  2  0
 0  0  0  0  2
 0  0  2  1  0
 2  1  0  0  0

# against column
julia> [findfirst(matching[i,:].==Hungarian.STAR) for i = 1:5]
5-element Array{Int64,1}:
 2
 4
 5
 3
 1

# against row
julia> [findfirst(matching[:,i].==Hungarian.STAR) for i = 1:5]
5-element Array{Int64,1}:
 5
 1
 4
 2
 3
```

## References
1. J. Munkres, "Algorithms for the Assignment and Transportation Problems", Journal of the Society for Industrial and Applied Mathematics, 5(1):32–38, 1957 March.

2. http://csclab.murraystate.edu/bob.pilgrim/445/munkres.html
