defmodule Mix.Tasks.AdventOfCode.Day04 do
  @moduledoc """
  Solution for day 4 exercise.

  It expected to receive the input file as first parameter.
  """
  @shortdoc "Solution for day 4 exercise."

  use Mix.Task

  alias AdventOfCode.Solutions.Day04

  @impl Mix.Task
  def run([filename]) do
    Day04.bingo(filename)
    Day04.bingo_opposite(filename)
  end

  def run(_args) do
    IO.puts("Expected usage: mix advent_of_code.day04 input_filename")
  end
end
