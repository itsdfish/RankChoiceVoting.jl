"""
IIA <: Criterion

An object representing the independence of irrelevant alternatives criterion
"""
mutable struct IIA <: Criterion

end

"""
    satisfies(::Fails, system::VotingSystem, criterion::IIA, rankings::Ranks;  _...) 

Tests whether a voting system satisfies the IIA of Irrelevant alternatives criterion. There are
several ways to test this criterion. Currently, it is tested by removing subsets of losing candidates and 
testing whether the winner changes. Other methods could add and/or subtract candidates and test whether the 
rank order changes. The current method is less strict compared to alternative methods. 

# Arguments

- `system::VotingSystem`: a voting system object
- `criterion::IIA`: IIA criterion object 
- `rankings::Ranks`: a rank choice voting object consisting of rank counts and unique ranks 
"""
function satisfies(::Fails, system::VotingSystem, criterion::IIA, rankings::Ranks;  _...) 
    winner = evaluate_winner(system, rankings)
    losers = setdiff(rankings.uranks[1], winner)
    for i ∈ 1:(length(losers) - 1)
        for comb ∈ combinations(losers, i)
            _rankings = deepcopy(rankings)
            violates(winner, system, _rankings, comb) ? (return false) : nothing 
        end
    end 
    return true
end

"""
    count_violations(system::VotingSystem, criterion::IIA, rankings::Ranks; _...)

Counts the number of violations of the IIA of Irrelevant alternatives criterion. There are
several ways to test this criterion. Currently, it is tested by removing subsets of losing candidates and 
testing whether the winner changes. Other methods could add and/or subtract candidates and test whether the 
rank order changes. The current method is less strict compared to alternative methods. 

# Arguments

- `system::VotingSystem`: a voting system object
- `criterion::IIA`: IIA criterion object 
- `rankings::Ranks`: a rank choice voting object consisting of rank counts and unique ranks 
"""
function count_violations(::Fails, system::VotingSystem, criterion::IIA, rankings::Ranks;  _...) 
    winner = evaluate_winner(system, rankings)
    losers = setdiff(rankings.uranks[1], winner)
    cnt = 0
    for i ∈ 1:(length(losers) - 1)
        for comb ∈ combinations(losers, i)
            _rankings = deepcopy(rankings)
            cnt += violates(winner, system, _rankings, comb)
        end
    end
    return cnt 
end

function violates(winner, system, rankings, removed_candidates)
    for c ∈ removed_candidates
        remove_candidate!.(rankings.uranks, c)
    end
    new_winner = evaluate_winner(system, rankings)
    return winner ≠ new_winner
end