{:ok, contents} = File.read("input.txt")

map =
  contents
  |> String.split("\n", trim: true)
  |> Enum.map(fn line -> line |> String.graphemes() end)

defmodule LoopFinder do
  def find(map, extra_obstruction) do
    {row_index, column_index, direction} =
      map
      |> Enum.with_index()
      |> Enum.find_value(fn {row, row_index} ->
        row
        |> Enum.with_index()
        |> Enum.find_value(fn {element, column_index} ->
          if element == "^" do
            {row_index, column_index, {-1, 0}}
          end
        end)
      end)

    if {row_index, column_index} == extra_obstruction do
      {false, MapSet.new()}
    else
      find(map, {row_index, column_index, direction}, MapSet.new(), extra_obstruction)
    end
  end

  defp find(
         map,
         {row_index, column_index, direction},
         seen_locations,
         extra_obstruction
       ) do
    if Enum.member?(seen_locations, {row_index, column_index, direction}) do
      {true, seen_locations}
    else
      next_row_index = row_index + elem(direction, 0)
      next_column_index = column_index + elem(direction, 1)
      next_element = get_map_element(map, next_row_index, next_column_index)
      new_seen_locations = MapSet.put(seen_locations, {row_index, column_index, direction})

      cond do
        next_element == "#" || ({next_row_index, next_column_index} == extra_obstruction) ->
          find(
            map,
            {
              row_index,
              column_index,
              get_next_direction(direction)
            },
            new_seen_locations,
            extra_obstruction
          )

        next_element ->
          find(
            map,
            {next_row_index, next_column_index, direction},
            new_seen_locations,
            extra_obstruction
          )

        true ->
          {false, new_seen_locations}
      end
    end
  end

  defp get_next_direction(direction) do
    cond do
      direction == {-1, 0} -> {0, 1}
      direction == {0, 1} -> {1, 0}
      direction == {1, 0} -> {0, -1}
      direction == {0, -1} -> {-1, 0}
    end
  end

  defp get_map_element(map, row_index, column_index) do
    case map do
      _map when row_index < 0 ->
        nil

      _map when column_index < 0 ->
        nil

      map ->
        case Enum.at(map, row_index) do
          nil -> nil
          row -> row |> Enum.at(column_index)
        end
    end
  end
end

defmodule CountDistinctObstruction do
  def count(map) do
    {_is_loop, path_locations} = LoopFinder.find(map, {})

    paths_no_directions = Enum.map(path_locations, fn {row_index, column_index, _direction} -> {row_index, column_index} end)
    |> MapSet.new()
    Enum.count(paths_no_directions, fn location ->
      {loop, _path} = LoopFinder.find(map, location)
      loop
    end)
  end
end

IO.inspect(CountDistinctObstruction.count(map))
