@safetestset "Independence" begin
    @safetestset "Instant Runoff 1" begin
        using RankChoiceVoting
        using Test
        using Random

        rankings = Vector{Vector{Symbol}}()
        push!(rankings, [[:a,:b,:c] for _ ∈ 1:37]...)
        push!(rankings, [[:b,:c,:a] for _ ∈ 1:22]...)
        push!(rankings, [[:b,:a,:c] for _ ∈ 1:12]...)
        push!(rankings, [[:c,:a,:b] for _ ∈ 1:29]...)
        
        system = InstantRunOff(rankings)
        criterion = Independence()
        @test !satisfies(system, criterion)
        @test count_violations(system, criterion) == 1
    end

    @safetestset "Instant Runoff 2" begin
        using RankChoiceVoting
        using Test
        using Random

        rankings = Vector{Vector{Symbol}}()
        push!(rankings, [[:c, :b, :a] for _ ∈ 1:3]...)
        push!(rankings, [[:c, :a, :b] for _ ∈ 1:2]...)
        push!(rankings, [[:b, :c, :a] for _ ∈ 1:3]...)
        push!(rankings, [[:a, :b, :c] for _ ∈ 1:3]...)
        push!(rankings, [[:a, :c, :b] for _ ∈ 1:2]...)
        push!(rankings, [[:b, :a, :c] for _ ∈ 1:2]...)

        system = InstantRunOff(rankings)
        criterion = Independence()
        @test satisfies(system, criterion)
    end

    @safetestset "Borda count 1" begin
        using RankChoiceVoting
        using Test
        using Random

        rankings = Vector{Vector{Symbol}}()
        push!(rankings, [[:c, :b, :a] for _ ∈ 1:4]...)
        push!(rankings, [[:a, :b, :c] for _ ∈ 1:2]...)
        push!(rankings, [[:b, :a, :c] for _ ∈ 1:1]...)
        push!(rankings, [[:b, :c, :a] for _ ∈ 1:3]...)
        push!(rankings, [[:a, :c, :b] for _ ∈ 1:2]...)

        system = Borda(rankings)
        criteria = Independence()
        @test !satisfies(system, criteria)
    end

    @safetestset "Borda count 2" begin
        using RankChoiceVoting
        using Test
        using Random

        rankings = Vector{Vector{Symbol}}()
        push!(rankings, [[:a, :b, :c] for _ ∈ 1:5]...)
        push!(rankings, [[:b, :c, :a] for _ ∈ 1:2]...)
        push!(rankings, [[:b, :a, :c] for _ ∈ 1:4]...)
        push!(rankings, [[:a, :c, :b] for _ ∈ 1:3]...)
        push!(rankings, [[:c, :a, :b] for _ ∈ 1:1]...)

        system = Borda(rankings)
        criteria = Independence()
        @test satisfies(system, criteria)
    end

    @safetestset "Bucklin 1" begin
        using RankChoiceVoting
        using Test
        using Random

        rankings = Vector{Vector{Symbol}}()
        push!(rankings, [[:a, :b, :c] for _ ∈ 1:5]...)
        push!(rankings, [[:a, :c, :b] for _ ∈ 1:4]...)
        push!(rankings, [[:b, :a, :c] for _ ∈ 1:4]...)
        push!(rankings, [[:c, :a, :b] for _ ∈ 1:2]...)

        system = Bucklin(rankings)
        criteria = Independence()
        @test satisfies(system, criteria)
    end

    @safetestset "Bucklin 2" begin
        using RankChoiceVoting
        using Test
        using Random

        rankings = Vector{Vector{Symbol}}()
        push!(rankings, [[:a, :b, :c] for _ ∈ 1:3]...)
        push!(rankings, [[:b, :c, :a] for _ ∈ 1:2]...)
        push!(rankings, [[:b, :a, :c] for _ ∈ 1:4]...)
        push!(rankings, [[:c, :a, :b] for _ ∈ 1:6]...)

        system = Bucklin(rankings)
        criteria = Independence()
        @test !satisfies(system, criteria)
    end
end