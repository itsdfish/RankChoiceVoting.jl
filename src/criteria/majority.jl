"""
    Majority <: Criterion

An object for the fairness criterion, majority. A voting system satisfies the majority criterion if it elects the candidate who
recieves more than 50% first preferences. 
"""
mutable struct Majority <: Criterion

end

"""
    satisfies(system::VotingSystem, criterion::Majority, rankings::Ranks; _...)

Tests whether a voting system satisfies the majority criterion.

# Arguments

- `system::VotingSystem`: a voting system object
- `criterion::Majority`: majority criterion object 
- `rankings::Ranks`: a rank choice voting object consisting of rank counts and unique ranks 
"""
function satisfies(::Fails, system::VotingSystem, criterion::Majority, rankings::Ranks; _...)
    winner_id = evaluate_winner(system, rankings)
    majority_id = get_majority_id(rankings)
    # should this be true,false or not applicable?
    #length(winner_id) ≠ 1 ? (return false) : nothing
    isempty(majority_id) ? (return true) : nothing
    return winner_id[1] ∈ majority_id ? true : false
end

"""
    count_violations(system::VotingSystem, criterion::Majority, rankings::Ranks; _...)

Counts the number of violations of the majority criterion for a given voting system.

# Arguments

- `system::VotingSystem`: a voting system object
- `criterion::Majority`: majority criterion object 
- `rankings::Ranks`: a rank choice voting object consisting of rank counts and unique ranks 
"""
function count_violations(T::Fails, system::VotingSystem, criterion::Majority, rankings::Ranks; _...)
    return satisfies(T, system, criterion, rankings) ? 0 : 1
end

get_majority_id(rankings) = get_majority_id(rankings.counts, rankings.uranks)

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

property(::Bucklin, ::Majority) = Holds()
property(::InstantRunOff, ::Majority) = Holds()
property(::Minimax, ::Majority) = Holds()