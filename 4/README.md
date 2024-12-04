# Notes on solution

## Part 1

### Assumptions
- The puzzle has an `N x M` dimension

A naive approach for solving this is to iterate through each row, column, and diagonal looking for both "XMAS" and "SAMX" and counting matches.
The row and columns are easier, the diagonal is the tricky part. A fact that can be used is that diagonals in a 2D matrix are elements who `x` and `y` 
indicies have the same difference (in the main diagonal) or sum (in the case of the anti-diagonal).
