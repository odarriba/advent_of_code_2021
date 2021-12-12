defmodule AdventOfCode.Solutions.Day12 do
  @moduledoc """
  Solution for day 12 exercise.

  ### Exercise
  https://adventofcode.com/2021/day/12
  """

  require Logger

  def find_paths(filename) do
    cave_map =
      filename
      |> File.read!()
      |> parse_input()

    valid_paths = calculate_paths(cave_map, :fast)
    IO.puts("Number of valid paths using fast mode: #{length(valid_paths)}")

    valid_paths = calculate_paths(cave_map, :slow)
    IO.puts("Number of valid paths using slow mode: #{length(valid_paths)}")
  end

  defp parse_input(file_content) do
    raw_connections =
      file_content
      |> String.replace("\r\n", "\n")
      |> String.split("\n", trim: true)
      |> Enum.map(&String.split(&1, "-"))

    # Transform connection pairs to a map of connections of each point (cave)
    Enum.reduce(raw_connections, %{}, fn [point_a, point_b], acc ->
      current_connections_point_a = Map.get(acc, point_a, [])
      current_connections_point_b = Map.get(acc, point_b, [])

      acc
      |> Map.put(point_a, [point_b | current_connections_point_a])
      |> Map.put(point_b, [point_a | current_connections_point_b])
    end)
    |> Enum.map(fn {point, connections} -> {point, Enum.uniq(connections)} end)
    |> Enum.into(%{})
  end

  defp calculate_paths(cave_map, mode, current_path \\ ["start"]) do
    [current_point | _others] = current_path
    current_connections = Map.get(cave_map, current_point)

    avoid_caves = get_caves_to_avoid(mode, current_path)

    current_connections
    |> Enum.reject(&(&1 in avoid_caves))
    |> Enum.reduce([], fn
      "start", acc ->
        acc

      "end", acc ->
        [["end" | current_path] | acc]

      point, acc ->
        acc ++ calculate_paths(cave_map, mode, [point | current_path])
    end)
  end

  # Function to calculate which caves (points) we need to avoid depending on the
  # mode:
  #
  # - `fast`: it only allows passing one time per each small cave.
  #
  # - `slow`: allows passing twice per a small cave (only one) and one time per
  # other small caves.
  #
  defp get_caves_to_avoid(:fast, current_path) do
    Enum.filter(current_path, &small_cave?/1)
  end

  defp get_caves_to_avoid(:slow, current_path) do
    small_cave_revisited =
      current_path
      |> Enum.frequencies()
      |> Enum.any?(fn {point, occurrences} -> small_cave?(point) && occurrences > 1 end)

    if small_cave_revisited do
      Enum.filter(current_path, &small_cave?/1)
    else
      []
    end
  end

  defp small_cave?(point) do
    point == String.downcase(point)
  end
end
