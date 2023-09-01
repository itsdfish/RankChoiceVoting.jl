# Majority Criterion

The majority criterion requires a rank choice voting system to select a candidate who recieves more than 50% of first place ranks. 
# Usage

```@setup majority_criterion
using RankChoiceVoting
criterion = Majority()
```
The code block below illustrates how to create a `Majority` criterion object.
```@example majority_criterion
using RankChoiceVoting
criterion = Majority()
```

## Satisfies
We can see which systems are *guaranteed* to satisfy the majority criterion by calling `satisfies` with the majority criterion object. 
```@example majority_criterion
satisfies(criterion)
```

## Example
In this example, we will demonstrate that the [Borda count](../systems/borda.md) system can violate the majority criterion in some cases. The Borda count system simply scores a candidate as the inverse rank and selects the candidate with the highest score. Suppose 100 voters rank order four canidates denoted $C = \{o,p,s,t\}$ as follows:
```@example majority_criterion 
ranks = [[:s,:t,:o,:p],[:t,:p,:o,:s],[:p,:t,:o,:s],[:o,:t,:p,:s]]
counts = [51,25,10,14]
rankings = Ranks(counts, ranks)
```
The output above shows that canidate `s` recieved 51%. According to the majority criterion, a rank choice voting system should select candidate `s`. However, we can see that the Borda count violates the majority criterion in this case.
```@example majority_criterion
system = Borda()
criterion = Majority()
satisfies(system, criterion, rankings)
```
Rather than selecting candidate `s`, the code block below shows that candidate `t` is selected instead.
```@example majority_criterion
evaluate_winner(system, rankings)
```
Note that the Borda count system can satisfy the majority criterion in some cases. For example, if `t` and `s` are switched in the second unique ranking above, the Borda count system will select the majority winner:

```@example majority_criterion 
ranks = [[:s,:t,:o,:p],[:s,:p,:o,:t],[:p,:t,:o,:s],[:o,:t,:p,:s]]
counts = [51,25,10,14]
rankings = Ranks(counts, ranks)
satisfies(system, criterion, rankings)
```
## References
