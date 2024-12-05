{:ok, contents} = File.read("input.txt")

lines = String.split(contents, "\n", trim: true)

# Split the lines into separate lists
{list1, list2} =
  Enum.reduce(lines, {[], []}, fn line, {list1, list2} ->
    [first_item, second_item] = String.split(line, " ", trim: true)
    {first_item_integer, _} = Integer.parse(first_item)
    {second_item_integer, _} = Integer.parse(second_item)
    {[first_item_integer | list1], [second_item_integer | list2]}
  end)

# Sort the lists
sorted_list1 = Enum.sort(list1)
sorted_list2 = Enum.sort(list2)

# Calculate the total distance
total_distance =
  Enum.zip(sorted_list1, sorted_list2)
  |> Enum.reduce(0, fn {item1, item2}, acc ->
    acc + abs(item1 - item2)
  end)

IO.puts(total_distance)
