"""
    Monotonicity <: Criterion

An object for the fairness criterion monotonicity. A voting system that satisfies the monotonicity criterion cannot elect 
a different candidate by increasing votes (without otherwise changing the rank order) of a candidate who would otherwise win.
In other words, redistributing more votes to the winner (without otherwise changing the rank order), should not prevent the winner
from winning. 
"""
mutable struct Monotonicity <: Criterion

end

function satisfies(system::VotingSystem, criteria::Monotonicity; n_reps=1000)
    system = deepcopy(system)
    add_zero_counts!(system)
    winner = evaluate_winner(system)
    win_ind = map(x -> x[1] == winner, system.uranks)
    for _ ∈ 1:n_reps
        _system = deepcopy(system)
        redistribute!(_system, win_ind)
        new_winner = evaluate_winner(_system)
        winner ≠ new_winner ? (return false) : nothing
    end
    return true
end

function count_violations(system::VotingSystem, criteria::Monotonicity; n_reps=1000)
    system = deepcopy(system)
    add_zero_counts!(system)
    winner = evaluate_winner(system)
    win_ind = map(x -> x[1] == winner, system.uranks)
    cnt = 0
    for _ ∈ 1:n_reps
        _system = deepcopy(system)
        redistribute!(_system, win_ind)
        new_winner = evaluate_winner(_system)
        cnt += winner ≠ new_winner ? 1 : 0
    end
    return cnt 
end