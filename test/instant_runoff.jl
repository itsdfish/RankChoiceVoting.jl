@safetestset "instant runoff" begin
    @safetestset "example1" begin
        using RankChoiceVoting
        using Test

        rankings = Vector{Vector{Symbol}}()
        push!(rankings, [[:d,:c,:a,:e,:b] for _ ∈ 1:9]...)
        push!(rankings, [[:b,:e,:a,:c,:d] for _ ∈ 1:5]...)
        push!(rankings, [[:e,:a,:d,:b,:c] for _ ∈ 1:2]...)
        push!(rankings, [[:b,:c,:a,:d,:e] for _ ∈ 1:5]...)
        push!(rankings, [[:c,:a,:d,:b,:e] for _ ∈ 1:8]...)
        push!(rankings, [[:b,:d,:c,:a,:e] for _ ∈ 1:6]...)
        
        system = InstantRunOff(rankings)
        winner = evaluate_winner(system)
        @test winner == :d
    end
end