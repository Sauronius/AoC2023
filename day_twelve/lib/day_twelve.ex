defmodule DayTwelve do
  @moduledoc """
  Documentation for `DayTwelve`.
  """

  @doc """
  Day twelve of Advent of Code 2023.

  1579489840074

  ## Examples

      iex> DayTwelve.part_one("C:/Users/donjuan/Downloads/input.txt)
      527856

  """

  def part_one(path) do
    path
    |> File.stream!()
    |> prepare_for_task()
    |> count_valid_posibilities()
    |> Enum.sum()
  end

  def part_two(path) do
    prep1 = path
    |> File.stream!()
    |> prepare_for_task()
    |> count_valid_posibilities()

    prep2 = path
    |> File.stream!()
    |> Stream.map(fn line -> [temp, rest] = String.split(line, " ", trim: true)
      if String.last(temp) == "#", do: "." <> line, else: temp <> "?" <> " " <> rest end)
    |> prepare_for_task()
    |> count_valid_posibilities()

    prep3 = path
    |> File.stream!()
    |> Stream.map(fn line -> [temp, _rest] = String.split(line, " ", trim: true)
      if String.last(temp) == "#", do: "." <> line, else: "?" <> line end)
    |> prepare_for_task()
    |> count_valid_posibilities()

    prep4 = Enum.zip_reduce(prep2, prep3, [], fn elem1, elem2, acc -> [max(elem1, elem2) | acc] end) |> Enum.reverse()

    #|> Enum.sum()

    Enum.zip_reduce(prep1, prep4, 0, fn elem1, elem2, acc -> acc + elem1 * elem2 ** 4 end)
  end

  defp prepare_for_task(input) do
    input
    |> Stream.map(fn line -> line
        |> String.trim("\n")
        |> String.split(" ", trim: true) end)
    |> Enum.map(fn [format1, format2] -> [Regex.split(~r/\?+/, format1, include_captures: true) |> Enum.filter(fn element -> element != "" end), String.split(format2, ",") |> Enum.map(&String.to_integer/1) |> create_regex()] end)
  end

  defp count_valid_posibilities(list) do
    list
    |> Enum.map(fn [list, regex] -> {list |> Enum.map(fn element -> if String.contains?(element, "?"), do: all_posibilities(~w[. #], ~w[. #], String.length(element)), else: element end), regex} end)
    |> Enum.reduce([], fn {line, regex}, acc -> [count_valid_in_single_line(line, regex, []) |> List.flatten() |> Enum.sum() | acc] end)
    |> Enum.reverse()
  end

  defp count_valid_in_single_line([], regex, table) do
    result = table
    |> Enum.reverse()
    |> Enum.join()

    result = Regex.match?(regex, result)

    if result == true do
      1
    else
      0
    end
  end

  defp count_valid_in_single_line([h | t], regex, table) do
    if is_list(h) do
      for element <- h do
        count_valid_in_single_line(t, regex, [element | table])
      end
    else
      count_valid_in_single_line(t, regex, [h | table])
    end
  end

  defp all_posibilities(created, base, range) when range > 1 do
    for i <- created,
      j <- base do
        "#{i}#{j}"
    end
    |> all_posibilities(base, range - 1)
  end
  defp all_posibilities(created, _base, _range), do: created

  defp create_regex(list) do
    first = List.first(list)
    regex_first = "^\\.*\#{#{first}}"
    last = List.last(list)
    regex_last = "\\.+\#{#{last}}\\.*$"
    regex_mid = for element <- Enum.slice(list, 1..-2//1), into: "" do
      "\\.+\#{#{element}}"
    end

    {_, regex} = Regex.compile(regex_first <> regex_mid <> regex_last)
    regex
  end

  def test() do
    list = [["....", "...#", "..#.", "..##", ".#..", ".#.#", ".##.", ".###", "#...", "#..#", "#.#.", "#.##", "##..", "##.#", "###.", "####"], ".######..#####."]
    string = "?###??????????###??????????###??????????###??????????###????????"

    regex = ~r/[\.\?]*[\#\?]{3}[\.\?]+[\#\?]{2}[\.\?]+[\#\?]{1}[\.\?]{1}/

    Regex.scan(regex, string) |> Enum.count()
  end
end
