@safetestset "reversal symmetry" begin
    @safetestset "instant runoff 1" begin
        using RankChoiceVoting
        using Test

        data = [[:a,:b,:c] for _ ∈ 1:4]
        push!(data, [[:b,:c,:a] for _ ∈ 1:3]...)
        push!(data, [[:c,:a,:b] for _ ∈ 1:2]...)
        rankings = Ranks(data)
        system = InstantRunOff()
        criterion = ReversalSymmetry()
        violations = count_violations(system, criterion, rankings)
        @test violations == 1
        @test !satisfies(system, criterion, rankings)
    end

    @safetestset "instant runoff 2" begin
        using RankChoiceVoting
        using Test

        data = [[:a,:b,:c] for _ ∈ 1:10]
        push!(data, [[:b,:c,:a] for _ ∈ 1:3]...)
        push!(data, [[:c,:a,:b] for _ ∈ 1:2]...)
        rankings = Ranks(data)

        system = InstantRunOff()
        criterion = ReversalSymmetry()
        violations = count_violations(system, criterion, rankings)
        @test violations == 0
        @test satisfies(system, criterion, rankings)
    end

    @safetestset "Borda count" begin
        using RankChoiceVoting
        using Test
        using Random

        Random.seed!(5601)
        for _ ∈ 1:25
            n = rand(10:100)
            data = map(_ -> shuffle([:a,:b,:c]), 1:n)
            rankings = Ranks(data)
            system = Borda()
            criterion = ReversalSymmetry()
            violations = count_violations(system, criterion, rankings)
            # Borda always satisfies reversal symmetry
            @test violations == 0
            @test satisfies(system, criterion, rankings)
        end
    end

    @safetestset "Minimax" begin
        using RankChoiceVoting
        using Test
  
        counts = [4,4,2,1,1,2]
        ranks = [[:a,:b,:d,:c],
                [:b,:c,:a,:d],
                [:c,:d,:a,:b],
                [:d,:a,:b,:c],
                [:d,:b,:c,:a],
                [:d,:c,:a,:b]]
        rankings = Ranks(counts, ranks)

        system = Minimax()
        criterion = ReversalSymmetry()

        winner = evaluate_winner(system, rankings)
        result = satisfies(system, criterion, rankings)

        @test winner == [:d]
        @test !result
    end

    @safetestset "plurality" begin
        using RankChoiceVoting
        using Test

        data = [[:a,:b,:c],[:c,:b,:a],[:b,:a,:c],[:c,:a,:b]]
        counts = fill(1, 4)
        rankings = Ranks(counts, data)

        system = Plurality()
        criterion = ReversalSymmetry()
        violations = count_violations(system, criterion, rankings)
        @test violations == 1
        @test !satisfies(system, criterion, rankings)
    end
end

