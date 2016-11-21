"""
    munkres(costMat) -> Zs

Find an optimal solution of the assignment problem represented by the square
matrix `costMat`. Return an sparse matrix illustrating the optimal matching.

# Examples

```julia
julia> costMat = ones(3,3)-eye(3,3)
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
function munkres{T<:Real}(costMat::Array{T,2})
    size(costMat,2) ≥ size(costMat,1) || throw(ArgumentError("Non-square matrix should have more columns than rows."))
    A = copy(costMat)
    # preliminaries:
    # "no lines are covered;"
    rowCovered = falses(size(A,1))
    columnCovered = falses(size(A,2))

    # "no zeros are starred or primed."
    # use a sparse matrix Zs to store these three kinds of zeros:
    # 0 => NON   => Non-zero
    # 1 => Z     => ordinary zero
    # 2 => STAR  => starred zero
    # 3 => PRIME => primed zero
    Zs = spzeros(Int, size(A)...)

    # "consider a row of the matrix A;
    #  subtract from each element in this row the smallest element of this row.
    #  do the same for each row."
    # it's succinct to implement this using broadcasting.
    A .-= minimum(A, 2)

    # "then consider each column of the resulting matrix and subtract from each
    #  column its smallest entry."
    # Note that, this step should be removed if the input matrix is not square.
    # A .-= minimum(A, 1)

    rowSTAR = falses(size(A,1))
    columnSTAR = falses(size(A,2))
    for ii in CartesianRange(size(A))
        # "consider a zero Z of the matrix;"
        if A[ii] == 0
            Zs[ii] = Z
            # "if there is no starred zero in its row and none in its column, star Z.
            #  repeat, considering each zero in the matrix in turn;"
            r, c = ii.I
            if !columnSTAR[c] && !rowSTAR[r]
                Zs[r,c] = STAR
                rowSTAR[r] = true
                columnSTAR[c] = true
                # "then cover every column containing a starred zero."
                columnCovered[c] = true
            end
        end
    end

    # preliminaries done, go to step 1
    stepNum = 1

    # if the assignment is already found, exist
    # here we adjust Munkres's algorithm in order to deal with rectangular matrices,
    # so only K columns are counted here, where K = min(size(Zs))
    if length(find(columnCovered)) == minimum(size(Zs))
        stepNum = 0
    end

    # these three steps are parallel with those in the paper:
    # J. Munkres, "Algorithms for the Assignment and Transportation Problems",
    # Journal of the Society for Industrial and Applied Mathematics, 5(1):32–38, 1957 March.
    while stepNum != 0
        if stepNum == 1
            stepNum = step1!(Zs, rowCovered, columnCovered)
        elseif stepNum == 2
            stepNum = step2!(Zs, rowCovered, columnCovered)
        elseif stepNum == 3
            stepNum = step3!(A, Zs, rowCovered, columnCovered)
        end
    end

    return Zs
end

"""
Step 1 of the original Munkres' Assignment Algorithm
"""
function step1!(Zs::SparseMatrixCSC{Int,Int},
                rowCovered::BitArray{1},
                columnCovered::BitArray{1}
               )
    columnLen = size(Zs,2)
    rows = rowvals(Zs)
    # step 1:
    zeroCoveredNum = 0
    # "repeat until all zeros are covered."
    while zeroCoveredNum < nnz(Zs)
        zeroCoveredNum = 0
        for c = 1:columnLen, i in nzrange(Zs, c)
            r = rows[i]
            # "choose a non-covered zero and prime it, consider the row containing it."
            if columnCovered[c] == false && rowCovered[r] == false
                Zs[r,c] = PRIME
                # "if there is a starred zero Z in this row"
                columnZ = 0
                for zc = 1:columnLen
                    if Zs[r,zc] == STAR
                        columnZ = zc
                        break
                    end
                end
                if columnZ != 0
                    # "cover this row and uncover the column of Z"
                    rowCovered[r] = true
                    columnCovered[columnZ] = false
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
function step2!(Zs::SparseMatrixCSC{Int,Int},
                rowCovered::BitArray{1},
                columnCovered::BitArray{1}
               )
    ZsDims = size(Zs)
    rows = rowvals(Zs)
    # step 2:
    sequence = Int[]
    flag = false
    # "there is a sequence of alternating primed and starred zeros, constructed
    #  as follows:"
    # "let Z₀ denote the uncovered 0′.[there is only one.]"
    for c = 1:ZsDims[2], i in nzrange(Zs, c)
        r = rows[i]
        # note that Z₀ is an **uncovered** 0′
        if Zs[r,c] == PRIME && columnCovered[c] == false && rowCovered[r] == false
            # push Z₀(uncovered 0′) into the sequence
            push!(sequence, sub2ind(ZsDims, r, c))
            # "let Z₁ denote the 0* in the Z₀'s column.(if any)"
            # find 0* in Z₀'s column
            for j in nzrange(Zs, c)
                Z₁r = rows[j]
                if Zs[Z₁r, c] == STAR
                    # push Z₁(0*) into the sequence
                    push!(sequence, sub2ind(ZsDims, Z₁r, c))
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
        r = ind2sub(ZsDims, sequence[end])[1]
        # find Z₂ in Z₃'s row (always exists)
        for c = 1:ZsDims[2]
            if Zs[r,c] == PRIME
                # push Z₂ into the sequence
                push!(sequence, sub2ind(ZsDims, r, c))
                # find 0* in Z₂'s column
                for j in nzrange(Zs, c)
                    Z₃r = rows[j]
                    if Zs[Z₃r, c] == STAR
                        # push Z₃(0*) into the sequence
                        push!(sequence, sub2ind(ZsDims, Z₃r, c))
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
    Zs[sequence[2:2:end-1]] = Z

    # "and star each primed zero of the sequence."
    Zs[sequence[1:2:end]] = STAR

    for c = 1:ZsDims[2], i in nzrange(Zs, c)
        r = rows[i]
        # "erase all primes;"
        if Zs[r,c] == PRIME
            Zs[r,c] = Z
        end
        # "and cover every column containing a 0*."
        if Zs[r,c] == STAR
            columnCovered[c] = true
        end
    end

    # "uncover every row"
    rowCovered[:] = false

    # "if all columns are covered, the starred zeros form the desired independent set."
    # here we adjust Munkres's algorithm in order to deal with rectangular matrices,
    # so only K columns are counted here, where K = min(size(Zs))
    if length(find(columnCovered)) == minimum(size(Zs))
        # algorithm exits
        return 0
    else
        # "otherwise, return to step 1."
        return 1
    end
end

"""
Step 3 of the original Munkres' Assignment Algorithm
"""
function step3!{T<:Real}(A::Array{T,2},
                         Zs::SparseMatrixCSC{Int,Int},
                         rowCovered::BitArray{1},
                         columnCovered::BitArray{1}
                        )
    # step 3(Step C):
    # "let h denote the smallest uncovered element of the matrix;"
    # find h and track the location of those new zeros
    # inspired by @PaulBellette's method at the link below, all credits to him
    # https://github.com/FugroRoames/Munkres.jl/blob/34065d11d0a6f224731e77f84c7cf1f5096121b5/src/Munkres.jl#L321-L347
    h = typemax(T)
    uncoveredRowInds = find(!rowCovered)
    uncoveredColumnInds = find(!columnCovered)
    minLocations = Int[]
    for j in uncoveredColumnInds, i in uncoveredRowInds
        @inbounds cost = A[i,j]
        if cost < h
            h = cost
            empty!(minLocations)
            push!(minLocations, i, j)
        elseif cost == h
            push!(minLocations, i, j)
        end
    end

    # # "add h to each covered row;"
    # A[rowCovered,:] += h
    # # "then subtract h from each uncovered column."
    # A[:,!columnCovered] -= h

    # de-vectorlize for better performance
    # "add h to each covered row;"
    coveredRowInds = find(rowCovered)
    for j = 1:size(A,2), i in coveredRowInds
        @inbounds A[i,j] += h
    end

    # "then subtract h from each uncovered column."
    for j in uncoveredColumnInds, i = 1:size(A,1)
        @inbounds A[i,j] -= h
    end

    # mark new zeros in Zs and remove those elements that will no longer be zero
    #             -h                    ||
    #              |     no change      || reduce old zeros
    #              | change:(+h)+(-h)=0 ||     change: +h
    #       +h ---------Covered Row-----||----Covered Row--------
    #              |  Uncovered Column  ||  Covered Column
    #==============|====================||================================#
    #              |   Uncovered Row    ||   Uncovered Row
    #              |  Uncovered Column  ||  Covered Column
    #              |    change: -h      ||    change: 0
    #              | produce new zeros  ||    no change
    #              |                    ||
    # produce new zeros
    for i = 1:2:length(minLocations)
        Zs[minLocations[i], minLocations[i+1]] = Z
    end
    # reduce old zeros
    coveredColumnInds = find(columnCovered)
    rows = rowvals(Zs)
    for c in coveredColumnInds, i in nzrange(Zs, c)
        r = rows[i]
        if rowCovered[r]
            Zs[r,c] = 0
        end
    end
    dropzeros!(Zs)

    # "return to step 1."
    return stepNum = 1
end
