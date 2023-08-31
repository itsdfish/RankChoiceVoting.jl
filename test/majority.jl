@safetestset "majority" begin
    @safetestset "get_majority_id 1" begin
        using RankChoiceVoting
        using Test
        using RankChoiceVoting: get_majority_id

        data = [[:a,:b,:c] for _ ∈ 1:37]
        push!(data, [[:b,:c,:a] for _ ∈ 1:22]...)
        push!(data, [[:b,:a,:c] for _ ∈ 1:12]...)
        push!(data, [[:c,:a,:b] for _ ∈ 1:29]...)
        rankings = Ranks(data)

        system = InstantRunOff()
        id = get_majority_id(rankings)
        @test isempty(id)
    end

    @safetestset "get_majority_id 2" begin
        using RankChoiceVoting
        using Test
        using RankChoiceVoting: get_majority_id

        data =  [[:a,:b,:c] for _ ∈ 1:30]
        push!(data, [[:b,:c,:a] for _ ∈ 1:26]...)
        push!(data, [[:b,:a,:c] for _ ∈ 1:25]...)
        push!(data, [[:c,:a,:b] for _ ∈ 1:19]...)
        rankings = Ranks(data)

        system = InstantRunOff()
        id = get_majority_id(rankings)
        @test id[1] == :b
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
        criterion = Majority()

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
        criterion = Majority()

        @test satisfies(system, criterion, rankings)
        @test count_violations(system, criterion, rankings) == 0
    end
end