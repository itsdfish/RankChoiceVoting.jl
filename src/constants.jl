const ALL_SYSTEMS = [
    Borda(),
    Bucklin(),
    InstantRunOff(),
    Minimax(),
    Plurality()
]

const ALL_CRITERIA = [
    CondorcetLoser(),
    CondorcetWinner(),
    Consistency(),
    Independence(),
    Majority(),
    Monotonicity(),
    MutualMajority(),
    ReversalSymmetry()
]
