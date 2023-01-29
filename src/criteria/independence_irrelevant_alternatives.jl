"""
Independence <: Criterion

A Consistency criterion object. According to the consistency criterion, if the votes are split into disjoint subsets, and 
the same candidate wins each subset, the system must select the same winner for the whole set of votes.
"""
mutable struct Independence <: Criterion

end

"""
    satisfies(::Fails, system::VotingSystem, criterion::Independence;  _...) 

Tests whether a voting system satisfies the Independence of Irrelevant alternatives criterion. There are
several ways to test this criterion. Currently, it is tested by removing subsets of losing candidates and 
testing whether the winner changes. Other methods could add and/or subtract candidates and test whether the 
rank order changes. The current method is less strict compared to alternative methods. 

# Arguments

- `system::VotingSystem`: a voting system object
- `criterion::Independence`: Independence criterion object 

"""
function satisfies(::Fails, system::VotingSystem, criterion::Independence;  _...) 
    winner = evaluate_winner(system)
    losers = setdiff(system.uranks[1], [winner])
    for i ∈ 1:(length(losers) - 1)
        for comb ∈ combinations(losers, i)
            _system = deepcopy(system)
            violates(winner, _system, comb) ? (return false) : nothing 
        end
    end 
    return true
end

function violates(winner, system, removed_candidates)
    for c ∈ removed_candidates
        remove_candidate!.(system.uranks, c)
    end
    new_winner = evaluate_winner(system)
    return winner ≠ new_winner
end

"""
    count_violations(system::VotingSystem, criterion::Independence; _...)

Counts the number of violations of the Independence of Irrelevant alternatives criterion. There are
several ways to test this criterion. Currently, it is tested by removing subsets of losing candidates and 
testing whether the winner changes. Other methods could add and/or subtract candidates and test whether the 
rank order changes. The current method is less strict compared to alternative methods. 

# Arguments

- `system::VotingSystem`: a voting system object
- `criterion::Independence`: Independence criterion object 

"""
function count_violations(::Fails, system::VotingSystem, criterion::Independence;  _...) 
    winner = evaluate_winner(system)
    losers = setdiff(system.uranks[1], [winner])
    cnt = 0
    for i ∈ 1:(length(losers) - 1)
        for comb ∈ combinations(losers, i)
            _system = deepcopy(system)
            cnt += violates(winner, _system, comb)
        end
    end
    return cnt 
end