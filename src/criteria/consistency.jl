"""
Consistency <: Criterion

A Consistency criterion object. The Condorcet criterion states that a candiate who wins all
pairwise elections must also win the election using a given voting system.
"""
mutable struct Consistency <: Criterion

end

"""
    satisfies(system::VotingSystem, criteria::Consistency; n_max=1000, _...)

Tests whether a voting system satisfies the Consistency criterion.

# Arguments

- `system::VotingSystem`: a voting system object
- `criteria::Consistency`: consistency criterion object 

# Keywords

- `n_max`: maximum Monte Carlo simulations to perform 
"""
function satisfies(system::VotingSystem, criteria::Consistency; n_max=1000, _...) 
    winner = evaluate_winner(system)
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
    return ((w1 == w2) && (winner ≠ w1))
end

function random_split(counts)
    c1 = @. rand(DiscreteUniform(counts))
    c2 = counts .- c1 
    return c1,c2
end

"""
    count_violations(system::VotingSystem, criteria::Consistency; n_rep=1000, _...)

Counts the number of violations of the consistency criterion for a given voting system.

# Arguments

- `system::VotingSystem`: a voting system object
- `criteria::Consistency`: condorcet criterion object 

# Keywords

- `n_rep`: number of Monte Carlo simulations to perform 
"""
function count_violations(system::VotingSystem, criteria::Consistency; n_reps=1000, _...)
    winner = evaluate_winner(system)
    cnt = 0
    for i ∈ 1:n_reps 
        cnt += violates(system, winner) ? 1 : 0
    end
    return cnt 
end