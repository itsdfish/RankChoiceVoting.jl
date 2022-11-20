"""
    CondorcetLoser <: Criterion

A Condorcet loser criterion object. The Condorcet criterion states that a candiate who wins all
pairwise elections must also win the election using a given voting system.
"""
mutable struct CondorcetLoser <: Condorcet

end

"""
    satisfies(system::VotingSystem, criterion::CondorcetLoser; _...)

Tests whether a voting system satisfies the Condorcet loser criterion.

# Arguments

- `system::VotingSystem`: a voting system object
- `criterion::CondorcetLoser`: condorcet loser criterion object 
"""
function satisfies(system::VotingSystem, criterion::CondorcetLoser; _...)
    return _satisfies(system, criterion)
end

# for testing
function _satisfies(system::VotingSystem{T,I}, criterion::CondorcetLoser; _...) where {T,I}
    system = deepcopy(system)
    (;counts,uranks) = system
    candidates = uranks[1]
    winner = evaluate_winner(system)
    pairs = combinations(candidates, 2) |> collect
    condorcet_losers = T[]
    for c ∈ candidates
        if is_condorcet(counts, uranks, pairs, c; compare = <)
            push!(condorcet_losers, c)
            break
        end
    end
    return (winner ∉ condorcet_losers) || isempty(condorcet_losers)
end

"""
    count_violations(system::VotingSystem, criterion::CondorcetLoser; _...)

Counts the number of violations of the Condorcet loser criterion for a given voting system.

# Arguments

- `system::VotingSystem`: a voting system object
- `criterion::CondorcetLoser`: condorcet criterion object 
"""
function count_violations(system::VotingSystem, criterion::CondorcetLoser; _...)
    return satisfies(system, criterion) ? 0 : 1
end

"""
    satisfies(system::InstantRunOff, criterion::CondorcetLoser; _...)

Tests whether the instant runoff system satisfies the Condorcet loser criterion. Always returns 
true. 

# Arguments

- `system::InstantRunOff`: an instant runoff voting system object
- `criterion::CondorcetLoser`: condorcet loser criterion object 
"""
function satisfies(system::InstantRunOff, criterion::CondorcetLoser; _...)
    return true
end

"""
    count_violations(system::InstantRunOff, criterion::CondorcetLoser; _...)

Counts the number of violations of the Condorcet loser criterion for an instant runoff voting system. 
Always returns 0.

# Arguments

- `system::InstantRunOff`: an instant runoff voting system object
- `criterion::CondorcetLoser`: condorcet criterion object 
"""
function count_violations(system::InstantRunOff, criterion::CondorcetLoser; _...)
    return 0
end

"""
    satisfies(system::Borda, criterion::CondorcetLoser; _...)

Tests whether the Borda count system satisfies the Condorcet loser criterion. Always returns 
true. 

# Arguments

- `system::Borda`: an instant runoff voting system object
- `criterion::CondorcetLoser`: condorcet loser criterion object 
"""
function satisfies(system::Borda, criterion::CondorcetLoser; _...)
    return true
end

"""
    count_violations(system::Borda, criterion::CondorcetLoser; _...)

Counts the number of violations of the Condorcet loser criterion for the Borda count voting system. 
Always returns 0.

# Arguments

- `system::Borda`: an instant runoff voting system object
- `criterion::CondorcetLoser`: condorcet criterion object 
"""
function count_violations(system::Borda, criterion::CondorcetLoser; _...)
    return 0
end

