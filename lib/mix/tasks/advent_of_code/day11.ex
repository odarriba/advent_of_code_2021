defmodule Mix.Tasks.AdventOfCode.Day11 do
  @moduledoc """
  Solution for day 11 exercise.

  It expected to receive the input file as first parameter.
  """
  @shortdoc "Solution for day 11 exercise."

  use Mix.Task

  alias AdventOfCode.Solutions.Day11

  @impl Mix.Task
  def run([filename]) do
    Day11.count_flashes(filename, 100)
    Day11.find_sync_step(filename)
  end

  def run(_args) do
    IO.puts("Expected usage: mix advent_of_code.day11 input_filename")
  end
end
