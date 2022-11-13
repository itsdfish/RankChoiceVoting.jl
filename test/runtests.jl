using SafeTestsets

@safetestset "remove_candidate!" begin
    using RankChoiceVoting
    using Test
    using RankChoiceVoting: remove_candidate!

    ranking = [1,4,2,10]
    remove_candidate!(ranking, 2)
    @test ranking == [1,4,10]
end

@safetestset "tally" begin
    using RankChoiceVoting
    using Test
    using RankChoiceVoting: tally

    rankings = [[1,2,3],[1,2,3],[2,3,1]]
    counts,uranks = tally(rankings)

    @test counts == [2,1]
    @test uranks[1] == [1,2,3]
    @test uranks[2] == [2,3,1]
end

@safetestset "count_top_ranks" begin
    using RankChoiceVoting
    using Test
    using RankChoiceVoting: count_top_ranks
    using RankChoiceVoting: tally

    rankings = [[1,2,3],[1,2,3],[2,3,1]]
    counts,uranks = tally(rankings)

    top_count = count_top_ranks(counts, uranks, 1)
    @test top_count == 2

    top_count = count_top_ranks(counts, uranks, 2)
    @test top_count == 1

    top_count = count_top_ranks(counts, uranks, 3)
    @test top_count == 0
end

@safetestset "redistribute!" begin
    using RankChoiceVoting
    using RankChoiceVoting: redistribute!
    using RankChoiceVoting: add_zero_counts!
    using Test
    using Random

    rankings = Vector{Vector{Symbol}}()
    push!(rankings, [[:a,:b,:c] for _ ∈ 1:37]...)
    push!(rankings, [[:b,:c,:a] for _ ∈ 1:22]...)
    push!(rankings, [[:b,:a,:c] for _ ∈ 1:12]...)
    push!(rankings, [[:c,:a,:b] for _ ∈ 1:29]...)

    system = InstantRunOff(rankings)
    system = deepcopy(system)
    add_zero_counts!(system)
    winner = evaluate_winner(system)
    win_ind = map(x -> x[1] == winner, system.uranks)

    _system = deepcopy(system)
    redistribute!(_system, win_ind)
    
    @test sum(system.counts) == sum(_system.counts)
    @test all(system.counts[win_ind] .≥ system.counts[win_ind])
end

@safetestset "instant runoff" begin
    @safetestset "example1" begin
        using RankChoiceVoting
        using Test

        rankings = Vector{Vector{Symbol}}()
        push!(rankings, [[:d,:c,:a,:e,:b] for _ ∈ 1:9]...)
        push!(rankings, [[:b,:e,:a,:c,:d] for _ ∈ 1:5]...)
        push!(rankings, [[:e,:a,:d,:b,:c] for _ ∈ 1:2]...)
        push!(rankings, [[:b,:c,:a,:d,:e] for _ ∈ 1:5]...)
        push!(rankings, [[:c,:a,:d,:b,:e] for _ ∈ 1:8]...)
        push!(rankings, [[:b,:d,:c,:a,:e] for _ ∈ 1:6]...)
        
        system = InstantRunOff(rankings)
        winner = evaluate_winner(system)
        @test winner == :d
    end
end

@safetestset "reversal symmetry" begin
    @safetestset "instant runoff" begin
        using RankChoiceVoting
        using Test

        rankings = Vector{Vector{Symbol}}()
        push!(rankings, [[:a,:b,:c] for _ ∈ 1:4]...)
        push!(rankings, [[:b,:c,:a] for _ ∈ 1:3]...)
        push!(rankings, [[:c,:a,:b] for _ ∈ 1:2]...)
        
        system = InstantRunOff(rankings)
        criteria = ReversalSymmetry()
        violations = count_violations(system, criteria)
        @test_skip violations == 1
    end
end

@safetestset "monotonicity" begin
    @safetestset "instant runoff test case" begin
        using RankChoiceVoting
        using Test

        rankings = Vector{Vector{Symbol}}()
        push!(rankings, [[:a,:b,:c] for _ ∈ 1:37]...)
        push!(rankings, [[:b,:c,:a] for _ ∈ 1:22]...)
        push!(rankings, [[:b,:a,:c] for _ ∈ 1:12]...)
        push!(rankings, [[:c,:a,:b] for _ ∈ 1:29]...)

        system = InstantRunOff(rankings)
        winner1 = evaluate_winner(system)

        rankings = Vector{Vector{Symbol}}()
        push!(rankings, [[:a,:b,:c] for _ ∈ 1:47]...)
        push!(rankings, [[:b,:c,:a] for _ ∈ 1:22]...)
        push!(rankings, [[:b,:a,:c] for _ ∈ 1:2]...)
        push!(rankings, [[:c,:a,:b] for _ ∈ 1:29]...)

        system = InstantRunOff(rankings)
        winner2 = evaluate_winner(system)
        @test winner1 ≠ winner2 
    end
end
