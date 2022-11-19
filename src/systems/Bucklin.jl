"""
    Bucklin{T,I<:Integer} <: VotingSystem

A Bucklin voting system object.

# Arguments

- `uranks`: a vector of unique rankings. Each ranking is a vector in which index represents rank and value represents candidate id.
- `counts`: a vector of frequency counts corresponding to each unique ranking 
"""
mutable struct Bucklin{T,I<:Integer} <: VotingSystem
    uranks::Vector{T}
    counts::Vector{I}
end

"""
    Bucklin(rankings)

A constructor for a Bucklin voting system

# Arguments

- `rankings`: a vector of rankings. Each ranking is a vector in which index represents rank and value represents candidate id.
"""
function Bucklin(rankings)
    counts, uranks = tally(rankings)
    return Bucklin(uranks, counts)
end

"""
    evaluate_winner(system::Bucklin)

Returns the id of the winning candiate in Bucklin voting system. 

# Arguments

- `system`: a Bucklin voting system object
"""
function evaluate_winner(system::Bucklin)
    counts = get_counts(system)
    uranks = get_uranks(system)
    winner = uranks[1][1]
    n_votes = sum(counts)
    max_iter = length(uranks[1]) - 1
    candidates = uranks[1]
    scores = Dict(c => 0 for c ∈ candidates)
    for r ∈ 1:max_iter
        tally_rank!(scores, counts, uranks, r)
        max_score,winner = findmax(scores)
        (max_score / n_votes) ≥ .50 ? (return winner) : nothing
    end
    return winner
end

"""
    tally_rank!(scores, counts, uranks, r)

Tallies a score based on the count of a rank for a candidate. For example, if a canidate has 28 first 
rank votes, the canidate will have a tally of 28. 

# Arguments

- `scores`: a dictionary mapping candidate id to score 
- `uranks`: a vector of unique rankings. Each ranking is a vector in which index represents rank and value represents candidate id.
- `counts`: a vector of frequency counts corresponding to each unique ranking 
- `r`: the rank being tallied
"""
function tally_rank!(scores, counts, uranks, r)
    for i ∈ 1:length(counts)
        c = uranks[i][r]
        scores[c] += counts[i]
    end
end