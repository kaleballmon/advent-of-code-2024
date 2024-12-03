# Notes on solution

## Part 1
### Observations
- There are only 6 lines total in the input, the lines are just really long

### Assumptions
- None of the numbers are negative

### Method to solve
*Regex is your best friend here*

1. After loading the lines, in each line get a regex that matches the `mul(X,Y)` pattern
1. You can then strip off the beginning and end parts of the string, split by the comma and then multiply the factors
  - In a functional paradigm, this would be done by s sequence of `maps`
1. Add up all of the results of the multiplication


## Part 2

### Method to solve

This will be a very similar method to solve, except I need to also extract the do's and don'ts
and keep an enable flag when I go to sum. A `reduce` or recursion should be used instead of a straight sum
to be able to control when summing is enabled or disabled as I iterate through the list.
