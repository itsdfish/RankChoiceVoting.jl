module RankChoiceVoting
    using Random
    export evaluate_winner
    export VotingSystem
    export InstantRunOff
    export ReversalSymmetry
    export count_violations

    include("structs.jl")
    include("criteria.jl")
    include("instant_runoff.jl")
    include("utilities.jl")
end
