@safetestset "Independence" begin
    @safetestset "Instant Runoff 1" begin
        using RankChoiceVoting
        using Test
        using Random

        data = [[:a,:b,:c] for _ ∈ 1:37]
        push!(data, [[:b,:c,:a] for _ ∈ 1:22]...)
        push!(data, [[:b,:a,:c] for _ ∈ 1:12]...)
        push!(data, [[:c,:a,:b] for _ ∈ 1:29]...)
        rankings = Ranks(data)

        system = InstantRunOff()
        criterion = Independence()
        @test !satisfies(system, criterion, rankings)
        @test count_violations(system, criterion, rankings) == 1
    end

    @safetestset "Instant Runoff 2" begin
        using RankChoiceVoting
        using Test
        using Random

        data = [[:c, :b, :a] for _ ∈ 1:3]
        push!(data, [[:c, :a, :b] for _ ∈ 1:2]...)
        push!(data, [[:b, :c, :a] for _ ∈ 1:3]...)
        push!(data, [[:a, :b, :c] for _ ∈ 1:3]...)
        push!(data, [[:a, :c, :b] for _ ∈ 1:2]...)
        push!(data, [[:b, :a, :c] for _ ∈ 1:2]...)
        rankings = Ranks(data)

        system = InstantRunOff()
        criterion = Independence()
        @test satisfies(system, criterion, rankings)
    end

    @safetestset "Borda count 1" begin
        using RankChoiceVoting
        using Test
        using Random

        data = [[:c, :b, :a] for _ ∈ 1:4]
        push!(data, [[:a, :b, :c] for _ ∈ 1:2]...)
        push!(data, [[:b, :a, :c] for _ ∈ 1:1]...)
        push!(data, [[:b, :c, :a] for _ ∈ 1:3]...)
        push!(data, [[:a, :c, :b] for _ ∈ 1:2]...)
        rankings = Ranks(data)

        system = Borda()
        criterion = Independence()
        @test !satisfies(system, criterion)
    end

    @safetestset "Borda count 2" begin
        using RankChoiceVoting
        using Test
        using Random

        data = [[:a, :b, :c] for _ ∈ 1:5]
        push!(data, [[:b, :c, :a] for _ ∈ 1:2]...)
        push!(data, [[:b, :a, :c] for _ ∈ 1:4]...)
        push!(data, [[:a, :c, :b] for _ ∈ 1:3]...)
        push!(data, [[:c, :a, :b] for _ ∈ 1:1]...)
        rankings =  Ranks(data)
        
        system = Borda()
        criterion = Independence()
        @test satisfies(system, criterion, rankings)
    end

    @safetestset "Bucklin 1" begin
        using RankChoiceVoting
        using Test
        using Random

        data = [[:a, :b, :c] for _ ∈ 1:5]
        push!(data, [[:a, :c, :b] for _ ∈ 1:4]...)
        push!(data, [[:b, :a, :c] for _ ∈ 1:4]...)
        push!(data, [[:c, :a, :b] for _ ∈ 1:2]...)
        rankings = Ranks(data)

        system = Bucklin()
        criterion = Independence()
        @test satisfies(system, criterion, rankings)
    end

    # @safetestset "plurality" begin
        ## for less strict version https://www.yorku.ca/bucovets/4080/choice/2.pdf
    #     using RankChoiceVoting
    #     using Test
    #     using Random

    #     data =  [[:a, :b, :c] for _ ∈ 1:3]
    #     push!(data, [[:b, :c, :a] for _ ∈ 1:2]...)
    #     push!(data, [[:b, :a, :c] for _ ∈ 1:4]...)
    #     push!(data, [[:c, :a, :b] for _ ∈ 1:6]...)
    #     rankings = Ranks(data)

    #     system = Bucklin()
    #     criterion = Independence()
    #     @test !satisfies(system, criterion, rankings)
    # end
end