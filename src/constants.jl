const ALL_SYSTEMS = [Borda(),Bucklin(),InstantRunOff(), Minimax()]
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
