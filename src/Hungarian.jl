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
    hungarian(costMat) -> (assignment, cost)

Find an optimal solution of the rectangular assignment problem represented by
the ``N x M`` matrix `costMat`. Return the optimal column indices and
corresponding minimal cost.

The `costMat[n,m]` denotes the `cost` to assign the `n`th worker to the `m`th job.
The zero element in the return value `assignment` means that these workers have
no assigned job.

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
function hungarian(costMat::AbstractMatrix)
    r, c = size(costMat)
    # r != c && warn("Currently, the function `hungarian` automatically transposes `cost matrix` when there are more workers than jobs.")
    costMatrix = r ≤ c ? costMat : costMat'
    matching = munkres(costMatrix)
    assignment = r ≤ c ? findn(matching'.==STAR)[1] : [findfirst(matching[:,i].==STAR) for i = 1:r]
    # calculate minimum cost
    cost = sum(costMat[i...] for i in zip(1:r, assignment) if i[2] != 0)
    return assignment, cost
end

export hungarian

end # module
