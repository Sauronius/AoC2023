defmodule DayTen do
  @moduledoc """
  Documentation for `DayTen`.
  """

  @doc """
  Day ten of Advent of Code 2023.

  ## Examples

      iex> DayTen.part_one("C:/Users/donjuan/Downloads/input.txt)
      527856

  """
  @sign_to_directions %{"|" => ["N", "S"], "-" => ["E", "W"], "L" => ["N", "E"], "J" => ["N", "W"], "7" => ["W", "S"], "F" => ["E", "S"], "." => [nil], "S" => ["finish"]}
  @complimentary_direction %{"N" => "S", "S" => "N", "W" => "E", "E" => "W"}
  @direction_to_coord %{"N" => {-1, 0}, "S" => {1, 0}, "E" => {0, 1}, "W" => {0, -1}}

  def part_one(path) do
    path
    |> File.read!()
    |> prepare_for_task()
    |> find_farthest_point()
  end

  def part_two(path) do
  path
    |> File.read!()
    |> prepare_for_task()
    |> find_non_loop_tile_groups()
    |> find_trapped_points()
  end

  defp prepare_for_task(input) do
    input
    |> String.trim("\n")
    |> String.split("\n")
    |> Enum.map(fn line -> line
        |> String.split("", trim: true)
        |> Enum.map(& (@sign_to_directions[&1])) end)
    |> Enum.map(&Enum.with_index/1)
    |> Enum.with_index()
    |> Enum.flat_map(fn {pipes, col_index} -> Enum.map(pipes, fn {pipe, row_index} -> {{col_index, row_index}, pipe} end) end)
    |> Map.new()
  end

  defp find_farthest_point(map) do
    {coordinates, _} = Enum.find(map, fn {_key, value} -> value == ["finish"] end)
    for direction <- ["N", "S", "E", "W"] do
      traverse_pipes(map, adjust_coordinates(coordinates, @direction_to_coord[direction]), coordinates, @complimentary_direction[direction], 1)
    end
    |> Enum.max()
    |> Kernel.div(2)
  end

  defp traverse_pipes(_map, nil, _start_coordinates, _direction, _distance), do: 0
  defp traverse_pipes(_map, coordinates, start_coordinates, _direction, distance) when coordinates == start_coordinates, do: distance
  defp traverse_pipes(map, coordinates, start_coordinates, direction, distance) do
    direction_list = map[coordinates]

    cond do
      oob?(coordinates) -> traverse_pipes(map, nil, start_coordinates, direction, distance)
      direction_list == [nil] -> traverse_pipes(map, nil, start_coordinates, direction, distance)
      not_continuing?(direction, direction_list) -> traverse_pipes(map, nil, start_coordinates, direction, distance)
      true -> current_direction = Enum.find(direction_list, & (&1 != direction))
        traverse_pipes(map, adjust_coordinates(coordinates, @direction_to_coord[current_direction]), start_coordinates, @complimentary_direction[current_direction], distance + 1)
    end
  end

  defp adjust_coordinates({y, x}, {dy, dx}) do
    {y + dy, x + dx}
  end

  defp not_continuing?(point, coll) do
    if point in coll do
      false
    else
      true
    end
  end

  defp oob?({y, x}) do
    if y < 0 || x < 0 do
      true
    else
      false
    end
  end

  defp find_non_loop_tile_groups(map) do
    {coordinates, _} = Enum.find(map, fn {_key, value} -> value == ["finish"] end)
    {loop_tiles, edges} = for direction <- ["N", "S", "E", "W"] do
      traverse_pipes2(map, adjust_coordinates(coordinates, @direction_to_coord[direction]), coordinates, @complimentary_direction[direction], [coordinates], [coordinates])
    end
    |> Enum.find(fn main -> main != [] end)

    non_loop_tiles = for {k, _v} <- map,
      k not in loop_tiles do
        k
      end
    |> find_groups([])

    edges
    |> connect_edges([], [])
    |> Enum.map(&List.flatten/1)
    {map, loop_tiles, non_loop_tiles, edges}
  end

  defp find_trapped_points({map, loop_tiles, non_loop_groups, edges}) do
    {{max_y, _}, _} = Enum.max_by(map, fn {{y, _}, _} -> y end)
    {{_, max_x}, _} = Enum.max_by(map, fn {{_, x}, _} -> x end)

    filtered_boundary = for group <- non_loop_groups,
      disconnected_from_boundary?(group, max_y, max_x) do
        group
      end

    non_escape_groups = for group <- filtered_boundary do
      min_group = Enum.filter(group, fn member -> Enum.any?(loop_tiles, fn tile -> neighbours_group?(tile, member) end) end)
      escape = for coord <- min_group do
        for direction <- ["N", "S", "E", "W"],
          adjust_coordinates(coord, @direction_to_coord[direction]) not in min_group do
            is_escaping?(coord, direction, true, true, map, loop_tiles)
          end
        end |> Enum.any?()
      if escape do
        []
      else
        group
      end
      end
      |> List.flatten()
      |> Enum.count()
  end

  defp traverse_pipes2(_map, nil, _start_coordinates, _direction, _distance, _edges), do: []
  defp traverse_pipes2(_map, coordinates, start_coordinates, _direction, distance, edges) when coordinates == start_coordinates, do: {distance, edges}
  defp traverse_pipes2(map, coordinates, start_coordinates, direction, distance, edges) do
    direction_list = map[coordinates]

    cond do
      oob?(coordinates) -> traverse_pipes2(map, nil, start_coordinates, direction, distance, edges)
      direction_list == [nil] -> traverse_pipes2(map, nil, start_coordinates, direction, distance, edges)
      not_continuing?(direction, direction_list) -> traverse_pipes2(map, nil, start_coordinates, direction, distance, edges)
      true -> current_direction = Enum.find(direction_list, & (&1 != direction))
        if current_direction != @complimentary_direction[direction] do
          traverse_pipes2(map, adjust_coordinates(coordinates, @direction_to_coord[current_direction]), start_coordinates, @complimentary_direction[current_direction], [coordinates | distance], [[coordinates] | edges])
        else
          traverse_pipes2(map, adjust_coordinates(coordinates, @direction_to_coord[current_direction]), start_coordinates, @complimentary_direction[current_direction], [coordinates | distance], [coordinates | edges])
        end
    end
  end

  defp find_groups([], group_list), do: group_list
  defp find_groups(coordinates, group_list) do
    [h | t] = coordinates
    {non_group, group} = group(t, [], [h])
    find_groups(non_group, [group | group_list])
  end

  defp group([], non_group, group), do: {non_group, group}
  defp group(coordinates, non_group, group) do
    element = Enum.find(coordinates, fn coordinate_set -> Enum.any?(group, fn elem -> neighbours_group?(elem, coordinate_set) end) end)
    case element do
      nil -> group([], coordinates, group)
      _ -> group(coordinates -- [element], non_group, [element | group])
    end
  end

  defp neighbours_group?({y, x}, {y1, x1}) do
    if (y == y1 && abs(x - x1) <= 1) || (x == x1 && abs(y - y1) <= 1) == true do
      true
    else
      false
    end
  end

  defp disconnected_from_boundary?(group, max_y, max_x) do
    Enum.any?(group, fn {y, x} -> y == max_y or x == max_x or y == 0 or x == 0 end) == false
  end

  defp is_escaping?(coord, direction, w1, w2, map, loop) do
    true ## TODO
  end

  defp connect_edges([], edge, edges), do: [edge | edges]
  defp connect_edges([{_, _} = coordinates | t], edge, edges), do: connect_edges(t, [coordinates | edge], edges)
  defp connect_edges([[{_, _}] = coordinates | t], edge, edges) do
    new_edge = [coordinates | edge]
    connect_edges(t, [coordinates], [new_edge | edges])
  end
end
