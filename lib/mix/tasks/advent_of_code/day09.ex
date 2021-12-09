defmodule Mix.Tasks.AdventOfCode.Day09 do
  @moduledoc """
  Solution for day 9 exercise.

  It expected to receive the input file as first parameter.
  """
  @shortdoc "Solution for day 9 exercise."

  use Mix.Task

  alias AdventOfCode.Solutions.Day09

  @impl Mix.Task
  def run([filename]) do
    Day09.calculate_risk(filename)
    Day09.calculate_basins(filename)
  end

  def run(_args) do
    IO.puts("Expected usage: mix advent_of_code.day09 input_filename")
  end
end
