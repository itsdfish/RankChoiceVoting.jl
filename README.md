# RankChoiceVoting.jl
[![](docs/logo/logo.png)](https://itsdfish.github.io/RankChoiceVoting.jl/dev/)
[![](https://img.shields.io/badge/docs-latest-blue.svg)](https://itsdfish.github.io/RankChoiceVoting.jl/dev/) [![CI](https://github.com/itsdfish/RankChoiceVoting.jl/actions/workflows/CI.yml/badge.svg)](https://github.com/itsdfish/RankChoiceVoting.jl/actions/workflows/CI.yml)

This package provides a framework for simulating and evaluating rank choice voting systems. See the [documentation](https://itsdfish.github.io/RankChoiceVoting.jl/dev/) for details. 

# Quick Example

The code block below provides an example in which the instant runoff voting system violates the
[monotonicity criterion](https://electionscience.org/library/monotonicity). First, load the package and generate some rank choice votes.
```julia
using RankChoiceVoting 
ranks = [[:a,:b,:c],[:b,:c,:a],[:b,:a,:c],[:c,:a,:b]]
counts = [37,22,12,29] 
rankings = Ranks(counts, ranks)
```

``` 
counts      ranks
37          [:a, :b, :c]
22          [:b, :c, :a]
12          [:b, :a, :c]
29          [:c, :a, :b]
```
Next, create an object for an instant runoff system and the monotonicity criterion.
```julia
system = InstantRunOff()
criterion = Monotonicity()
```
Now we can use the function `satisfies` to determine whether the instant runoff system violates monotonicty in the provided rank choice votes.
```julia
satisfies(system, criterion, rankings)
```
```
false
```
See the [documentation](https://itsdfish.github.io/RankChoiceVoting.jl/dev/) for more information and examples. 