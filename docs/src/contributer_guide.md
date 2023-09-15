# Process

Thank you for your interest in contributing to RankChoiceVoting. If you would like to contribute, please open an issue and propose your ideas.  

# Style Guide

In most cases, code written in RankChoiceVoting.jl follows the guidelines specified in the [blue style](https://github.com/invenia/BlueStyle) guide for Julia. Please use the blue style guide or existing code as a guide, and deviate from the guides only when there is a compelling reason to do so.

# API 

The basic API is summarized below. If you add a new voting system, it should work with the fairness criteria already established. By default, voting systems are assumed to violate fairness criteria. Consequentially, functions such as `satisfies` will manually check for violations. Use `property` to specify that a system is gaurunteed to satisfy a criterion, which will bypass the violatio check. As an example, consider:

```julia 
property(::MyCoolVotingSystem, ::Majority) = Holds()
```
Also, add new types to `src/constants.jl` to ensure they are included in the evaluation of methods `satisfies(system)` and `satisfies(criteria)`.
## Types

- `systems`: a set of rules for transforming individual rank choice votes into a societal ranking
- `criteria`: fairness criteria against which a voting system is evaluated 

## Functions

The API uses the following methods:

- `compute_ranks`: transforms a set of individual rank choices into a societal ranking
- `evaluate_winner`: returns the winner(s) of an election
- `satisfies`: evaluates whether a system satisfies a given criterion
- `count_violations`: counts the number of violations of a criterion in a given set of rank choice votes


# Documentation

If you add a new fairness criterion or voting system, please provide examples based on existing examples. 

## Docstrings

At minimum, add doc strings to methods in the API. Adding docstrings for internal methods is encouraged. Please use the following template for docstrings:
```julia 
"""
    satisfies(system::VotingSystem, criterion::Majority, rankings::Ranks; _...)

Tests whether a voting system satisfies the majority criterion.

# Arguments

- `system::VotingSystem`: a voting system object
- `criterion::Majority`: majority criterion object 
- `rankings::Ranks`: a rank choice voting object consisting of rank counts and unique ranks 
"""
```
Add any additional information that might be relevant to the user. 

# API

Only export (make public) types and methods that are intended for users. Other methods are implementational details for interal use. 

# Unit tests

Provide unit tests for most (if not all) methods. When possible, programatically test a method over a wide range of inputs. If you find a bug, write a unit test for the bug to prevent regressions. When possible, compare methods to those defined in established and trusted packages in other languages.  
