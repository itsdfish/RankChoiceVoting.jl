abstract type VotingSystem{T,I} end

abstract type Criterion end

abstract type Condorcet <: Criterion end

struct Holds end

struct Fails end 

property(::VotingSystem, ::Criterion) = Fails()
satisfies(s::VotingSystem, c::Criterion; kwargs...) = satisfies(property(s, c), s, c; kwargs...)
count_violations(s::VotingSystem, c::Criterion; kwargs...) = count_violations(property(s, c), s, c; kwargs...)

"""
    satisfies(system::InstantRunOff, criterion::CondorcetLoser; _...)

Tests whether the instant runoff system satisfies the Condorcet loser criterion. Always returns 
true. 

# Arguments

- `system::InstantRunOff`: an instant runoff voting system object
- `criterion::CondorcetLoser`: condorcet loser criterion object 
"""
function satisfies(::Holds, system::VotingSystem, criterion::Criterion; _...)
    return true
end

function count_violations(::Holds, system::VotingSystem, criterion::Criterion; _...)
    return 0
end

"""
    remove_candidate!(ranking, id)

Remove candidate from ranking based on id 

# Arguments
- `ranking`: a vector in which index represents rank and value represents candidate id 
- `id`: candidate id
"""
function remove_candidate!(ranking, id)
    deleteat!(ranking, findfirst(x -> x == id, ranking))
end

"""
    tally(rankings)

Returns a vector of counts and a corresponding vector of unique ranks. 

# Arguments
- `rankings`: a vector in which each element is a ranking. Each ranking is a vector in which index represents rank and value represents candidate id.
"""
function tally(rankings)
    uranks = unique(rankings)
    counts = map(c -> count(r -> r == c, rankings), uranks)
    return counts, uranks
end

"""
    count_top_ranks(counts, uranks, id)

Returns the number of rankings in which a candidate recieved a ranking of 1.

# Arguments
- `counts`: a count for each unique ranking
- `uranks`: a vector of unique rankings. Each ranking is a vector in which index represents rank and value represents candidate id.
- `id`: a candidate id
"""
function count_top_ranks(counts, uranks, id)
    cnt = 0
    for i ??? 1:length(counts)
        cnt += uranks[i][1] == id ? counts[i] : 0
    end
    return cnt
end

"""
    add_zero_counts!(system)

Adds rank orders which have zero votes.

# Arguments

- `system`: a voting system object
"""
function add_zero_counts!(system)
    (;counts,uranks) = system 
    all_uranks = permutations(uranks[1])
    for r ??? all_uranks 
        if r ??? uranks 
            push!(uranks, r)
            push!(counts, 0)
        end
    end
    return nothing 
end

get_counts(system) = system.counts
get_uranks(system) = system.uranks
