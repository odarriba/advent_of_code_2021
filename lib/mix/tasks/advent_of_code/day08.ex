defmodule Mix.Tasks.AdventOfCode.Day08 do
  @moduledoc """
  Solution for day 8 exercise.

  It expected to receive the input file as first parameter.
  """
  @shortdoc "Solution for day 8 exercise."

  use Mix.Task

  alias AdventOfCode.Solutions.Day08

  @impl Mix.Task
  def run([filename]) do
    Day08.calculate_segments(filename, :direct)
    Day08.calculate_segments(filename, :full)
  end

  def run(_args) do
    IO.puts("Expected usage: mix advent_of_code.day08 input_filename")
  end
end
