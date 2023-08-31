
The following example demonstrates how to use RankChoiceVoting.jl to test whether the instant runoff voting system violates the reveral symmetry criterion in a specific example. An instant runoff voting system iteratively eliminates the candidate with the minimum first preferences until one canidate reaches 50% first preferences. According to the reversal systemetry criterion, a winner of an election cannot win if each voter's ranks are reversed.  

Consider a hypothetical rank choice tally in the table below taken from lô (2014). 

| Counts | 4 | 3 | 2 |
|--------|---|---|---|
| First  | a | b | c |
| Second | b | c | a |
| Third  | c | a | b |

In the fist iteration, leading candidate `a` does not have a majority first preference (i.e., 4/9 < .50). In the next, round candidate c is eliminated, yielding

| Counts | 4 | 3 | 2 |
|--------|---|---|---|
| First  | a | b | a |
| Second | b | a | b |

which means candidate `a` now has a majority first preference: 6/9 > .50. 

Let's use RankChoiceVoting.jl to check whether reversal symmetry is violated in this example. 

First, load RankChoiceVoting into your session:

```julia
using RankChoiceVoting
```

Next, create the rankings in the first table above:

```julia
rankings = Vector{Vector{Symbol}}()
push!(rankings, [[:a,:b,:c] for _ ∈ 1:4]...)
push!(rankings, [[:b,:c,:a] for _ ∈ 1:3]...)
push!(rankings, [[:c,:a,:b] for _ ∈ 1:2]...)
```
Now, create an instant runoff voting system object:

```julia
system = InstantRunOff(rankings)
```

The winner of the election under an instant runoff voting system can be determined with the function 
`evaluate_winner` as follows:

```julia
evaluate_winner(system)
```
In agreement with the worked example above, the result is candidate `a`. In RankChoiceVoting.jl, the function `satisfies` determines whether a voting system complies with a given criterion for the provided rankings. This can be achieved with the following code:
```julia 
criteria = ReversalSymmetry()
violations = satisfies(system, criteria)
```
which yields true for this example.  
## Counting Violations

The function `count_violations` will count the number of violations of a fairness criterion in a set of ranked choice votes under a specified voting system. Depending on the fairness criterion, the maximum number of violations can be greater than 1. 

# References

lô Gueye, A. (2014). Failures of reversal symmetry under two common voting rules. Economics Bulletin, 34(3), 1970-1975.