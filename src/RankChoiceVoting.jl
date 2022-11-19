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
    export Condorcet
    export Borda
    export Majority
    export Consistency

    include("common.jl")
    include("systems/instant_runoff.jl")
    include("systems/Borda.jl")
    include("systems/Bucklin.jl")
    include("criteria/monotonicity.jl")
    include("criteria/reversalsymmetry.jl")
    include("criteria/condorcet.jl")
    include("criteria/majority.jl")
    include("criteria/consistency.jl")
end
