@safetestset "consistency" begin
    @safetestset "instant runoff" begin
        using RankChoiceVoting
        using Test

        data = [[:a,:b,:c] for _ ∈ 1:8]
        push!(data, [[:b,:c,:a] for _ ∈ 1:8]...)
        push!(data, [[:c,:a,:b] for _ ∈ 1:12]...)
        rankings = Ranks(data)

        system = InstantRunOff()
        criteria = Consistency()
        violations = count_violations(system, criteria, rankings)
        @test violations > 0
        @test !satisfies(system, criteria, rankings)
    end

    @safetestset "Borda" begin
        using RankChoiceVoting
        using Test
        using Random
        using RankChoiceVoting: violates
        using RankChoiceVoting: Fails
        Random.seed!(8554)

        candidates = [:a,:b,:c]
        criterion = Consistency()

        for _ ∈ 1:100
            n = rand(50:500)
            data = map(_ -> shuffle(candidates), 1:n)
            rankings = Ranks(data)
            system = Borda()
            @test satisfies(Fails(), system, criterion, rankings)
        end
    end
end