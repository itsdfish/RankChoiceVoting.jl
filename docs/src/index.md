# Overview

This package provides a framework for simulating and evaluating rank choice voting systems. Rank choice voting systems allow voters to order candidates according to preference rather than providing a single selection of the most preferred candidate. Each rank choice voting system specifies a rule for aggregating individual rankings into a societial ranking from which a winner is selected. Importantly, the rules can provide different election outcomes. 

Interestingly, [Arrow's impossibility theorem](https://en.wikipedia.org/wiki/Arrow%27s_impossibility_theorem) demonstrates that it is impossible to design a rank choice voting system that can satisfy a set of fairness criteria for all possible preference profiles (i.e., election outcomes). What this means is that every rank choice voting system is flawed to some degree, and may lead to undesirable behavior in some situations. The purpose of this package is allow users to explore the conditions under which fairness criteria are satisfied and violated.

# Installation

In the REPL, type `]` to enter package mode and type

```julia 
add RankChoiceVoting
```
to add RankChoiceVoting.jl to your environment.

# API Overview

The API for RankChoiceVoting.jl is summarized below. For more details, use the navigation panel on the left.
## Type System

The API for RankChoiceVoting consists of three sets of types: 

- `ranks`: a rank choice data object
- `systems`: a set of rules for transforming individual rank choice votes into a societal ranking
- `criteria`: fairness criteria against which a voting system is evaluated 

## Functions

- `compute_ranks`: transforms a set of individual rank choices into a societal ranking
- `evaluate_winner`: returns the winner(s) of an election
- `satisfies`: evaluates whether a system satisfies a given criterion
- `count_violations`: counts the number of violations of a criterion in a given set of rank choice votes

# Quick Example
Below, we will showcase some common uses of RankChoiceVoting.jl using an example based on the `Borda count` system.

## Rank Choice Votes
The code block below generates synthetic rank choice votes of candidates $C = \{c,k,m,n\}$ from 100 voters:
```@setup index
using RankChoiceVoting

data = [[:m,:n,:c,:k],[:n,:m,:c,:k],[:c,:k,:n,:m],[:k,:c,:n,:m]]
counts = [42,26,15,17]
rankings = Ranks(counts, data)

system = Borda()
```

```@example index
using RankChoiceVoting

data = [[:m,:n,:c,:k],[:n,:m,:c,:k],[:c,:k,:n,:m],[:k,:c,:n,:m]]
counts = [42,26,15,17]
rankings = Ranks(counts, data)
```
## Select Winner
We can use the function `evaluate_winner` to determine the winner of the election.
```@example index
system = Borda()
evaluate_winner(system, rankings)
```
## Compute Ranks

Similarly, we can determine the full ranking with the function `compute_ranks`:

```@example index
compute_ranks(system, rankings)
```
## Fairness Criteria

The code block below shows how to use the `satisfies` function to determine which criteria the `Borda` voting system satisfies.
```@example 
using RankChoiceVoting
system = Borda()
satisfies(system)
```

Alternatively, it is possible to pass a criterion to the function `satisfies` to determine which voting systems satisfy the criterion.
```@example 
using RankChoiceVoting
criterion = Consistency()
satisfies(criterion)
```