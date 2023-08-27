!!! warning 
    Work in progress

# Overview

This package provides a framework for simulating and evaluating rank choice voting systems. Rank choice voting systems allow voters to order candidates according to preference rather than providing a single selection of the most preferred candidate. Each rank choice voting system specifies a rule for aggregating individual rankings into a societial ranking from which a winner is selected. Importantly, the rules can provide different election outcomes. 

Interestingly, Arrow's impossibility theorem demonstrates that it is impossible to design a rank choice voting system that can satisfy a set of fairness criteria in all possible elections. What this means is that every rank choice voting system is flawed to some degree, and may lead to undesirable behavior in some situations. Although insightful, many interesting questions remain unanswered by Arrow's impossibility theorem. For example, how prevalent are violations of fairness critera, and under what conditions are they violated? This package is designed to help answer questions of this nature.

# Installation

In the REPL, type `]` to enter package mode and type

```julia 
add https://github.com/itsdfish/RankChoiceVoting.jl
```
to add RankChoiceVoting.jl to your environment.

# Quick Example
In this quick example, we will plot the histogram for the Racing Diffusion Model (RDM). Note that you will need to install SequentialSamplingModels in order for the example to work.

```@example 
using RankChoiceVoting

rankings = [[:m,:n,:c,:k] for _ ∈ 1:42]
push!(rankings, [[:n,:m,:c,:k] for _ ∈ 1:26]...)
push!(rankings, [[:c,:k,:n,:m] for _ ∈ 1:15]...)
push!(rankings, [[:k,:c,:n,:m] for _ ∈ 1:17]...)

system = Borda(rankings)

evaluate_winner(system)
```
