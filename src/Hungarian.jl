module Hungarian


# Zero markers used in hungarian algorithm
# 0 => NON   => Non-zero
# 1 => Z     => ordinary zero
# 2 => STAR  => starred zero
# 3 => PRIME => primed zero
const NON = 0
const Z = 1
const STAR = 2
const PRIME = 3

include("./Munkres.jl")

"""
    hungarian(costMat)

Find an optimal solution of the rectangular assignment problem represented by
the ``N x M`` matrix `costMat`. Return the optimal column indices and
corresponding minimal cost.

The `costMat[n,m]` denotes the cost to assign the `n`th job to the `m`th worker.
Note that, when dealing with "partial assignment" problems, the zero element in
the return value `assignment` means there is no matching job for that worker.

# Examples
```julia
julia> A = [ 24     1     8;
              5     7    14;
              6    13    20;
             12    19    21;
             18    25     2];

julia> assignment, cost = hungarian(A)
([2,1,0,0,3],8)

julia> assignment, cost = hungarian(A')
([2,1,5],8)
```

"""
function hungarian{T<:Real}(costMat::Array{T,2})
    # deal with non-square input
    r, c = size(costMat)
    if r != c
        n = max(r,c)
        squareMat = fill(typemax(T), n, n)
        squareMat[1:r, 1:c] = costMat
    else
        squareMat = costMat
    end

    # run munkres's algorithm
    matching = munkres(squareMat)

    # find assignment
    assignment = [findfirst(matching[i,:].==STAR) for i = 1:r]
    assignment[assignment.>c] = 0

    # calculate minimum cost
    cost = 0
    for i in zip(1:r, assignment)
        if i[2] != 0
            cost += costMat[i...]
        end
    end

    return assignment, cost
end

export hungarian

end # module
