@safetestset "Bucklin" begin
    @safetestset "tally_rank!" begin
        using RankChoiceVoting
        using Test
        using RankChoiceVoting: tally_rank!
        using RankChoiceVoting: get_counts 
        using RankChoiceVoting: get_uranks

        rankings = Vector{Vector{Symbol}}()
        push!(rankings, [[:m,:n,:c,:k] for _ ∈ 1:40]...)
        push!(rankings, [[:n,:c,:k,:m] for _ ∈ 1:26]...)
        push!(rankings, [[:c,:k,:n,:m] for _ ∈ 1:15]...)
        push!(rankings, [[:k,:c,:n,:m] for _ ∈ 1:17]...)
        push!(rankings, [[:m,:n,:c,:k] for _ ∈ 1:2]...)
        
        system = Bucklin(rankings)

        counts = get_counts(system)
        uranks = get_uranks(system)
        candidates = uranks[1]
        scores = Dict(c => 0 for c ∈ candidates)

        tally_rank!(scores, counts, uranks, 1)
        true_scores = Dict(:m => 42, :n => 26, :c => 15, :k => 17)
        for k ∈ keys(scores)
            @test scores[k] == true_scores[k]
        end

        tally_rank!(scores, counts, uranks, 2)
        true_scores = Dict(:m => 42, :n => 68, :c => 58, :k => 32)
        for k ∈ keys(scores)
            @test scores[k] == true_scores[k]
        end
    end

    @safetestset "evaluate_winner" begin
        using RankChoiceVoting
        using Test
        using RankChoiceVoting: tally_rank!

        rankings = Vector{Vector{Symbol}}()
        push!(rankings, [[:m,:n,:c,:k] for _ ∈ 1:42]...)
        push!(rankings, [[:n,:c,:k,:m] for _ ∈ 1:26]...)
        push!(rankings, [[:c,:k,:n,:m] for _ ∈ 1:15]...)
        push!(rankings, [[:k,:c,:n,:m] for _ ∈ 1:17]...)
        
        system = Bucklin(rankings)
        winner = evaluate_winner(system)
        @test winner == :n
    end
end