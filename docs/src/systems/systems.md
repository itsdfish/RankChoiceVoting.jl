# Majority Criterion

# Example

```@setup majority_criterion
using RankChoiceVoting
```

```@example majority_criterion
using RankChoiceVoting 

rankings = [[:m,:n,:c,:k] for _ ∈ 1:42]
push!(rankings, [[:n,:m,:c,:k] for _ ∈ 1:26]...)
push!(rankings, [[:c,:k,:n,:m] for _ ∈ 1:15]...)
push!(rankings, [[:k,:c,:n,:m] for _ ∈ 1:17]...)

system = Borda(rankings)
```

## Compute Ranking


```@example majority_criterion
compute_ranks(system)
```

## Evaluate Winner

```@example majority_criterion
evaluate_winner(system)
```

## Satisfies

```@example majority_criterion
evaluate_winner(system)
```

```@example majority_criterion
evaluate_winner(system, rankings)
```

## Count Violations

```@example majority_criterion
count_violations(system)
```

## References
