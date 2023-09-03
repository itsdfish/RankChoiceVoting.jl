@safetestset "condorcet winner" begin
    @safetestset "instant runoff 1" begin
        using RankChoiceVoting
        using Test

        data = [[:a,:b,:c] for _ ∈ 1:37]
        push!(data, [[:b,:c,:a] for _ ∈ 1:22]...)
        push!(data, [[:b,:a,:c] for _ ∈ 1:12]...)
        push!(data, [[:c,:a,:b] for _ ∈ 1:29]...)

        rankings = Ranks(data)

        system = InstantRunOff()
        criterion = CondorcetWinner()
        violations = count_violations(system, criterion, rankings)
        @test violations == 0
        @test satisfies(system, criterion, rankings)
    end

    @safetestset "instant runoff 2" begin
        #https://math.hawaii.edu/~marriott/teaching/summer2013/math100/violations.pdf
        using RankChoiceVoting
        using Test

        data = [[:a,:c,:b,:d] for _ ∈ 1:10]
        push!(data, [[:d,:b,:a,:c] for _ ∈ 1:7]...)
        push!(data, [[:b,:c,:a,:d] for _ ∈ 1:5]...)
        push!(data, [[:c,:d,:a,:b] for _ ∈ 1:5]...)
        push!(data, [[:b,:c,:d,:a] for _ ∈ 1:4]...)
        rankings = Ranks(data)

        system = InstantRunOff()
        criterion = CondorcetWinner()
        violations = count_violations(system, criterion, rankings)
        @test violations == 1
        @test !satisfies(system, criterion, rankings)
    end

    @safetestset "minimax 1" begin
        using RankChoiceVoting
        using Test
        using Random
        
        system = Minimax()
        criterion = CondorcetWinner()

        @test satisfies(system, criterion)
    end

    @safetestset "minimax 2" begin
        using RankChoiceVoting
        using Test
        using RankChoiceVoting: Fails
        using Random

        candidates = [:a,:c,:b,:d] 

        for _ ∈ 1:100
            n = rand(10:100)
            data = [shuffle(candidates) for _ ∈ 1:n]
            rankings = Ranks(data)
            system = Minimax()
            criterion = CondorcetWinner()
            @test satisfies(Fails(), system, criterion, rankings)
        end
    end

    @safetestset "plurality" begin
        # https://en.wikipedia.org/wiki/Condorcet_winner_criterion#Plurality_voting
        using RankChoiceVoting
        using Test

        data = [[:a,:b,:c],[:c,:a,:b],[:b,:a,:c]]
        counts = [3,3,4]
        rankings = Ranks(counts, data)

        system = Plurality()
        criterion = CondorcetWinner()
        violations = count_violations(system, criterion, rankings)
        @test violations == 1
        @test !satisfies(system, criterion, rankings)
    end
end