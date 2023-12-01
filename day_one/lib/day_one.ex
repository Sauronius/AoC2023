defmodule DayOne do
  @moduledoc """
  Documentation for `DayOne`.
  """

  @doc """
  Day one of Advent of Code 2023.

  ## Examples

      iex> DayOne.part_one("C:/Users/dupajaja/Downloads/input.txt)
      2137

  """
  def part_one(path) do
    path
    |> File.stream!()
    |> Enum.map(fn line ->
        Regex.scan(~r/\d/, line)
        |> List.flatten()
        |> first_and_last() end)
    |> Enum.sum()
  end

  def part_two(path) do
    path
    |> File.stream!()
    |> Enum.map(fn line ->
      first_digit = Regex.scan(~r/^.*\d{1}|^.*one{1}|^.*two{1}|^.*three{1}|^.*four{1}|^.*five{1}|^.*six{1}|^.*seven{1}|^.*eight{1}|^.*nine{1}/, line) |> Enum.join() |> find_word_in_chaos() |> List.first()
      second_digit = Regex.scan(~r/\d.*$|one.*$|two.*$|three.*$|four.*$|five.*$|six.*$|seven.*$|eight.*$|nine.*$/, line) |> Enum.join() |> find_last_digit()
      [first_digit, second_digit]
      |> List.flatten()
      |> Enum.map(&word_to_stringified_digit/1)
      |> first_and_last() end)
    |> Enum.sum()
  end

  defp first_and_last(list) do
    first = list
      |> List.first("0")
      |> String.to_integer()

    last = list
      |> List.last("0")
      |> String.to_integer()

    10 * first + last
  end

  defp word_to_stringified_digit("one"), do: "1"
  defp word_to_stringified_digit("two"), do: "2"
  defp word_to_stringified_digit("three"), do: "3"
  defp word_to_stringified_digit("four"), do: "4"
  defp word_to_stringified_digit("five"), do: "5"
  defp word_to_stringified_digit("six"), do: "6"
  defp word_to_stringified_digit("seven"), do: "7"
  defp word_to_stringified_digit("eight"), do: "8"
  defp word_to_stringified_digit("nine"), do: "9"
  defp word_to_stringified_digit(word), do: word

  defp find_word_in_chaos(string), do: Regex.scan(~r/\d|one|two|three|four|five|six|seven|eight|nine/, string)
  defp find_last_digit(string) do
    if Regex.match?(~r/\d$|one$|two$|three$|four$|five$|six$|seven$|eight$|nine$/, string) do
      Regex.scan(~r/\d$|one$|two$|three$|four$|five$|six$|seven$|eight$|nine$/, string)
    else
      {new_string, _} = String.split_at(string, -1)
      find_last_digit(new_string)
    end
  end
end
