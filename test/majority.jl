
@safetestset "majority" begin
    @safetestset "get_majority_id 1" begin
        using RankChoiceVoting
        using Test
        using RankChoiceVoting: get_majority_id

        rankings = Vector{Vector{Symbol}}()
        push!(rankings, [[:a,:b,:c] for _ ∈ 1:37]...)
        push!(rankings, [[:b,:c,:a] for _ ∈ 1:22]...)
        push!(rankings, [[:b,:a,:c] for _ ∈ 1:12]...)
        push!(rankings, [[:c,:a,:b] for _ ∈ 1:29]...)

        system = InstantRunOff(rankings)
        id = get_majority_id(system)
        @test isempty(id)
    end

    @safetestset "get_majority_id 2" begin
        using RankChoiceVoting
        using Test
        using RankChoiceVoting: get_majority_id

        rankings = Vector{Vector{Symbol}}()
        push!(rankings, [[:a,:b,:c] for _ ∈ 1:30]...)
        push!(rankings, [[:b,:c,:a] for _ ∈ 1:26]...)
        push!(rankings, [[:b,:a,:c] for _ ∈ 1:25]...)
        push!(rankings, [[:c,:a,:b] for _ ∈ 1:19]...)

        system = InstantRunOff(rankings)
        id = get_majority_id(system)
        @test id[1] == :b
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
        criterion = Majority()

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
end