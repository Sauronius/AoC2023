defmodule DayThirteen do
  @moduledoc """
  Documentation for `DayThirteen`.
  """

  @doc """
  Day thirteen of Advent of Code 2023.

  ## Examples

      iex> DayThirteen.part_one("C:/Users/donjuan/Downloads/input.txt")
      527856

  """

  def part_one(path) do
    path
    |> File.read!()
    |> prepare_for_task()
    |> find_mirrors([])
    |> Enum.map(fn {multiplier, {min, _max}} -> multiplier * min end)
    |> Enum.sum()
  end

  def part_two(path) do
  path
    |> File.read!()
    |> prepare_for_task()
    |> find_mirrors_2([])
    |> Enum.map(fn {multiplier, {min, _max}} -> multiplier * min end)
    |> Enum.sum()
  end

  defp prepare_for_task(input) do
    input
    |> String.split("\n\n")
    |> Enum.map(&String.split(&1, "\n", trim: true))
    |> Enum.map(fn input -> {input |> Enum.with_index(fn value, key -> {key + 1, value} end) |> Map.new(), input |> Enum.map(&String.split(&1, "", trim: true)) |> Enum.zip() |> Enum.map(fn line -> line |> Tuple.to_list() |> Enum.join() end) |> Enum.with_index(fn value, key -> {key + 1, value} end) |> Map.new()} end)
  end

  defp find_mirrors([], mirrors), do: mirrors
  defp find_mirrors([{horizontal, vertical} | t], mirrors) do
    horiz_mirror = horizontal
      |> find_position()
      |> List.first()
    ver_mirror = vertical
      |> find_position()
      |> List.first()

    if horiz_mirror != nil do
      mirror = {100, horiz_mirror}
      find_mirrors(t, [mirror | mirrors])
    else
      mirror = {1, ver_mirror}
      find_mirrors(t, [mirror | mirrors])
    end
  end

  defp find_position(map) do
    {min, max} = map |> Map.keys() |> Enum.min_max()
    for i <- 1..Enum.count(map) - 1,
      true_mirror?(min, max, i, i + 1, map) == true do
        {i, i + 1}
    end
  end

  defp true_mirror?(min, max, search_min, search_max, map) do
    cond do
      search_min < min || search_max > max -> true
      map[search_min] == map[search_max] -> true_mirror?(min, max, search_min - 1, search_max + 1, map)
      true -> false
    end
  end

  defp find_new_mirror(<<>>, <<>>, _index, list), do: (if Enum.count(list) == 1, do: List.first(list), else: nil)
  defp find_new_mirror(<<element, rest::binary>>, <<element2, rest2::binary>>, index, list) do
    if <<element>> != <<element2>> do
      pair = {index, index + 1}
      find_new_mirror(rest, rest2, index + 1, [pair | list])
    else
      find_new_mirror(rest, rest2, index + 1, list)
    end
  end

  defp find_mirrors_2([], mirrors), do: mirrors
  defp find_mirrors_2([{horizontal, vertical} | t], mirrors) do
    horiz_mirror = horizontal
      |> find_position_2()
      |> List.first()
    ver_mirror = vertical
      |> find_position_2()
      |> List.first()

    cond do
    horiz_mirror != nil && true_mirror?(1, String.length(horizontal[1]), elem(horiz_mirror, 0), elem(horiz_mirror, 1), horizontal) ->
      mirror = {100, horiz_mirror}
      find_mirrors_2(t, [mirror | mirrors])
    ver_mirror != nil && true_mirror?(1, String.length(vertical[1]), elem(ver_mirror, 0), elem(ver_mirror, 1), vertical) ->
      mirror = {1, ver_mirror}
      find_mirrors_2(t, [mirror | mirrors])
    true ->
      hm3 = horizontal
        |> find_position_3()
        |> Kernel.--(find_position(horizontal))
        |> List.first()
      vm3 = vertical
        |> find_position_3()
        |> Kernel.--(find_position(vertical))
        |> List.first()

        if hm3 != nil do
          mirror = {100, hm3}
          find_mirrors_2(t, [mirror | mirrors])
        else
          mirror = {1, vm3}
          find_mirrors_2(t, [mirror | mirrors])
        end
    end
  end

  defp find_position_2(map) do
    for i <- 1..Enum.count(map) - 1,
      find_new_mirror(map[i], map[i + 1], 0, []) != nil do
        {i, i + 1}
    end
  end

  defp can_repair?(line1, line2) do
    find_new_mirror(line1, line2, 0, []) != nil
  end

  defp true_mirror_2?(min, max, search_min, search_max, used, map) do
    cond do
      search_min < min || search_max > max -> true
      map[search_min] == map[search_max] -> true_mirror_2?(min, max, search_min - 1, search_max + 1, used, map)
      can_repair?(map[search_min], map[search_max]) && used == false -> true_mirror_2?(min, max, search_min - 1, search_max + 1, true, map)
      true -> false
    end
  end

  defp find_position_3(map) do
    {min, max} = map |> Map.keys() |> Enum.min_max()
    for i <- 1..Enum.count(map) - 1,
      true_mirror_2?(min, max, i, i + 1, false, map) == true do
        {i, i + 1}
    end
  end
end
