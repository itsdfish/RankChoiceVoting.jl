"""
    ReversalSymmetry <: Criterion

An object for the fairness criterion reversal symmetry. According to the reversal systemetry criterion, 
a winner of an election cannot win if each voter's rankings are reversed
"""
mutable struct ReversalSymmetry <: Criterion

end

"""
    satisfies(system::VotingSystem, criterion::ReversalSymmetry; _...)

Tests whether a voting system satisfies the reversal symmetry criterion.

# Arguments

- `system::VotingSystem`: a voting system object
- `criterion::ReversalSymmetry`: condorcet criterion object 
"""
function satisfies(::Fails, system::VotingSystem, criterion::ReversalSymmetry, rankings::Ranks; kwargs...)
    winner = evaluate_winner(system, rankings)
    _rankings = deepcopy(rankings)
    reverse!.(_rankings.uranks)
    _winner = evaluate_winner(system, _rankings)
    return winner ≠ _winner
end

"""
    count_violations(system::VotingSystem, criterion::ReversalSymmetry; _...)

Counts the number of violations of the reversal symmetry criterion for a given voting system.

# Arguments

- `system::VotingSystem`: a voting system object
- `criterion::ReversalSymmetry`: reversal symmetry criterion object 
"""
function count_violations(T::Fails, system::VotingSystem, criterion::ReversalSymmetry, rankings::Ranks; _...)
    return satisfies(T, system, criterion, rankings) ? 0 : 1
end

property(::Borda, ::ReversalSymmetry) = Holds()
