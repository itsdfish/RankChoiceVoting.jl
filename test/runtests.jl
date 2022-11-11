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
