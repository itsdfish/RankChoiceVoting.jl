@safetestset "consistency" begin
    @safetestset "instant runoff" begin
        using RankChoiceVoting
        using Test

        data = [[:a,:b,:c] for _ ∈ 1:8]
        push!(data, [[:b,:c,:a] for _ ∈ 1:8]...)
        push!(data, [[:c,:a,:b] for _ ∈ 1:12]...)
        rankings = Ranks(data)

        system = InstantRunOff()
        criterion = Consistency()
        violations = count_violations(system, criterion, rankings)
        @test violations > 0
        @test !satisfies(system, criterion, rankings)
    end

    @safetestset "Borda" begin
        using RankChoiceVoting
        using Test
        using Random
        using RankChoiceVoting: violates
        using RankChoiceVoting: Fails
        Random.seed!(8554)

        candidates = [:a,:b,:c]
        criterion = Consistency()

        for _ ∈ 1:100
            n = rand(50:500)
            data = map(_ -> shuffle(candidates), 1:n)
            rankings = Ranks(data)
            system = Borda()
            @test satisfies(Fails(), system, criterion, rankings)
        end
    end

    @safetestset "minimax" begin
        using RankChoiceVoting
        using Test

        system = Minimax()
        criterion = Consistency()

        ranks = [[:a,:b,:c,:d],
                [:a,:b,:d,:c],
                [:a,:d,:b,:c],
                [:a,:d,:c,:b],
                [:b,:c,:d,:a],
                [:c,:b,:d,:a],
                [:c,:d,:b,:a],
                [:d,:c,:b,:a]]
        counts = [1,8,6,2,5,9,6,6]
        rankings = Ranks(counts, ranks)
        winner = evaluate_winner(system, rankings)

        ranks = [[:a,:b,:c,:d],
                [:a,:d,:b,:c],
                [:b,:c,:d,:a],
                [:c,:d,:b,:a]]
        counts = [1,6,5,6]
        rankings = Ranks(counts, ranks)
        winner1 = evaluate_winner(system, rankings)

        ranks = [[:a,:b,:d,:c],
        [:a,:d,:c,:b],
        [:c,:b,:d,:a],
        [:d,:c,:b,:a]]
        counts = [8,2,9,6]
        rankings = Ranks(counts, ranks)
        winner2 = evaluate_winner(system, rankings)

        @test winner1 == winner2
        @test winner ≠ winner1
    end

    @safetestset "plurality" begin
        using RankChoiceVoting
        using Test
        using Random
        using RankChoiceVoting: Fails

        candidates = [:a,:b,:c]
        criterion = Consistency()

        for _ ∈ 1:100
            n = rand(50:500)
            data = map(_ -> shuffle(candidates), 1:n)
            rankings = Ranks(data)
            system = Plurality()
            @test satisfies(Fails(), system, criterion, rankings)
        end
    end
end