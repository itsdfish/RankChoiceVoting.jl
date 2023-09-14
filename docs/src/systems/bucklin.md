```@setup bucklin
using RankChoiceVoting
data = [[:m,:n,:c,:k],[:n,:m,:c,:k],[:c,:k,:n,:m],[:k,:c,:n,:m]]
counts = [42,26,15,17]
rankings = Ranks(counts, data)
system = Bucklin()
```
# Bucklin

In the Bucklin voting system, points are added for each candidate in an iterative manner until the point value of a candidate exceeds 50% of the number of voters. In the first round, each candidate recieves a point for each first rank preference. If the candidate with the most points does not exceed 50%, the candidates recieve a point for each second rank vote, and so forth until a candidate exceeds the 50% point threshold.  

As an example, consider the preference profile for the $n=9$ voters and candidates $C = \{a,b,c\}$:
```@example bucklin 
using RankChoiceVoting
data = [[:a,:b,:c],[:b,:a,:c],[:c,:b,:a]]
counts = [4,2,3]
rankings = Ranks(counts, data)
# system = Bucklin()
# evaluate_winner(system, rankings)
```
In the first round, the points for first preference votes are: 

- a: $4$
- b: $2$
- c: $2$  

The election proceeds to the second round because no candidates exceed the 50% threshold. The updated points for the second round are: 

- a: $6$
- b: $9$
- c: $2$  

Candidate $b$ is selected because it exceeds the 50% criterion and has the maximum points.
# Example Usage

The following examples illustrate some ways in which the Bucklin system can be used in RankChoiceVoting.jl. To begin, let's generate some synthetic rank choice votes for candidates $C = \{c,k,m,n\}$ from 100 voters. 

```@example bucklin
using RankChoiceVoting 

data = [[:m,:n,:c,:k],[:n,:m,:c,:k],[:c,:k,:n,:m],[:k,:c,:n,:m]]
counts = [42,26,15,17]
rankings = Ranks(counts, data)
```
Next, let's create objects for the `Consistency` criterion and the `Bucklin` voting system.
```@example bucklin 
criterion = Consistency()
system = Bucklin()
```

## Compute Ranking
The function `compute_ranks` is used to generate a complete rank ordering of candidates. In the case of ties, candidates will share the same rank value. 
```@example bucklin
compute_ranks(system, rankings)
```

## Evaluate Winner
We can use the function `evaluate_winner` to return the winner of the election as a vector. If multiple candidates tie for winner, the vector will contain each winning candidate.
```@example bucklin
evaluate_winner(system, rankings)
```

## Satisfies
The example below determines whether the a voting system is guaranteed to satisfy a given fairness criterion. 

```@example bucklin
satisfies(system, criterion)
```
It is also possible to check whether a system satisfies a given fairness criterion for a specific set of rank choice votes.
```@example bucklin
satisfies(system, criterion, rankings)
```
Although the Bucklin voting system does not satisfy the [consistency criterion](../criteria/consistency.md) in general, it does hold for the example above. 

## Count Violations
The code block below shows how to use `count_violations` to determine the number of violations of a fairness criterion a given system produces for a specific set of rank choice votes.
```@example bucklin
count_violations(system, criterion, rankings)
```
The count is zero because the Bucklin system satisfies the consistency criterion in this case. 
