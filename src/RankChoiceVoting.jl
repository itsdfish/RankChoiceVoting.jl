module RankChoiceVoting
    using Random
    export evaluate_winner
    export VotingSystem
    export InstantRunOff

    include("structs.jl")
    include("criteria.jl")
    include("instant_runoff.jl")
    include("utilities.jl")
end
