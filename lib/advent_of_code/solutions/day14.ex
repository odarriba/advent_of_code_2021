defmodule AdventOfCode.Solutions.Day14 do
  @moduledoc """
  Solution for day 14 exercise.

  ### Exercise
  https://adventofcode.com/2021/day/14
  """

  require Logger

  def run(filename, iterations) do
    {polymer, instructions} =
      filename
      |> File.read!()
      |> parse_input()

    result =
      polymer
      |> apply_instructions(instructions, iterations)
      |> calculate_result()

    IO.puts("Result after #{iterations} iterations: #{result}")
  end

  defp parse_input(file_content) do
    [polymer_raw, instructions_raw] =
      file_content
      |> String.replace("\r\n", "\n")
      |> String.split("\n\n", trim: true)

    polymer =
      polymer_raw
      |> String.graphemes()
      |> Enum.chunk_every(2, 1)
      |> Enum.frequencies()
      |> Enum.filter(fn {elements, _freq} -> length(elements) == 2 end)

    instructions =
      instructions_raw
      |> String.split("\n", trim: true)
      |> Enum.map(fn line ->
        [input, output] = String.split(line, " -> ")
        {String.graphemes(input), output}
      end)
      |> Enum.into(%{})

    {polymer, instructions}
  end

  defp apply_instructions(polymer, _instructions, 0), do: polymer

  defp apply_instructions(polymer, instructions, loops) do
    new_polymer =
      Enum.reduce(polymer, %{}, fn {[a, b], count}, acc ->
        inserted_element = Map.fetch!(instructions, [a, b])

        pair_one = Map.get(acc, [a, inserted_element], 0)
        pair_two = Map.get(acc, [inserted_element, b], 0)

        acc
        |> Map.put([a, inserted_element], pair_one + count)
        |> Map.put([inserted_element, b], pair_two + count)
      end)

    apply_instructions(new_polymer, instructions, loops - 1)
  end

  defp calculate_result(polymer) do
    stats =
      Enum.reduce(polymer, %{}, fn {[_a, b], count}, acc ->
        stats_b = Map.get(acc, b, 0)

        Map.put(acc, b, stats_b + count)
      end)

    max_appareances = stats |> Map.values() |> Enum.max()
    min_appareances = stats |> Map.values() |> Enum.min()

    max_appareances - min_appareances
  end
end
