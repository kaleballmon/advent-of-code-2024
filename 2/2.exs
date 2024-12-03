defmodule SafetyCheck do
  def check_safety(report) do
    if is_safe(report) do
      true
    else
      check_safety(report, [])
    end
  end

  defp check_safety([], before), do: false
    
  defp check_safety([head | tail], before) do 
    if is_safe(before ++ tail) do
      true
    else
      check_safety(tail, before ++ [head])
    end
  end

  def is_safe(report) do
    Enum.reduce_while(report, %{prev: nil, direction: nil, safe: true}, fn level, acc ->
        int_level = String.to_integer(level)
        cond do
          acc.prev == nil ->
            {:cont, Map.replace(acc, :prev, int_level)}
          acc.direction == nil && int_level != acc.prev && abs(int_level - acc.prev) < 4 -> 
            {
              :cont, 
              Map.replace(acc, :prev, int_level) 
                |> Map.replace(:direction, (if int_level > acc.prev, do: "up", else: "down"))
            }
          acc.direction == "up" && int_level > acc.prev && int_level - acc.prev < 4 ->
            {:cont, Map.replace(acc, :prev, int_level)}
          acc.direction == "down" && int_level < acc.prev && acc.prev - int_level < 4 ->
            {:cont, Map.replace(acc, :prev, int_level)}
          true ->
            {:halt, Map.replace(acc, :safe, false)}
        end
    end).safe
  end
end


{:ok, contents} = File.read("input.txt")


report_safety = String.split(contents, "\n", trim: true)
  |> Enum.map(
    fn report ->
      String.split(report, " ", trim: true)
        |> SafetyCheck.check_safety
      end)

report_safety_count = Enum.count(report_safety, fn report -> report end)

IO.puts(report_safety_count)
