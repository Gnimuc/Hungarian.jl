module Hungarian

# enums
@enum MARK N=0 ZERO=1 STAR=2 PRIME=3

Base.zero(::Type{MARK}) = convert(MARK,0)

include("./Munkres.jl")

export munkres

end # module
