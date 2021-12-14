defmodule Mix.Tasks.AdventOfCode.Day14 do
  @moduledoc """
  Solution for day 14 exercise.

  It expected to receive the input file as first parameter.
  """
  @shortdoc "Solution for day 14 exercise."

  use Mix.Task

  alias AdventOfCode.Solutions.Day14

  @impl Mix.Task
  def run([filename]) do
    Day14.run(filename, 10)
    Day14.run(filename, 40)
  end

  def run(_args) do
    IO.puts("Expected usage: mix advent_of_code.day14 input_filename")
  end
end
