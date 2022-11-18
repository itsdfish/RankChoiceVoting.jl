"""
    Majority <: Criterion

An object for the fairness criterion, majority. A voting system satisfies the majority criterion if it elects the candidate who
recieves more than 50% first preferences. 
"""
mutable struct Majority <: Criterion

end

"""
    satisfies(system::VotingSystem, criteria::Majority; _...)

Tests whether a voting system satisfies the majority criterion.

# Arguments

- `system::VotingSystem`: a voting system object
- `criteria::Majority`: majority criterion object 

"""
function satisfies(system::VotingSystem, criteria::Majority; _...)
    winner_id = evaluate_winner(system)
    majority_id = get_majority_id(system)
    isempty(majority_id) ? (return true) : nothing
    return winner_id == majority_id[1] ? true : false
end

"""
    count_violations(system::VotingSystem, criteria::Majority; _...)

Counts the number of violations of the majority criterion for a given voting system.

# Arguments

- `system::VotingSystem`: a voting system object
- `criteria::Majority`: majority criterion object 
"""
function count_violations(system::VotingSystem, criteria::Majority; _...)
    return satisfies(system, criteria) ? 0 : 1
end

get_majority_id(system) = get_majority_id(system.counts, system.uranks)

function get_majority_id(counts, uranks::Vector{Vector{T}}) where {T}
    id = T[]
    candidates = uranks[1]
    proportions = fill(0.0, length(candidates))
    n_votes = sum(counts)
    for i ∈ 1:length(candidates)
        proportions[i] = count_top_ranks(counts, uranks, candidates[i])
    end
    proportions ./= n_votes
    winner_id = findfirst(p -> p > .50, proportions)
    isnothing(winner_id) ? nothing : (push!(id, candidates[winner_id]))
    return id
end

"""
    satisfies(system::InstantRunOff, criteria::Majority; _...)

Tests whether the instant runoff voting system satisfies the majority criterion. The instant run off voting system 
always satisifes the majority criterion. 
# Arguments

- `system::InstantRunOff`: a voting system object
- `criteria::Majority`: majority criterion object 

"""
function satisfies(system::InstantRunOff, criteria::Majority; _...)
    return true
end

"""
    count_violations(system::InstantRunOff, criteria::Majority; n_reps=1000, _...)

Counts the number of violations of the majority criterion for the instant runoff voting system.
The number of violations is always zero for the instant runoff voting system. 

# Arguments

- `system::InstantRunOff`: a voting system object
- `criteria::Majority`: majority criterion object 
"""
function count_violations(system::InstantRunOff, criteria::Majority; _...)
    return 0
end