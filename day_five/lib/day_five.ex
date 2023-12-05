defmodule DayFive do
  @moduledoc """
  Documentation for `DayFive`.
  """

  @doc """
  Day five of Advent of Code 2023.

  ## Examples

      iex> DayFive.part_one("C:/Users/dupajaja/Downloads/input.txt)
      2137

  """
  def part_one(path) do
    path
    |> File.stream!()
    |> Enum.join("")
    |> prepare()
    |> find_lowest_location_number()
  end

  def part_two(path) do
    path
    |> File.stream!()
    |> Enum.join("")
    |> prepare()
    |> expand_numbers()
    |> find_lowest_location_number_ranges()
  end

  defp prepare(input) do
    altered_input = Regex.replace(~r/\w+\-\to\-\w+\:\n/, input, "")
    [[numbers] | transformations] = Regex.split(~r/\n\n/, altered_input)
    |> Enum.map(fn line -> String.split(line, "\n")
        |> Enum.map(fn true_line -> Regex.scan(~r/\d+/, true_line)
            |> Enum.flat_map(&List.flatten/1) end) end)
    |> Enum.map(fn line -> remove_empty(line, [])
        |> Enum.map(&string_to_number/1) end)

    {numbers, transformations}
  end

  defp string_to_number(list) do
    for number <- list do
      String.to_integer(number)
    end
  end

  defp remove_empty([], fixed_list), do: Enum.reverse(fixed_list)
  defp remove_empty([[] | t], fixed_list), do: remove_empty(t, fixed_list)
  defp remove_empty([h | t], fixed_list), do: remove_empty(t, [h | fixed_list])

  defp find_lowest_location_number({numbers, []}), do: numbers |> Enum.sort() |> IO.inspect() |> List.first()
  defp find_lowest_location_number({numbers, [map_list | rest] = _transformations}) do
    new_numbers = for number <- numbers do
      apply_transformation(number, map_list)
    end

    find_lowest_location_number({new_numbers, rest})
  end

  defp apply_transformation(number, map_list) do
    for [destination_range, source_range, range_length] <- map_list,
      number in source_range..(source_range + range_length - 1) do
        destination_range + number - source_range
      end
    |> List.first(number)
  end

  defp expand_numbers({numbers, transformations}) do
    expanded_numbers = numbers
    |> Enum.chunk_every(2)
    |> Enum.map(fn [range_start, range_count] -> range_start..(range_start + range_count - 1) end)
    |> List.flatten()

    transformations_fixed = transformations
    |> Enum.map(fn line -> Enum.map(line, fn [a, b, c] -> {a, b, c} end) end)
    {expanded_numbers, transformations_fixed}
  end

  defp find_lowest_location_number_ranges({numbers, []}), do: numbers |> Enum.sort() |> List.first() |> first_from_range()
  defp find_lowest_location_number_ranges({numbers, [map_list | rest] = _transformations}) do
    new_numbers = for number = _st.._fin <- numbers do
      apply_transformation_ranges(number, map_list, [])
    end
    |> List.flatten()

    find_lowest_location_number_ranges({new_numbers, rest})
  end

  defp apply_transformation_ranges(number_range = _start_number_range.._finish_number_range, [], []), do: number_range
  defp apply_transformation_ranges(_, [], updated_list), do: updated_list
  defp apply_transformation_ranges(number_range = start_number_range..finish_number_range, [{destination_range, source_range, range_length} | map_list], updated_list) do
    if !Range.disjoint?(number_range, source_range..(source_range + range_length - 1)) do
        transformation = split_properly(start_number_range, finish_number_range, source_range, source_range + range_length - 1, destination_range)
      case transformation do
        {[], range} -> [range | updated_list]
        {_first.._last = not_transformed, range} -> t1 = [range | updated_list]
          apply_transformation_ranges(not_transformed, map_list, [not_transformed | t1])
      end
    else
      apply_transformation_ranges(number_range, map_list, updated_list)
    end
  end

  defp split_properly(r1_start, r1_finish, r2_start, r2_finish, target) do
    cond do
      r1_start < r2_start && r1_finish <= r2_finish -> {r1_start..(r2_start - 1), (target)..(target + r1_finish - r2_start)}
      r1_start >= r2_start && r1_finish > r2_finish -> {(r2_finish + 1)..r1_finish, (target + r1_start - r2_start)..(target + r2_finish - r2_start)}
      r1_start >= r2_start && r1_finish <= r2_finish -> {[], (target + r1_start - r2_start)..(target + r1_finish - r2_start)}
      r1_start < r2_start && r1_finish > r2_finish -> {[r1_start..(r2_start - 1), (r2_finish + 1)..r1_finish], (target)..(target + r2_finish - r2_start)}
    end
  end

  defp first_from_range(first.._last) do
    first
  end
end
