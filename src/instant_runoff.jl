"""
    evaluate_winner(system::InstantRunOff)

Returns the id of the winning candiate for an instant runoff election. 

# Arguments
- `system`: an instant runoff system object
"""
function evaluate_winner(system::InstantRunOff)
    counts = copy(system.counts)
    uranks = copy(system.uranks)
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
    return winner
end


