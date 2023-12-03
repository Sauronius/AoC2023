defmodule DayThree do
  @moduledoc """
  Documentation for `DayThree`.
  """

  @doc """
  Day three of Advent of Code 2023.

  ## Examples

      iex> DayThree.part_one("C:/Users/dupajaja/Downloads/input.txt)
      2137

  """
  def part_one(path) do
    path
    |> File.stream!()
    |> Enum.map(&numbers_and_sign_positions/1)
    |> valid_numbers()
    |> Enum.sum()
  end

  def part_two(path) do
    path
    |> File.stream!()
    |> Enum.map(&numbers_and_star_positions/1)
    |> Enum.with_index()
    |> valid_ratios()
    |> Enum.sum()
  end

  defp numbers_and_sign_positions(line) do
    index_list = Regex.scan(~r/\d+/, line, return: :index)
      |> List.flatten()
    number_list = Regex.scan(~r/\d+/, line)
      |> List.flatten()
    sign_index_list = Regex.scan(~r/[^\d\s\w\.]/, line,  return: :index)
      |> List.flatten()
      |> Enum.map(fn {position, _length} -> position end)

    numbers = Enum.zip(number_list, index_list)

    [numbers, sign_index_list]
  end

  defp valid_numbers(list_of_lines) do
    {first, rest} = List.pop_at(list_of_lines, 0)
    list_touching(first, rest, [])
  end

  defp list_touching([], [], list_of_valid_numbers), do: list_of_valid_numbers |> List.flatten()
  defp list_touching([numbers, list_of_sign_index], [], list_of_valid_numbers) do
    list = for {number, {index, length}} <- numbers,
      connected_in_line?(index, length, list_of_sign_index) do
      {n, _} = Integer.parse(number)
      n
    end
    list_touching([], [], [list | list_of_valid_numbers])
  end

  defp list_touching([numbers, list_of_sign_index], [h | t], list_of_valid_numbers) do
    [numbers_next, list_of_sign_index_next] = h
    numbers_used = []

    list = for {number, {index, length}} <- numbers,
      connected_with_any?(index, length, list_of_sign_index, list_of_sign_index_next) do
      {n, _} = Integer.parse(number)
      n
    end

    list_next = for {number, {index, length}} = n2 <- numbers_next,
    connected_with_neighbour?(index, length, list_of_sign_index) do
    [n2 | numbers_used]
    {n, _} = Integer.parse(number)
    n
    end

    updated_head = [numbers_next -- numbers_used, list_of_sign_index_next]
    total_list = [list_next | list]
    list_touching(updated_head, t, [total_list | list_of_valid_numbers])
  end

  defp connected_in_line?(index_of_number_start, length_of_number, list_of_sign_index) do
    Enum.any?(list_of_sign_index, fn index_of_sign -> index_of_sign == index_of_number_start + length_of_number or index_of_sign == index_of_number_start - 1 end)
  end

  defp connected_with_neighbour?(index_of_number_start, length_of_number, list_of_sign_index) do
    Enum.any?(list_of_sign_index, fn index_of_sign -> index_of_sign in index_of_number_start - 1..index_of_number_start + length_of_number end)
  end

  defp connected_with_any?(index_of_number_start, length_of_number, list_of_sign_index, list_of_sign_index_next) do
    connected_in_line?(index_of_number_start, length_of_number, list_of_sign_index) or connected_with_neighbour?(index_of_number_start, length_of_number, list_of_sign_index_next)
  end

  defp numbers_and_star_positions(line) do
    index_list = Regex.scan(~r/\d+/, line, return: :index)
      |> List.flatten()
    number_list = Regex.scan(~r/\d+/, line)
      |> List.flatten()
    star_index_list = Regex.scan(~r/\*/, line,  return: :index)
      |> List.flatten()
      |> Enum.map(fn {position, _length} -> position end)

    numbers = Enum.zip(number_list, index_list)

    [numbers, star_index_list]
  end

  defp valid_ratios(list_of_lines) do
    {first, rest} = List.pop_at(list_of_lines, 0)

    list_gears(first, rest, [])
    |> Enum.group_by(fn {_number, x} -> x end)
    |> Enum.filter(fn {_key, val} -> Enum.count(val) == 2 end)
    |> Enum.map(fn {_key, [{number, _}, {second_number, _}]} -> number * second_number end)
  end

  defp list_gears([], [], list_of_valid_numbers), do: list_of_valid_numbers |> List.flatten()
  defp list_gears({[numbers, list_of_sign_index], line}, [], list_of_valid_numbers) do
    list = for {number, {index, length}} <- numbers,
      connected_in_line?(index, length, list_of_sign_index) do
      {n, _} = Integer.parse(number)
      potential_gear = Enum.find(list_of_sign_index, fn index_of_sign -> single_connection?(index, length, index_of_sign) end)
      {n, line, potential_gear}
    end
    list_gears([], [], [list | list_of_valid_numbers])
  end

  defp list_gears({[numbers, list_of_sign_index], line}, [h | t], list_of_valid_numbers) do
    {[numbers_next, list_of_sign_index_next], next_line} = h
    numbers_used = []

    list = for {number, {index, length}} <- numbers,
      connected_with_any?(index, length, list_of_sign_index, list_of_sign_index_next) do
      {n, _} = Integer.parse(number)
      temp_line = next_line
      potential_gear = Enum.find(list_of_sign_index_next, fn index_of_sign -> single_neighbour?(index, length, index_of_sign) end)
      if potential_gear == nil do
        potential_gear = Enum.find(list_of_sign_index, fn index_of_sign -> single_connection?(index, length, index_of_sign) end)
        temp_line = line
        {n, {temp_line, potential_gear}}
      else
      {n, {temp_line, potential_gear}}
      end
    end

    list_next = for {number, {index, length}} = n2 <- numbers_next,
    connected_with_neighbour?(index, length, list_of_sign_index) do
    [n2 | numbers_used]
    {n, _} = Integer.parse(number)
    potential_gear = Enum.find(list_of_sign_index, fn index_of_sign -> single_neighbour?(index, length, index_of_sign) end)
    {n, {line, potential_gear}}
    end

    updated_head = {[numbers_next -- numbers_used, list_of_sign_index_next], next_line}
    total_list = [list_next | list]
    list_gears(updated_head, t, [total_list | list_of_valid_numbers])
  end

  defp single_neighbour?(index_of_number_start, length_of_number, index_of_sign) do
    index_of_sign in index_of_number_start - 1..index_of_number_start + length_of_number
  end

  defp single_connection?(index_of_number_start, length_of_number, index_of_sign) do
    index_of_sign == index_of_number_start + length_of_number or index_of_sign == index_of_number_start - 1
  end
end
