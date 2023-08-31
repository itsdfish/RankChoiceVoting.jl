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

@safetestset "head_to_head" begin 
    using RankChoiceVoting
    using RankChoiceVoting: head_to_head
    using Test
    using Random

    Random.seed!(602)

    data =  [[:a,:b,:c] for _ ∈ 1:10]
    push!(data, [[:b,:c,:a] for _ ∈ 1:5]...)
    push!(data, [[:b,:a,:c] for _ ∈ 1:1]...)
    push!(data, [[:c,:a,:b] for _ ∈ 1:2]...)

    rankings = Ranks(data)
    system = InstantRunOff()
    winner = head_to_head(rankings, :a, :b)
    @test winner == :a
    winner = head_to_head(rankings, :b, :a)
    @test winner == :a
    @test winner == :a
    winner = head_to_head(rankings, :c, :a)
    @test winner == :a
end

@safetestset "redistribute!" begin
    @safetestset "1" begin 
        using RankChoiceVoting
        using RankChoiceVoting: redistribute!
        using RankChoiceVoting: add_zero_counts!
        using Test
        using Random

        data = [[:a,:b,:c] for _ ∈ 1:37]
        push!(data, [[:b,:c,:a] for _ ∈ 1:22]...)
        push!(data, [[:b,:a,:c] for _ ∈ 1:12]...)
        push!(data, [[:c,:a,:b] for _ ∈ 1:29]...)

        rankings = Ranks(data)
    
        system = InstantRunOff()
        rankings = deepcopy(rankings)
        add_zero_counts!(rankings)
        winner = evaluate_winner(system, rankings)
        win_ind = map(x -> x[1] == winner, rankings.uranks)
    
        _rankings = deepcopy(rankings)
        redistribute!(_rankings, win_ind)
        
        @test sum(rankings.counts) == sum(_rankings.counts)
        @test all(rankings.counts[win_ind] .≥ rankings.counts[win_ind])
    end

    @safetestset "2" begin 
        using RankChoiceVoting
        using RankChoiceVoting: redistribute!
        using RankChoiceVoting: add_zero_counts!
        using Test
        using Random
    
        Random.seed!(55)

        data =  [[:a,:b,:c] for _ ∈ 1:10]
        push!(data, [[:b,:c,:a] for _ ∈ 1:5]...)
        push!(data, [[:b,:a,:c] for _ ∈ 1:5]...)
        push!(data, [[:c,:a,:b] for _ ∈ 1:5]...)
        push!(data, [[:c,:b,:a] for _ ∈ 1:0]...)
        push!(data, [[:a,:c,:b] for _ ∈ 1:0]...)

        rankings = Ranks(data)
    
        system = InstantRunOff()
        rankings = deepcopy(rankings)
        add_zero_counts!(rankings)
        winner = evaluate_winner(system, rankings)
        win_ind = map(x -> x[1] == winner, rankings.uranks)
    
        for _ ∈ 1:1000
            _rankings= deepcopy(rankings)
            redistribute!(_rankings, win_ind)
            @test sum(rankings.counts) == sum(_rankings.counts)
            @test all(rankings.counts[win_ind] .≥ rankings.counts[win_ind])
            @test all(rankings.counts[win_ind .≠ true] .≤ rankings.counts[win_ind .≠ true])
        end
    end
end