"""
    ReversalAsymmetry <: Criterion

An object for the fairness criterion reversal symmetry. According to the reversal systemetry criterion, 
a winner of an election cannot win if each voter's rankings are reversed
"""
mutable struct ReversalSymmetry <: Criterion

end

function satisfies(system::VotingSystem, criteria::ReversalSymmetry)
    winner = evaluate_winner(system)
    _system = deepcopy(system)
    reverse!.(_system.uranks)
    _winner = evaluate_winner(_system)
    return winner ≠ _winner
end

function count_violations(system::VotingSystem, criteria::ReversalSymmetry)
    return satisfies(system, criteria) ? 0 : 1
end