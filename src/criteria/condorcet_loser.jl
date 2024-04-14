"""
    CondorcetLoser <: Condorcet

A Condorcet loser criterion object. The Condorcet loser criterion states that a voting system cannot selected
acandiate who loses all pairwise comparisons cannot be selected.
"""
struct CondorcetLoser <: Condorcet
end

"""
    satisfies(system::VotingSystem, criterion::CondorcetLoser, rankings::Ranks; _...)

Tests whether a voting system satisfies the Condorcet loser criterion.

# Arguments

- `system::VotingSystem`: a voting system object
- `criterion::CondorcetLoser`: condorcet loser criterion object 
- `rankings::Ranks`: a rank choice voting object consisting of rank counts and unique ranks 
"""
function satisfies(
    ::Fails,
    system::VotingSystem,
    criterion::CondorcetLoser,
    rankings::Ranks{T};
    _...
) where {T}
    rankings = deepcopy(rankings)
    (; counts, uranks) = rankings
    candidates = uranks[1]
    winner = evaluate_winner(system, rankings)
    length(winner) ≠ 1 ? (return true) : nothing
    pairs = combinations(candidates, 2) |> collect
    condorcet_losers = T[]
    for c ∈ candidates
        if is_condorcet(counts, uranks, pairs, c; compare = <)
            push!(condorcet_losers, c)
            break
        end
    end
    return (winner[1] ∉ condorcet_losers) || isempty(condorcet_losers)
end

"""
    count_violations(system::VotingSystem, criterion::CondorcetLoser, rankings::Ranks; _...)

Counts the number of violations of the Condorcet loser criterion for a given voting system. The count is 
either 0 or 1. 

# Arguments

- `system::VotingSystem`: a voting system object
- `criterion::CondorcetLoser`: condorcet criterion object
- `rankings::Ranks`: a rank choice voting object consisting of rank counts and unique ranks 
"""
function count_violations(
    T::Fails,
    system::VotingSystem,
    criterion::CondorcetLoser,
    rankings::Ranks;
    _...
)
    return satisfies(T, system, criterion, rankings) ? 0 : 1
end

property(::Borda, ::CondorcetLoser) = Holds()
property(::InstantRunOff, ::CondorcetLoser) = Holds()
