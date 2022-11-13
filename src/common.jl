abstract type VotingSystem end

abstract type Criterion end


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
    for i ∈ 1:length(counts)
        cnt += uranks[i][1] == id ? counts[i] : 0
    end
    return cnt
end

function redistribute!(system, win_ind)
    counts = get_counts(system)
    n = length(counts)
    n_w = sum(win_ind)
    for i ∈ 1:n 
        if !win_ind[i]
            total = counts[i]
            new_vals = rand(Multinomial(total, n_w + 1))
            counts[i] = new_vals[1]
            cnt = 2
            j = 1
            while cnt ≤ (n_w + 1)
                if win_ind[j] 
                    counts[j] += new_vals[cnt]
                    cnt += 1
                end
                j += 1
            end
        end
    end
    return nothing
end

function add_zero_counts!(system)
    (;counts,uranks) = system 
    all_uranks = permutations(uranks[1])
    for r ∈ all_uranks 
        if r ∉ uranks 
            push!(uranks, r)
            push!(counts, 0)
        end
    end
    return nothing 
end

get_counts(system) = system.counts
get_uranks(system) = system.uranks
