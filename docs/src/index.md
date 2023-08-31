!!! warning 
    Work in progress

# Overview

This package provides a framework for simulating and evaluating rank choice voting systems. Rank choice voting systems allow voters to order candidates according to preference rather than providing a single selection of the most preferred candidate. Each rank choice voting system specifies a rule for aggregating individual rankings into a societial ranking from which a winner is selected. Importantly, the rules can provide different election outcomes. 

Interestingly, Arrow's impossibility theorem demonstrates that it is impossible to design a rank choice voting system that can satisfy a set of fairness criteria in all possible elections. What this means is that every rank choice voting system is flawed to some degree, and may lead to undesirable behavior in some situations. Although insightful, many interesting questions remain unanswered by Arrow's impossibility theorem. For example, how prevalent are violations of fairness critera, and under what conditions are they violated? This package is designed to help answer questions of this nature.

# Installation

In the REPL, type `]` to enter package mode and type

```julia 
add https://github.com/itsdfish/RankChoiceVoting.jl
```
to add RankChoiceVoting.jl to your environment.

# API Overview

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
The code block below shows how to determine the winner of an election using the `Borda` system.

```@setup index
using RankChoiceVoting

data = [[:m,:n,:c,:k] for _ ∈ 1:42]
push!(data, [[:n,:m,:c,:k] for _ ∈ 1:26]...)
push!(data, [[:c,:k,:n,:m] for _ ∈ 1:15]...)
push!(data, [[:k,:c,:n,:m] for _ ∈ 1:17]...)
rankings = Ranks(data)

system = Borda()
```

```@example index
using RankChoiceVoting

data = [[:m,:n,:c,:k] for _ ∈ 1:42]
push!(data, [[:n,:m,:c,:k] for _ ∈ 1:26]...)
push!(data, [[:c,:k,:n,:m] for _ ∈ 1:15]...)
push!(data, [[:k,:c,:n,:m] for _ ∈ 1:17]...)
rankings = Ranks(data)

system = Borda()
evaluate_winner(system, rankings)
```
Similarly, we can determine the full ranking with the function `compute_ranks`:

```@example index
compute_ranks(system, rankings)
```

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