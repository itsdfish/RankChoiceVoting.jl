# Voting Data
```@setup ranks 
using RankChoiceVoting
data = [[:a,:b,:c],[:a,:c,:b],[:a,:c,:b],[:b,:a,:c]]
```

Rank choice voting data is compressed and stored efficiently in a object type called `Ranks`, which has two fields:

- `uranks`: a vector of unique rank choice vectors
- `counts`: a vector of counts corresponding to the number of votes for each unique rank choice vector

Below, we provide two examples for converting rank choice data into the appropriate format for a `Ranks` data object.
## Example 1

In this first example, the rank choice votes of each individual is contained in a vector. All of the individual vectors are wrapped in a larger vector. Here is a simple case using four hypothetical individuals:
```@example ranks 
using RankChoiceVoting
data = [[:a,:b,:c],[:a,:c,:b],[:a,:c,:b],[:b,:a,:c]]
```
The output above shows that the first and fourth individuals have unique rank choices, whereas the second and third individuals have the same rank choices. We can pass the `data` vector to the `Ranks` construct to create a more efficent data representation: 

```@example ranks
rankings = Ranks(data)
```

## Example 2
Unlike the example above, where ranks for each individual was provided, this second example shows how construct a `Rank` data object from pre-processed data. The code block shows the pre-processed data as a unique vector of ranks, `unique_ranks`, and the associated counts in a vector called `counts`.
```@example ranks 
using RankChoiceVoting 
unique_ranks = [[:a,:b,:c],[:a,:c,:b],[:b,:a,:c]]
counts = [1,2,1]
rankings = Ranks(counts, unique_ranks)
```