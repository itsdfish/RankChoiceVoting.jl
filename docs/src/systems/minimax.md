```@setup minimax
using RankChoiceVoting
data = [[:m,:n,:c,:k],[:n,:m,:c,:k],[:c,:k,:n,:m],[:k,:c,:n,:m]]
counts = [42,26,15,17]
rankings = Ranks(counts, data)
system = Minimax()
```
# Minimax

The minimax system selects the winner whose worst case scenario is the best amoung other candidates. There are different ways to measure the worst case scenario. In this package, the worst case scenario is measures using a margin of pairwise victories of candidate. Formally, let $C = \{c_i\}_{i\in \mathcal{I}}$ be a set of $n$ candidates, where $\mathcal{I}=\{1,\dots,n\}$ is the index set. The margin of voters prefering candidate $i$ over candidate $j$ is given by:

$f(c_i,c_j) = d(c_i,c_j) - d(c_j,c_i),$

where $d(i,j)$ is the number of voters who prefer candidate $i$ over candidate $j$. In the example below, the maximum margin of defeat is $[-2,2,2]$ for candidates a, b, and c, respectively. The *best* worst case scenario occurs for candidate a, whose score indicates a margin of victory of 2.  

```@example 
using RankChoiceVoting
using RankChoiceVoting: score_pairwise

data = [[:a,:b,:c],[:a,:c,:b],[:c,:b,:a]]
counts = [2,1,1]
rankings = Ranks(counts, data)
system = Minimax()
x = score_pairwise(rankings, [:a,:b,:c])
```
# Example Usage

The following examples illustrate some ways in which the minimax system can be used in RankChoiceVoting.jl. To begin, let's generate some synthetic rank choice votes for candidates $C = \{c,k,m,n\}$ from 100 voters. 

```@example minimax
using RankChoiceVoting 

data = [[:m,:n,:c,:k],[:n,:m,:c,:k],[:c,:k,:n,:m],[:k,:c,:n,:m]]
counts = [42,26,15,17]
rankings = Ranks(counts, data)
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