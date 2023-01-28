"""
    MutualMajority <: Criterion

An object for the fairness criterion, majority. A voting system satisfies the majority criterion if it elects the candidate who
recieves more than 50% first preferences. 
"""
mutable struct MutualMajority <: Criterion

end

"""
    satisfies(system::VotingSystem, criterion::MutualMajority; _...)

Tests whether a voting system satisfies the mutual majority criterion.

# Arguments

- `system::VotingSystem`: a voting system object
- `criterion::MutualMajority`: majority criterion object 
"""
function satisfies(::Fails, system::VotingSystem, criterion::MutualMajority; _...)
    winner_id = evaluate_winner(system)
    majority_set = get_majority_set(system)
    return winner_id ∈ majority_set
end

"""
    count_violations(system::VotingSystem, criterion::MutualMajority; _...)

Counts the number of violations of the majority criterion for a given voting system.

# Arguments

- `system::VotingSystem`: a voting system object
- `criterion::Majority`: majority criterion object 
"""
function count_violations(T::Fails, system::VotingSystem, criterion::MutualMajority; _...)
    return satisfies(T, system, criterion) ? 0 : 1
end

get_majority_set(system) = get_majority_set(system.counts, system.uranks)

"""
    rank_preferred(rank, idx)

    Returns true if the set is preferred in a specific ranking (e.g., [:a,:c,:b]) and false otherwise.

    Example: if idx = [:a,:b]  and rank = [:a,:c,:b,:d], the return value is false because :c is preferred to 
    :b.   
    # Arguments
    
    - `rank`: a vector of candidates ordered from most to least preferred 
    - `idx`: a vector of indicies for a possible set of strickly preferred candidates 
"""
function rank_preferred(rank, idx)
    n = length(idx)
    return Set(idx) == Set(rank[1:n])
end

"""
    set_preferred(counts, uranks, idx)

Returns true if the set is preferred and false otherwise. A set 'idx' is preferred if 
more than half of voters strickly prefer 'idx' to candidates not in 'idx'. 

"""
function set_preferred(counts, uranks, idx)
    # half of n voters 
    n_half = sum(counts) / 2
    # count for preffered 
    n_preffered = 0
    # count for not preferred 
    n_not_preferred = 0
    # loop over the unique ranks until either more than half prefer idx 
    # or more than half do not prefer idx. There is no reason to loop through 
    # all unique vectors 
    for i ∈ 1:length(uranks)
        # determine whether current idx is preffered or not in the current rank
        if rank_preferred(uranks[i], idx)
            n_preffered += counts[i]
        else
            n_not_preferred += counts[i]
        end
        # try to terminate early 
        if n_preffered > n_half
            return true 
        elseif n_not_preferred > n_half
            return false
        end
    end
    # should only reach this if equal split
    return false 
end

get_majority_set(system::VotingSystem) = get_majority_set(system.counts, system.uranks)

# this can be speed up by looking at the sets of candidates in the first positions,
# rather than brute force. Doing so eliminates the number of checks: map(x->Set(x[1:2]), ranks)
function get_majority_set(counts, uranks::Vector{Vector{T}}) where {T}
    n_candidates = length(uranks[1])
    candidates = uranks[1]
    # the set size of the mutual majority is unknown.
    # starting with set size = 1, test whether there is a simple majority 
    # increment set size until mutual majority is found or all set sized have 
    # been examined
    for set_size ∈ 1:n_candidates
        # for each set size, try each combination, e.g., [:a,:b], [:a, :c] etc. 
        for idx ∈ combinations(candidates, set_size)
            # if a mutual majority is found, stop and return the set 
            if set_preferred(counts, uranks, idx)
                return idx
            end
        end
    end
    # no mutual majority set 
    return T[]
end

property(::Bucklin, ::MutualMajority) = Holds()
property(::InstantRunOff, ::MutualMajority) = Holds()