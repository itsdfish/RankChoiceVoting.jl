@safetestset "plurality" begin
    @safetestset "evaluate_winner 1" begin
        using RankChoiceVoting
        using Test

        data = [[:m, :n, :c, :k] for _ ∈ 1:42]
        push!(data, [[:n, :c, :k, :m] for _ ∈ 1:26]...)
        push!(data, [[:c, :k, :n, :m] for _ ∈ 1:15]...)
        push!(data, [[:k, :c, :n, :m] for _ ∈ 1:17]...)

        rankings = Ranks(data)
        system = Plurality()
        winner = evaluate_winner(system, rankings)

        @test winner == [:m]
    end

    @safetestset "evaluate_winner 2" begin
        using RankChoiceVoting
        using Test

        data = [[:a, :b], [:b, :a]]
        counts = [2, 2]
        rankings = Ranks(counts, data)
        system = Plurality()
        winner = evaluate_winner(system, rankings)

        @test winner == [:a, :b]
    end

    @safetestset "compute_ranks 1" begin
        using RankChoiceVoting
        using Test

        data = [[:m, :n, :c, :k] for _ ∈ 1:42]
        push!(data, [[:n, :c, :k, :m] for _ ∈ 1:26]...)
        push!(data, [[:c, :k, :n, :m] for _ ∈ 1:15]...)
        push!(data, [[:k, :c, :n, :m] for _ ∈ 1:17]...)

        rankings = Ranks(data)
        system = Plurality()
        _, ranks = compute_ranks(system, rankings)

        @test ranks == [:m]
    end

    @safetestset "compute_ranks 2" begin
        using RankChoiceVoting
        using Test

        data = [[:a, :b], [:b, :a]]
        counts = [2, 2]
        rankings = Ranks(counts, data)
        system = Plurality()
        _, ranks = compute_ranks(system, rankings)

        @test ranks == [:a, :b]
    end
end
