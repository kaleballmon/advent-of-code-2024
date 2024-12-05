{:ok, contents} = File.read("input.txt")

report_safety =
  String.split(contents, "\n", trim: true)
  |> Enum.map(fn report ->
    String.split(report, " ", trim: true)
    |> Enum.reduce_while(%{prev: nil, direction: nil, safe: true}, fn level, acc ->
      int_level = String.to_integer(level)

      cond do
        acc.prev == nil ->
          {:cont, Map.replace(acc, :prev, int_level)}

        acc.direction == nil && int_level != acc.prev && abs(int_level - acc.prev) < 4 ->
          {
            :cont,
            Map.replace(acc, :prev, int_level)
            |> Map.replace(:direction, if(int_level > acc.prev, do: "up", else: "down"))
          }

        acc.direction == "up" && int_level > acc.prev && int_level - acc.prev < 4 ->
          {:cont, Map.replace(acc, :prev, int_level)}

        acc.direction == "down" && int_level < acc.prev && acc.prev - int_level < 4 ->
          {:cont, Map.replace(acc, :prev, int_level)}

        true ->
          {:halt, Map.replace(acc, :safe, false)}
      end
    end)
  end)

report_safety_count = Enum.count(report_safety, fn report -> report.safe end)

IO.puts(report_safety_count)
