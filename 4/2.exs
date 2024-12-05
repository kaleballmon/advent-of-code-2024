{:ok, contents} = File.read("input.txt")

defmodule FindX_MAS do
  def find_x_mas(puzzle_graphemes) do
    Enum.with_index(
      puzzle_graphemes,
      fn line, row_index -> Enum.with_index(line, fn item, column_index ->
        if item == "S" || item == "M" do
          is_x_mas(puzzle_graphemes, row_index, column_index)
        else
          false
        end
      end)
    end)
  end

  defp is_x_mas(puzzle_graphemes, row_index, column_index) do
    top_row = Enum.at(puzzle_graphemes, row_index)
    center_row = Enum.at(puzzle_graphemes, row_index + 1)
    bottom_row = Enum.at(puzzle_graphemes, row_index + 2)

    top_left = Enum.at(top_row, column_index)
    top_right = Enum.at(top_row, column_index + 2)
    center = if center_row, do: Enum.at(center_row, column_index + 1), else: nil
    bottom_left = if bottom_row, do: Enum.at(bottom_row, column_index), else: nil
    bottom_right = if bottom_row, do: Enum.at(bottom_row, column_index + 2), else: nil

    the_x = [
      top_left,
      top_right,
      center,
      bottom_left,
      bottom_right,
    ]

    occurences_map = Enum.reduce(the_x, %{}, fn item, acc ->
      Map.update(acc, item, 1, &(&1 + 1))
    end)
    (occurences_map == %{"M" => 2, "A" => 1, "S" => 2}) && center == "A" && top_left != bottom_right
  end
end


puzzle_graphemes = String.split(contents, "\n", trim: true)
 |> Enum.map(fn line -> String.graphemes(line)
end)


IO.inspect(FindX_MAS.find_x_mas(puzzle_graphemes) |> List.flatten() |> Enum.count(fn item -> item end))
