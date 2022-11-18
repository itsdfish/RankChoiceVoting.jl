"""
    Borda{T,I<:Integer} <: VotingSystem

A Borda count voting system object.

# Arguments

- `uranks`: a vector of unique rankings. Each ranking is a vector in which index represents rank and value represents candidate id.
- `counts`: a vector of frequency counts corresponding to each unique ranking 
"""
mutable struct Borda{T,I<:Integer} <: VotingSystem
    uranks::Vector{T}
    counts::Vector{I}
end

"""
Borda(rankings)

A constructor for a Borda count voting system

# Arguments

- `rankings`: a vector of rankings. Each ranking is a vector in which index represents rank and value represents candidate id.
"""
function Borda(rankings)
    counts, uranks = tally(rankings)
    return Borda(uranks, counts)
end

"""
    evaluate_winner(system::Borda)

Returns the id of the winning candiate in Borda count election. 

# Arguments

- `system`: an instant runoff system object
"""
function evaluate_winner(system::Borda)
    scores = score_borda(system)
    return findmax(scores)[2]
end

function score_borda(system::Borda)
    counts = deepcopy(get_counts(system))
    uranks = deepcopy(get_uranks(system))
    winner_idx = -100
    n_votes = sum(counts)
    candidates = uranks[1]
    scores = Dict(c => 0 for c ∈ candidates)
    n_candidates = length(candidates)
    for r ∈ 1:length(counts), i ∈ 1:n_candidates
        c = uranks[r][i]
        points = n_candidates - i + 1
        scores[c] += counts[r] * points
    end
    return scores 
end