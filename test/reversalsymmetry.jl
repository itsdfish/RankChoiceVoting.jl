@safetestset "reversal symmetry" begin
    @safetestset "instant runoff 1" begin
        using RankChoiceVoting
        using Test

        rankings = Vector{Vector{Symbol}}()
        push!(rankings, [[:a,:b,:c] for _ ∈ 1:4]...)
        push!(rankings, [[:b,:c,:a] for _ ∈ 1:3]...)
        push!(rankings, [[:c,:a,:b] for _ ∈ 1:2]...)
        
        system = InstantRunOff(rankings)
        criteria = ReversalSymmetry()
        violations = count_violations(system, criteria)
        @test violations == 1
        @test !satisfies(system, criteria)
    end

    @safetestset "instant runoff 2" begin
        using RankChoiceVoting
        using Test

        rankings = Vector{Vector{Symbol}}()
        push!(rankings, [[:a,:b,:c] for _ ∈ 1:10]...)
        push!(rankings, [[:b,:c,:a] for _ ∈ 1:3]...)
        push!(rankings, [[:c,:a,:b] for _ ∈ 1:2]...)

        system = InstantRunOff(rankings)
        criteria = ReversalSymmetry()
        violations = count_violations(system, criteria)
        @test violations == 0
        @test satisfies(system, criteria)
    end

    @safetestset "Borda count" begin
        using RankChoiceVoting
        using Test
        using Random

        Random.seed!(5601)
        for _ ∈ 1:25
            n = rand(10:100)
            rankings = map(_ -> shuffle([:a,:b,:c]), 1:n)
            system = Borda(rankings)
            criteria = ReversalSymmetry()
            violations = count_violations(system, criteria)
            # Borda always satisfies reversal symmetry
            @test violations == 0
            @test satisfies(system, criteria)
        end
    end
end