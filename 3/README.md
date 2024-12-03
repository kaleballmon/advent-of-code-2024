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
