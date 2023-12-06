defmodule DaySix do
  @moduledoc """
  Documentation for `DaySix`.
  """

  @doc """
  Day six of Advent of Code 2023.

  ## Examples

      iex> DaySix.part_one("C:/Users/dupajaja/Downloads/input.txt)
      2137

  """
  def part_one(path) do
    path
    |> File.read!()
    |> prepare_for_task(1)
    |> Enum.map(&count_ways_to_win/1)
    |> Enum.product()
  end

  def part_two(path) do
    path
    |> File.read!()
    |> prepare_for_task(2)
    |> List.first()
    |> count_ways_to_win()
  end

  defp prepare_for_task(task_input, number) do
    task_input
    |> String.split("\n")
    |> Enum.map(fn line -> new_line = Regex.replace(~r/\w+\:\s{1}/, line, "")
        prepare_line(new_line, number) end)
    |> Enum.slice(0..1)
    |> Enum.zip()
  end

  defp count_ways_to_win({time, distance}) do
    for speed <- 0..time,
      speed * (time - speed) > distance do
        1
    end
    |> Enum.sum()
  end

  defp prepare_line(line, 1) do
    Regex.scan(~r/\d+/, line)
    |> List.flatten()
    |> Enum.map(&String.to_integer/1)
  end

  defp prepare_line(line, 2) do
    new_line = Regex.replace(~r/\s/, line, "")
    Regex.scan(~r/\d+/, new_line)
    |> List.flatten()
    |> Enum.map(&String.to_integer/1)
  end
end
