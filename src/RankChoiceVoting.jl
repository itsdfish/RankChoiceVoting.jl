module RankChoiceVoting
    using Random
    using Combinatorics
    using Distributions
    export evaluate_winner
    export count_violations
    export VotingSystem
    export InstantRunOff
    export ReversalSymmetry
    export Monotonicity

    include("common.jl")
    include("instant_runoff.jl")
    include("monotonicity.jl")
    include("reversalsymmetry.jl")
end
