function count_violations(system::VotingSystem, criteria::ReversalSymmetry)
    winner = evaluate_winner(system)
    _system = deepcopy(system)
    reverse!.(_system.uranks)
    _winner = evaluate_winner(_system)
    return winner == _winner ? 1 : 0
end

function count_violations(system::VotingSystem)

end