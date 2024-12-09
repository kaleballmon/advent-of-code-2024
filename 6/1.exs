{:ok, contents} = File.read("input.txt")

map =
  contents
  |> String.split("\n", trim: true)
  |> Enum.map(fn line -> line |> String.graphemes() end)

defmodule CountDistinctLocation do
  def count(map) do
    starting_location =
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

    get_location_set(
      map,
      starting_location,
      MapSet.new()
    )
    |> MapSet.size()
  end

  defp get_next_location_transform(location_transform) do
    cond do
      location_transform == {-1, 0} -> {0, 1}
      location_transform == {0, 1} -> {1, 0}
      location_transform == {1, 0} -> {0, -1}
      location_transform == {0, -1} -> {-1, 0}
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

  defp get_location_set(
         map,
         {row_index, column_index, location_transform},
         location_set
       ) do
    next_row_index = row_index + elem(location_transform, 0)
    next_column_index = column_index + elem(location_transform, 1)

    next_element = get_map_element(map, next_row_index, next_column_index)
    next_location_transform = get_next_location_transform(location_transform)
    new_location_set = MapSet.put(location_set, {row_index, column_index})

    cond do
      next_element == "#" ->
        get_location_set(
          map,
          {
            row_index,
            column_index,
            next_location_transform
          },
          new_location_set
        )

      next_element ->
        get_location_set(
          map,
          {next_row_index, next_column_index, location_transform},
          new_location_set
        )

      true ->
        new_location_set
    end
  end
end

IO.inspect(CountDistinctLocation.count(map))
