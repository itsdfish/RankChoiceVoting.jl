```@setup consistency
using RankChoiceVoting
using Random
Random.seed!(3)
data = [[:a,:b,:c],[:b,:c,:a],[:c,:a,:b]]
counts = [8,8,12]
rankings = Ranks(counts, data)

```
# Consistency
The consistency criterion states that if a preference profile is split into disjoint subsets and a voting system selects the same candidate for both subsets, it must also select the same candidate when applied to the combined set. 

Below, we will illustrate how the plurality method can violate the Consistency criterion. Consider the preference profile of $n=10$ voters for candidates $C = \{a,b,c\}$. 

```@example consistency
using RankChoiceVoting
system = InstantRunOff()
data = [[:a,:b,:c],[:b,:c,:a],[:c,:a,:b]]
counts = [8,8,12]
rankings = Ranks(counts, data)
```
The plurality method selects candidate $a$ because $a$ has the most first rank preferences. Now let's see how candidate $a$ performs in head-to-head compititions between canidates $b$ and $c$. In a head-to-head competition, candidate $a$ loses to candidate $b$:
- a vs. b: 4 
- b vs. a: 6
In a head-to-head competition,candidate $a$ also loses to candidate $c$:

- a vs c: 4
- c vs a: 6
Candidate $a$, who was selected by the plurality method, is a Condorcet loser because $a$ lost each head-to-head competition. 


# Usage
The following examples illustrate various uses of the Consistency criterion. 

## Satisfies
We can see which systems are *guaranteed* to satisfy the Consistency criterion by calling `satisfies` with the majority criterion object. 
```@example consistency
using RankChoiceVoting
criterion = Consistency()
satisfies(criterion)
```

## Example

In the next example, we will illustrate how to check whether the Bucklin system violates the Consistency criterion for a specific preference profile. Consider the following preference profile of $n=100$ voters for $m=4$ candidates. 

```@example consistency 
ranks = [[:a,:b,:c],[:b,:c,:a],[:b,:a,:c],[:c,:a,:b]]
counts = [37,22,12,29]
rankings = Ranks(counts, ranks)
```
Now, create an Bucklin voting system object:

```@example consistency 
system = Bucklin()
```

In the code block below, we can determine the winner of the election with the function `evaluate_winner` as follows:

```@example consistency 
evaluate_winner(system, rankings)
```
In the next code block, we will use the function `satisifies` to determine whether the Bucklin system complies with the Consistency criterion for the preference profile above.
```@example consistency 
criterion = Consistency()
satisfies(system, criterion, rankings)
```
Although the Bucklin system does not satisfy the Consistency criterion in general, it does satisfy it in this specific example.