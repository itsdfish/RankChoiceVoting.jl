"""
    Borda{T,I<:Integer} <: VotingSystem{T,I}

A Borda count voting system object.

# Arguments

- `uranks`: a vector of unique rankings. Each ranking is a vector in which index represents rank and value represents candidate id.
- `counts`: a vector of frequency counts corresponding to each unique ranking 
"""
mutable struct Borda{T,I<:Integer} <: VotingSystem{T,I}
    uranks::Vector{Vector{T}}
    counts::Vector{I}
end

"""
    Borda(rankings=[Symbol[]])

A constructor for a Borda count voting system

# Arguments

- `rankings`: a vector of rankings. Each ranking is a vector in which index represents rank and value represents candidate id.
"""
function Borda(rankings=[Symbol[]])
    counts, uranks = tally(rankings)
    return Borda(uranks, counts)
end

"""
    evaluate_winner(system::Borda)

Returns the id of the winning candiate in Borda count election. 

# Arguments

- `system`: a Borda voting system object
"""
function evaluate_winner(system::Borda)
    ranks,candidates = compute_ranks(system)
    return candidates[ranks .== 1]
end

function compute_ranks(system::Borda)
    scores = score(system)
    sort!(scores, byvalue=true, rev=true)
    ranks = tied_ranks(collect(values(scores)))
    candidates = collect(keys(scores))
    return ranks, candidates
end

function score(system::Borda)
    counts = get_counts(system)
    uranks = get_uranks(system)
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