# Part 1

To solve this, I'm first going to take the liberty to separate the rules and the updates
into different files for loading in my program.

I'll create a map where the keys are the update numbers and the values are a list
of all the update numbers that the update number **must** be before.

For each update, I will iterate through each item of the update, keeping track of the update
numbers that have already been seen. If any of the numbers seen before are in the list of update
numbers that the current update must be before, then we know that the update is invalid. If we make it
to the end then the update is valid.

Since we are looking for the sum of the center numbers here, it would make sense to use a `filter`
on the update list first to filter out the good updates and then iterate through the good updates
again and sum the middle numbers.

## Observations on the input
- The count of update numbers in an update is **not** consistent across updates

## Assumptions
- The count of update numbers in an update will be **odd**, since there  must be an exact center