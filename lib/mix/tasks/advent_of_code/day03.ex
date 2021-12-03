defmodule Mix.Tasks.AdventOfCode.Day03 do
  @moduledoc """
  Solution for day 3 exercise.

  It expected to receive the input file as first parameter.
  """
  @shortdoc "Solution for day 3 exercise."

  use Mix.Task

  alias AdventOfCode.Solutions.Day03

  @impl Mix.Task
  def run([filename]) do
    Day03.energy_consumption(filename)
    Day03.life_support_rating(filename)
  end

  def run(_args) do
    IO.puts("Expected usage: mix advent_of_code.day03 input_filename")
  end
end
