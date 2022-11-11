abstract type VotingSystem end

"""
    InstantRunOff{T} <: VotingSystem

An instant runoff voting system object.

# Arguments
- `uranks`: a vector of unique rankings. Each ranking is a vector in which index represents rank and value represents candidate id.
- `counts`: a vector of frequency counts corresponding to each unique ranking 
"""
mutable struct InstantRunOff{T} <: VotingSystem
    uranks::Vector{T}
    counts::Vector{<:Integer}
end

"""
    InstantRunOff(rankings)

A constructor for an instant runoff voting system

#Arguments
- `rankings`: a vector of rankings. Each ranking is a vector in which index represents rank and value represents candidate id.
"""
function InstantRunOff(rankings)
    counts, uranks = tally(rankings)
    return InstantRunOff(uranks, counts)
end