defmodule DayTwo do
  @moduledoc """
  Documentation for `DayTwo`.
  """

  @doc """
  Day two of Advent of Code 2023.

  ## Examples

      iex> DayTwo.part_one("C:/Users/dupajaja/Downloads/input.txt)
      2137

  """
  def part_one(path) do
    path
    |> File.stream!()
    |> Enum.map(&game_id_for_valid_games/1)
    |> List.flatten()
    |> Enum.sum()
  end

  def part_two(path) do
    path
    |> File.stream!()
    |> Enum.map(&power_of_coulours/1)
    |> Enum.sum()
  end

  defp game_id_for_valid_games(game) do
    captures = Regex.scan(~r/(:?Game )(?<game>\d+)|(?<blue>\d{2,})(:?\sblue)|(?<red>\d{2,})(:?\sred)|(?<green>\d{2,})(:?\sgreen)/, game, [capture: ["game", "red", "green", "blue"]])
    |> Enum.map(&value_interpretation/1)

    if Enum.all?(captures) do
      Enum.filter(captures, fn capture -> capture != true end)
    else
      0
    end
  end

  defp value_interpretation([game, "", "", ""]), do: String.to_integer(game)
  defp value_interpretation(["", red, "", ""]), do: red |> String.to_integer() |> Kernel.<=(12)
  defp value_interpretation(["", "", green, ""]), do: green |> String.to_integer() |> Kernel.<=(13)
  defp value_interpretation(["", "", "", blue]), do: blue |> String.to_integer() |> Kernel.<=(14)

  defp power_of_coulours(game) do
    Regex.scan(~r/(?<blue>\d+)(:?\sblue)|(?<red>\d+)(:?\sred)|(?<green>\d+)(:?\sgreen)/, game, [capture: ["red", "green", "blue"]])
    |> find_max_values([0, 0, 0])
    |> Enum.product()
  end

  defp find_max_values([], [r, g, b]), do: [r, g, b]
  defp find_max_values([capture | rest] = _captures, [r, g, b]) do
    case capture do
      [red, "", ""] -> find_max_values(rest, [max(String.to_integer(red), r), g, b])
      ["", green, ""] -> find_max_values(rest, [r, max(String.to_integer(green), g), b])
      ["", "", blue] -> find_max_values(rest, [r, g, max(String.to_integer(blue), b)])
      _ -> [r, g, b]
    end
  end
end
