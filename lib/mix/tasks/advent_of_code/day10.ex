defmodule Mix.Tasks.AdventOfCode.Day10 do
  @moduledoc """
  Solution for day 10 exercise.

  It expected to receive the input file as first parameter.
  """
  @shortdoc "Solution for day 10 exercise."

  use Mix.Task

  alias AdventOfCode.Solutions.Day10

  @impl Mix.Task
  def run([filename]) do
    Day10.score(filename)
  end

  def run(_args) do
    IO.puts("Expected usage: mix advent_of_code.day10 input_filename")
  end
end
