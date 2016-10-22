module Hungarian

# enums
@enum MARK N=0 ZERO=1 STAR=2 PRIME=3

Base.zero(::Type{MARK}) = convert(MARK,0)

include("./Munkres.jl")

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
