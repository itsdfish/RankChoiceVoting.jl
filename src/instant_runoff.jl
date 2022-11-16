"""
    InstantRunOff{T,I<:Integer} <: VotingSystem

An instant runoff voting system object.

# Arguments

- `uranks`: a vector of unique rankings. Each ranking is a vector in which index represents rank and value represents candidate id.
- `counts`: a vector of frequency counts corresponding to each unique ranking 
"""
mutable struct InstantRunOff{T,I<:Integer} <: VotingSystem
    uranks::Vector{T}
    counts::Vector{I}
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

"""
    evaluate_winner(system::InstantRunOff)

Returns the id of the winning candiate in an instant runoff election. 

# Arguments
- `system`: an instant runoff system object
"""
function evaluate_winner(system::InstantRunOff)
    counts = deepcopy(get_counts(system))
    uranks = deepcopy(get_uranks(system))
    winner_idx = -100
    n_votes = sum(counts)
    max_iter = length(uranks[1]) - 1
    candidates = uranks[1][:]
    for _ ∈ 1:max_iter
        n_first = map(id -> count_top_ranks(counts, uranks, id), candidates)
        max_first,winner_idx = findmax(n_first)
        (max_first / n_votes) ≥ .50 ? (return candidates[winner_idx]) : nothing
        _,loser_idx = findmin(n_first)
        remove_candidate!.(uranks, candidates[loser_idx])
        deleteat!(candidates, loser_idx)
    end
    return candidates[winner_idx]
end