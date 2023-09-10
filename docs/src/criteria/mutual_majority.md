```@setup mutual_majority
using RankChoiceVoting
data = [[:a,:b,:c] for _ ∈ 1:4]
push!(data, [[:b,:c,:a] for _ ∈ 1:3]...)
push!(data, [[:c,:a,:b] for _ ∈ 1:2]...)
rankings = Ranks(data)
```
# Mutual Majority

Suppose there is a set of candidates $C = \{c_1,\dots, c_m\}$. According to the mutual majority criterion, a voting system must select a candidate from the smallest set $B = \{b_1, \dots, b_k\}$ of the $k \leq m$ highest ranked candidates whose combined support exceeds 50%. In other words, at least 50% of voters prefer candidates in $B$ to candidates in $C \setminus B$ and $k$ is the smallest number to satisfy this condition. As an example, consider the following preference profile from 6 voters:

```@example mutual_majority
rankings = [
    [:a, :b, :c, :d, :e],
    [:b, :a, :c, :d, :e],
    [:a, :b, :c, :e, :d],
    [:b, :a, :c, :d, :e],
    [:e, :b, :c, :d, :a],
    [:d, :a, :c, :b, :e]
]
Ranks(rankings)
```
The mutual majority set for the example above is $\{a,b\}$ because in the first four out of six rank orders, candidates $a$ and $b$ have the the highest rank orders, which exceeds 50% (i.e., $\frac{4}{6} \approx .66$).

# Usage
The following example illustrates how to evaluate the Borda count voting system with respect to the mutual majority criterion. The code block below illustrates how to create a `MutualMajority` criterion object.
```@example mutual_majority
using RankChoiceVoting
criterion = MutualMajority()
```

## Satisfies
We can see which systems are *guaranteed* to satisfy the mutual majority criterion by calling `satisfies` with the majority criterion object. 
```@example mutual_majority
satisfies(criterion)
```

## Example

Let's  check whether mutual majority is violated in a different example. In the code block below, we will define a preference profile of $n=100$ voters for $m=4$ candidates. 

```@example mutual_majority 
data = [[:s,:t,:o,:p], [:t,:p,:o,:s],[:p,:t,:o,:s],[:o,:t,:p,:s]]
counts = [51,25,10,14]

rankings = Ranks(counts, data)
```
Now, create an Borda count voting system object:

```@example mutual_majority 
system = Borda()
```

In the code block below, we can determine the winner of the election with the function `evaluate_winner` as follows:

```@example mutual_majority 
evaluate_winner(system, rankings)
```
In the next code block, we will use the function `satisifies` to determine whether the Borda count system complies with the mutual majority criterion for the preference profile above.
```@example mutual_majority 
criterion = MutualMajority()
satisfies(system, criterion, rankings)
```
which yields false for this example. To explore this result in more detail, we can use `get_majority_set` to list the candidates in the mutual majority set $B$. 

```@example mutual_majority
get_majority_set(rankings)
```
In this simple example, $B = \{s\}$, and the winning candidate $t \notin B$.
# References
