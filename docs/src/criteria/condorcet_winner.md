```@setup condorcet_winner
using RankChoiceVoting
ranks = [[:a,:b,:c],[:b,:c,:a],[:b,:a,:c],[:c,:a,:b]]
counts = [37,22,12,29]
rankings = Ranks(counts, ranks)

```
# Condorcet winner
In a head-to-head competition, let $d(x,y)$ be a function which counts the number of voters who perfer $x$ to $y$. Candidate x wins the head-to-head competition if $d(x,y) > d(y,x)$. According to the Condorcet winner criterion, a voting system should  select a candidate who wins all head-to-head competitions. 

Below, we will illustrate how the plurality method can violate the Condorcet winner criterion. Consider the preference profile of $n=10$ voters for candidates $C = \{a,b,c\}$. 

```@example condorcet_winner
using RankChoiceVoting
system = Plurality()
data = [[:a,:b,:c],[:c,:a,:b],[:b,:a,:c]]
counts = [3,3,4]
rankings = Ranks(counts, data)
```
The plurality method selects candidate $c$ because $c$ has the most first rank preferences. However, candidate $a$ is the Condocet winner. In a head-to-head competition, candidate $a$ defeats candidate $b$:
- a vs. b: 6 
- b vs. a: 4
In a head-to-head competition,candidate $a$ also defeats candidate $c$:
- a vs c: 6
- c vs a: 4
The Condorcet winner criterion is not satisfied in the example above: candidate $a$ is the Condorcet winner, but the plurality method selected candidate $c$. 


# Usage
The following examples illustrate various uses of the Condorcet winner criterion. 

## Satisfies
We can see which systems are *guaranteed* to satisfy the Condorcet winner criterion by calling `satisfies` with the majority criterion object. 
```@example condorcet_winner
using RankChoiceVoting
criterion = CondorcetWinner()
satisfies(criterion)
```

## Example

In the next example, we will illustrate how to check whether the Bucklin system violates the Condorcet winner criterion for a specific preference profile. Consider the following preference profile of $n=100$ voters for $m=4$ candidates. 

```@example condorcet_winner 
ranks = [[:a,:b,:c],[:b,:c,:a],[:b,:a,:c],[:c,:a,:b]]
counts = [37,22,12,29]
rankings = Ranks(counts, ranks)
```
Now, create an Bucklin voting system object:

```@example condorcet_winner 
system = Bucklin()
```

In the code block below, we can determine the winner of the election with the function `evaluate_winner` as follows:

```@example condorcet_winner 
evaluate_winner(system, rankings)
```
In the next code block, we will use the function `satisifies` to determine whether the Bucklin system complies with the Condorcet winner criterion for the preference profile above.
```@example condorcet_winner 
criterion = CondorcetWinner()
satisfies(system, criterion, rankings)
```
Although the Bucklin system does not satisfy the Condorcet winner criterion in general, it does satisfy it in this specific example.
# References
