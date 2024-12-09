{:ok, contents} = File.read("input.txt")

defmodule GetAntinodes do
  def get(frequency_locations, max_row_index, max_column_index) do
    Enum.reduce(frequency_locations, MapSet.new(), fn {_frequency, locations}, acc ->
      get(locations, acc)
    end)
    |> Enum.filter(fn {row_index, column_index} ->
      row_index >= 0 && row_index <= max_row_index && column_index >= 0 &&
        column_index <= max_column_index
    end)
    |> length()
  end

  defp get([head | tail], acc) do
    get(
      tail,
      Enum.reduce(tail, acc, fn element, acc ->
        MapSet.union(acc, antennas(head, element))
      end)
    )
  end

  defp get([], acc), do: acc

  defp is_ascending({row_1, col_1}, {row_2, col_2}) do
    if(
      (row_1 > row_2 && col_1 < col_2) ||
        (row_1 < row_2 && col_1 > col_2)
    ) do
      true
    else
      false
    end
  end

  defp antennas({row_1, col_1}, {row_2, col_2}) do
    rise = abs(row_1 - row_2)
    run = abs(col_1 - col_2)

    if is_ascending({row_1, col_1}, {row_2, col_2}) do
      MapSet.new([
        {max(row_1, row_2) + rise, min(col_1, col_2) - run},
        {min(row_1, row_2) - rise, max(col_1, col_2) + run}
      ])
    else
      MapSet.new([
        {min(row_1, row_2) - rise, min(col_1, col_2) - run},
        {max(row_1, row_2) + rise, max(col_1, col_2) + run}
      ])
    end
  end
end

map =
  contents
  |> String.split("\n", trim: true)
  |> Enum.map(fn line -> line |> String.graphemes() end)

frequency_locations =
  Enum.with_index(map)
  |> Enum.reduce(%{}, fn {row, row_index}, acc ->
    row
    |> Enum.with_index()
    |> Enum.reduce(acc, fn {element, column_index}, acc ->
      if element == "." do
        acc
      else
        Map.update(acc, element, [{row_index, column_index}], fn indices ->
          [{row_index, column_index} | indices]
        end)
      end
    end)
  end)

IO.inspect(GetAntinodes.get(frequency_locations, length(map) - 1, length(Enum.at(map, 0)) - 1))
