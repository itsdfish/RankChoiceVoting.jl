const ALL_SYSTEMS = [Borda(), Bucklin(), InstantRunOff(), Minimax(), Plurality()]

const ALL_CRITERIA = [
    CondorcetLoser(),
    CondorcetWinner(),
    Consistency(),
    IIA(),
    Majority(),
    Monotonicity(),
    MutualMajority(),
    ReversalSymmetry(),
]
