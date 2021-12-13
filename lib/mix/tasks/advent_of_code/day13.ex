defmodule Mix.Tasks.AdventOfCode.Day13 do
  @moduledoc """
  Solution for day 13 exercise.

  It expected to receive the input file as first parameter.
  """
  @shortdoc "Solution for day 13 exercise."

  use Mix.Task

  alias AdventOfCode.Solutions.Day13

  @impl Mix.Task
  def run([filename]) do
    Day13.run(filename)
  end

  def run(_args) do
    IO.puts("Expected usage: mix advent_of_code.day13 input_filename")
  end
end
