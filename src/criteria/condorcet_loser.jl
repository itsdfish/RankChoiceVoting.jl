"""
    CondorcetLoser <: Condorcet

A Condorcet loser criterion object. The Condorcet criterion states that a candiate who wins all
pairwise elections must also win the election using a given voting system.
"""
mutable struct CondorcetLoser <: Condorcet

end

"""
    satisfies(system::VotingSystem, criterion::CondorcetLoser; _...)

Tests whether a voting system satisfies the Condorcet loser criterion.

# Arguments

- `system::VotingSystem`: a voting system object
- `criterion::CondorcetLoser`: condorcet loser criterion object 
"""
function satisfies(::Fails, system::VotingSystem{T,I}, criterion::CondorcetLoser; _...) where {T,I}
    system = deepcopy(system)
    (;counts,uranks) = system
    candidates = uranks[1]
    winner = evaluate_winner(system)
    pairs = combinations(candidates, 2) |> collect
    condorcet_losers = T[]
    for c ∈ candidates
        if is_condorcet(counts, uranks, pairs, c; compare = <)
            push!(condorcet_losers, c)
            break
        end
    end
    return (winner ∉ condorcet_losers) || isempty(condorcet_losers)
end

"""
    count_violations(system::VotingSystem, criterion::CondorcetLoser; _...)

Counts the number of violations of the Condorcet loser criterion for a given voting system.

# Arguments

- `system::VotingSystem`: a voting system object
- `criterion::CondorcetLoser`: condorcet criterion object 
"""
function count_violations(T::Fails, system::VotingSystem, criterion::CondorcetLoser; _...)
    return satisfies(T, system, criterion) ? 0 : 1
end

property(::Borda, ::CondorcetLoser) = Holds()
property(::InstantRunOff, ::CondorcetLoser) = Holds()