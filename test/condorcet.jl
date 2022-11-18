@safetestset "condorcet" begin
    @safetestset "instant runoff 1" begin
        using RankChoiceVoting
        using Test

        rankings = Vector{Vector{Symbol}}()
        push!(rankings, [[:a,:b,:c] for _ ∈ 1:37]...)
        push!(rankings, [[:b,:c,:a] for _ ∈ 1:22]...)
        push!(rankings, [[:b,:a,:c] for _ ∈ 1:12]...)
        push!(rankings, [[:c,:a,:b] for _ ∈ 1:29]...)

        system = InstantRunOff(rankings)
        criteria = Condorcet()
        violations = count_violations(system, criteria)
        @test violations == 0
        @test satisfies(system, criteria)
    end

    @safetestset "instant runoff 2" begin
        #https://math.hawaii.edu/~marriott/teaching/summer2013/math100/violations.pdf
        using RankChoiceVoting
        using Test

        rankings = Vector{Vector{Symbol}}()
        push!(rankings, [[:a,:c,:b,:d] for _ ∈ 1:10]...)
        push!(rankings, [[:d,:b,:a,:c] for _ ∈ 1:7]...)
        push!(rankings, [[:b,:c,:a,:d] for _ ∈ 1:5]...)
        push!(rankings, [[:c,:d,:a,:b] for _ ∈ 1:5]...)
        push!(rankings, [[:b,:c,:d,:a] for _ ∈ 1:4]...)

        system = InstantRunOff(rankings)
        criteria = Condorcet()
        violations = count_violations(system, criteria)
        @test violations == 1
        @test !satisfies(system, criteria)
    end
end