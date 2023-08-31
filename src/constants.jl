const ALL_SYSTEMS = [Borda(),Bucklin(),InstantRunOff()]
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
