"""
    MutualMajority <: Criterion

An object for the mutual majority. The mutual majority criterion requires a system to select a candidate from the smallest set of the k highest ranked candidates whose combined support exceeds 50%. 
"""
struct MutualMajority <: Criterion

end

"""
    satisfies(system::VotingSystem, criterion::MutualMajority, rankings::Ranks; _...)

Tests whether a voting system satisfies the mutual majority criterion.

# Arguments

- `system::VotingSystem`: a voting system object
- `criterion::MutualMajority`: majority criterion object 
- `rankings::Ranks`: a rank choice voting object consisting of rank counts and unique ranks 
"""
function satisfies(
    ::Fails,
    system::VotingSystem,
    criterion::MutualMajority,
    rankings::Ranks;
    _...,
)
    winner_id = evaluate_winner(system, rankings)
    majority_set = get_majority_set(rankings)
    # maybe ties should be checked in majority_set
    length(winner_id) ≠ 1 ? (return true) : nothing
    return winner_id[1] ∈ majority_set
end

"""
    count_violations(system::VotingSystem, criterion::MutualMajority, rankings::Ranks; _...)

Counts the number of violations of the majority criterion for a given voting system. The count is either 0 or 1.

# Arguments

- `system::VotingSystem`: a voting system object
- `criterion::Majority`: majority criterion object 
- `rankings::Ranks`: a rank choice voting object consisting of rank counts and unique ranks 
"""
function count_violations(
    T::Fails,
    system::VotingSystem,
    criterion::MutualMajority,
    rankings::Ranks;
    _...,
)
    return satisfies(T, system, criterion, rankings) ? 0 : 1
end

get_top_sets(uranks, r) = map(x -> Set(x[1:r]), uranks)

"""
    find_majority_set(top_sets::Vector{Set{T}}, counts) where {T}

Return the majority set for a given vector of top sets.

- `top_sets::Vector{Set{T}}`: the top ranked candidates of a given size
- `uranks`: a vector of unique rankings. Each ranking is a vector in which index represents rank and value represents candidate id.
"""
function find_majority_set(top_sets::Vector{Set{T}}, counts) where {T}
    n_half = sum(counts) / 2
    usets = unique(top_sets)
    for uset ∈ usets
        uset_count = 0
        i = 1
        for set ∈ top_sets
            if uset == set
                uset_count += counts[i]
            end
            uset_count > n_half ? (return uset) : nothing
            i += 1
        end
    end
    return Set(T[])
end

get_majority_set(rankings) = get_majority_set(rankings.counts, rankings.uranks)

"""
    get_majority_set(counts, uranks::Vector{Vector{T}}) where {T}

Returns the smallest set of candidates who are strictly preferred to candidates not in the set. 

# Arguments

- `uranks`: a vector of unique rankings. Each ranking is a vector in which index represents rank and value represents candidate id.
- `counts`: a vector of frequency counts corresponding to each unique ranking 
"""
function get_majority_set(counts, uranks::Vector{Vector{T}}) where {T}
    n_candidates = length(uranks[1])
    for c ∈ 1:n_candidates
        top_sets = get_top_sets(uranks, c)
        majority_set = find_majority_set(top_sets, counts)
        !isempty(majority_set) ? (return majority_set) : nothing
    end
    return Set(T[])
end

property(::Bucklin, ::MutualMajority) = Holds()
property(::InstantRunOff, ::MutualMajority) = Holds()
