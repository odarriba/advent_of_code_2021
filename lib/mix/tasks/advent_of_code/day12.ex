defmodule Mix.Tasks.AdventOfCode.Day12 do
  @moduledoc """
  Solution for day 12 exercise.

  It expected to receive the input file as first parameter.
  """
  @shortdoc "Solution for day 12 exercise."

  use Mix.Task

  alias AdventOfCode.Solutions.Day12

  @impl Mix.Task
  def run([filename]) do
    Day12.find_paths(filename)
  end

  def run(_args) do
    IO.puts("Expected usage: mix advent_of_code.day12 input_filename")
  end
end
