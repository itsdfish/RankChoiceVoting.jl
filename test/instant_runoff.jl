@safetestset "instant runoff" begin
    @safetestset "example1" begin
        using RankChoiceVoting
        using Test

        data = [[:d,:c,:a,:e,:b] for _ ∈ 1:9]
        push!(data, [[:b,:e,:a,:c,:d] for _ ∈ 1:5]...)
        push!(data, [[:e,:a,:d,:b,:c] for _ ∈ 1:2]...)
        push!(data, [[:b,:c,:a,:d,:e] for _ ∈ 1:5]...)
        push!(data, [[:c,:a,:d,:b,:e] for _ ∈ 1:8]...)
        push!(data, [[:b,:d,:c,:a,:e] for _ ∈ 1:6]...)
        rankings = Ranks(data)
        
        system = InstantRunOff()
        winner = evaluate_winner(system, rankings)
        @test length(winner) == 1
        @test winner[1] == :d
    end

    @safetestset "tie" begin 
        using RankChoiceVoting
        using Test
        
        data = [[:a, :b, :c] for _ ∈ 1:8]
        push!(data, [[:b, :c, :a] for _ ∈ 1:8]...)
        rankings = Ranks(data)

        system = InstantRunOff()
        _,ranks = compute_ranks(system, rankings)
        winner = evaluate_winner(system, rankings)
        
        @test (ranks == [:a,:b,:c]) || (ranks == [:b,:a,:c])
        @test Set(winner) == Set([:a,:b])
    end

    @safetestset "example2" begin
        # https://courses.lumenlearning.com/mathforliberalartscorequisite/chapter/instant-runoff-voting/
        using RankChoiceVoting
        using Test

        data = [[:b,:c,:a,:d,:e] for _ ∈ 1:3]
        push!(data, [[:c,:a,:d,:b,:e] for _ ∈ 1:4]...)
        push!(data, [[:b,:d,:c,:a,:e] for _ ∈ 1:4]...)
        push!(data, [[:d,:c,:a,:e,:b] for _ ∈ 1:6]...)
        push!(data, [[:b,:e,:a,:c,:d] for _ ∈ 1:2]...)
        push!(data, [[:e,:a,:d,:b,:c] for _ ∈ 1:1]...)
        rankings = Ranks(data)
        
        system = InstantRunOff()
        _,ranks = compute_ranks(system, rankings)
        winner = evaluate_winner(system, rankings)

        @test winner == [:d]
        @test ranks == [:d,:b,:c,:e,:a]
    end
end