defmodule DayFour do
  @moduledoc """
  Documentation for `DayFour`.
  """

  @doc """
  Day four of Advent of Code 2023.

  ## Examples

      iex> DayFour.part_one("C:/Users/dupajaja/Downloads/input.txt)
      2137

  """
  def part_one(path) do
    path
    |> File.stream!()
    |> Stream.map(&prepare_card/1)
    |> Enum.reduce(0, fn [owned_numbers, winning_numbers], acc -> acc + count_points(owned_numbers, winning_numbers) end)
  end

  def part_two(path) do
    path
    |> File.stream!()
    |> Stream.map(&prepare_card/1)
    |> Enum.map(fn [owned_numbers, winning_numbers] -> {count_my_winning_numbers(owned_numbers, winning_numbers), 1} end)
    |> multiply_scratchcards([])
    |> Enum.sum()
  end

  defp prepare_card(line) do
    Regex.replace(~r/Card\s+\d+\:/, line, "")
      |> String.split("|")
      |> Enum.map(fn part -> Regex.scan(~r/\d+/, part) end)
      |> Enum.map(fn part -> List.flatten(part) end)
  end

  defp count_points(owned_numbers, winning_numbers) do
    owned_winning_numbers = count_my_winning_numbers(owned_numbers, winning_numbers)

    if owned_winning_numbers == 0 do
      0
    else
      2 ** (owned_winning_numbers - 1)
    end
  end

  defp count_my_winning_numbers(owned_numbers, winning_numbers) do
    for number <- owned_numbers,
      number in winning_numbers do
        1
      end
    |> Enum.sum()
  end

  defp multiply_scratchcards([], scratchcards), do: scratchcards
  defp multiply_scratchcards([_h = {winning_numbers, copies} | t], scratchcards) do
    list = update_list(t, winning_numbers - 1, copies)

    multiply_scratchcards(list, [copies | scratchcards])
  end

  defp update_list(list, -1, _copies), do: list
  defp update_list(list, index, copies), do: update_list(List.update_at(list, index, fn {wn, own_copies} -> {wn, own_copies + copies} end), index - 1, copies)
end
