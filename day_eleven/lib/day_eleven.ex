defmodule DayEleven do
  @moduledoc """
  Documentation for `DayEleven`.
  """

  @doc """
  Day eleven of Advent of Code 2023.

  ## Examples

      iex> DayEleven.part_one("C:/Users/donjuan/Downloads/input.txt)
      527856

  """
  @almost_mil 999999

  def part_one(path) do
    path
    |> File.read!()
    |> prepare_for_task()
    |> count_shortest_paths([])
  end

  def part_two(path) do
    puzzle_input = File.read!(path)
    unchanged = prepare_for_task2(puzzle_input)
    slightly_changed = prepare_for_task(puzzle_input)

    unchanged
    |> Enum.zip(slightly_changed)
    |> Enum.map(fn {{unch_y, unch_x}, {chg_y, chg_x}} -> {unch_y + (chg_y - unch_y) * @almost_mil, unch_x + (chg_x - unch_x) * @almost_mil} end)
    |> count_shortest_paths([])
  end

  defp prepare_for_task(input) do
    input
    |> String.trim("\n")
    |> String.split("\n")
    |> Enum.map(fn line -> if String.contains?(line, "#"), do: line, else: [line, line] end)
    |> List.flatten()
    |> Enum.map(&String.codepoints/1)
    |> Enum.zip()
    |> Enum.map(fn tuple -> tuple |> Tuple.to_list() |> Enum.join("") end)
    |> Enum.map(fn line -> if String.contains?(line, "#"), do: line, else: [line, line] end)
    |> List.flatten()
    |> Enum.map(fn line -> Regex.scan(~r/\#/, line, return: :index) |> Enum.map(fn [{index, _}] -> index end) end)
    |> Enum.with_index(fn values, index -> Enum.map(values, fn x -> {index , x} end) end)
    |> List.flatten()
  end

  defp count_shortest_paths([], distances), do: Enum.sum(distances)
  defp count_shortest_paths([galaxy | t], distances) do
    part_distance = for galaxy2 <- t do
      path_length(galaxy, galaxy2)
    end
    |> Enum.sum()

    count_shortest_paths(t, [part_distance | distances])
  end

  defp prepare_for_task2(input) do
    input
    |> String.trim("\n")
    |> String.split("\n")
    |> Enum.map(&String.codepoints/1)
    |> Enum.zip()
    |> Enum.map(fn tuple -> tuple |> Tuple.to_list() |> Enum.join("") end)
    |> Enum.map(fn line -> Regex.scan(~r/\#/, line, return: :index) |> Enum.map(fn [{index, _}] -> index end) end)
    |> Enum.with_index(fn values, index -> Enum.map(values, fn x -> {index , x} end) end)
    |> List.flatten()
  end

  defp path_length({y1, x1}, {y2, x2}) do
    abs(x1 - x2) + abs(y1 - y2)
  end
end
