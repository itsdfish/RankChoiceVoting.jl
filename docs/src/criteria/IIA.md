```@setup IIA
using RankChoiceVoting
using Random
Random.seed!(34)
data = [[:a,:b,:c],[:b,:c,:a],[:b,:a,:c],[:c,:a,:b]]
counts = [37,22,12,29]
rankings = Ranks(counts, data)

```
# Independence of Irrelevant Alternatives
According to the independence of irrelevant alternatives (IIA) criterion, the winner of an election should not depend on the presence or absence of less prefered candidates. Although there are several variations in the implimentation of IIA, RankChoiceVoting.jl tests for violations of IIA by removing subsets of lossing candidates. 

Below, we will illustrate how the instant runoff system can violate the IIA criterion. Consider the preference profile of $n=100$ voters for candidates $C = \{a,b,c\}$. As the code block below shows, canidate $a$ is the winner.

```@example IIA
using RankChoiceVoting
system = InstantRunOff()
data = [[:a,:b,:c],[:b,:c,:a],[:b,:a,:c],[:c,:a,:b]]
counts = [37,22,12,29]
rankings = Ranks(counts, data)
evaluate_winner(system, rankings)
```
However, when $b$ is eliminated, $c$ is now the winner. 
```@example IIA
system = InstantRunOff()
data = [[:a,:c],[:c,:a]]
counts = [49,51]
rankings = Ranks(counts, data)
evaluate_winner(system, rankings)
```


# Usage
The following examples illustrate various uses of the I criterion. 

## Satisfies
We can see which systems are *guaranteed* to satisfy the IIA criterion by calling `satisfies` with the independence of irrelevant alternatives criterion object. 
```@example IIA
using RankChoiceVoting
criterion = IIA()
satisfies(criterion)
```
The results above show that none of the supported rank choice voting systems in the package are guaranteed to satisfy IIA. 
## Example

In the next example, we will illustrate how to check whether the Bucklin system violates the IIA criterion for a specific preference profile. Consider the following preference profile of $n=100$ voters for $m=3$ candidates. 

```@example IIA 
ranks = [[:a,:b,:c],[:b,:c,:a],[:b,:a,:c],[:c,:a,:b]]
counts = [37,22,12,29]
rankings = Ranks(counts, ranks)
```
Now, create an Bucklin voting system object:

```@example IIA 
system = Bucklin()
```

In the code block below, we can determine the winner of the election with the function `evaluate_winner` as follows:

```@example IIA 
evaluate_winner(system, rankings)
```
In the next code block, we will use the function `satisifies` to determine whether the Bucklin system complies with the IIA criterion for the preference profile above.
```@example IIA 
criterion = IIA()
satisfies(system, criterion, rankings)
```
The results indicate that the Bucklin voting system violates IIA for this preference profile. 