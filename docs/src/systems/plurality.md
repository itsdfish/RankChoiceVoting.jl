```@setup plurality
using RankChoiceVoting
data = [[:m,:n,:c,:k],[:n,:m,:c,:k],[:c,:k,:n,:m],[:k,:c,:n,:m]]
counts = [42,26,15,17]
rankings = Ranks(counts, data)
system = Plurality()
```
# Plurality

A plurality voting system selects the candidate who has the greatest first position preferences. Formally, let $C = \{c_i\}_{i\in \mathcal{I}}$ be a set of $n$ candidates, where $\mathcal{I}=\{1,\dots,n\}$ is the index set. Let $r_j(c_i)$ be a function which counts the number of $j^{th}$ position preferences for candidate $i$. The winning candidate is given by 

$c_m = \underset{c_i \in C}{\mathrm{argmax}}f_1(c_i).$

# Example Usage

The following examples illustrate some ways in which the plurality system can be used in RankChoiceVoting.jl. To begin, let's generate some synthetic rank choice votes for candidates $C = \{c,k,m,n\}$ from 100 voters. 

```@example plurality
using RankChoiceVoting 
data = [[:m,:n,:c,:k],[:n,:m,:c,:k],[:c,:k,:n,:m],[:k,:c,:n,:m]]
counts = [42,26,15,17]
rankings = Ranks(counts, data)
```
Next, let's create objects for the `Consistency` criterion and the `plurality` voting system.
```@example plurality 
criterion = Consistency()
system = Plurality()
```

## Compute Ranking
The function `compute_ranks` is used to generate a complete rank ordering of candidates. In the case of ties, candidates will share the same rank value. 
```@example plurality
compute_ranks(system, rankings)
```

## Evaluate Winner
We can use the function `evaluate_winner` to return the winner of the election as a vector. If multiple candidates tie for winner, the vector will contain each winning candidate.
```@example plurality
evaluate_winner(system, rankings)
```

## Satisfies
The example below determines whether the a voting system is guaranteed to satisfy a given fairness criterion. 

```@example plurality
satisfies(system, criterion)
```
It is also possible to check whether a system satisfies a given fairness criterion for a specific set of rank choice votes.
```@example plurality
satisfies(system, criterion, rankings)
```
In the case above, the plurality system satisfies the [consistency criterion](../criteria/consistency.md) because it holds in general. However, if a system does not satisify a criterion in general, it may satisfy the criterion in specific cases. 

## Count Violations
The code block below shows how to use `count_violations` to determine the number of violations of a fairness criterion a given system produces for a specific set of rank choice votes.
```@example plurality
count_violations(system, criterion, rankings)
```

## References