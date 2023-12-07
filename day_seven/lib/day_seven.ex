defmodule DaySeven do
  @moduledoc """
  Documentation for `DaySeven`.
  """

  @doc """
  Day seven of Advent of Code 2023.

  ## Examples

      iex> DaySeven.part_one("C:/Users/dupajaja/Downloads/input.txt)
      2137

  """
  @card_values%{"A" => 14, "K" => 13, "Q" => 12, "J" => 11, "T" => 10, "9" => 9, "8" => 8, "7" => 7, "6" => 6, "5" => 5, "4" => 4, "3" => 3, "2" => 2}
  @card_values_joker%{"A" => 14, "K" => 13, "Q" => 12, "J" => 1, "T" => 10, "9" => 9, "8" => 8, "7" => 7, "6" => 6, "5" => 5, "4" => 4, "3" => 3, "2" => 2}

  def part_one(path) do
    path
    |> File.stream!()
    |> prepare_for_task(@card_values, 1)
    |> Enum.sort_by(& {&1[:frequencies], &1[:cards]})
    |> Enum.with_index(1)
    |> Enum.reduce(0, fn {map, rank}, acc -> acc + rank * map[:bid] end)
  end

  def part_two(path) do
    path
    |> File.stream!()
    |> prepare_for_task(@card_values_joker, 2)
    |> Enum.sort_by(& {&1[:frequencies], &1[:cards]})
    |> Enum.with_index(1)
    |> Enum.reduce(0, fn {map, rank}, acc -> acc + rank * map[:bid] end)
  end

  defp prepare_for_task(line, card_values, task_part) do
    line
    |> Stream.map(fn line -> line
        |> String.trim("\n")
        |> String.split(" ") end)
    |> Stream.map(fn [cards, bid] -> frequencies = get_hand(cards, task_part)
        translated_cards = cards |> String.graphemes() |> Enum.map(& card_values[&1])
       %{cards: translated_cards, bid: String.to_integer(bid), frequencies: frequencies} end)
  end

  defp get_hand(cards, 1) do
    cards
    |> String.graphemes()
    |> Enum.frequencies()
    |> Map.values()
    |> Enum.sort(:desc)
  end

  defp get_hand(cards, 2) do
    {jokers, rest_of_hand} = cards
    |> String.graphemes()
    |> Enum.frequencies()
    |> Map.pop("J", 0)

    if rest_of_hand == %{} do
      [jokers]
    else
      rest_of_hand
      |> Map.values()
      |> Enum.sort(:desc)
      |> List.update_at(0, &(&1 + jokers))
    end
  end
end
