@safetestset "monotonicity" begin
    @safetestset "instant runoff test case" begin
        using RankChoiceVoting
        using Test

        data = [[:a,:b,:c] for _ ∈ 1:37]
        push!(data, [[:b,:c,:a] for _ ∈ 1:22]...)
        push!(data, [[:b,:a,:c] for _ ∈ 1:12]...)
        push!(data, [[:c,:a,:b] for _ ∈ 1:29]...)
        rankings = Ranks(data)

        system = InstantRunOff()
        winner1 = evaluate_winner(system, rankings)

        data = [[:a,:b,:c] for _ ∈ 1:47]
        push!(data, [[:b,:c,:a] for _ ∈ 1:22]...)
        push!(data, [[:b,:a,:c] for _ ∈ 1:2]...)
        push!(data, [[:c,:a,:b] for _ ∈ 1:29]...)
        rankings = Ranks(data)

        system = InstantRunOff()
        winner2 = evaluate_winner(system, rankings)
        @test winner1 ≠ winner2 
    end
    
    @safetestset "instant runoff 1" begin
        using RankChoiceVoting
        using Test
        using Random

        Random.seed!(4741)

        data = [[:c,:a,:b],[:b,:a,:c],[:b,:c,:a],[:a,:b,:c],[:a,:c,:b]]
        counts = [6,2,3,4,2]
        rankings = Ranks(counts, data)

        system = InstantRunOff()
        criteria = Monotonicity()
        violations = count_violations(system, criteria, rankings)
        @test violations > 0
        @test !satisfies(system, criteria, rankings)
    end

    @safetestset "instant runoff 2" begin
        using RankChoiceVoting
        using Test
        using Random

        Random.seed!(8784)

        data = [[:a,:b,:c] for _ ∈ 1:37]
        push!(data, [[:b,:c,:a] for _ ∈ 1:22]...)
        push!(data, [[:b,:a,:c] for _ ∈ 1:12]...)
        push!(data, [[:c,:a,:b] for _ ∈ 1:29]...)
        rankings = Ranks(data)

        system = InstantRunOff()
        criteria = Monotonicity()
        violations = count_violations(system, criteria, rankings)
        @test violations > 0
        @test !satisfies(system, criteria, rankings)
    end

    @safetestset "instant runoff 3" begin
        # https://rangevoting.org/Monotone.html
        using RankChoiceVoting
        using Test
        using Random

        Random.seed!(98)

        data = [[:c,:b,:a],[:a,:c,:b],[:b,:a,:c]]
        counts = [5,4,8]
        rankings = Ranks(counts, data)

        system = InstantRunOff()
        criteria = Monotonicity()
        violations = count_violations(system, criteria, rankings)
        @test violations > 0
        @test !satisfies(system, criteria, rankings)
    end

    @safetestset "Borda 1" begin
        using RankChoiceVoting
        using Test
        using Random

        Random.seed!(1231)
        for _ ∈ 1:25
            n = rand(10:100)
            data = [[1,2,3] for _ ∈ 1:n]
            shuffle!.(data)
            rankings = Ranks(data)
            system = Borda()
            criterion = Monotonicity()
            violations = count_violations(system, criterion, rankings)
            # Borda always satisfies Monotonicity
            @test violations == 0
            @test satisfies(system, criterion, rankings)
        end
    end

    @safetestset "Borda 2" begin
        using RankChoiceVoting
        using Test
        using Random
        using RankChoiceVoting: violates
        using RankChoiceVoting: Fails

        Random.seed!(8554)
        criterion = Monotonicity()
        candidates = [:a,:b,:c]

        for _ ∈ 1:100
            n = rand(50:500)
            data = map(_ -> shuffle(candidates), 1:n)
            rankings = Ranks(data)
            system = Borda()
            @test satisfies(Fails(), system, criterion, rankings)
        end
    end

    @safetestset "Bucklin" begin
        using RankChoiceVoting
        using Test
        using Random

        Random.seed!(9854)
        for _ ∈ 1:25
            n = rand(10:100)
            data = [[1,2,3] for _ ∈ 1:n]
            shuffle!.(data)
            rankings = Ranks(data)
            system = Bucklin()
            criterion = Monotonicity()
            violations = count_violations(system, criterion, rankings)
            # Borda always satisfies Monotonicity
            @test violations == 0
            @test satisfies(system, criterion, rankings)
        end
    end

    @safetestset "minimax" begin
        using RankChoiceVoting
        using Test
        using RankChoiceVoting: Fails
        using Random

        candidates = [:a,:c,:b,:d] 

        for i ∈ 1:100
            Random.seed!(i)
            n = rand(10:100)
            data = [shuffle(candidates) for _ ∈ 1:n]
            rankings = Ranks(data)
            system = Minimax()
            criteria = Monotonicity()
            @test satisfies(Fails(), system, criteria, rankings)
        end
    end

    @safetestset "plurality" begin
        using RankChoiceVoting
        using Test
        using Random
        using RankChoiceVoting: Fails

        candidates = [:a,:b,:c]
        criterion = Monotonicity()

        for _ ∈ 1:100
            n = rand(50:500)
            data = map(_ -> shuffle(candidates), 1:n)
            rankings = Ranks(data)
            system = Plurality()
            @test satisfies(Fails(), system, criterion, rankings)
        end
    end
end