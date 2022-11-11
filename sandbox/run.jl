############################################################################################################
#                                         load packages
############################################################################################################
cd(@__DIR__)
using Pkg 
Pkg.activate("..")
using Revise, Random, RankChoiceVoting

rankings = [shuffle(1:4) for _ ∈ 1:1000]
system = InstantRunOff(rankings)
evaluate_winner(system)

using RankChoiceVoting: tally
using RankChoiceVoting: count_top_ranks
counts,uranks = tally(rankings)


rankings = Vector{Vector{Symbol}}()
push!(rankings, [[:d,:c,:a,:e,:b] for _ ∈ 1:9]...)
push!(rankings, [[:b,:e,:a,:c,:d] for _ ∈ 1:5]...)
push!(rankings, [[:e,:a,:d,:b,:c] for _ ∈ 1:2]...)
push!(rankings, [[:b,:c,:a,:d,:e] for _ ∈ 1:5]...)
push!(rankings, [[:c,:a,:d,:b,:e] for _ ∈ 1:8]...)
push!(rankings, [[:b,:d,:c,:a,:e] for _ ∈ 1:6]...)

system = InstantRunOff(rankings)
winner = evaluate_winner(system, counts, uranks)
