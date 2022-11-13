"""
    ReversalAsymmetry <: Criterion

An object for the fairness criterion reversal symmetry. According to the reversal systemetry criterion, 
a winner of an election cannot win if each voter's ranks are reversed
"""
mutable struct ReversalSymmetry <: Criterion

end

"""
    Monotonicity <: Criterion

An object for the fairness criterion monotonicity. Monotonicity states that the societal rank order of a candidate
should not decrease if a person increases his or perference for the same candidate. In other words, increasing perference
for a candidate should not "hurt" the candidate. 
"""
mutable struct Monotonicity <: Criterion

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
        # if sum(abs.(_system.counts .- [47,22,2,29,0,0]))  < 50
        #     println(_system.counts)
        # end
        new_winner = evaluate_winner(_system)
        cnt += winner ≠ new_winner ? 1 : 0
    end
    return cnt 
end