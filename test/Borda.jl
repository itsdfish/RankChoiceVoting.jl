@safetestset "Borda" begin
    @safetestset "score_borda" begin
        using RankChoiceVoting
        using Test
        using RankChoiceVoting: score

        data = [[:s,:t,:o,:p] for _ ∈ 1:51]
        push!(data, [[:t,:p,:o,:s] for _ ∈ 1:25]...)
        push!(data, [[:p,:t,:o,:s] for _ ∈ 1:10]...)
        push!(data, [[:o,:t,:p,:s] for _ ∈ 1:14]...)
        
        rankings = Ranks(data)
        system = Borda()
        scores = score(system, rankings)

        true_scores = Dict(:s => 253, :t => 325, :o => 228, :p => 194)

        for k ∈ keys(scores)
            @test scores[k] == true_scores[k]
        end
    end

    @safetestset "evaluate_winner" begin
        using RankChoiceVoting
        using Test

        data = [[:s,:t,:o,:p] for _ ∈ 1:51]
        push!(data, [[:t,:p,:o,:s] for _ ∈ 1:25]...)
        push!(data, [[:p,:t,:o,:s] for _ ∈ 1:10]...)
        push!(data, [[:o,:t,:p,:s] for _ ∈ 1:14]...)
        
        rankings = Ranks(data)
        
        system = Borda()
        winner_id = evaluate_winner(system, rankings)

        @test winner_id == [:t]
    end
end