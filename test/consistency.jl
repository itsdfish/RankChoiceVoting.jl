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

        Random.seed!(8554)

        function _satisfies(system; n_max=1000)
            winner = evaluate_winner(system)
            for i ∈ 1:n_max 
                violates(system, winner) ? (return false) : nothing 
            end
            return true 
        end

        candidates = [:a,:b,:c]

        for _ ∈ 1:100
            n = rand(50:500)
            rankings = map(_ -> shuffle(candidates), 1:n)
            system = Borda(rankings)
            @test _satisfies(system)
        end
    end
end


