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
    candidates = rankings.uranks[1]
    cnt = 0
    for _ ∈ 1:n_reps
        _rankings = deepcopy(rankings)
        giver,taker = sample(candidates, 2, replace=false)
        redistribute!(_rankings, giver, taker)
        new_winner = evaluate_winner(system, _rankings)
        if (taker == winner[1]) && (new_winner ≠ winner)
            println("1")
            print(_rankings)
            println("")
            println(rankings)
            return false
        end
        if (giver ≠ winner[1]) && (giver == new_winner[1])
            println("2")
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
    candidates = rankings.uranks[1]
    cnt = 0
    for _ ∈ 1:n_reps
        _rankings = deepcopy(rankings)
        giver,taker = sample(candidates, 2, replace=false)
        redistribute!(_rankings, giver, taker)
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
function redistribute!(rankings, giver, taker)
    counts = get_counts(rankings)
    uranks = get_uranks(rankings)
    n = length(counts)
    take_ids = Int[]
    give_ids = Int[]
    for i ∈ 1:n 
        if is_preferred_to(giver, taker, uranks[i])
            push!(give_ids, i)
        else
            push!(take_ids, i)
        end
    end
    # figure out how much to give
    total_to_give = 0
    for i ∈ give_ids
        to_give = rand(0:counts[i])
        total_to_give += to_give 
        counts[i] -= to_give
    end
    # give it to the takers
    n_takers = length(take_ids)
    for i ∈ 1:n_takers
        to_take = rand(0:total_to_give)
        total_to_give -= to_take
        counts[take_ids[i]] += to_take
    end
    counts[take_ids[end]] += total_to_give     
    return nothing
end

function is_preferred_to(c1, c2, uranks::Vector{T}) where {T}
    for r ∈ uranks 
        if r == c1 
            return true 
        elseif r == c2 
            return false 
        end
    end 
    return false 
end

property(::Borda, ::Monotonicity) = Holds()
property(::Bucklin, ::Monotonicity) = Holds()
property(::Plurality, ::Monotonicity) = Holds()