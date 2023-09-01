```@setup reversal_symmetry
using RankChoiceVoting
data = [[:a,:b,:c] for _ ∈ 1:4]
push!(data, [[:b,:c,:a] for _ ∈ 1:3]...)
push!(data, [[:c,:a,:b] for _ ∈ 1:2]...)
rankings = Ranks(data)
```
# Reversal Symmetry

According to the reversal symmetry criterion,  if a rank choice voting system selects candidate `c` as a winner, it cannot select `c` as a winner after reverse ranking the votes.  
# Usage

```@setup reversal_symmetry
using RankChoiceVoting
criterion = ReversalSymmetry()
```
The code block below illustrates how to create a `Majority` criterion object.
```@example reversal_symmetry
using RankChoiceVoting
criterion = ReversalSymmetry()
```

## Satisfies
We can see which systems are *guaranteed* to satisfy the reversal symmetry criterion by calling `satisfies` with the majority criterion object. 
```@example reversal_symmetry
satisfies(criterion)
```

## Example

The following example demonstrates how to use RankChoiceVoting.jl to test whether the instant runoff voting system violates the reveral symmetry criterion in a specific example. 

Let's use RankChoiceVoting.jl to check whether reversal symmetry is violated in this example. 

Next, create the rankings in the first table above:

```@example reversal_symmetry 
ranks = [[:a,:b,:c],[:b,:c,:a],[:c,:a,:b]]
counts = [4,3,2]
rankings = Ranks(counts, ranks)
```
Now, create an instant runoff voting system object:

```@example reversal_symmetry 
system = InstantRunOff()
```

The winner of the election under an instant runoff voting system can be determined with the function 
`evaluate_winner` as follows:

```@example reversal_symmetry 
evaluate_winner(system, rankings)
```
In agreement with the worked example above, the result is candidate `a`. In RankChoiceVoting.jl, the function `satisfies` determines whether a voting system complies with a given criterion for the provided rankings. This can be achieved with the following code:
```@example reversal_symmetry 
criterion = ReversalSymmetry()
violations = satisfies(system, criterion, rankings)
```
which yields true for this example.  

# References

lô Gueye, A. (2014). Failures of reversal symmetry under two common voting rules. Economics Bulletin, 34(3), 1970-1975.