defmodule AdventOfCode.Solutions.Day13 do
  @moduledoc """
  Solution for day 13 exercise.

  ### Exercise
  https://adventofcode.com/2021/day/13
  """

  require Logger

  def run(filename) do
    {points, instructions} =
      filename
      |> File.read!()
      |> parse_input()

    first_fold = hd(instructions)

    result =
      points
      |> execute_folds([first_fold])
      |> Enum.count()

    IO.puts("Number of points after first fold: #{result}")

    IO.puts("Code to introduce:")

    points
    |> execute_folds(instructions)
    |> print_code()
  end

  defp parse_input(file_content) do
    [points_raw, instructions_raw] =
      file_content
      |> String.replace("\r\n", "\n")
      |> String.split("\n\n", trim: true)

    points =
      points_raw
      |> String.split("\n", trim: true)
      |> Enum.map(fn coords ->
        [x, y] =
          coords
          |> String.split(",")
          |> Enum.map(&String.to_integer/1)

        {x, y}
      end)

    instructions =
      instructions_raw
      |> String.split("\n", trim: true)
      |> Enum.map(fn
        <<"fold along y=", coord::binary>> ->
          {:y, String.to_integer(coord)}

        <<"fold along x=", coord::binary>> ->
          {:x, String.to_integer(coord)}
      end)

    {points, instructions}
  end

  defp execute_folds(points, folds) do
    Enum.reduce(folds, points, &execute_fold/2)
  end

  defp execute_fold({:x, coord}, points) do
    points_to_keep = Enum.filter(points, fn {x, _y} -> x < coord end)

    points_folded =
      points
      |> Enum.filter(fn {x, _y} -> x > coord end)
      |> Enum.map(fn {x, y} ->
        {x - 2 * abs(x - coord), y}
      end)

    Enum.uniq(points_to_keep ++ points_folded)
  end

  defp execute_fold({:y, coord}, points) do
    points_to_keep = Enum.filter(points, fn {_x, y} -> y < coord end)

    points_folded =
      points
      |> Enum.filter(fn {_x, y} -> y > coord end)
      |> Enum.map(fn {x, y} ->
        {x, y - 2 * abs(y - coord)}
      end)

    Enum.uniq(points_to_keep ++ points_folded)
  end

  defp print_code(points) do
    for y <- 0..max_coord(points, :y) do
      for x <- 0..max_coord(points, :x) do
        character = if {x, y} in points, do: "#", else: "."
        IO.write(character)
      end

      IO.write("\n")
    end
  end

  defp max_coord(points, :x), do: Enum.map(points, fn {x, _y} -> x end) |> Enum.max()
  defp max_coord(points, :y), do: Enum.map(points, fn {_x, y} -> y end) |> Enum.max()
end
