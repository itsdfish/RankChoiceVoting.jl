"""
    Minimax <: VotingSystem

A Minimax voting system object.
"""
mutable struct Minimax <: VotingSystem end

"""
    evaluate_winner(system::Minimax, rankings::Ranks)

Returns the id of the winning candiate in Minimax system. 

# Arguments

- `system`: a Minimax voting system object
- `rankings::Ranks`: an object containing counts and unique rank orders 
"""
function evaluate_winner(system::Minimax, rankings::Ranks)
    ranks,candidates = compute_ranks(system, rankings)
    return candidates[ranks .== 1]
end

"""
    compute_ranks(system::Minimax, rankings::Ranks)

Ranks candidates using Minimax system. 

# Arguments

- `system`: a Minimax voting system object
- `rankings::Ranks`: an object containing counts and unique rank orders 
"""
function compute_ranks(system::Minimax, rankings::Ranks)
    candidates = rankings.uranks[1]
    defeat_margins = score_pairwise(rankings, candidates)
    max_defeats = maximum(defeat_margins, dims=1)[:]
    ranks = denserank(max_defeats)
    return ranks, candidates
end

function score_pairwise(rankings, candidates)
    n = length(candidates)
    scores = fill(0, n-1, n)
    for i ∈ 1:n
        z = 1
        for j ∈ 1:n 
            i == j ? continue : nothing 
            scores[z,i] = win_margin(rankings, candidates[j], candidates[i])
            z += 1
        end
    end
    return scores
end

function win_margin(rankings, c1, c2)
    (;counts,uranks) = rankings 
    cnt = 0
    n = sum(counts)
    for i ∈ 1:length(counts)
        r1 = findfirst(x -> x == c1, uranks[i])
        r2 = findfirst(x -> x == c2, uranks[i])
        cnt += r1 < r2 ? counts[i] : 0
    end
    return 2 * cnt - n
end