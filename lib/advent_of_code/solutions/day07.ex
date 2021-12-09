defmodule AdventOfCode.Solutions.Day07 do
  @moduledoc """
  Solution for day 7 exercise.

  ### Exercise
  https://adventofcode.com/2021/day/7
  """

  require Logger

  @doc """
  Calculates optimal position and fuel needed to align all crab submarines.

  Mode can be either `:constant` or `:incremental`
  """
  def calculate_best_aligment(filename, mode) do
    initial_positions =
      filename
      |> File.read!()
      |> parse_positions()

    {position, used_gas} = calculate_optimal_position(initial_positions, mode)

    IO.puts("Gas used for optimal position (#{position}) in mode #{mode}: #{used_gas}")
  end

  defp parse_positions(file_content) do
    file_content
    |> String.replace("\r\n", "\n")
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1, ",", trim: true))
    |> List.flatten()
    |> Enum.map(&String.to_integer/1)
  end

  defp calculate_optimal_position(initial_positions, mode) do
    possible_positions = Enum.min(initial_positions)..Enum.max(initial_positions)

    possible_positions
    |> Enum.reduce(%{}, fn possible_position, acc ->
      gas_used =
        initial_positions
        |> Enum.map(&gas_used(&1, possible_position, mode))
        |> Enum.sum()

      Map.put(acc, possible_position, gas_used)
    end)
    |> Enum.min_by(fn {_k, v} -> v end)
  end

  defp gas_used(position_1, position_2, :constant) do
    abs(position_1 - position_2)
  end

  defp gas_used(position_1, position_2, :incremental) do
    diff = abs(position_1 - position_2)
    Enum.sum(1..diff)
  end
end
