"""
    munkres(costMat) -> Zs

Find an optimal solution of the assignment problem represented by the square
matrix `costMat`. Return an sparse matrix illustrating the optimal matching.

# Examples

```julia
julia> costMat = ones(3, 3) - eye(3, 3)
3×3 Array{Float64,2}:
 0.0  1.0  1.0
 1.0  0.0  1.0
 1.0  1.0  0.0

julia> matching = Hungarian.munkres(costMat)
3×3 sparse matrix with 3 Int64 nonzero entries:
	[1, 1]  =  2
	[2, 2]  =  2
	[3, 3]  =  2

julia> full(matching)
3×3 Array{Int64,2}:
 2  0  0
 0  2  0
 0  0  2
```
"""
munkres(costMat::AbstractMatrix{T}) where {T<:Real} = munkres!(copy(costMat))

"""
    munkres!(costMat) -> Zs

Identical to `munkres`, except that it directly modifies its input matrix `costMat`
instead of allocating a copy. *As a result, the value of this matrix in the caller
code will be modified and should therefore no more be used!* This function should
rather be used by advanced users to improve performance of critical code.
"""
function munkres!(costMat::AbstractMatrix{T}) where T <: Real
    rowNum, colNum = size(costMat)
    colNum ≥ rowNum || throw(ArgumentError("Non-square matrix should have more columns than rows."))

    # preliminaries:
    # "no lines are covered;"
    rowCovered = falses(rowNum)
    colCovered = falses(colNum)

    # for tracking changes per row/col of A
    Δrow = zeros(rowNum)
    Δcol = zeros(colNum)

    # for tracking indices
    rowCoveredIdx = Int[]
    colCoveredIdx = Int[]
    rowUncoveredIdx = Int[]
    colUncoveredIdx = Int[]
    sizehint!(rowCoveredIdx, rowNum)
    sizehint!(colCoveredIdx, colNum)
    sizehint!(rowUncoveredIdx, rowNum)
    sizehint!(colUncoveredIdx, colNum)

    # "no zeros are starred or primed."
    # use a sparse matrix Zs to store these three kinds of zeros:
    # 0 => NON   => Non-zero
    # 1 => Z     => ordinary zero
    # 2 => STAR  => starred zero
    # 3 => PRIME => primed zero
    Zs = spzeros(Int8, rowNum, colNum)

    # "consider a row of the matrix A;
    #  subtract from each element in this row the smallest element of this row.
    #  do the same for each row."
    costMat .-= minimum(costMat, dims=2)

    # "then consider each column of the resulting matrix and subtract from each
    #  column its smallest entry."
    # Note that, this step should be omitted if the input matrix is not square.
    rowNum == colNum && (costMat .-= minimum(costMat, dims=1);)

    # for tracking those starred zero
    rowSTAR = falses(rowNum)
    colSTAR = falses(colNum)
    # since looping through a row in a SparseMatrixCSC is costy(not cache-friendly),
    # a row to column index mapping of starred zeros is also tracked here.
    row2colSTAR = Dict{Int,Int}()
    for ii in CartesianIndices(size(costMat))
        # "consider a zero Z of the matrix;"
        if costMat[ii] == 0
            Zs[ii] = Z
            # "if there is no starred zero in its row and none in its column, star Z.
            #  repeat, considering each zero in the matrix in turn;"
            r, c = ii.I
            if !colSTAR[c] && !rowSTAR[r]
                Zs[r,c] = STAR
                rowSTAR[r] = true
                colSTAR[c] = true
                row2colSTAR[r] = c
                # "then cover every column containing a starred zero."
                colCovered[c] = true
            end
        end
    end

    # preliminaries done, go to step 1
    stepNum = 1

    # if the assignment is already found, exit
    stepNum = exit_criteria(colCovered, size(Zs))

    # pre-allocation
    sequence = Tuple{Int,Int}[]       # used in step 2
    minLocations = Tuple{Int,Int}[]   # used in step 3

    # these three steps are parallel with those in the paper:
    # J. Munkres, "Algorithms for the Assignment and Transportation Problems",
    # Journal of the Society for Industrial and Applied Mathematics, 5(1):32–38, 1957 March.
    while stepNum != 0
        if stepNum == 1
            stepNum = step1!(Zs, rowCovered, colCovered, rowSTAR, row2colSTAR)
        elseif stepNum == 2
            empty!(sequence)
            stepNum = step2!(Zs, sequence, rowCovered, colCovered, rowSTAR, row2colSTAR)
        elseif stepNum == 3
            empty!(rowCoveredIdx)
            empty!(colCoveredIdx)
            empty!(rowUncoveredIdx)
            empty!(colUncoveredIdx)
            empty!(minLocations)
            stepNum = step3!(costMat, Zs, minLocations, rowCovered, colCovered, rowSTAR, row2colSTAR, Δrow, Δcol, rowCoveredIdx, colCoveredIdx, rowUncoveredIdx, colUncoveredIdx)
        end
    end

    return Zs
end

function munkres(costMat::AbstractMatrix{S}) where {T <: Real, S <: Union{Missing, T}}
    # replace forbidden edges (i.e. those with a missing cost) by a very large cost, so that they
    # are never chosen for the matching (except if they are the only possible edges)
    costMatReal = [ismissing(x) ? typemax(T) : x for x in costMat]

    # compute the assignment with the standard procedure. the return value is guaranteed to be sparse
    assignment = munkres(costMatReal)

    # remove the forbidden edges, would they be in the assignment
    colLen = size(assignment, 2)
    rows = rowvals(assignment)
    for c in 1:colLen, i in nzrange(assignment, c)
        r = rows[i]
        if assignment[r, c] == STAR && ismissing(costMat[r, c])
            assignment[r, c] = Z # standard zero, no assignment made
        end
    end

    return assignment
end

"""
    exit_criteria(colCovered, ZsDims) -> stepNum
We adjust Munkres's algorithm in order to deal with rectangular matrices,
so only K columns are counted here, where K = min(size(Zs))
"""
function exit_criteria(colCovered, ZsDims)
    count = 0
    @inbounds for i in eachindex(colCovered)
        colCovered[i] && (count += 1;)
    end
    if count == ZsDims[1]
        # algorithm exits
        return 0
    else
        # "otherwise, return to step 1."
        return 1
    end
end


"""
Step 1 of the original Munkres' Assignment Algorithm
"""
function step1!(Zs, rowCovered, colCovered, rowSTAR, row2colSTAR)
    colLen = size(Zs,2)
    rows = rowvals(Zs)
    # step 1:
    zeroCoveredNum = 0
    # "repeat until all zeros are covered."
    while zeroCoveredNum < nnz(Zs)
        zeroCoveredNum = 0
        for c = 1:colLen, i in nzrange(Zs, c)
            r = rows[i]
            # "choose a non-covered zero and prime it"
            if colCovered[c] == false && rowCovered[r] == false
                Zs[r,c] = PRIME
                # "consider the row containing it."
                # "if there is a starred zero Z in this row"
                if rowSTAR[r]
                    # "cover this row and uncover the column of Z"
                    rowCovered[r] = true
                    colCovered[row2colSTAR[r]] = false
                else
                    # "if there is no starred zero in this row,
                    #  go at once to step 2."
                    return 2
                end
            else
                # otherwise, this zero is covered
                zeroCoveredNum += 1
            end
        end
    end
    # "go to step 3."
    return 3
end

"""
Step 2 of the original Munkres' Assignment Algorithm
"""
function step2!(Zs, sequence, rowCovered, colCovered, rowSTAR, row2colSTAR)
    ZsDims = size(Zs)
    rows = rowvals(Zs)
    # step 2:
    flag = false
    # "there is a sequence of alternating primed and starred zeros, constructed
    #  as follows:"
    # "let Z₀ denote the uncovered 0′.[there is only one.]"
    for c = 1:ZsDims[2], i in nzrange(Zs, c)
        r = rows[i]
        # note that Z₀ is an **uncovered** 0′
        if Zs[r,c] == PRIME && colCovered[c] == false && rowCovered[r] == false
            # push Z₀(uncovered 0′) into the sequence
            push!(sequence, (r, c))
            # "let Z₁ denote the 0* in the Z₀'s column.(if any)"
            # find 0* in Z₀'s column
            for j in nzrange(Zs, c)
                Z₁r = rows[j]
                if Zs[Z₁r, c] == STAR
                    # push Z₁(0*) into the sequence
                    push!(sequence, (Z₁r, c))
                    # set sequence continue flag => true
                    flag = true
                    break
                end
            end
            break
        end
    end
    # "let Z₂ denote the 0′ in Z₁'s row(there will always be one)."
    # "let Z₃ denote the 0* in the Z₂'s column."
    # "continue until the sequence stops at a 0′ Z₂ⱼ, which has no 0* in its column."
    while flag
        flag = false
        r = sequence[end][1]
        # find Z₂ in Z₃'s row (always exits)
        for c = 1:ZsDims[2]
            if Zs[r,c] == PRIME
                # push Z₂ into the sequence
                push!(sequence, (r, c))
                # find 0* in Z₂'s column
                for j in nzrange(Zs, c)
                    Z₃r = rows[j]
                    if Zs[Z₃r, c] == STAR
                        # push Z₃(0*) into the sequence
                        push!(sequence, (Z₃r, c))
                        # set sequence continue flag => true
                        flag = true
                        break
                    end
                end
                break
            end
        end
    end

    # "unstar each starred zero of the sequence;"
    for i in 2:2:length(sequence)-1
        Zs[sequence[i]...] = Z
    end

    # clean up
    fill!(rowSTAR, false)
    empty!(row2colSTAR)

    # "and star each primed zero of the sequence."
    for i in 1:2:length(sequence)
        Zs[sequence[i]...] = STAR
    end

    for c = 1:ZsDims[2], i in nzrange(Zs, c)
        r = rows[i]
        # "erase all primes;"
        if Zs[r,c] == PRIME
            Zs[r,c] = Z
        end
        # "and cover every column containing a 0*."
        if Zs[r,c] == STAR
            colCovered[c] = true
            rowSTAR[r] = true
            row2colSTAR[r] = c
        end
    end

    # "uncover every row"
    fill!(rowCovered, false)

    # "if all columns are covered, the starred zeros form the desired independent set."
    return exit_criteria(colCovered, ZsDims)
end

"""
Step 3 of the original Munkres' Assignment Algorithm
"""
function step3!(costMat::AbstractMatrix{T}, Zs, minLocations, rowCovered, colCovered, rowSTAR, row2colSTAR,
                Δrow, Δcol, rowCoveredIdx, colCoveredIdx, rowUncoveredIdx, colUncoveredIdx) where T <: Real
    # step 3(Step C):
    # "let h denote the smallest uncovered element of the matrix;
    #  add h to each covered row; then subtract h from each uncovered column."
    #             -h                    ||
    #              |     no change      ||  reduce old zeros
    #              | change:(+h)+(-h)=0 ||     change: +h
    #       +h ---------Covered Row-----||----Covered Row--------
    #              |  Uncovered Column  ||   Covered Column
    #==============|====================||================================#
    #              |   Uncovered Row    ||    Uncovered Row
    #              |  Uncovered Column  ||   Covered Column
    #              |    change: -h      ||     change: 0
    #              | produce new zeros  ||     no change
    #              |                    ||
    # since we always apply add/substract h to a whole row/column, it's unnecessary
    # to apply every operation to every entry of A's row/column, we only need a row
    # and a column vector to keep tracking those changes and use it when necessary.

    # find h and track the location of those new zeros
    @inbounds for i in eachindex(rowCovered)
        rowCovered[i] ? push!(rowCoveredIdx, i) : push!(rowUncoveredIdx, i)
    end

    @inbounds for i in eachindex(colCovered)
        colCovered[i] ? push!(colCoveredIdx, i) : push!(colUncoveredIdx, i)
    end

    h = Inf
    @inbounds for j in colUncoveredIdx, i in rowUncoveredIdx
        cost = costMat[i,j] + Δcol[j] + Δrow[i]
        if cost <= h
            if cost != h
                h = cost
                empty!(minLocations)
            end
            push!(minLocations, (i,j))
        end
    end

    for i in rowCoveredIdx
        Δrow[i] += h
    end

    for i in colUncoveredIdx
        Δcol[i] -= h
    end

    # mark new zeros in Zs and remove those elements that will no longer be zero
    # produce new zeros
    for loc in minLocations
        Zs[loc...] = Z
    end
    # reduce old zeros
    rows = rowvals(Zs)
    for c in colCoveredIdx, i in nzrange(Zs, c)
        r = rows[i]
        if rowCovered[r]
            if Zs[r,c] == STAR
                rowSTAR[r] = false
                delete!(row2colSTAR, r)
            end
            Zs[r,c] = NON
        end
    end

    dropzeros!(Zs)

    # "return to step 1."
    return stepNum = 1
end
