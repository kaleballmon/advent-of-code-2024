{:ok, contents} = File.read("input.txt")


defmodule ConditionalSum do
  def sum(list) do
    sum(list, 0, true)
  end

  defp sum([], total, enabled), do: total

  defp sum([head | tail], total, enabled) do
    cond do
      head == "do" ->
        sum(tail, total, true)
      head == "don't" ->
        sum(tail, total, false)
      true ->
        sum(tail, (if enabled, do: total + head, else: total), enabled)
    end
  end
end



sum = String.split(contents, "\n", trim: true)
 |> Enum.map(fn line -> Regex.scan(~r/(?:mul\(\d{1,3},\d{1,3}\)|do\(\)|don't\(\))/, line) end)
 |> List.flatten()
 |> Enum.map(fn factors -> String.replace(factors, "mul", "") end)
 |> Enum.map(fn factors -> String.replace(factors, "(", "") end)
 |> Enum.map(fn factors -> String.replace(factors, ")", "") end)
 |> Enum.map(fn factors -> String.split(factors, ",", trim: true) end)
 |> Enum.map(fn
    [a, b] -> String.to_integer(a) * String.to_integer(b)
    [a] -> a
  end)
 |> ConditionalSum.sum()

IO.puts(sum)
