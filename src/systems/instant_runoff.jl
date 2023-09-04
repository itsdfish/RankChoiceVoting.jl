"""
    InstantRunOff{T,I<:Integer} <: VotingSystem{T,I}

An instant runoff voting system object.

# Arguments

- `uranks`: a vector of unique rankings. Each ranking is a vector in which index represents rank and value represents candidate id.
- `counts`: a vector of frequency counts corresponding to each unique ranking 
"""
struct InstantRunOff <: VotingSystem end

"""
    evaluate_winner(system::InstantRunOff, rankings::Ranks)

Returns the id of the winning candiate in an instant runoff election. 

# Arguments
- `system`: an instant runoff system object
- `rankings::Ranks`: an object containing counts and unique rank orders 
"""
function evaluate_winner(system::InstantRunOff, rankings::Ranks)
    rank,candidates = compute_ranks(system, rankings)
    return candidates[rank .== 1]
end

"""
    compute_ranks(system::InstantRunOff, rankings::Ranks)

Ranks candidates using the InstantRunOff system. 

# Arguments

- `system`: an InstantRunOff voting system object
- `rankings::Ranks`: an object containing counts and unique rank orders 
"""
function compute_ranks(system::InstantRunOff, rankings::Ranks)
    counts = deepcopy(get_counts(rankings))
    uranks = deepcopy(get_uranks(rankings))
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