############################################################################################################
#                                         load packages
############################################################################################################
cd(@__DIR__)
using Pkg 
Pkg.activate("..")
using Revise, Random, RankChoiceVoting
cnt = 0
for _ in 1:1000
    rankings = [shuffle(1:4) for _ ∈ 1:1000]
    system = InstantRunOff(rankings)
    criteria = ReversalAsymmetry()
    cnt += count_violations(system, criteria)

end


rankings = Vector{Vector{Symbol}}()
push!(rankings, [[:a,:b,:c] for _ ∈ 1:4]...)
push!(rankings, [[:b,:c,:a] for _ ∈ 1:3]...)
push!(rankings, [[:c,:a,:b] for _ ∈ 1:2]...)

system = InstantRunOff(rankings)
criteria = ReversalSymmetry()
winner = count_violations(system, criteria)

@code_warntype evaluate_winner(system)
@code_warntype count_violations(system, criteria)
