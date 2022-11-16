"""
    ReversalAsymmetry <: Criterion

An object for the fairness criterion reversal symmetry. According to the reversal systemetry criterion, 
a winner of an election cannot win if each voter's rankings are reversed
"""
mutable struct ReversalSymmetry <: Criterion

end

"""
    satisfies(system::VotingSystem, criteria::ReversalSymmetry; _...)

Tests whether a voting system satisfies the reversal symmetry criterion.

# Arguments

- `system::VotingSystem`: a voting system object
- `criteria::ReversalSymmetry`: condorcet criterion object 
"""
function satisfies(system::VotingSystem, criteria::ReversalSymmetry; kwargs...)
    winner = evaluate_winner(system)
    _system = deepcopy(system)
    reverse!.(_system.uranks)
    _winner = evaluate_winner(_system)
    return winner ≠ _winner
end

"""
    count_violations(system::VotingSystem, criteria::ReversalSymmetry; _...)

Counts the number of violations of the reversal symmetry criterion for a given voting system.

# Arguments

- `system::VotingSystem`: a voting system object
- `criteria::ReversalSymmetry`: reversal symmetry criterion object 
"""
function count_violations(system::VotingSystem, criteria::ReversalSymmetry; _...)
    return satisfies(system, criteria) ? 0 : 1
end