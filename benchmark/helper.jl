"""
    simulate_votes(candidates, n)

Simulates random votes
"""
simulate_votes(n_candidates, n_voters) = Ranks(_sim([1:n_candidates;], n_voters))

_sim(candidates, n) = map(_ -> shuffle(candidates), 1:n)
