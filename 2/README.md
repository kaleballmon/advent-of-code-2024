# Notes on solution

## Part 1

### Method to solve
1. For each report, iterate through each item
1. As you iterate, keep track of the last item and trend.
1. See if the trend is the same and if the item is in range.
1. Short-circuit if any invariant is not respected, store when the invariant is not repsected for a report
1. Count all reports where the invariant is respected
