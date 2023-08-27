module RankChoiceVoting
    using Combinatorics
    using Distributions
    using OrderedCollections
    using Random

    export compute_ranks
    export count_violations
    export evaluate_winner
    export satisfies
    
    export Borda
    export Bucklin
    export CondorcetLoser
    export CondorcetWinner
    export Consistency
    export Independence
    export InstantRunOff
    export Majority
    export Monotonicity
    export MutualMajority
    export ReversalSymmetry
    export VotingSystem

    include("common.jl")
    include("systems/instant_runoff.jl")
    include("systems/Borda.jl")
    include("systems/Bucklin.jl")
    include("criteria/monotonicity.jl")
    include("criteria/reversalsymmetry.jl")
    include("criteria/condorcet_winner.jl")
    include("criteria/condorcet_loser.jl")
    include("criteria/majority.jl")
    include("criteria/consistency.jl")
    include("criteria/mutual_majority.jl")
    include("criteria/independence_irrelevant_alternatives.jl")
end
