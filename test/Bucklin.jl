@safetestset "Bucklin" begin
    @safetestset "tally_rank!" begin
        using RankChoiceVoting
        using Test
        using RankChoiceVoting: score!
        using RankChoiceVoting: get_counts
        using RankChoiceVoting: get_uranks

        data = [[:m, :n, :c, :k] for _ ∈ 1:40]
        push!(data, [[:n, :c, :k, :m] for _ ∈ 1:26]...)
        push!(data, [[:c, :k, :n, :m] for _ ∈ 1:15]...)
        push!(data, [[:k, :c, :n, :m] for _ ∈ 1:17]...)
        push!(data, [[:m, :n, :c, :k] for _ ∈ 1:2]...)

        rankings = Ranks(data)

        system = Bucklin()

        counts = get_counts(rankings)
        uranks = get_uranks(rankings)
        candidates = uranks[1]
        scores = Dict(c => 0 for c ∈ candidates)

        score!(scores, counts, uranks, 1)
        true_scores = Dict(:m => 42, :n => 26, :c => 15, :k => 17)
        for k ∈ keys(scores)
            @test scores[k] == true_scores[k]
        end

        score!(scores, counts, uranks, 2)
        true_scores = Dict(:m => 42, :n => 68, :c => 58, :k => 32)
        for k ∈ keys(scores)
            @test scores[k] == true_scores[k]
        end
    end

    @safetestset "evaluate_winner" begin
        using RankChoiceVoting
        using Test

        data = [[:m, :n, :c, :k] for _ ∈ 1:42]
        push!(data, [[:n, :c, :k, :m] for _ ∈ 1:26]...)
        push!(data, [[:c, :k, :n, :m] for _ ∈ 1:15]...)
        push!(data, [[:k, :c, :n, :m] for _ ∈ 1:17]...)

        rankings = Ranks(data)
        system = Bucklin()
        _, ranks = compute_ranks(system, rankings)
        winner = evaluate_winner(system, rankings)

        @test winner == [:n]
        @test ranks == [:n, :c, :m, :k]
    end
end
