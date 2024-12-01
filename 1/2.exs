{:ok, contents} = File.read("input.txt")

lines = String.split(contents, "\n", trim: true)

# Split the lines into separate lists
{list1, list2} = Enum.reduce(lines, {[], []}, fn line, {list1, list2} -> 
  [first_item, second_item] = String.split(line, " ", trim: true)
  {first_item_integer, _} = Integer.parse(first_item)
  {second_item_integer, _} = Integer.parse(second_item)
  {[first_item_integer | list1], [second_item_integer | list2]}
end)

# Make a map of right list number occurences
occurence_map = Enum.reduce(list2, %{}, fn item, acc -> 
  Map.update(acc, item, 1, fn existing_value -> existing_value + 1 end)
end)

total_similarity = Enum.reduce(list1, 0, fn item, acc -> 
  (item * Map.get(occurence_map, item, 0)) + acc
end)

IO.puts(total_similarity)
