defmodule Mix.Tasks.AdventOfCode.Day07 do
  @moduledoc """
  Solution for day 7 exercise.

  It expected to receive the input file as first parameter.
  """
  @shortdoc "Solution for day 7 exercise."

  use Mix.Task

  alias AdventOfCode.Solutions.Day07

  @impl Mix.Task
  def run([filename]) do
    Day07.calculate_best_aligment(filename, :constant)
    Day07.calculate_best_aligment(filename, :incremental)
  end

  def run(_args) do
    IO.puts("Expected usage: mix advent_of_code.day07 input_filename")
  end
end
