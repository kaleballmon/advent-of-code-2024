{:ok, contents} = File.read("input.txt")

calibrations =
  contents
  |> String.split("\n", trim: true)
  |> Enum.map(fn line -> String.split(line, ":", trim: true) end)
  |> Enum.map(fn [total, equation] ->
    [
      String.to_integer(total),
      String.split(equation)
      |> Enum.map(fn number -> String.to_integer(number) end)
    ]
  end)

defmodule CheckCalibration do
  def check(total, [head | tail]) do
    if check(total, tail, head), do: total, else: 0
  end

  defp check(total, [head | tail], running) do
    check(total, tail, running + head) || check(total, tail, running * head) || check(total, tail, String.to_integer(Integer.to_string(running) <> Integer.to_string(head)))
  end

  defp check(total, [], running), do: running == total
end

IO.inspect(
  Enum.map(calibrations, fn [total, equation] -> CheckCalibration.check(total, equation) end)
  |> Enum.sum()
)
