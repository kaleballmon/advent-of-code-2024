{:ok, contents} = File.read("input.txt")

defmodule Diagonals do
  def get_main_diagonals(puzzle_graphemes) do
    num_rows = length(puzzle_graphemes)
    num_columns = length(List.first(puzzle_graphemes))
    highest_row_index = num_rows - 1
    highest_column_index = num_columns - 1

    index_diff_range = -highest_column_index..highest_row_index

    Enum.map(Enum.to_list(index_diff_range), fn diff ->
      get_main_diagonals(puzzle_graphemes, diff)
    end)
    |> Enum.map(fn row -> Enum.join(row) end)
  end

  defp get_main_diagonals(puzzle_graphemes, diff) do
    # The main diagonals in a 2D matrix are elements with the same difference
    # between their row and column indexes
    for {row, row_index} <- Enum.with_index(puzzle_graphemes),
        {item, col_index} <- Enum.with_index(row),
        row_index - col_index == diff,
        do: item
  end

  def get_anti_diagonals(puzzle_graphemes) do
    num_rows = length(puzzle_graphemes)
    num_columns = length(List.first(puzzle_graphemes))
    highest_row_index = num_rows - 1
    highest_column_index = num_columns - 1

    index_sum_range = 0..(highest_row_index + highest_column_index)

    Enum.map(Enum.to_list(index_sum_range), fn index_sum ->
      get_anti_diagonals(puzzle_graphemes, index_sum)
    end)
    |> Enum.map(fn row -> Enum.join(row) end)
  end

  defp get_anti_diagonals(puzzle_graphemes, diff) do
    # The anti-diagonals in a 2D matrix are elements with the same sum
    # between their row and column indexes
    for {row, row_index} <- Enum.with_index(puzzle_graphemes),
        {item, col_index} <- Enum.with_index(row),
        row_index + col_index == diff,
        do: item
  end
end

puzzle_lines_left_to_right = String.split(contents, "\n", trim: true)

puzzle_graphemes = Enum.map(puzzle_lines_left_to_right, fn line -> String.graphemes(line) end)

puzzle_lines_top_to_bottom =
  Enum.map(
    Enum.to_list(0..(length(List.first(puzzle_graphemes)) - 1)),
    fn n -> Enum.map(puzzle_graphemes, fn row -> Enum.at(row, n) end) end
  )
  |> Enum.map(fn row -> Enum.join(row) end)

puzzle_lines_main_diagonal = Diagonals.get_main_diagonals(puzzle_graphemes)

puzzle_lines_anti_diagonal = Diagonals.get_anti_diagonals(puzzle_graphemes)

count_xmas = fn lines ->
  Enum.map(
    lines,
    # This regex logic is a bit complicated. We have to use a lookahead to make sure we are getting overlapping words
    # but an empty string capturing group is added to the beginning of the scan so we have to remove that for an
    # accurate count
    fn line -> Regex.scan(~r/(?=(XMAS|SAMX))/, line) |> Enum.map(fn [_, group] -> group end) end
  )
  |> List.flatten()
  |> length()
end

total =
  (puzzle_lines_left_to_right |> count_xmas.()) + (puzzle_lines_top_to_bottom |> count_xmas.()) +
    (puzzle_lines_main_diagonal |> count_xmas.()) + (puzzle_lines_anti_diagonal |> count_xmas.())

IO.puts(total)
