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
        criterion = CondorcetLoser()
        violations = count_violations(system, criterion, rankings)
        @test violations == 0
        @test satisfies(system, criterion, rankings)
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
            criterion = CondorcetLoser()
            @test satisfies(Fails(), system, criterion, rankings)
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
        criterion = CondorcetLoser()
        violations = count_violations(system, criterion, rankings)
        @test violations == 0
        @test satisfies(system, criterion, rankings)
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
        criterion = CondorcetLoser()
        violations = count_violations(system, criterion, rankings)
        @test violations == 1
        @test !satisfies(system, criterion, rankings)
    end

    @safetestset "Minimax" begin
        # https://en.wikipedia.org/wiki/Condorcet_loser_criterion#Minimax
        using RankChoiceVoting
        using Test
  
        counts = [1,1,3,1,1,2]
        ranks = [[:a,:b,:c,:l],
                [:a,:b,:l,:c],
                [:b,:c,:a,:l],
                [:c,:l,:a,:b],
                [:l,:a,:b,:c],
                [:l,:c,:a,:b]]
        rankings = Ranks(counts, ranks)
        
        system = Minimax()
        criterion = CondorcetLoser()

        winner = evaluate_winner(system, rankings)
        result = satisfies(system, criterion, rankings)

        @test winner == [:l]
        @test !result
    end

    @safetestset "plurality" begin
        # https://en.wikipedia.org/wiki/Condorcet_loser_criterion#Plurality_voting
        using RankChoiceVoting
        using Test
  
        data = [[:m,:n,:c,:k] for _ ∈ 1:42]
        push!(data, [[:n,:c,:k,:m] for _ ∈ 1:26]...)
        push!(data, [[:c,:k,:n,:m] for _ ∈ 1:15]...)
        push!(data, [[:k,:c,:n,:m] for _ ∈ 1:17]...)
        
        rankings = Ranks(data)
        system = Plurality()
        criterion = CondorcetLoser()

        winner = evaluate_winner(system, rankings)
        result = satisfies(system, criterion, rankings)

        @test winner == [:m]
        @test !result
    end
end



