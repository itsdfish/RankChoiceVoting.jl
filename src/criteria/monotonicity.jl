"""
    Monotonicity <: Criterion

An object for the fairness criterion monotonicity. A voting system that satisfies the monotonicity criterion cannot elect 
a different candidate by increasing votes (without otherwise changing the rank order) of a candidate who would otherwise win.
In other words, redistributing more votes to the winner (without otherwise changing the rank order), should not prevent the winner
from winning. 
"""
mutable struct Monotonicity <: Criterion

end

"""
    satisfies(system::VotingSystem, criteria::Monotonicity; _...)

Tests whether a voting system satisfies the monotonicity criterion.

# Arguments

- `system::VotingSystem`: a voting system object
- `criteria::Monotonicity`: monotonicity criterion object 

# Keywords

- `max_reps=1000`: maximum number of Monte Carlo simulations to perform while searching 
for a violation
"""
function satisfies(system::VotingSystem, criteria::Monotonicity; max_reps=1000, _...)
    return _satisfies(system, criteria; max_reps)
end

# used for testing
function _satisfies(system::VotingSystem, criteria::Monotonicity; max_reps=1000, _...)
    system = deepcopy(system)
    add_zero_counts!(system)
    winner = evaluate_winner(system)
    win_ind = map(x -> x[1] == winner, system.uranks)
    for _ ∈ 1:max_reps
        _system = deepcopy(system)
        redistribute!(_system, win_ind)
        new_winner = evaluate_winner(_system)
        winner ≠ new_winner ? (return false) : nothing
    end
    return true
end

"""
    count_violations(system::VotingSystem, criteria::Monotonicity; n_reps=1000, _...)

Counts the number of violations of the monotonicity criterion for a given voting system.

# Arguments

- `system::VotingSystem`: a voting system object
- `criteria::Monotonicity`: condorcet criterion object 

# Keywords

- `n_reps=1000`: maximum number of Monte Carlo simulations to perform
"""
function count_violations(system::VotingSystem, criteria::Monotonicity; n_reps=1000, _...)
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

"""
    redistribute!(system, win_ind)

Redistributes a random number votes to winner. The votes are redistributed from 
voters who have the same rank ordering except for the winner. For example,
[1,2,3,4] vs [2,1,3,4]. Thus, the rank orders are the same except for candidates 1 and 2. 

# Arguments
- `system`: a voting system object 
- `win_ind`: a vector indicating which ranks corresond to the winner. 
"""
function redistribute!(system, win_ind)
    counts = get_counts(system)
    uranks = get_uranks(system)
    n = length(counts)
    for i ∈ 1:n 
        if win_ind[i]
            swapped_rank = swap(uranks[i])
            cidx = findfirst(x -> x == swapped_rank, uranks)
            total = counts[cidx]
            Δ = rand(0:total)
            counts[cidx] -= Δ 
            counts[i] += Δ 
        end
    end
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

"""
    satisfies(system::Borda, criteria::Monotonicity; _...)

Tests whether the Borda count system satisfies the monotonicity criterion.
The value returned is true because the Borda count system always satisfies monotonicity.

# Arguments

- `system::Borda`: a voting system object
- `criteria::Monotonicity`: monotonicity criterion object 
"""
function satisfies(system::Borda, criteria::Monotonicity; _...)
    return true
end

"""
    count_violations(system::Borda, criteria::Monotonicity; _...)

Counts the number of violations of the monotonicity criterion for the Borda count system.
The value returned is zero because the Borda count system always satisfies monotonicity.

# Arguments

- `system::Borda`: a voting system object
- `criteria::Monotonicity`: condorcet criterion object 
"""
function count_violations(system::Borda, criteria::Monotonicity; _...)
    return 0
end

"""
    satisfies(system::Bucklin, criteria::Monotonicity; _...)

Tests whether the Bucklin voting system satisfies the monotonicity criterion.
The value returned is true because the Bucklin voting system always satisfies monotonicity.

# Arguments

- `system::Bucklin`: a voting system object
- `criteria::Monotonicity`: monotonicity criterion object 
"""
function satisfies(system::Bucklin, criteria::Monotonicity; _...)
    return true
end

"""
    count_violations(system::Bucklin, criteria::Monotonicity; _...)

Counts the number of violations of the monotonicity criterion for the Bucklin voting system.
The value returned is zero because the Bucklin voting system always satisfies monotonicity.

# Arguments

- `system::Bucklin`: a voting system object
- `criteria::Monotonicity`: condorcet criterion object 
"""
function count_violations(system::Bucklin, criteria::Monotonicity; _...)
    return 0
end