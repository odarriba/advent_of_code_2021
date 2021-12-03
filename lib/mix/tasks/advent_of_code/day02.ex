defmodule Mix.Tasks.AdventOfCode.Day02 do
  @moduledoc """
  Solution for day 2 exercise.

  It expected to receive the input file as first parameter.
  """
  @shortdoc "Solution for day 2 exercise."

  use Mix.Task

  alias AdventOfCode.Solutions.Day02

  @impl Mix.Task
  def run(["first", filename]) do
    Day02.first_part(filename)
  end

  def run(["second", filename]) do
    Day02.second_part(filename)
  end

  def run(_args) do
    IO.puts("Expected usage: mix advent_of_code.day02 <first|second> input_filename")
  end
end
