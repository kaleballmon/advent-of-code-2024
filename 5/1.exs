defmodule FilterGoodUpdates do
  def filter(rules_map, updates) do
    Enum.filter(updates, fn update -> is_good_update(rules_map, update, []) end)
  end

  defp is_good_update(rules_map, [head | tail], before) do
    if MapSet.disjoint?(MapSet.new(Map.get(rules_map, head, [])), MapSet.new(before)) do
      is_good_update(rules_map, tail, [head | before])
    else
      false
    end
  end

  defp is_good_update(_rules_map, [], _before), do: true
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

answer = FilterGoodUpdates.filter(rules_map, updates)
|> Enum.map(fn list -> String.to_integer(Enum.at(list, div(length(list), 2))) end)
|> Enum.sum()

IO.inspect(answer)
