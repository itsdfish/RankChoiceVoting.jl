```@setup spatial_model
using LinearAlgebra
using Plots
using RankChoiceVoting
using Random
using StatsBase
```

# Spatial Model Example

The following example illustrates how to generate simulated preference profiles from a spatial model and evaluate whether the Borda count voting system satisfies independence of irrelevant alternatives (IIA). A spatial model describes the beliefs of voters as points in an n-dimensional space where each dimension represents a belief about a policy or value. Candidates are represented as points in the n-dimensional space. The model assumes voters rank order candidates as an increasing function of distance, where the minimum distance is ranked 1, the second shortest distances is ranked 2 and so forth. 

## Load Dependencies

The first step is to load the required dependencies.
```@example spatial_model
using LinearAlgebra
using Plots
using RankChoiceVoting
using Random
using StatsBase
Random.seed!(54)
```
## Define Helper Functions

In the code block below, we define two helper functions. The function `rank_candidates` computes the distance between a voter and the candidatess and returns a rank ordering based on distance. The function `select` returns the index associated with the most preferred candidate. 

```@example spatial_model
function rank_candidates(beliefs, candidates)
    return competerank(map(c -> norm(beliefs .- c), candidates))
end

function select(beliefs, candidates)
    _,choice = findmin(rank_candidates(beliefs, candidates))
    return choice
end
```
## Define Candidates

Lets assume the belief space defined over $[0,1]^2$ and the candidates occupy the following positions in that space.
```@example spatial_model
candidates = [(.3,.3), (.3,.5),(.8,.5)]
```
The plot below illustrates the area of the belief space to which the canidates appeal. For example, voters in the top left quadrant will vote for candidate 2.
```@example spatial_model
points = [Tuple(rand(2)) for _ ∈ 1:10_000]
first_choices = map(x -> select(x, candidates), points)
scatter(points, lims=(0,1), grid=false, legendtitle="candidates", group=first_choices,  legend=:outerright)
```

## Define Voters
Next, we will define a set of 100 voters by sampling uniformly over $[0,1]^2$:
```@example spatial_model
voters = [Tuple(rand(2)) for _ ∈ 1:100]
votes = map(v -> rank_candidates(v, candidates), voters)
ranks = Ranks(votes)
```

# Evaluate  
The last code blocks tests whether the Borda count system satisisfies IIA for the simulated preference profile.

```@example spatial_model
satisfies(Borda(), IIA(), ranks)
```

In this case, it does satisfy IIA. Does hold in general? Let's call `satisfies` without the preference profile to answer that question. 

```@example spatial_model
satisfies(Borda(), IIA())
```

The result above indicates that there are some cases in which the Borda count system violates IIA.