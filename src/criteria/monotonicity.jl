"""
    Monotonicity <: Criterion

An object for the fairness criterion monotonicity. A voting system that satisfies the monotonicity criterion cannot elect 
a different candidate by increasing votes (without otherwise changing the rank order) of a candidate who would otherwise win.
In other words, redistributing more votes to the winner (without otherwise changing the rank order), should not prevent the winner
from winning. 
"""
struct Monotonicity <: Criterion

end

"""
    satisfies(system::VotingSystem, criteria::Monotonicity, rankings::Ranks; _...)

Tests whether a voting system satisfies the monotonicity criterion.

# Arguments

- `system::VotingSystem`: a voting system object
- `criteria::Monotonicity`: monotonicity criterion object 
- `rankings::Ranks`: a rank choice voting object consisting of rank counts and unique ranks 

# Keywords

- `n_reps=1000`: maximum number of Monte Carlo simulations to perform while searching 
for a violation
"""
function satisfies(::Fails, system::VotingSystem, criteria::Monotonicity, rankings::Ranks; n_reps=1000, _...)
    rankings = deepcopy(rankings)
    add_zero_counts!(rankings)
    winner = evaluate_winner(system, rankings)
    length(winner) ≠ 1 ? (return true) : nothing
    uranks = get_uranks(rankings)
    cnt = 0
    for _ ∈ 1:n_reps
        _rankings = deepcopy(rankings)
        target_rankings = rand(uranks)
        taker,giver = target_rankings[1:2]
        redistribute!(_rankings, target_rankings)
        new_winner = evaluate_winner(system, _rankings)
        if (taker == winner[1]) && (new_winner ≠ winner)
            return false
        end
        if (giver ≠ winner[1]) && (giver == new_winner[1])
            return false
        end
    end
    return true 
end

"""
    count_violations(system::VotingSystem, criteria::Monotonicity, rankings::Ranks; n_reps=1000, _...)

Counts the number of violations of the monotonicity criterion for a given voting system.

# Arguments

- `system::VotingSystem`: a voting system object
- `criteria::Monotonicity`: condorcet criterion object 
- `rankings::Ranks`: a rank choice voting object consisting of rank counts and unique ranks 

# Keywords

- `n_reps=1000`: maximum number of Monte Carlo simulations to perform
"""
function count_violations(::Fails, system::VotingSystem, criteria::Monotonicity, rankings::Ranks; n_reps=1000, _...)
    rankings = deepcopy(rankings)
    add_zero_counts!(rankings)
    winner = evaluate_winner(system, rankings)
    length(winner) ≠ 1 ? (return 0) : nothing
    uranks = get_uranks(rankings)
    cnt = 0
    for _ ∈ 1:n_reps
        _rankings = deepcopy(rankings)
        target_rankings = rand(uranks)
        taker,giver = target_rankings[1:2]
        redistribute!(_rankings, target_rankings)
        new_winner = evaluate_winner(system, _rankings)
        if (taker == winner[1]) && (new_winner ≠ winner)
            cnt += 1
        end
        if (giver ≠ winner[1]) && (giver == new_winner[1])
            cnt += 1
        end
    end
    return cnt 
end

"""
    redistribute!(system, win_ind)

Redistributes a random number votes to winner. The votes are redistributed from 
voters who have the same rank ordering except for the winner. For example,
[1,2,3,4] vs [2,1,3,4]. Thus, the rank orders are the same except for candidates 1 and 2. 

# Arguments
- `system`: a voting system object 
- `win_ind`: a vector indicating which ranks corresond to the winner. 
"""
function redistribute!(rankings, target_ranks)
    counts = get_counts(rankings)
    uranks = get_uranks(rankings)
    swapped_rank = swap(target_ranks)
    idx = findfirst(x -> x == target_ranks, uranks)
    cidx = findfirst(x -> x == swapped_rank, uranks)
    total = counts[cidx]
    Δ = rand(0:total)
    counts[cidx] -= Δ 
    counts[idx] += Δ 
    return nothing
end

"""
    swap(urank; idx=1:2)

Reverse a subset of rankings. Returns a new ranking vector.

# Arguments

- `urank`: - `uranks`: a vector of unique rankings. Each ranking is a vector in which index represents rank and value represents candidate id.

# Keywords

- `idx=1:2`: an index range to reverse order
"""
function swap(urank; idx=1:2)
    r = urank[:]
    reverse!(@view r[idx])
    return r
end

property(::Borda, ::Monotonicity) = Holds()
property(::Bucklin, ::Monotonicity) = Holds()
property(::Plurality, ::Monotonicity) = Holds()