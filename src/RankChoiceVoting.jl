module RankChoiceVoting
    using Random
    using Combinatorics
    using Distributions
    export evaluate_winner
    export count_violations
    export satisfies
    export VotingSystem
    export InstantRunOff
    export Bucklin
    export ReversalSymmetry
    export Monotonicity
    export CondorcetWinner
    export CondorcetLoser
    export Borda
    export Majority
    export MutualMajority
    export Consistency

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
end
