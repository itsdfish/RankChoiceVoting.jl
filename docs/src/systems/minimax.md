```@setup minimax
using RankChoiceVoting
data = [[:m,:n,:c,:k] for _ ∈ 1:42]
push!(data, [[:n,:m,:c,:k] for _ ∈ 1:26]...)
push!(data, [[:c,:k,:n,:m] for _ ∈ 1:15]...)
push!(data, [[:k,:c,:n,:m] for _ ∈ 1:17]...)
rankings = Ranks(data)
system = Minimax()
```
# Minimax

The minimax system assigns a score to each vote according to the following rule:

$s = n - r + 1$

where $s$ is the score, $n$ is the number of candidates and $r$ is the rank. Effectively, the score reverse codes the rank votes. The candidate with the highest Borda score is selected as the winner. As an example, consider the following:

| count 	| 1 	| 2 	| 3 	|
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

```@example minimax
using RankChoiceVoting 

data = [[:m,:n,:c,:k] for _ ∈ 1:42]
push!(data, [[:n,:m,:c,:k] for _ ∈ 1:26]...)
push!(data, [[:c,:k,:n,:m] for _ ∈ 1:15]...)
push!(data, [[:k,:c,:n,:m] for _ ∈ 1:17]...)
rankings = Ranks(data)
```
Next, let's create objects for the `Consistency` criterion and the `Minimax` voting system.
```@example minimax 
criterion = Consistency()
system = Minimax()
```

## Compute Ranking
The function `compute_ranks` is used to generate a complete rank ordering of candidates. In the case of ties, candidates will share the same rank value. 
```@example minimax
compute_ranks(system, rankings)
```

## Evaluate Winner
We can use the function `evaluate_winner` to return the winner of the election as a vector. If multiple candidates tie for winner, the vector will contain each winning candidate.
```@example minimax
evaluate_winner(system, rankings)
```

## Satisfies
The example below determines whether the a voting system is guaranteed to satisfy a given fairness criterion. 

```@example minimax
satisfies(system, criterion)
```
It is also possible to check whether a system satisfies a given fairness criterion for a specific set of rank choice votes.
```@example minimax
satisfies(system, criterion, rankings)
```
In the case above, the Borda system satisfies the [consistency criterion](../criteria/consistency.md) because it holds in general. However, if a system does not satisify a criterion in general, it may satisfy the criterion in specific cases. 

## Count Violations
The code block below shows how to use `count_violations` to determine the number of violations of a fairness criterion a given system produces for a specific set of rank choice votes.
```@example minimax
count_violations(system, criterion, rankings)
```

## References