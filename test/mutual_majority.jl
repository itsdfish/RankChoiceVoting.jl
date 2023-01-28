@safetestset "mutual majority" begin
    @safetestset "get_majority_set 1" begin
        using RankChoiceVoting
        using Test
        using RankChoiceVoting: get_majority_set, tally

        rankings = Vector{Vector{Symbol}}()
        push!(rankings, [[:c,:a,:b,:d] for _ ∈ 1:19]...)
        push!(rankings, [[:d,:c,:a,:b] for _ ∈ 1:17]...)
        push!(rankings, [[:b,:c,:a,:d] for _ ∈ 1:17]...)
        push!(rankings, [[:d,:b,:c,:a] for _ ∈ 1:16]...)
        push!(rankings, [[:a,:b,:c,:d] for _ ∈ 1:16]...)
        push!(rankings, [[:d,:a,:b,:c] for _ ∈ 1:15]...)

        counts, uranks = tally(rankings) 
        majority_set = get_majority_set(counts, uranks)
        @test Set(majority_set) == Set([:a,:b,:c])
    end

    @safetestset "get_majority_set 2" begin
        using RankChoiceVoting
        using Test
        using RankChoiceVoting: get_majority_set, tally

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
        @test Set(majority_set) == Set([1,2])
    end

    @safetestset "get_majority_set 3" begin
        using RankChoiceVoting
        using Test
        using RankChoiceVoting: get_majority_set, tally

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
        @test Set(majority_set) == Set([1]) || Set(majority_set) == Set([2])
    end

    @safetestset "Borda 1" begin
        using RankChoiceVoting
        using Test

        rankings = Vector{Vector{Symbol}}()
        push!(rankings, [[:s,:t,:o,:p] for _ ∈ 1:51]...)
        push!(rankings, [[:t,:p,:o,:s] for _ ∈ 1:25]...)
        push!(rankings, [[:p,:t,:o,:s] for _ ∈ 1:10]...)
        push!(rankings, [[:o,:t,:p,:s] for _ ∈ 1:14]...)
        
        
        system = Borda(rankings)
        criterion = MutualMajority()
        @test !satisfies(system, criterion)
        @test count_violations(system, criterion) == 1
    end

    @safetestset "Borda 2" begin
        using RankChoiceVoting
        using Test

        rankings = Vector{Vector{Symbol}}()
        push!(rankings, [[:s,:t,:o,:p] for _ ∈ 1:20]...)
        push!(rankings, [[:t,:p,:o,:s] for _ ∈ 1:2]...)
        push!(rankings, [[:p,:t,:o,:s] for _ ∈ 1:1]...)
        push!(rankings, [[:o,:t,:p,:s] for _ ∈ 1:2]...)
        
        system = Borda(rankings)
        criterion = Majority()

        @test satisfies(system, criterion)
        @test count_violations(system, criterion) == 0
    end

    @safetestset "Bucklin 1" begin
        using RankChoiceVoting
        using Test

        rankings = Vector{Vector{Symbol}}()
        push!(rankings, [[:s,:t,:o,:p] for _ ∈ 1:20]...)
        push!(rankings, [[:t,:p,:o,:s] for _ ∈ 1:2]...)
        push!(rankings, [[:p,:t,:o,:s] for _ ∈ 1:1]...)
        push!(rankings, [[:o,:t,:p,:s] for _ ∈ 1:2]...)
        
        system = Bucklin(rankings)
        criterion = MutualMajority()

        @test satisfies(system, criterion)
        @test count_violations(system, criterion) == 0
    end

    @safetestset "Bucklin 2" begin
        using RankChoiceVoting
        using RankChoiceVoting: Fails
        using Random
        using Test

        Random.seed!(5200)        
        for _ ∈ 1:25
            n = rand(10:100)
            rankings = [[1,2,3] for _ ∈ 1:n]
            shuffle!.(rankings)
            system = Bucklin(rankings)
            criterion = MutualMajority()
            @test satisfies(Fails(), system, criterion)
            @test count_violations(Fails(), system, criterion) == 0
        end
    end
end