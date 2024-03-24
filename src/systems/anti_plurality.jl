"""
    Plurality <: VotingSystem

A Plurality  voting system object.
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
    ranks, candidates = compute_ranks(system, rankings)
    return candidates[ranks.==1]
end

"""
    compute_ranks(system::Plurality, rankings::Ranks)

Ranks candidates using Plurality system. 

# Arguments

- `system`: a Plurality voting system object
- `rankings::Ranks`: an object containing s and unique rank orders 
"""
function compute_ranks(system::Plurality, rankings::Ranks)
    scores = score(system, rankings)
    sort!(scores, byvalue = true, rev = true)
    ranks = denserank(collect(values(scores)), rev = true)
    candidates = collect(keys(scores))
    return ranks, candidates
end
