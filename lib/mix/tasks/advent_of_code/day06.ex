defmodule Mix.Tasks.AdventOfCode.Day06 do
  @moduledoc """
  Solution for day 6 exercise.

  It expected to receive the input file as first parameter.
  """
  @shortdoc "Solution for day 6 exercise."

  use Mix.Task

  alias AdventOfCode.Solutions.Day06

  @impl Mix.Task
  def run([filename]) do
    Day06.calculate_population(filename, 80)
    Day06.calculate_population(filename, 256)
  end

  def run(_args) do
    IO.puts("Expected usage: mix advent_of_code.day06 input_filename")
  end
end
