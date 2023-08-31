"""
    Borda <: VotingSystem

A Borda count voting system object.
"""
mutable struct Borda <: VotingSystem end

"""
    evaluate_winner(system::Borda, rankings::Ranks)

Returns the id of the winning candiate in Borda count system. 

# Arguments

- `system`: a Borda voting system object
- `rankings::Ranks`: an object containing counts and unique rank orders 
"""
function evaluate_winner(system::Borda, rankings::Ranks)
    ranks,candidates = compute_ranks(system, rankings)
    return candidates[ranks .== 1]
end

"""
    compute_ranks(system::Borda, rankings::Ranks)

Ranks candidates using Borda count system. 

# Arguments

- `system`: a Borda voting system object
- `rankings::Ranks`: an object containing counts and unique rank orders 
"""
function compute_ranks(system::Borda, rankings::Ranks)
    scores = score(system, rankings)
    sort!(scores, byvalue=true, rev=true)
    ranks = tied_ranks(collect(values(scores)))
    candidates = collect(keys(scores))
    return ranks, candidates
end

function score(system::Borda, rankings::Ranks)
    (;counts,uranks) = rankings
    candidates = uranks[1]
    scores = OrderedDict(c => 0 for c ∈ candidates)
    n_candidates = length(candidates)
    for r ∈ 1:length(counts), i ∈ 1:n_candidates
        c = uranks[r][i]
        points = n_candidates - i + 1
        scores[c] += counts[r] * points
    end
    return scores 
end