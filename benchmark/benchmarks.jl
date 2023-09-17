####################################################################################################
#                                       set up
####################################################################################################
using BenchmarkTools
using Random
using RankChoiceVoting
using RankChoiceVoting: ALL_SYSTEMS
using RankChoiceVoting: ALL_CRITERIA
include("helper.jl")
SUITE = BenchmarkGroup()
####################################################################################################
#                                       satisfies
####################################################################################################
SUITE[:satisfies] = BenchmarkGroup()
n_voters = [10]
n_candidates = 4
for system ∈ ALL_SYSTEMS
    system_name = Symbol(typeof(system))
    SUITE[:satisfies][system_name] = BenchmarkGroup()
    for criterion ∈ ALL_CRITERIA
        criterion_name = Symbol(typeof(criterion))
        SUITE[:satisfies][system_name][criterion_name] = BenchmarkGroup()
        for n ∈ n_voters
            SUITE[:satisfies][system_name][criterion_name][n] = @benchmarkable(
                satisfies($system, $criterion, rankings),
                evals = 10,
                samples = 1000,
                setup = (rankings=simulate_votes(n_candidates, $n))
            )
        end
    end
end
# use this to test locally
# results = run(SUITE)
# mean(results)

# using BenchmarkPlots, StatsPlots
# t = run(g)
# plot(t)