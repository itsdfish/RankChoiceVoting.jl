@safetestset "minimax" begin
    @safetestset "win_margin" begin
        using RankChoiceVoting
        using Test
        using RankChoiceVoting: win_margin

        counts = [1,3]
        ranks = [[:a,:b,:c],[:b,:c,:a]]
        rankings = Ranks(counts, ranks)
        
        @test win_margin(rankings, :b, :c) == 4
        @test win_margin(rankings, :c, :b) == -4
        @test win_margin(rankings, :a, :b) == -2
        @test win_margin(rankings, :a, :c) == -2
    end

    @safetestset "score_pairwise" begin
        using RankChoiceVoting
        using Test
        using RankChoiceVoting: score_pairwise


        data = [[:m,:n,:c,:k] for _ ∈ 1:42]
        push!(data, [[:n,:c,:k,:m] for _ ∈ 1:26]...)
        push!(data, [[:c,:k,:n,:m] for _ ∈ 1:15]...)
        push!(data, [[:k,:c,:n,:m] for _ ∈ 1:17]...)
        rankings = Ranks(data)
        
        ground_truth = [16  -16  -16  -16;
                        16  -36   36   36;
                        16  -36  -66   66]
        scores = score_pairwise(rankings, [:m,:n,:c,:k])
        @test ground_truth == scores
    end

    @safetestset "evaluate_winner" begin
        using RankChoiceVoting
        using Test

        data = [[:m,:n,:c,:k] for _ ∈ 1:42]
        push!(data, [[:n,:c,:k,:m] for _ ∈ 1:26]...)
        push!(data, [[:c,:k,:n,:m] for _ ∈ 1:15]...)
        push!(data, [[:k,:c,:n,:m] for _ ∈ 1:17]...)
        rankings = Ranks(data)
        
        system = Minimax()

        ground_truth = [:n]
        winner = evaluate_winner(system, rankings)
      
        @test ground_truth == winner
    end

    @safetestset "compute_ranks" begin
        using RankChoiceVoting
        using Test

        data = [[:m,:n,:c,:k] for _ ∈ 1:42]
        push!(data, [[:n,:c,:k,:m] for _ ∈ 1:26]...)
        push!(data, [[:c,:k,:n,:m] for _ ∈ 1:15]...)
        push!(data, [[:k,:c,:n,:m] for _ ∈ 1:17]...)
        rankings = Ranks(data)
        
        system = Minimax()

        ground_truth = [:n,:m,:c,:k]
        ranks,candidates = compute_ranks(system, rankings)
      
        @test ground_truth == candidates[ranks]
    end
end