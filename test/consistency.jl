@safetestset "consistency" begin
    @safetestset "instant runoff" begin
        using RankChoiceVoting
        using Test

        rankings = Vector{Vector{Symbol}}()
        push!(rankings, [[:a,:b,:c] for _ ∈ 1:8]...)
        push!(rankings, [[:b,:c,:a] for _ ∈ 1:8]...)
        push!(rankings, [[:c,:a,:b] for _ ∈ 1:12]...)

        system = InstantRunOff(rankings)
        criteria = Consistency()
        violations = count_violations(system, criteria)
        @test violations > 0
        @test !satisfies(system, criteria)
    end

    @safetestset "Borda" begin
        using RankChoiceVoting
        using Test
        using Random
        using RankChoiceVoting: violates
        using RankChoiceVoting: _satisfies
        Random.seed!(8554)


        candidates = [:a,:b,:c]
        criterion = Consistency()

        for _ ∈ 1:100
            n = rand(50:500)
            rankings = map(_ -> shuffle(candidates), 1:n)
            system = Borda(rankings)
            @test _satisfies(system, criterion)
        end
    end
end


