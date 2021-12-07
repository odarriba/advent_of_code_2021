defmodule AdventOfCode.Solutions.Day05 do
  @moduledoc """
  Solution for day 5 exercise.

  ### Exercise
  https://adventofcode.com/2021/day/5
  """

  require Logger

  @points_separator " -> "
  @coords_separator ","

  def ovarlap_points(filename, mode \\ :full) do
    result =
      filename
      |> File.read!()
      |> parse_file()
      |> filter_lines(mode)
      |> Enum.map(&expand_line/1)
      |> find_overlaps()

    mode_text = if mode == :full, do: "(including diagonals) ", else: ""
    IO.puts("Number of overlapping points #{mode_text}#{length(result)}")
  end

  defp parse_file(file_content) do
    file_content
    |> String.replace("\r\n", "\n")
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_line/1)
  end

  defp parse_line(line_str) do
    line_str
    |> String.split(@points_separator)
    |> Enum.map(&parse_point/1)
  end

  defp parse_point(point_str) do
    point_str
    |> String.split(@coords_separator)
    |> Enum.map(&String.to_integer/1)
  end

  defp filter_lines(lines, mode) do
    Enum.filter(lines, fn
      [[x, _y1], [x, _y2]] ->
        true

      [[_x1, y], [_x2, y]] ->
        true

      [[x1, y1], [x2, y2]] ->
        # Diagonal lines only allowed if at 45 degress and full mode
        abs(x1 - x2) == abs(y1 - y2) && mode == :full
    end)
  end

  defp expand_line([[x, y1], [x, y2]]) do
    for y <- y1..y2 do
      {x, y}
    end
  end

  defp expand_line([[x1, y], [x2, y]]) do
    for x <- x1..x2 do
      {x, y}
    end
  end

  defp expand_line([[x1, y1], [x2, y2]]) do
    diff = abs(x2 - x1)

    direction_x = direction_factor(x1, x2)
    direction_y = direction_factor(y1, y2)

    for i <- 0..diff do
      {x1 + direction_x * i, y1 + direction_y * i}
    end
  end

  defp direction_factor(x1, x2) when x1 > x2, do: -1
  defp direction_factor(x1, x2) when x1 < x2, do: 1

  defp find_overlaps(lines) do
    lines
    |> List.flatten()
    |> Enum.frequencies()
    |> Enum.filter(fn {_k, v} -> v > 1 end)
  end
end
