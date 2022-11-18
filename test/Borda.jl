@safetestset "Borda" begin
    @safetestset "score_borda" begin
        using RankChoiceVoting
        using Test
        using RankChoiceVoting: score_borda

        rankings = Vector{Vector{Symbol}}()
        push!(rankings, [[:s,:t,:o,:p] for _ ∈ 1:51]...)
        push!(rankings, [[:t,:p,:o,:s] for _ ∈ 1:25]...)
        push!(rankings, [[:p,:t,:o,:s] for _ ∈ 1:10]...)
        push!(rankings, [[:o,:t,:p,:s] for _ ∈ 1:14]...)
        
        system = Borda(rankings)
        scores = score_borda(system)

        true_scores = Dict(:s => 253, :t => 325, :o => 228, :p => 194)

        for k ∈ keys(scores)
            @test scores[k] == true_scores[k]
        end
    end

    @safetestset "evaluate_winner" begin
        using RankChoiceVoting
        using Test

        rankings = Vector{Vector{Symbol}}()
        push!(rankings, [[:s,:t,:o,:p] for _ ∈ 1:51]...)
        push!(rankings, [[:t,:p,:o,:s] for _ ∈ 1:25]...)
        push!(rankings, [[:p,:t,:o,:s] for _ ∈ 1:10]...)
        push!(rankings, [[:o,:t,:p,:s] for _ ∈ 1:14]...)
        
        system = Borda(rankings)
        winner_id = evaluate_winner(system)

        @test winner_id == :t
    end
end