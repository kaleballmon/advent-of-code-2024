# Notes on solution

## Part 1
### Assumptions
- Both lists are the same length.

### Method to solve
1. Loading both lists and sorting them in ascending order.
1. Look at the 0th through Nth item of each item in the list
1. Take the absolute value difference of each item and add to a running sum

## Part 2
### Assumptions
- Not list 1 items are in list 2

### Method to solve
1. Loading both lists
1. Turn the second list into a map where the key is the number and the value is the occurnence of that number
1. Iterate through the first list and do the math, keeping a sum of the similarity
