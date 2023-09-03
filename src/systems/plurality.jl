"""
    Plurality <: VotingSystem

A Plurality voting system object.
"""
mutable struct Plurality <: VotingSystem end

"""
    evaluate_winner(system::Plurality, rankings::Ranks)

Returns the id of the winning candiate in Plurality system. 

# Arguments

- `system`: a Plurality voting system object
- `rankings::Ranks`: an object containing s and unique rank orders 
"""
function evaluate_winner(system::Plurality, rankings::Ranks)
    _,candidates = compute_ranks(system, rankings)
    return candidates
end

"""
    compute_ranks(system::Plurality, rankings::Ranks)

Ranks candidates using Plurality system. 

# Arguments

- `system`: a Plurality voting system object
- `rankings::Ranks`: an object containing counts and unique rank orders 
"""
function compute_ranks(system::Plurality, rankings::Ranks)
    (;counts,uranks) = rankings
    ids = uranks[1]
    top_counts = map(id -> count_top_ranks(counts, uranks, id), ids)
    max_first,winner_idx = findmax(top_counts)
    max_ids = findall(x -> x == max_first, top_counts)
    return fill(1, length(max_ids)), ids[max_ids]
end
