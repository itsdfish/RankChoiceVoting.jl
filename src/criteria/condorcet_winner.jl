"""
    CondorcetWinner <: Criterion

A Condorcet winner criterion object. The Condorcet criterion states that a candiate who wins all
pairwise elections must also win the election using a given voting system.
"""
mutable struct CondorcetWinner <: Condorcet

end

"""
    satisfies(system::VotingSystem, criterion::CondorcetWinner; _...)

Tests whether a voting system satisfies the Condorcet winner criterion.

# Arguments

- `system::VotingSystem`: a voting system object
- `criterion::CondorcetWinner`: condorcet criterion object 
"""
function satisfies(::Fails, system::VotingSystem{T,I}, criterion::CondorcetWinner; _...) where {T,I}
    system = deepcopy(system)
    (;counts,uranks) = system
    candidates = uranks[1]
    winner = evaluate_winner(system)
    length(winner) ≠ 1 ? (return true) : nothing
    pairs = combinations(candidates, 2) |> collect
    condorcet_winners = T[]
    for c ∈ candidates
        if is_condorcet(counts, uranks, pairs, c)
            push!(condorcet_winners, c)
            break
        end
    end
    return (winner[1] ∈ condorcet_winners) || isempty(condorcet_winners)
end

"""
    count_violations(system::VotingSystem, criterion::CondorcetWinner; _...)

Counts the number of violations of the Condorcet for a given voting system.

# Arguments

- `system::VotingSystem`: a voting system object
- `criterion::CondorcetWinner`: condorcet criterion object 
"""
function count_violations(T, system::VotingSystem, criterion::CondorcetWinner; _...)
    return satisfies(T, system, criterion) ? 0 : 1
end

"""
    is_condorcet(counts, uranks, pairs, id; compare = >)

Tests whether a candidate is the Condorcet winner or loser, depending on the keyword `compare`.

# Arguments

- `uranks`: a vector of unique rankings. Each ranking is a vector in which index represents rank and value represents candidate id.
- `counts`: a vector of frequency counts corresponding to each unique ranking 
- `pairs`: combination of pairwise candidate ids
- `id`: target candidate id

# Keywords 

- `compare = >`: use `>` for winner and `<` for loser
"""
function is_condorcet(counts, uranks, pairs, id; compare = >)
    c_pairs = filter(x -> id ∈ x, pairs)
    for p ∈ c_pairs
        id1 = head_to_head(counts, uranks, p...; compare)
        id1 ≠ id ? (return false) : nothing
    end
    return true 
end

"""
    head_to_head(system, id1, id2)

Returns the winner of a pairwise election between two candidates

# Arguments

- `system`: a voting system object
- `id1`: candidate id 1
- `id2`: candidate id 2
"""
head_to_head(system, id1, id2; compare = >) = head_to_head(system.counts, system.uranks, id1, id2; compare)

"""
    head_to_head(counts, uranks, id1, id2)

Returns the winner of a pairwise election between two candidates

# Arguments

- `uranks`: a vector of unique rankings. Each ranking is a vector in which index represents rank and value represents candidate id.
- `counts`: a vector of frequency counts corresponding to each unique ranking 
- `id1`: candidate id 1
- `id2`: candidate id 2

# Keywords 

- `compare = >`: use `>` for winner and `<` for loser
"""
function head_to_head(counts, uranks, id1, id2; compare = >)
    cnt = 0
    for i ∈ 1:length(counts)
        r = findfirst(x -> x == id1 || x == id2, uranks[i])
        cnt += uranks[i][r] == id1 ? counts[i] : -counts[i] 
    end
    return compare(cnt, 0) ? id1 : id2
end