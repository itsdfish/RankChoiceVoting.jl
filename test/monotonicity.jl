@safetestset "monotonicity" begin
    @safetestset "instant runoff test case" begin
        using RankChoiceVoting
        using Test

        rankings = Vector{Vector{Symbol}}()
        push!(rankings, [[:a,:b,:c] for _ ∈ 1:37]...)
        push!(rankings, [[:b,:c,:a] for _ ∈ 1:22]...)
        push!(rankings, [[:b,:a,:c] for _ ∈ 1:12]...)
        push!(rankings, [[:c,:a,:b] for _ ∈ 1:29]...)

        system = InstantRunOff(rankings)
        winner1 = evaluate_winner(system)

        rankings = Vector{Vector{Symbol}}()
        push!(rankings, [[:a,:b,:c] for _ ∈ 1:47]...)
        push!(rankings, [[:b,:c,:a] for _ ∈ 1:22]...)
        push!(rankings, [[:b,:a,:c] for _ ∈ 1:2]...)
        push!(rankings, [[:c,:a,:b] for _ ∈ 1:29]...)

        system = InstantRunOff(rankings)
        winner2 = evaluate_winner(system)
        @test winner1 ≠ winner2 
    end
    
    @safetestset "instant runoff" begin
        using RankChoiceVoting
        using Test
        using Random

        Random.seed!(6951)

        rankings = Vector{Vector{Symbol}}()
        push!(rankings, [[:a,:b,:c] for _ ∈ 1:37]...)
        push!(rankings, [[:b,:c,:a] for _ ∈ 1:22]...)
        push!(rankings, [[:b,:a,:c] for _ ∈ 1:12]...)
        push!(rankings, [[:c,:a,:b] for _ ∈ 1:29]...)

        system = InstantRunOff(rankings)
        criteria = Monotonicity()
        violations = count_violations(system, criteria)
        @test violations > 0
        @test !satisfies(system, criteria)
    end

    @safetestset "Borda count" begin
        using RankChoiceVoting
        using Test
        using Random

        rankings = map(_ -> shuffle([:a,:b,:c]), 1:100)
        system = Borda(rankings)
        criteria = Monotonicity()
        violations = count_violations(system, criteria)
        # Borda always satisfies Monotonicity
        @test violations == 0
        @test satisfies(system, criteria)
    end
end