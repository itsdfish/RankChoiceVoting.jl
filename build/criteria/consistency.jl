"""
Consistency <: Criterion

A Consistency criterion object. According to the consistency criterion, if the votes are split into disjoint subsets, and 
the same candidate wins each subset, the system must select the same winner for the whole set of votes.
"""
mutable struct Consistency <: Criterion

end

"""
    satisfies(system::VotingSystem, criterion::Consistency; n_max=1000, _...)

Tests whether a voting system satisfies the Consistency criterion.

# Arguments

- `system::VotingSystem`: a voting system object
- `criterion::Consistency`: consistency criterion object 

# Keywords

- `n_max`: maximum Monte Carlo simulations to perform 
"""
function satisfies(::Fails, system::VotingSystem, criterion::Consistency; n_max=1000, _...) 
    winner = evaluate_winner(system)
    length(winner) > 1 ? (return true) : nothing 
    for i ∈ 1:n_max 
        violates(system, winner) ? (return false) : nothing 
    end
    return true 
end

function violates(system::V, winner) where {V<:VotingSystem}
    system = deepcopy(system)
    (;counts,uranks) = system
    c1,c2 = random_split(counts)
    s1 = V(uranks, c1)
    s2 = V(uranks, c2)
    w1 = evaluate_winner(s1)
    w2 = evaluate_winner(s2)
    # check for violation if a winner can be determined 
    # in each split
    if (length(w1) == 1) && (length(w2) == 1) 
        return ((w1 == w2) && (winner ≠ w1))
    end
    return false
end

function random_split(counts)
    c1 = @. rand(DiscreteUniform(counts))
    c2 = counts .- c1 
    # make sure c2 contains at least some votes
    while (sum(c1) == 0) || (sum(c2) == 0)
        c1 = @. rand(DiscreteUniform(counts))
        c2 = counts .- c1 
    end
    return c1,c2
end

"""
    count_violations(system::VotingSystem, criterion::Consistency; n_rep=1000, _...)

Counts the number of violations of the consistency criterion for a given voting system.

# Arguments

- `system::VotingSystem`: a voting system object
- `criterion::Consistency`: condorcet criterion object 

# Keywords

- `n_rep`: number of Monte Carlo simulations to perform 
"""
function count_violations(::Fails, system::VotingSystem, criterion::Consistency; n_reps=1000, _...)
    winner = evaluate_winner(system)
    cnt = 0
    for i ∈ 1:n_reps 
        cnt += violates(system, winner) ? 1 : 0
    end
    return cnt 
end

property(::Borda, ::Consistency) = Holds()