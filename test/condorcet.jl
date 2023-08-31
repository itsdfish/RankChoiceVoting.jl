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
        criteria = CondorcetWinner()
        violations = count_violations(system, criteria, rankings)
        @test violations == 0
        @test satisfies(system, criteria, rankings)
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
        criteria = CondorcetWinner()
        violations = count_violations(system, criteria, rankings)
        @test violations == 1
        @test !satisfies(system, criteria, rankings)
    end
end

@safetestset "condorcet loser" begin
    @safetestset "instant runoff 1" begin
        using RankChoiceVoting
        using Test
        using Random

        data = [[:a,:b,:c] for _ ∈ 1:37]
        push!(data, [[:b,:c,:a] for _ ∈ 1:22]...)
        push!(data, [[:b,:a,:c] for _ ∈ 1:12]...)
        push!(data, [[:c,:a,:b] for _ ∈ 1:29]...)
        rankings = Ranks(data)

        system = InstantRunOff()
        criteria = CondorcetLoser()
        violations = count_violations(system, criteria, rankings)
        @test violations == 0
        @test satisfies(system, criteria, rankings)
    end

    @safetestset "instant runoff 2" begin
        using RankChoiceVoting
        using Test
        using RankChoiceVoting: Fails
        using Random

        candidates = [:a,:c,:b,:d] 

        for _ ∈ 1:100
            n = rand(10:100)
            data = [shuffle(candidates) for _ ∈ 1:n]
            rankings = Ranks(data)
            system = InstantRunOff()
            criteria = CondorcetLoser()
            @test_skip satisfies(Fails(), system, criteria, rankings)
        end
    end

    @safetestset "Borda count" begin
        using RankChoiceVoting
        using Test
        using Random

        data = [[:a,:b,:c] for _ ∈ 1:37]
        push!(data, [[:b,:c,:a] for _ ∈ 1:22]...)
        push!(data, [[:b,:a,:c] for _ ∈ 1:12]...)
        push!(data, [[:c,:a,:b] for _ ∈ 1:29]...)
        rankings = Ranks(data)

        system = Borda()
        criteria = CondorcetLoser()
        violations = count_violations(system, criteria, rankings)
        @test violations == 0
        @test satisfies(system, criteria, rankings)
    end

    @safetestset "Bucklin" begin
        # counts 
        # [1, 3, 3, 1, 2, 1]

        # ranks 
        # 1  2  3  1  2  3
        # 2  1  1  3  3  2
        # 3  3  2  2  1  1

        # 6 or higher to win 

        # round 1

        # 1: 2
        # 2: 5
        # 3: 4

        # round 2

        # 1: 8
        # 2: 7
        # 3: 7

        # 1 is the winner 


        # 1 vs. 2: 5, 6  
        # 1 vs. 3: 5, 6 
        # 2 vs. 3: 6, 5

        # 1 is the Condorcet loser 
        using RankChoiceVoting
        using Test
        using Random

        data =  [[1,2,3] for _ ∈ 1:1]
        push!(data, [[2,1,3] for _ ∈ 1:3]...)
        push!(data, [[3,1,2] for _ ∈ 1:3]...)
        push!(data, [[1,3,2] for _ ∈ 1:1]...)
        push!(data, [[2,3,1] for _ ∈ 1:2]...)
        push!(data, [[3,2,1] for _ ∈ 1:1]...)
        rankings = Ranks(data)

        system = Bucklin()
        criteria = CondorcetLoser()
        violations = count_violations(system, criteria, rankings)
        @test violations == 1
        @test !satisfies(system, criteria, rankings)
    end
end