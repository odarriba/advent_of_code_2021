defmodule AdventOfCode.Solutions.Day11 do
  @moduledoc """
  Solution for day 11 exercise.

  ### Exercise
  https://adventofcode.com/2021/day/11
  """

  require Logger

  def count_flashes(filename, steps) do
    input =
      filename
      |> File.read!()
      |> parse_input()

    {num_flashes, _final_status} = calculate_flashes(input, steps)
    IO.puts("Number of flashes after #{steps}: #{num_flashes}")
  end

  def find_sync_step(filename) do
    input =
      filename
      |> File.read!()
      |> parse_input()

    result = do_find_sync_step(input)
    IO.puts("Flashes will be synchronized at step: #{result}")
  end

  defp parse_input(file_content) do
    matrix =
      file_content
      |> String.replace("\r\n", "\n")
      |> String.split("\n", trim: true)
      |> Enum.map(fn row ->
        row
        |> String.graphemes()
        |> Enum.map(&String.to_integer/1)
      end)

    num_rows = length(matrix)

    Enum.reduce(0..(num_rows - 1), %{}, fn y, acc ->
      row = Enum.at(matrix, y)
      num_columns = length(row)

      Enum.reduce(0..(num_columns - 1), acc, fn x, row_acc ->
        energy = Enum.at(row, x)
        Map.put(row_acc, {x, y}, energy)
      end)
    end)
  end

  defp calculate_flashes(input, steps) do
    Enum.reduce(1..steps, {0, input}, fn _step, {num_flashes, acc_input} ->
      updated_input = process_step(acc_input)

      step_flashes = Enum.count(updated_input, fn {{_x, _y}, energy} -> energy == 0 end)

      {num_flashes + step_flashes, updated_input}
    end)
  end

  defp do_find_sync_step(input) do
    updated_input = process_step(input)

    if Enum.all?(updated_input, fn {{_x, _y}, energy} -> energy == 0 end) do
      1
    else
      1 + do_find_sync_step(updated_input)
    end
  end

  defp process_step(input) do
    coords = Map.keys(input)

    coords
    |> Enum.reduce(input, fn {x, y}, acc ->
      increase_energy(acc, {x, y})
    end)
    |> Enum.map(fn
      {{x, y}, energy} when energy > 9 -> {{x, y}, 0}
      {{x, y}, energy} -> {{x, y}, energy}
    end)
    |> Enum.into(%{})
  end

  defp increase_energy(input, {x, y}) do
    value = Map.get(input, {x, y})

    if is_integer(value) do
      new_value = value + 1
      updated_input = Map.put(input, {x, y}, new_value)

      if new_value == 10 do
        get_surroundings({x, y})
        |> Enum.reduce(updated_input, &increase_energy(&2, &1))
      else
        updated_input
      end
    else
      input
    end
  end

  defp get_surroundings({x, y}) do
    [
      {x + 1, y},
      {x - 1, y},
      {x, y + 1},
      {x, y - 1},
      {x + 1, y + 1},
      {x + 1, y - 1},
      {x - 1, y + 1},
      {x - 1, y - 1}
    ]
  end
end
