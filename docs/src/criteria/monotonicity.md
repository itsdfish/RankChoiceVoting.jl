```@setup monotonicity
using RankChoiceVoting
ranks = [[:a,:b,:c],[:b,:c,:a],[:b,:a,:c],[:c,:a,:b]]
counts = [37,22,12,29]
rankings = Ranks(counts, ranks)

```
# Monotonicity
According to the monotonicity criterion, a winning candidate should not lose if some voters switch preference from a losing candidate to the winning candidate (without changing the rank order of the other candidates). We will demonstrate a violation of the monotonicity criterion with an example below using the instant runoff voting system. To begin, lets create an object for the instant runoff voting system. 

```@example monotonicity
using RankChoiceVoting
system = InstantRunOff()
```

Next, lets generate a preference profile for $n=100$ candidates:
```@example monotonicity
ranks = [[:a,:b,:c],[:b,:c,:a],[:b,:a,:c],[:c,:a,:b]]
counts = [37,22,12,29]
rankings1 = Ranks(counts, ranks)
```
The code block below uses `evaluate_winner` to determine the winner of the election.
```@example monotonicity
evaluate_winner(system, rankings1)
```
In this case, candidate $a$ won the election. Now suppose 10 voters who ranked $\{b,a,c\}$ swiched their preference betwen canidates $a$ and $b$, resulting in a new preference profile:
```@example monotonicity
ranks = [[:a,:b,:c],[:b,:c,:a],[:b,:a,:c],[:c,:a,:b]]
counts = [47,22,2,29]
rankings2 = Ranks(counts, ranks)
```
In other words, support for the winning candidate $a$ increased. After updating the preference profile, the winner is no longer $a$:
```@example monotonicity
evaluate_winner(system, rankings2)
```
Thus, motonicity was violated. Increasing support for the winning candidate resulted in a lose for the candidate who initially won with less support. 

# Usage
The following example illustrates how to evaluate the instant runoff voting system with respect to the monotonicity criterion. The code block below illustrates how to create a `Monotonicity` criterion object.
```@example monotonicity
using RankChoiceVoting
criterion = Monotonicity()
```

## Satisfies
We can see which systems are *guaranteed* to satisfy the monotonicity criterion by calling `satisfies` with the majority criterion object. 
```@example monotonicity
satisfies(criterion)
```

## Example

Let's  check whether mutual majority is violated in a different example. In the code block below, we will define a preference profile of $n=100$ voters for $m=4$ candidates. 

```@example monotonicity 
ranks = [[:a,:b,:c],[:b,:c,:a],[:b,:a,:c],[:c,:a,:b]]
counts = [37,22,12,29]
rankings = Ranks(counts, ranks)
```
Now, create an Borda count voting system object:

```@example monotonicity 
system = Borda()
```

In the code block below, we can determine the winner of the election with the function `evaluate_winner` as follows:

```@example monotonicity 
evaluate_winner(system, rankings)
```
In the next code block, we will use the function `satisifies` to determine whether the Borda count system complies with the mutual majority criterion for the preference profile above.
```@example monotonicity 
criterion = MutualMajority()
satisfies(system, criterion, rankings)
```
which yields false for this example. To explore this result in more detail, we can use `get_majority_set` to list the candidates in the mutual majority set $B$. 

```@example monotonicity
get_majority_set(rankings)
```
In this simple example, $B = \{s\}$, and the winning candidate $t \notin B$.
# References
