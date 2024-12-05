{:ok, contents} = File.read("input.txt")

sum =
  String.split(contents, "\n", trim: true)
  |> Enum.map(fn line -> Regex.scan(~r/mul\(\d{1,3},\d{1,3}\)/, line) end)
  |> List.flatten()
  |> Enum.map(fn factors -> String.replace(factors, "mul(", "") end)
  |> Enum.map(fn factors -> String.replace(factors, ")", "") end)
  |> Enum.map(fn factors -> String.split(factors, ",", trim: true) end)
  |> Enum.map(fn [a, b] -> String.to_integer(a) * String.to_integer(b) end)
  |> Enum.sum()

IO.puts(sum)
