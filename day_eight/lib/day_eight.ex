defmodule DayEight do
  @moduledoc """
  Documentation for `DayEight`.
  """

  @doc """
  Day eight of Advent of Code 2023.

  ## Examples

      iex> DayEight.part_one("C:/Users/donjuan/Downloads/input.txt)
      527856

  """

  def part_one(path) do
    path
    |> File.read!()
    |> prepare_for_task()
    |> add_information()
    |> steps_count(0)
  end

  def part_two(path) do
    path
    |> File.read!()
    |> prepare_for_task()
    |> starting_and_ending_nodes()
    |> steps_count_2(0, [])
  end

  defp prepare_for_task(input) do
    [instructions, maps] = input
    |> String.split("\n\n")

    instructions_list = String.graphemes(instructions)

    maped_maps = maps
    |> String.trim("\n")
    |> String.split("\n")
    |> Enum.map(fn instruction_map -> Regex.named_captures(~r/(?<node>\w{3})\s\=\s\((?<L>\w{3})\,\s(?<R>\w{3})\)/, instruction_map) end)

    {instructions_list, maped_maps}
  end

  defp add_information({instructions_list, maped_maps}) do
    initial_map = Enum.find(maped_maps, &(Map.fetch!(&1, "node") == "AAA"))

    target = Enum.find(maped_maps, &(Map.fetch!(&1, "node") == "ZZZ"))

    {instructions_list, maped_maps, initial_map, target}
  end

  defp steps_count({_, _, current_map, target}, count) when target == current_map, do: count
  defp steps_count({instructions_list, maps, current_map, target}, count) do
    instruction = List.first(instructions_list)
    next_map = Enum.find(maps, &(Map.fetch!(&1, "node") == current_map[instruction]))
    updated_instruction_list = Enum.slide(instructions_list, 0, -1)
    steps_count({updated_instruction_list, maps, next_map, target}, count + 1)
  end

  defp steps_count_2({_, _, current_nodes, _}, _count, list) when current_nodes == %{} do
    [h | t] = list |> Enum.map(&(&1 + 1))
    lcm(t, h)
  end

  defp steps_count_2({instructions_list, maps, current_nodes, ending_nodes}, count, list) do
    instruction = List.first(instructions_list)
    next_nodes = for node <- current_nodes, into: %{} do
      single_step(instruction, maps, node)
    end

    updated_instruction_list = Enum.slide(instructions_list, 0, -1)

    if Enum.any?(next_nodes, &(&1 in ending_nodes)) do
      {k, _v} = Enum.find(next_nodes, &(&1 in ending_nodes))
        {_x, nnn} = Map.pop(next_nodes, k)
      steps_count_2({updated_instruction_list, maps, nnn, ending_nodes}, count + 1, [count | list])
    else
      steps_count_2({updated_instruction_list, maps, next_nodes, ending_nodes}, count + 1, list)
    end
  end

  defp single_step(instruction, maps, current_map) do
    Enum.find(maps, fn {k, _v} -> {_k1, v1} = current_map
      k == v1[instruction] end)
  end

  defp starting_and_ending_nodes({instructions_list, maped_maps}) do
    starting_nodes = for map <- maped_maps,
      Regex.match?(~r/\w{2}A/, Map.fetch!(map, "node")), into: %{} do
        {map["node"], %{"L" => map["L"], "R" => map["R"]}}
      end

    ending_nodes = for map <- maped_maps,
      Regex.match?(~r/\w{2}Z/, Map.fetch!(map, "node")), into: %{} do
        {map["node"], %{"L" => map["L"], "R" => map["R"]}}
    end

    new_maps = maped_maps
      |> Enum.map(fn map -> {map["node"], %{"L" => map["L"], "R" => map["R"]}}end)
      |> Map.new()

    {instructions_list, new_maps, starting_nodes, ending_nodes}
  end

  defp lcm([], lcm), do: lcm
  defp lcm([h | t], lcm) do
    new_lcm = lcm(h, lcm)
    lcm(t, new_lcm)
  end

	defp lcm(0, 0), do: 0
	defp lcm(a, b), do: (a * b) / gcd(a, b) |> trunc()

  defp gcd(a, 0), do: a
	defp gcd(0, b), do: b
	defp gcd(a, b), do: gcd(b, rem(a, b))
 end
