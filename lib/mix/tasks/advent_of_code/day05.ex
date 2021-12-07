defmodule Mix.Tasks.AdventOfCode.Day05 do
  @moduledoc """
  Solution for day 5 exercise.

  It expected to receive the input file as first parameter.
  """
  @shortdoc "Solution for day 5 exercise."

  use Mix.Task

  alias AdventOfCode.Solutions.Day05

  @impl Mix.Task
  def run([filename]) do
    Day05.ovarlap_points(filename, :restricted)
    Day05.ovarlap_points(filename, :full)
  end

  def run(_args) do
    IO.puts("Expected usage: mix advent_of_code.day05 input_filename")
  end
end
