defmodule Mix.Tasks.AdventOfCode.Day01 do
  @moduledoc """
  Solution for day 1 exercise.

  It expected to receive the input file as first parameter.
  """
  @shortdoc "Solution for day 1 exercise."

  use Mix.Task

  alias AdventOfCode.Solutions.Day01

  @impl Mix.Task
  def run(["first", filename]) do
    Day01.first_part(filename)
  end

  def run(["second", filename]) do
    Day01.second_part(filename)
  end

  def run(_args) do
    IO.puts("Expected usage: mix advent_of_code.day01 <first|second> input_filename")
  end
end
