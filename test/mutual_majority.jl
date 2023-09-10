@safetestset "mutual majority" begin
    @safetestset "get_majority_set 1" begin
        using RankChoiceVoting
        using Test
        using RankChoiceVoting: tally

        rankings = Vector{Vector{Symbol}}()
        push!(rankings, [[:c,:a,:b,:d] for _ ∈ 1:19]...)
        push!(rankings, [[:d,:c,:a,:b] for _ ∈ 1:17]...)
        push!(rankings, [[:b,:c,:a,:d] for _ ∈ 1:17]...)
        push!(rankings, [[:d,:b,:c,:a] for _ ∈ 1:16]...)
        push!(rankings, [[:a,:b,:c,:d] for _ ∈ 1:16]...)
        push!(rankings, [[:d,:a,:b,:c] for _ ∈ 1:15]...)

        counts, uranks = tally(rankings) 
        majority_set = get_majority_set(counts, uranks)
        @test majority_set == Set([:a,:b,:c])
    end

    @safetestset "get_majority_set 2" begin
        using RankChoiceVoting
        using Test
        using RankChoiceVoting: tally

        rankings = [
            [1, 2, 3, 4, 5],
            [2, 1, 3, 4, 5],
            [1, 2, 3, 5, 4],
            [2, 1, 3, 4, 5],
            [5, 2, 3, 4, 1],
            [4, 1, 3, 2, 5]
        ]
        
        counts, uranks = tally(rankings) 
        majority_set = get_majority_set(counts, uranks)
        @test majority_set == Set([1,2])
    end

    @safetestset "get_majority_set 3" begin
        using RankChoiceVoting
        using Test
        using RankChoiceVoting: tally

        rankings = [
            [1, 2, 3, 4, 5],
            [1, 2, 3, 4, 5],
            [1, 2, 3, 5, 4],
            [1, 2, 3, 4, 5],
            [5, 2, 3, 4, 1],
            [4, 1, 3, 2, 5]
        ]
        
        counts, uranks = tally(rankings) 
        majority_set = get_majority_set(counts, uranks)
    end

    @safetestset "get_majority_set 4" begin
        using RankChoiceVoting
        using Test
        using RankChoiceVoting: tally

        rankings = [
            [:a,:b,:c],
            [:b,:c,:a],
            [:c,:a,:b],
        ]
        
        counts, uranks = tally(rankings) 
        majority_set = get_majority_set(counts, uranks)
        @test majority_set == Set([:a,:b,:c])
    end

    @safetestset "get_majority_set 5" begin
        # https://en.wikipedia.org/wiki/Mutual_majority_criterion#Plurality
        using RankChoiceVoting
        using Test
    
        data = [[:m,:n,:c,:k] for _ ∈ 1:42]
        push!(data, [[:n,:c,:k,:m] for _ ∈ 1:26]...)
        push!(data, [[:c,:k,:n,:m] for _ ∈ 1:15]...)
        push!(data, [[:k,:c,:n,:m] for _ ∈ 1:17]...)
        rankings = Ranks(data)
        (;counts,uranks) = rankings
        majority_set = get_majority_set(counts, uranks)
    
        @test majority_set == Set([:n,:k,:c])
    end

    @safetestset "Borda 1" begin
        using RankChoiceVoting
        using Test

        data = [[:s,:t,:o,:p] for _ ∈ 1:51]
        push!(data, [[:t,:p,:o,:s] for _ ∈ 1:25]...)
        push!(data, [[:p,:t,:o,:s] for _ ∈ 1:10]...)
        push!(data, [[:o,:t,:p,:s] for _ ∈ 1:14]...)
        rankings = Ranks(data)

        system = Borda()
        criterion = MutualMajority()
        @test !satisfies(system, criterion, rankings)
        @test count_violations(system, criterion, rankings) == 1
    end

    @safetestset "Borda 2" begin
        using RankChoiceVoting
        using Test

        data = [[:s,:t,:o,:p] for _ ∈ 1:20]
        push!(data, [[:t,:p,:o,:s] for _ ∈ 1:2]...)
        push!(data, [[:p,:t,:o,:s] for _ ∈ 1:1]...)
        push!(data, [[:o,:t,:p,:s] for _ ∈ 1:2]...)
        rankings = Ranks(data)
        
        system = Borda()
        criterion = Majority()

        @test satisfies(system, criterion, rankings)
        @test count_violations(system, criterion, rankings) == 0
    end

    @safetestset "Bucklin 1" begin
        using RankChoiceVoting
        using Test

        data = [[:s,:t,:o,:p] for _ ∈ 1:20]
        push!(data, [[:t,:p,:o,:s] for _ ∈ 1:2]...)
        push!(data, [[:p,:t,:o,:s] for _ ∈ 1:1]...)
        push!(data, [[:o,:t,:p,:s] for _ ∈ 1:2]...)
        rankings = Ranks(data)

        system = Bucklin()
        criterion = MutualMajority()

        @test satisfies(system, criterion, rankings)
        @test count_violations(system, criterion, rankings) == 0
    end

    @safetestset "Bucklin 2" begin
        using RankChoiceVoting
        using RankChoiceVoting: Fails
        using Random
        using Test

        Random.seed!(5200)        
        for _ ∈ 1:25
            n = rand(10:100)
            data = [[1,2,3] for _ ∈ 1:n]
            shuffle!.(data)
            rankings = Ranks(data)
            system = Bucklin()
            criterion = MutualMajority()
            @test satisfies(Fails(), system, criterion, rankings)
            @test count_violations(Fails(), system, criterion, rankings) == 0
        end
    end

    @safetestset "InstantRunOff" begin
        using RankChoiceVoting
        using RankChoiceVoting: Fails
        using Random
        using Test

        Random.seed!(5200)        
        for _ ∈ 1:25
            n = rand(10:100)
            data = [[1,2,3] for _ ∈ 1:n]
            shuffle!.(data)
            rankings = Ranks(data)
            system = InstantRunOff()
            criterion = MutualMajority()
            @test satisfies(Fails(), system, criterion, rankings)
            @test count_violations(Fails(), system, criterion, rankings) == 0
        end
    end

    @safetestset "Minimax" begin
        # https://en.wikipedia.org/wiki/Mutual_majority_criterion#Minimax
        using RankChoiceVoting
        using Test
  
        counts = [19,17,17,16,16,15]
        ranks = [[:c,:a,:b,:d],
                [:d,:c,:a,:b],
                [:b,:c,:a,:d],
                [:d,:b,:c,:a],
                [:a,:b,:c,:d],
                [:d,:a,:b,:c]]
        rankings = Ranks(counts, ranks)

        system = Minimax()
        criterion = MutualMajority()

        winner = evaluate_winner(system, rankings)
        result = satisfies(system, criterion, rankings)

        @test winner == [:d]
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
        criterion = MutualMajority()

        winner = evaluate_winner(system, rankings)
        result = satisfies(system, criterion, rankings)

        @test winner == [:m]
        @test !result
    end
end
