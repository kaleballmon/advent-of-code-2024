# Notes on solution

## Part 1

### Assumptions
- The puzzle has an `N x M` dimension

A naive approach for solving this is to iterate through each row, column, and diagonal looking for both "XMAS" and "SAMX" and counting matches.
The row and columns are easier, the diagonal is the tricky part. A fact that can be used is that diagonals in a 2D matrix are elements who `x` and `y` 
indicies have the same difference (in the main diagonal) or sum (in the case of the anti-diagonal).

## Part 2

The approach I'm taking here is to simplu count all of the **top left corners** of the `X`s. This means that whenever I hit an `S` or an `M`,
I will stop and check the 4 corners and the center and check for 3 invariants:
- There are 2 `S`s, 2 `M`s, and 1 `A`
- The `A` is in the center
- The character opposite the top-left corner is not the same character.
