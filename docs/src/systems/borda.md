# Majority Criterion

# Example

```@setup majority_criterion
using RankChoiceVoting
data = [[:m,:n,:c,:k] for _ ∈ 1:42]
push!(data, [[:n,:m,:c,:k] for _ ∈ 1:26]...)
push!(data, [[:c,:k,:n,:m] for _ ∈ 1:15]...)
push!(data, [[:k,:c,:n,:m] for _ ∈ 1:17]...)
rankings = Ranks(data)
system = Borda()
```

```@example majority_criterion
using RankChoiceVoting 

data = [[:m,:n,:c,:k] for _ ∈ 1:42]
push!(data, [[:n,:m,:c,:k] for _ ∈ 1:26]...)
push!(data, [[:c,:k,:n,:m] for _ ∈ 1:15]...)
push!(data, [[:k,:c,:n,:m] for _ ∈ 1:17]...)
rankings = Ranks(data)
criterion = Consistency()

system = Borda()
```

## Compute Ranking


```@example majority_criterion
compute_ranks(system, rankings)
```

## Evaluate Winner

```@example majority_criterion
evaluate_winner(system, rankings)
```

## Satisfies

```@example majority_criterion
satisfies(system, criterion, rankings)
```

```@example majority_criterion
satisfies(system, criterion)
```

## Count Violations

```@example majority_criterion
count_violations(system, criterion, rankings)
```

## References
 