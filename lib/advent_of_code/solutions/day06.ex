defmodule AdventOfCode.Solutions.Day06 do
  @moduledoc """
  Solution for day 6 exercise.

  ### Exercise
  https://adventofcode.com/2021/day/6
  """

  require Logger

  def calculate_population(filename, days) do
    initial_population =
      filename
      |> File.read!()
      |> parse_population()

    result_population = population_growth(initial_population, days)

    IO.puts("Number of lanternfishes after #{days} days: #{result_population}")
  end

  defp parse_population(file_content) do
    file_content
    |> String.replace("\r\n", "\n")
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1, ",", trim: true))
    |> List.flatten()
    |> Enum.map(&String.to_integer/1)
  end

  defp population_growth(initial_population, days) do
    born_per_day =
      Enum.reduce(initial_population, %{}, fn lanternfish, acc ->
        # We are on day 0, so the fish borned on a negative day on our scale
        born_day = -8 + lanternfish
        current = Map.get(acc, born_day, 0)
        Map.put(acc, born_day, current + 1)
      end)

    born_per_day =
      Enum.reduce(1..days, born_per_day, fn day, acc ->
        born_days = get_born_days(day)

        num_born =
          born_days
          |> Enum.map(&Map.get(acc, &1, 0))
          |> Enum.sum()

        Map.put(acc, day, num_born)
      end)

    born_per_day
    |> Map.values()
    |> Enum.sum()
  end

  defp get_born_days(current_day, list \\ [])

  defp get_born_days(current_day, []) do
    get_born_days(current_day - 9, [current_day - 9])
  end

  defp get_born_days(current_day, list) when current_day >= -8 do
    get_born_days(current_day - 7, [current_day - 7 | list])
  end

  defp get_born_days(_current_day, list), do: list
end
