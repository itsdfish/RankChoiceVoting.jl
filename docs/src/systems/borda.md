```@setup borda_count
using RankChoiceVoting
data = [[:m,:n,:c,:k],[:n,:m,:c,:k],[:c,:k,:n,:m],[:k,:c,:n,:m]]
counts = [42,26,15,17]
rankings = Ranks(counts, data)
system = Borda()
```
# Borda Count

The Borda count system assigns a score to each vote according to the following rule:

$s = n - r + 1$

where $s$ is the score, $n$ is the number of candidates and $r$ is the rank. Effectively, the score reverse codes the rank votes. The candidate with the highest Borda score is selected as the winner. As an example, consider the following:

| count 	|  	|  	|  	|
|-------	|---	|---	|---	|
| 1     	| a 	| b 	| c 	|
| 2     	| c 	| b 	| a 	|

The Borda scores for each candidate are:

| candidate 	| score 	|
|-----------	|-------	|
| a         	| 4     	|
| b         	| 6     	|
| c         	| 6     	|

which creates a tie between candidates b and c. 

# Example Usage

The following examples illustrate some ways in which the Borda system can be used in RankChoiceVoting.jl. To begin, let's generate some synthetic rank choice votes for candidates $C = \{c,k,m,n\}$ from 100 voters. 

```@example borda_count
using RankChoiceVoting 

data = [[:m,:n,:c,:k],[:n,:m,:c,:k],[:c,:k,:n,:m],[:k,:c,:n,:m]]
counts = [42,26,15,17]
rankings = Ranks(counts, data)
rankings = Ranks(data)
```
Next, let's create objects for the `Consistency` criterion and the `Borda` voting system.
```@example borda_count 
criterion = Consistency()
system = Borda()
```

## Compute Ranking
The function `compute_ranks` is used to generate a complete rank ordering of candidates. In the case of ties, candidates will share the same rank value. 
```@example borda_count
compute_ranks(system, rankings)
```

## Evaluate Winner
We can use the function `evaluate_winner` to return the winner of the election as a vector. If multiple candidates tie for winner, the vector will contain each winning candidate.
```@example borda_count
evaluate_winner(system, rankings)
```

## Satisfies
The example below determines whether the a voting system is guaranteed to satisfy a given fairness criterion. 

```@example borda_count
satisfies(system, criterion)
```
It is also possible to check whether a system satisfies a given fairness criterion for a specific set of rank choice votes.
```@example borda_count
satisfies(system, criterion, rankings)
```
In the case above, the Borda system satisfies the [consistency criterion](../criteria/consistency.md) because it holds in general. However, if a system does not satisify a criterion in general, it may satisfy the criterion in specific cases. 

## Count Violations
The code block below shows how to use `count_violations` to determine the number of violations of a fairness criterion a given system produces for a specific set of rank choice votes.
```@example borda_count
count_violations(system, criterion, rankings)
```