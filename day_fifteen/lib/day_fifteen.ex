defmodule DayFifteen do
  @moduledoc """
  Documentation for `DayFifteen`.
  """

  @doc """
  Day fifteen of Advent of Code 2023.

  ## Examples

      iex> DayFifteen.part_one("C:/Users/donjuan/Downloads/input.txt")
      527856

  """

  def part_one(path) do
    path
    |> File.read!()
    |> prepare_for_task()
    |> Enum.map(fn string -> run_hash(string, 0) end)
    |> Enum.sum()
  end

  def part_two(path) do
    boxes = Map.from_keys(0..255 |> Enum.to_list, [])

    path
    |> File.read!()
    |> prepare_for_task()
    |> Enum.map(fn string ->
        decoded_string = Regex.named_captures(~r/(?<label>\w+)(?<operation>\=|\-)(?<focallength>\d*)/, string)
        box_number = run_hash(decoded_string["label"], 0)
        {box_number, decoded_string} end)
    |> Enum.reduce(boxes, fn {box_number, decoded_string}, acc ->
        case decoded_string["operation"] do
          "-" -> if (index = Enum.find_index(acc[box_number], fn {label, _} -> label == decoded_string["label"] end)) == nil do
              acc
            else
              Map.update!(acc, box_number, fn list -> List.delete_at(list, index) end)
            end
          "=" -> if (index = Enum.find_index(acc[box_number], fn {label, _} -> label == decoded_string["label"] end)) == nil do
            Map.update!(acc, box_number, fn list -> list ++ [{decoded_string["label"], decoded_string["focallength"] |> String.to_integer()}] end)
          else
            Map.update!(acc, box_number, fn list -> List.update_at(list, index, fn {label, _} -> {label, decoded_string["focallength"] |> String.to_integer()} end) end)
          end
        end
    end)
    |> Map.filter(fn {_, value} -> value != [] end)
    |> Enum.reduce(0, fn {key, value}, acc -> acc + (key + 1) * lens_power(value) end)
  end

  defp prepare_for_task(input) do
    input
    |> String.trim("\n")
    |> String.split("\n")
    |> Enum.flat_map(fn line -> String.split(line, ",", trim: true) end)
  end

  defp run_hash(<<>>, value), do: value
  defp run_hash(<<sign::8, rest::binary>>, value) do
    new_value = hash(sign + value)
    run_hash(rest, new_value)
  end

  defp hash(value) do
    rem(value * 17, 256)
  end

  defp lens_power(lens_list) do
    lens_list
    |> Enum.with_index(1)
    |> Enum.map(fn {{_, focallength}, index} -> focallength * index end)
    |> Enum.sum()
  end
end
