function munkres{T<:Real}(input::Array{T,2})
    A = copy(input)
    rowLen, columnLen = size(A)
    # preliminaries
    # "no lines are covered;"
    rowCovered = falses(rowLen)
    columnCovered = falses(columnLen)

    # "no zeros are starred or primed."
    # we can use a sparse matrix Zs to store these three kinds of markers:
    # 1 => ordinary zero
    # 2 => starred zero
    # 3 => primed zero
    # (TODO: use @enum instead of hard-coded integer)
    Zs = spzeros(Int, rowLen, columnLen)

    # "consider a row of the matrix A;
    #  subtract from each element in this row the smallest element of this row.
    #  do the same for each row."
    # it's succinct to implement this using broadcasting.
    A .-= minimum(A, 2)

    # "then consider each column of the resulting matrix and subtract from each
    #  column its smallest entry."
    A .-= minimum(A, 1)

    for ii in CartesianRange(size(A))
        # "consider a zero Z of the matrix;"
        if A[ii] == 0
            Zs[ii] = 1
            # "if there is no starred zero in its row and none in its column, star Z.
            #  repeat, considering each zero in the matrix in turn;"
            r, c = ii.I
            if !( any(Zs[r,:] .== 2) || any(Zs[:,c] .== 2) )
                Zs[r,c] = 2
                # "then cover every column containing a starred zero."
                columnCovered[c] = true
            end
        end
    end

    # preliminaries done, go to step 1
    stepNum = 1

    # if the assignment is already found, exist
    if all(columnCovered)
        stepNum = 0
    end

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

function step1!(Zs::SparseMatrixCSC{Int,Int},
                rowCovered::BitArray{1},
                columnCovered::BitArray{1}
               )
    columnLen = size(Zs)[2]
    rows = rowvals(Zs)
    # step 1
    zeroCoveredNum = 0
    # "repeat until all zeros are covered."
    while zeroCoveredNum < nnz(Zs)
        zeroCoveredNum = 0
        for c = 1:columnLen, i in nzrange(Zs, c)
            r = rows[i]
            # "choose a non-covered zero and prime it, consider the row containing it."
            if columnCovered[c] == false && rowCovered[r] == false
                Zs[r,c] = 3
                # "if there is a starred zero Z in this row"
                columnZ = 0
                for zc = 1:columnLen
                    if Zs[r,zc] == 2
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
                    return stepNum = 2
                end
            else
                # otherwise, this zero is covered
                zeroCoveredNum += 1
            end
        end
    end
    # "go to step 3."
    return stepNum = 3
end

function step2!(Zs::SparseMatrixCSC{Int,Int},
                rowCovered::BitArray{1},
                columnCovered::BitArray{1}
               )
    ZsDims = size(Zs)
    rows = rowvals(Zs)
    # step 2
    sequence = Int[]
    flag = false
    # "there is a sequence of alternating primed and starred zeros, constructed
    #  as follows:"
    # "let Z₀ denote the uncovered 0′.[there is only one.]"
    for c = 1:ZsDims[2], i in nzrange(Zs, c)
        r = rows[i]
        # note that Z₀ is an **uncovered** 0′
        if Zs[r,c] == 3 && columnCovered[c] == false && rowCovered[r] == false
            # push Z₀(uncovered 0′) into the sequence
            push!(sequence, sub2ind(ZsDims, r, c))
            # "let Z₁ denote the 0* in the Z₀'s column.(if any)"
            # find 0* in Z₀'s column
            for j in nzrange(Zs, c)
                Z₁r = rows[j]
                if Zs[Z₁r, c] == 2
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
        # find Z₂ in Z₃'s row
        for c = 1:ZsDims[2]
            if Zs[r,c] == 3
                # push Z₂ into the sequence
                push!(sequence, sub2ind(ZsDims, r, c))
                # find 0* in Z₂'s column
                for j in nzrange(Zs, c)
                    Z₃r = rows[j]
                    if Zs[Z₃r, c] == 2
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
    Zs[sequence[2:2:end-1]] = 1

    # "and star each primed zero of the sequence."
    Zs[sequence[1:2:end]] = 2

    for c = 1:ZsDims[2], i in nzrange(Zs, c)
        r = rows[i]
        # "erase all primes;"
        if Zs[r,c] == 3
            Zs[r,c] = 1
        end
        # "and cover every column containing a 0*."
        if Zs[r,c] == 2
            columnCovered[c] = true
        end
    end

    # "uncover every row"
    rowCovered[:] = false

    # "if all columns are covered, the starred zeros form the desired independent set."
    if all(columnCovered)
        return stepNum = 0
    else
        # "otherwise, return to step 1."
        return stepNum = 1
    end
end

function step3!{T<:Real}(A::Array{T,2},
                         Zs::SparseMatrixCSC{Int,Int},
                         rowCovered::BitArray{1},
                         columnCovered::BitArray{1}
                        )
    # step 3 (Step C)
    # "let h denote the smallest uncovered element of the matrix;"
    uncoveredA = @view A[!rowCovered,!columnCovered]
    h = minimum(uncoveredA)

    # use for-loops for better performance
    @inbounds for ii in CartesianRange(size(A))
        # "add h to each covered row;"
        if rowCovered[ii[1]]
            A[ii] += h
        end
        # "then subtract h from each uncovered column."
        if !columnCovered[ii[2]]
            A[ii] -= h
        end
        # mark new zeros in Zs
        if A[ii] == 0 && Zs[ii] == 0
            Zs[ii] = 1
        end
    end

    # "return to step 1."
    return stepNum = 1
end
