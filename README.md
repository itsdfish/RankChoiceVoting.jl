# RankChoiceVoting.jl (Work in progress)

This package provides a framework for simulating and evaluating rank choice voting systems. A rank choice voting system 


# API

## Voting Systems

All voting systems are a subtype of an abstract type called `VotingSystem`. Each voting system has a minimum of two fields: a vector of unique rankings, and the corresponding counts. The following example is for the instant runoff voting system:

```julia
mutable struct InstantRunOff{T,I<:Integer} <: VotingSystem
    uranks::Vector{T}
    counts::Vector{I}
end
```

## Criteria

Researchers and public policy makers are interested in whether rank choice voting systems provide "reasonable" results. To achieve this goal, rank choice voting systems are evaluated against well-defined criteria, such as the condorcet criterion, monotonicity, and independence of irrelvant alternatives. In RankChoiceVoting.jl, all criteria are a subtype of an abstract type called `Criteria`. Here is an example using reversal symmetry

```julia
mutable struct ReversalSymmetry <: Criteria

end
```

Fields are not required by default, but can be added to new types as needed. 

## Evaluting a Winner

## Counting Violations



### Example: a violation of reversal symmetry

The following example demonstrates how to use RankChoiceVoting.jl to test whether the instant runoff voting system violates the reveral symmetry criterion in a specific example. Consider a hypothetical rank choice tally in the table below taken from lô (2014). 

| Counts | 4 | 3 | 2 |
|--------|---|---|---|
| First  | a | b | c |
| Second | b | c | a |
| Third  | c | a | b |

The rankings can be produced with the following code:

```julia
rankings = Vector{Vector{Symbol}}()
push!(rankings, [[:a,:b,:c] for _ ∈ 1:4]...)
push!(rankings, [[:b,:c,:a] for _ ∈ 1:3]...)
push!(rankings, [[:c,:a,:b] for _ ∈ 1:2]...)
```
Next, create an instant runoff voting system object:

```julia
system = InstantRunOff(rankings)
```

The winner of the election under an instant runoff voting system can be determined with the function 
`evaluate_winner` as follows:

```julia
evaluate_winner(system)
```
The result is candidate `a`. According to the reversal symmetry criterion, the same candidate should not win if the order of each voter's ranking is reversed. In RankChoiceVoting.jl, you can count the number of volations using the function `count_violations`:
```julia 
criteria = ReversalSymmetry()
violations = count_violations(system, criteria)
```
For reversal symmetry, the maximum number of violations is 1 (there is only one way to reverse the rank ordering for each person). There might be multiple ways to violate other criteria.  
# References

lô Gueye, A. (2014). Failures of reversal symmetry under two common voting rules. Economics Bulletin, 34(3), 1970-1975.