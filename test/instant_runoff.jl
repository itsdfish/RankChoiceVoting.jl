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
        @test length(winner) == 1
        @test winner[1] == :d
    end

    @safetestset "tie" begin 
        using RankChoiceVoting
        using Test
        
        rankings = Vector{Vector{Symbol}}()
        push!(rankings, [[:a, :b, :c] for _ ∈ 1:8]...)
        push!(rankings, [[:b, :c, :a] for _ ∈ 1:8]...)
        
        system = InstantRunOff(rankings)
        _,ranks = compute_ranks(system)
        winner = evaluate_winner(system)
        
        @test (ranks == [:a,:b,:c]) || (ranks == [:b,:a,:c])
        @test Set(winner) == Set([:a,:b])
    end

    @safetestset "example2" begin
        # https://courses.lumenlearning.com/mathforliberalartscorequisite/chapter/instant-runoff-voting/
        using RankChoiceVoting
        using Test

        rankings = Vector{Vector{Symbol}}()
        push!(rankings, [[:b,:c,:a,:d,:e] for _ ∈ 1:3]...)
        push!(rankings, [[:c,:a,:d,:b,:e] for _ ∈ 1:4]...)
        push!(rankings, [[:b,:d,:c,:a,:e] for _ ∈ 1:4]...)
        push!(rankings, [[:d,:c,:a,:e,:b] for _ ∈ 1:6]...)
        push!(rankings, [[:b,:e,:a,:c,:d] for _ ∈ 1:2]...)
        push!(rankings, [[:e,:a,:d,:b,:c] for _ ∈ 1:1]...)
        
        system = InstantRunOff(rankings)
        _,ranks = compute_ranks(system)
        winner = evaluate_winner(system)

        @test winner == []:d]
        @test ranks == [:d,:b,:c,:e,:a]
    end
end