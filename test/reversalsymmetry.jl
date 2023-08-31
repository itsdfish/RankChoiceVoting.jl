@safetestset "reversal symmetry" begin
    @safetestset "instant runoff 1" begin
        using RankChoiceVoting
        using Test

        data = [[:a,:b,:c] for _ ∈ 1:4]
        push!(data, [[:b,:c,:a] for _ ∈ 1:3]...)
        push!(data, [[:c,:a,:b] for _ ∈ 1:2]...)
        rankings = Ranks(data)
        system = InstantRunOff()
        criteria = ReversalSymmetry()
        violations = count_violations(system, criteria, rankings)
        @test violations == 1
        @test !satisfies(system, criteria, rankings)
    end

    @safetestset "instant runoff 2" begin
        using RankChoiceVoting
        using Test

        data = [[:a,:b,:c] for _ ∈ 1:10]
        push!(data, [[:b,:c,:a] for _ ∈ 1:3]...)
        push!(data, [[:c,:a,:b] for _ ∈ 1:2]...)
        rankings = Ranks(data)

        system = InstantRunOff()
        criteria = ReversalSymmetry()
        violations = count_violations(system, criteria, rankings)
        @test violations == 0
        @test satisfies(system, criteria, rankings)
    end

    @safetestset "Borda count" begin
        using RankChoiceVoting
        using Test
        using Random

        Random.seed!(5601)
        for _ ∈ 1:25
            n = rand(10:100)
            data = map(_ -> shuffle([:a,:b,:c]), 1:n)
            rankings = Ranks(data)
            system = Borda()
            criteria = ReversalSymmetry()
            violations = count_violations(system, criteria, rankings)
            # Borda always satisfies reversal symmetry
            @test violations == 0
            @test satisfies(system, criteria, rankings)
        end
    end
end