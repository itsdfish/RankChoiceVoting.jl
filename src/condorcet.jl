mutable struct Condorcet <: Criterion

end

function satisfies(system::VotingSystem, criteria::Condorcet)
    system = deepcopy(system)
    (;counts,uranks) = system
    candidates = uranks[1]
    winner = evaluate_winner(system)
    pairs = combinations(candidates, 2) |> collect
    condorcet_winners = eltype(candidates)[]
    for c ∈ candidates
        if is_condorcet(counts, uranks, pairs, c)
            push!(condorcet_winners, c)
            break
        end
    end
    return ((winner ∈ condorcet_winners) || isempty(condorcet_winners))
end

function count_violations(system::VotingSystem, criteria::Condorcet)
    return satisfies(system, criteria) ? 0 : 1
end

function is_condorcet(counts, uranks, pairs, id)
    c_pairs = filter(x -> id ∈ x, pairs)
    for p ∈ c_pairs
        winner = head_to_head(counts, uranks, p...)
        winner ≠ id ? (return false) : nothing
    end
    return true 
end

head_to_head(system, id1, id2) = head_to_head(system.counts, system.uranks, id1, id2)

function head_to_head(counts, uranks, id1, id2)
    cnt = 0
    for i ∈ 1:length(counts)
        r = findfirst(x -> x == id1 || x == id2, uranks[i])
        cnt += uranks[i][r] == id1 ? counts[i] : -counts[i] 
    end
    return cnt > 0 ? id1 : id2
end