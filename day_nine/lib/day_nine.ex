defmodule DayNine do
  @moduledoc """
  Documentation for `DayNine`.
  """

  @doc """
  Day nine of Advent of Code 2023.

  ## Examples

      iex> DayNine.part_one("C:/Users/donjuan/Downloads/input.txt)
      527856

  """

def part_one(path) do
  path
  |> File.read!()
  |> prepare_for_task()
  |> Enum.map(&difference_tree(&1, []))
  |> Enum.map(fn tree -> Enum.reduce(tree, 0, fn differences, acc -> List.last(differences) + acc end) end)
  |> Enum.sum()
end

def part_two(path) do
  path
  |> File.read!()
  |> prepare_for_task()
  |> Enum.map(&difference_tree(&1, []))
  |> Enum.map(fn tree -> Enum.reduce(tree, 0, fn differences, acc -> List.first(differences) - acc end) end)
  |> Enum.sum()
end

defp prepare_for_task(input) do
  input
  |> String.trim("\n")
  |> String.split("\n")
  |> Enum.map(&String.split/1)
  |> Enum.map(fn values -> Enum.map(values, &String.to_integer/1) end)
end

defp difference_tree([], all_levels), do: all_levels
defp difference_tree(current_level, all_levels) do
  next_level = find_differences(current_level, [])

  if is_zeros?(next_level) do
    almost_finished = [current_level | all_levels]
    difference_tree([], [next_level | almost_finished])
  else
    difference_tree(next_level, [current_level | all_levels])
  end
end

defp find_differences([_h | []], differences), do: differences |> Enum.reverse()
defp find_differences([first | rest], differences) do
  [second | _] = rest
  find_differences(rest, [(second - first) | differences])
end

defp is_zeros?(list), do: Enum.all?(list, & (&1 == 0))
end
