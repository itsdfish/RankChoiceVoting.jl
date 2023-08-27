"""
    InstantRunOff{T,I<:Integer} <: VotingSystem{T,I}

An instant runoff voting system object.

# Arguments

- `uranks`: a vector of unique rankings. Each ranking is a vector in which index represents rank and value represents candidate id.
- `counts`: a vector of frequency counts corresponding to each unique ranking 
"""
mutable struct InstantRunOff{T,I<:Integer} <: VotingSystem{T,I}
    uranks::Vector{Vector{T}}
    counts::Vector{I}
end

"""
    InstantRunOff(rankings=[Symbol[]])

A constructor for an instant runoff voting system

# Arguments
- `rankings`: a vector of rankings. Each ranking is a vector in which index represents rank and value represents candidate id.
"""
function InstantRunOff(rankings=[Symbol[]])
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
    rank,candidates = compute_ranks(system)
    return candidates[rank .== 1]
end

function compute_ranks(system::InstantRunOff)
    counts = deepcopy(get_counts(system))
    uranks = deepcopy(get_uranks(system))
    winner_idx = -100
    n_votes = sum(counts)
    candidates = uranks[1][:]
    n_candidates = length(candidates)
    max_iter = n_candidates - 1
    ranked_candidates = uranks[1][:]
    rank_value = fill(0, length(ranked_candidates))
    i = 1
    while i ≤ max_iter
        #the number of first ranked votes for each candidate
        n_first = map(id -> count_top_ranks(counts, uranks, id), candidates)
        max_first,winner_idx = findmax(n_first)
        if (max_first / n_votes) > .50
            idx = sortperm(n_first, rev=true)
            for (j,v) ∈ enumerate(idx)
                ranked_candidates[j] = candidates[v]
                rank_value[j] = j
            end
            return rank_value, ranked_candidates
        end 
        if i < max_iter
            min_val,loser_idx = findmin(n_first)
            loser = candidates[loser_idx]
            ridx = n_candidates - i + 1
            ranked_candidates[ridx] = loser
            rank_value[ridx] = ridx
            remove_candidate!.(uranks, loser)
            deleteat!(candidates, loser_idx)
        end   
        i += 1  
    end
    n_remaining = length(candidates)
    ranked_candidates[1:n_remaining] .= candidates 
    rank_value[1:n_remaining] .= 1 
    return rank_value, ranked_candidates
end