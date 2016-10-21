# Hungarian

[![Build Status](https://travis-ci.org/Gnimuc/Hungarian.jl.svg?branch=master)](https://travis-ci.org/Gnimuc/Hungarian.jl)
[![Build status](https://ci.appveyor.com/api/projects/status/8ym5dy9navw9hmd8?svg=true)](https://ci.appveyor.com/project/Gnimuc/hungarian-jl)
[![codecov.io](http://codecov.io/github/Gnimuc/Hungarian.jl/coverage.svg?branch=master)](http://codecov.io/github/Gnimuc/Hungarian.jl?branch=master)
[![Coverage Status](https://coveralls.io/repos/github/Gnimuc/Hungarian.jl/badge.svg?branch=master)](https://coveralls.io/github/Gnimuc/Hungarian.jl?branch=master)

Currently, the package only provides an implementation of the **[Hungarian algorithm](https://en.wikipedia.org/wiki/Hungarian_algorithm)**(*Kuhn-Munkres algorithm*) based on its matrix interpretation. I also plan to implement a O(3) version.

## Installation
```julia
Pkg.clone("https://github.com/Gnimuc/Hungarian.jl.git")
```

## Reference
J. Munkres, "Algorithms for the Assignment and Transportation Problems", Journal of the Society for Industrial and Applied Mathematics, 5(1):32–38, 1957 March.
