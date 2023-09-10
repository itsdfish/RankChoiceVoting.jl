```@setup instant_runoff
using RankChoiceVoting
data = [[:m,:n,:c,:k],[:n,:m,:c,:k],[:c,:k,:n,:m],[:k,:c,:n,:m]]
counts = [42,26,15,17]
rankings = Ranks(counts, data)
system = InstantRunOff()
```
# Instant Runoff

An instant runoff voting system iteratively eliminates the candidate with the minimum first preferences until one canidate reaches 50% first preferences.
```@example 
using RankChoiceVoting

data = [[:a,:b,:c],[:a,:c,:b],[:c,:b,:a]]
counts = [2,1,1]
rankings = Ranks(counts, data)
system = InstantRunOff()
```
# Example Usage

The following examples illustrate some ways in which the instant_runoff system can be used in RankChoiceVoting.jl. To begin, let's generate some synthetic rank choice votes for candidates $C = \{c,k,m,n\}$ from 100 voters. 

```@example instant_runoff
using RankChoiceVoting 

data = [[:m,:n,:c,:k],[:n,:m,:c,:k],[:c,:k,:n,:m],[:k,:c,:n,:m]]
counts = [42,26,15,17]
rankings = Ranks(counts, data)
```
Next, let's create objects for the `Consistency` criterion and the `instant_runoff` voting system.
```@example instant_runoff 
criterion = Consistency()
system = InstantRunOff()
```

## Compute Ranking
The function `compute_ranks` is used to generate a complete rank ordering of candidates. In the case of ties, candidates will share the same rank value. 
```@example instant_runoff
compute_ranks(system, rankings)
```

## Evaluate Winner
We can use the function `evaluate_winner` to return the winner of the election as a vector. If multiple candidates tie for winner, the vector will contain each winning candidate.
```@example instant_runoff
evaluate_winner(system, rankings)
```

## Satisfies
The example below determines whether the a voting system is guaranteed to satisfy a given fairness criterion. 

```@example instant_runoff
satisfies(system, criterion)
```
It is also possible to check whether a system satisfies a given fairness criterion for a specific set of rank choice votes.
```@example instant_runoff
satisfies(system, criterion, rankings)
```
In the case above, the Borda system satisfies the [consistency criterion](../criteria/consistency.md) because it holds in general. However, if a system does not satisify a criterion in general, it may satisfy the criterion in specific cases. 

## Count Violations
The code block below shows how to use `count_violations` to determine the number of violations of a fairness criterion a given system produces for a specific set of rank choice votes.
```@example instant_runoff
count_violations(system, criterion, rankings)
```

## References
