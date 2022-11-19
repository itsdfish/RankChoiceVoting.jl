"""
    ReversalAsymmetry <: Criterion

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
function satisfies(system::VotingSystem, criterion::ReversalSymmetry; kwargs...)
    winner = evaluate_winner(system)
    _system = deepcopy(system)
    reverse!.(_system.uranks)
    _winner = evaluate_winner(_system)
    return winner ≠ _winner
end

"""
    count_violations(system::VotingSystem, criterion::ReversalSymmetry; _...)

Counts the number of violations of the reversal symmetry criterion for a given voting system.

# Arguments

- `system::VotingSystem`: a voting system object
- `criterion::ReversalSymmetry`: reversal symmetry criterion object 
"""
function count_violations(system::VotingSystem, criterion::ReversalSymmetry; _...)
    return satisfies(system, criterion) ? 0 : 1
end

"""
    satisfies(system::Borda, criterion::ReversalSymmetry; _...)

Tests whether the Borda count satisfies the reversal symmetry criterion. A value of true is always returned.

# Arguments

- `system::Borda`: a voting system object
- `criterion::ReversalSymmetry`: condorcet criterion object 
"""
function satisfies(system::Borda, criterion::ReversalSymmetry; kwargs...)
    return true
end

"""
    count_violations(system::Borda, criterion::ReversalSymmetry; _...)

Counts the number of violations of the reversal symmetry criterion for the Borda count. A value of zero is 
always returned

# Arguments

- `system::Borda`: a voting system object
- `criterion::ReversalSymmetry`: reversal symmetry criterion object 
"""
function count_violations(system::Borda, criterion::ReversalSymmetry; _...)
    return 0
end