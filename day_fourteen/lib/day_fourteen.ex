defmodule DayFourteen do
  @moduledoc """
  Documentation for `DayFourteen`.
  """

  @doc """
  Day fourteen of Advent of Code 2023.

  Part2 tuned to find a cycle loop, in case of not finding loops increase the parameter for cycle_in_cycles?/3 function.

  ## Examples

      iex> DayFourteen.part_one("C:/Users/donjuan/Downloads/input.txt")
      527856

  """
  @direction_to_coord %{"N" => {1, 0}, "S" => {-1, 0}, "E" => {0, 1}, "W" => {0, -1}}
  @number_of_cycles 100

  def part_one(path) do
    path
    |> File.read!()
    |> prepare_for_task()
    |> roll_to_direction("N")
    |> load_of_north_support_beams()
  end

  def part_two(path) do
    map = path
    |> File.read!()
    |> prepare_for_task()

    {start_map, cycles, start_number} = cycle_in_cycles(map, [map], @number_of_cycles)
    remainding_cycles = rem(1000000000 - start_number, cycles)

    start_map
    |> spin_cycle(remainding_cycles)
    |> load_of_north_support_beams()
  end

  defp prepare_for_task(input) do
    input
    |> String.trim("\n")
    |> String.split("\n", trim: true)
    |> Enum.reverse()
    |> Enum.with_index(1)
    |> Enum.reverse()
    |> Enum.flat_map(fn {line, weight} ->  line
        |> String.split("", trim: true)
        |> Enum.with_index(fn data, x_axis -> {{weight, x_axis + 1}, data} end) end)
    |> Map.new()
  end

  defp roll_to_direction(map, direction) do
    {start, finish} = Map.keys(map) |> Enum.max()
    case direction do
      "N" -> update_map(map, start, finish, start - 1, 1, direction)
      "W" -> update_map(map, start, finish, 1, 2, direction)
      "S" -> update_map(map, start, finish, 2, 1, direction)
      "E" -> update_map(map, start, finish, 1, finish - 1, direction)
    end
  end

  defp update_map(map, start_row, finish_column, current_row, current_column, direction = "N") do
    current_key = {current_row, current_column}
    cond do
      current_row == 1 && current_column > finish_column -> map
      current_column > finish_column -> update_map(map, start_row, finish_column, current_row - 1, 1, direction)
      map[current_key] == "O" -> new_key = look_ahead(map, current_key, current_key, direction)
          new_map = map
          |> Map.update(current_key, map[current_key], fn _val -> "." end)
          |> Map.update(new_key, map[current_key], fn _val -> "O" end)
          update_map(new_map, start_row, finish_column, current_row, current_column + 1, direction)
      true -> update_map(map, start_row, finish_column, current_row, current_column + 1, direction)
    end
  end

  defp update_map(map, start_row, finish_column, current_row, current_column, direction = "W") do
    current_key = {current_row, current_column}
    cond do
      current_column == finish_column && current_row > start_row -> map
      current_row > start_row -> update_map(map, start_row, finish_column, 1, current_column + 1, direction)
      map[current_key] == "O" -> new_key = look_ahead(map, current_key, current_key, direction)
          new_map = map
          |> Map.update(current_key, map[current_key], fn _val -> "." end)
          |> Map.update(new_key, map[current_key], fn _val -> "O" end)
          update_map(new_map, start_row, finish_column, current_row + 1, current_column, direction)
      true -> update_map(map, start_row, finish_column, current_row + 1, current_column, direction)
    end
  end

  defp update_map(map, start_row, finish_column, current_row, current_column, direction = "S") do
    current_key = {current_row, current_column}
    cond do
      current_row == start_row && current_column > finish_column -> map
      current_column > finish_column -> update_map(map, start_row, finish_column, current_row + 1, 1, direction)
      map[current_key] == "O" -> new_key = look_ahead(map, current_key, current_key, direction)
          new_map = map
          |> Map.update(current_key, map[current_key], fn _val -> "." end)
          |> Map.update(new_key, map[current_key], fn _val -> "O" end)
          update_map(new_map, start_row, finish_column, current_row, current_column + 1, direction)
      true -> update_map(map, start_row, finish_column, current_row, current_column + 1, direction)
    end
  end

  defp update_map(map, start_row, finish_column, current_row, current_column, direction = "E") do
    current_key = {current_row, current_column}
    cond do
      current_column == 1 && current_row > start_row -> map
      current_row > start_row -> update_map(map, start_row, finish_column, 1, current_column - 1, direction)
      map[current_key] == "O" -> new_key = look_ahead(map, current_key, current_key, direction)
          new_map = map
          |> Map.update(current_key, map[current_key], fn _val -> "." end)
          |> Map.update(new_key, map[current_key], fn _val -> "O" end)
          update_map(new_map, start_row, finish_column, current_row + 1, current_column, direction)
      true -> update_map(map, start_row, finish_column, current_row + 1, current_column, direction)
    end
  end

  defp look_ahead(map, {row, col} = _key, destination, direction) do
    {dr, dc} = @direction_to_coord[direction]
    next_key = {row + dr, col + dc}
    case map[next_key] do
      "." -> look_ahead(map, next_key, next_key, direction)
      _ -> destination
    end
  end

  defp load_of_north_support_beams(map) do
    map
    |> Map.filter(fn {_k, v} -> v == "O" end)
    |> Map.keys()
    |> Enum.map(fn {weight, _} -> weight end)
    |> Enum.sum()
  end

  defp spin_cycle(map, 0), do: map
  defp spin_cycle(map, left) do
    map
    |> roll_to_direction("N")
    |> roll_to_direction("W")
    |> roll_to_direction("S")
    |> roll_to_direction("E")
    |> spin_cycle(left - 1)
  end

  defp cycle_in_cycles(map, _list, 0), do: {map, 0, 0} #list |> Enum.frequencies() |> Map.values() |> Enum.any?(& (&1 > 1))
  defp cycle_in_cycles(map, list, number_of_cycles) do
    new_map = spin_cycle(map, 1)
    if new_map in list do
      numbers_to_cycle = Enum.find_index(Enum.reverse(list), & (&1 == new_map))
      {new_map, @number_of_cycles - number_of_cycles - numbers_to_cycle + 1, numbers_to_cycle}
    else
      cycle_in_cycles(new_map, [new_map | list], number_of_cycles - 1)
    end
  end
end
