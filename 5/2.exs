defmodule FilterBadUpdates do
  def filter(rules_map, updates) do
    Enum.filter(updates, fn update -> is_bad_update(rules_map, update, []) end)
  end

  defp is_bad_update(rules_map, [head | tail], before) do
    if MapSet.disjoint?(MapSet.new(Map.get(rules_map, head, [])), MapSet.new(before)) do
      is_bad_update(rules_map, tail, [head | before])
    else
      true
    end
  end

  defp is_bad_update(_rules_map, [], _before), do: false
end

{:ok, raw_rules} = File.read("rules.txt")
{:ok, raw_updates} = File.read("updates.txt")

rules_map =
  String.split(raw_rules, "\n", trim: true)
  |> Enum.map(fn raw_rule -> String.split(raw_rule, "|", trim: true) end)
  |> Enum.reduce(%{}, fn [left_update_number, right_update_number], acc ->
    Map.update(acc, left_update_number, [right_update_number], fn existing_list ->
      [right_update_number | existing_list]
    end)
  end)

updates =
  String.split(raw_updates, "\n", trim: true)
  |> Enum.map(fn raw_update -> String.split(raw_update, ",", trim: true) end)

total =
  FilterBadUpdates.filter(rules_map, updates)
  |> Enum.map(fn update ->
    Enum.with_index(update)
    |> Enum.reduce(%{}, fn {update_number, index}, acc -> Map.put(acc, index, update_number) end)
  end)
  |> Enum.map(fn update_map ->
    # Iterate through each item in the map by index and fix the order up to that index
    Enum.reduce(0..map_size(update_map), update_map, fn index, acc ->
      Enum.reduce(0..index, acc, fn sub_index, sub_acc ->
        current_element = Map.get(sub_acc, index)
        current_checking_element = Map.get(sub_acc, sub_index)
        current_element_rules = Map.get(rules_map, current_element)

        if current_element_rules && Enum.member?(current_element_rules, current_checking_element) do
          Map.replace(sub_acc, sub_index, current_element)
          |> Map.replace(index, current_checking_element)
        else
          sub_acc
        end
      end)
    end)
  end)
  |> Enum.map(fn update_map ->
    String.to_integer(Map.get(update_map, div(map_size(update_map), 2)))
  end)
  |> Enum.sum()

IO.inspect(total)
