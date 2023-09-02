```@setup mutual_majority
using RankChoiceVoting
data = [[:a,:b,:c] for _ ∈ 1:4]
push!(data, [[:b,:c,:a] for _ ∈ 1:3]...)
push!(data, [[:c,:a,:b] for _ ∈ 1:2]...)
rankings = Ranks(data)
```Mutual Majority

According to the mutual majority criterion, states that a system must select a winning candidate from the smallest set of the $k$ highest ranked candidates whose combined support exceeds 50%. Consider the following preference profile from 6 voters:

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

```@setup mutual_majority
using RankChoiceVoting
criterion = ReversalSymmetry()
```
The code block below illustrates how to create a `MutualMajority` criterion object.
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

The following example demonstrates how to use RankChoiceVoting.jl to test whether the instant runoff voting system violates the reveral symmetry criterion in a specific example. 

Let's use RankChoiceVoting.jl to check whether mutual majority is violated in this example. 

Next, create the rankings in the first table above:

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
In agreement with the worked example above, the result is candidate `a`. In RankChoiceVoting.jl, the function `satisfies` determines whether a voting system complies with a given criterion for the provided rankings. This can be achieved with the following code:
```@example mutual_majority 
criterion = MutualMajority()
satisfies(system, criterion, rankings)
```
which yields false for this example.  

# References
