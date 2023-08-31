"""
    Bucklin{T,I<:Integer} <: VotingSystem{T,I}

A Bucklin voting system object.

"""
mutable struct Bucklin <: VotingSystem end

"""
    evaluate_winner(system::Bucklin)

Returns the id of the winning candiate in Bucklin voting system. 

# Arguments

- `system`: a Bucklin voting system object
"""
function evaluate_winner(system::Bucklin, rankings::Ranks)
    ranks,candidates = compute_ranks(system, rankings)
    return candidates[ranks .== 1]
end

function compute_ranks(system::Bucklin, rankings::Ranks)
    scores = score(system, rankings)
    sort!(scores, byvalue=true, rev=true)
    ranks = tied_ranks(collect(values(scores)))
    candidates = collect(keys(scores))
    return ranks, candidates
end

function score(system::Bucklin, rankings::Ranks)
    counts = get_counts(rankings)
    uranks = get_uranks(rankings)
    winner = uranks[1][1]
    n_votes = sum(counts)
    max_iter = length(uranks[1]) - 1
    candidates = uranks[1]
    scores = OrderedDict(c => 0 for c ∈ candidates)
    for r ∈ 1:max_iter
        score!(scores, counts, uranks, r)
        max_score,winner = findmax(scores)
        (max_score / n_votes) ≥ .50 ? break : nothing
    end
    return scores
end

"""
    score!(scores, counts, uranks, r)

Tallies a score based on the count of a rank for a candidate. For example, if a canidate has 28 first 
rank votes, the canidate will have a tally of 28. 

# Arguments

- `scores`: a dictionary mapping candidate id to score 
- `uranks`: a vector of unique rankings. Each ranking is a vector in which index represents rank and value represents candidate id.
- `counts`: a vector of frequency counts corresponding to each unique ranking 
- `r`: the rank being tallied
"""
function score!(scores, counts, uranks, r)
    for i ∈ 1:length(counts)
        c = uranks[i][r]
        scores[c] += counts[i]
    end
end