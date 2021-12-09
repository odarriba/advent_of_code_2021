defmodule AdventOfCode.Solutions.Day09 do
  @moduledoc """
  Solution for day 9 exercise.

  ### Exercise
  https://adventofcode.com/2021/day/9
  """

  require Logger

  def calculate_risk(filename) do
    map =
      filename
      |> File.read!()
      |> parse_map()

    result = do_calculate_risk(map)

    IO.puts("Risk associated is #{result}")
  end

  def calculate_basins(filename) do
    map =
      filename
      |> File.read!()
      |> parse_map()

    result = do_calculate_basins(map)

    IO.puts("Result of basins calculation is #{result}")
  end

  defp parse_map(file_content) do
    file_content
    |> String.replace("\r\n", "\n")
    |> String.split("\n", trim: true)
    |> Enum.map(fn row ->
      row
      |> String.graphemes()
      |> Enum.map(&String.to_integer/1)
    end)
  end

  defp do_calculate_risk(map) do
    get_low_points(map)
    |> Enum.map(fn {x, y} -> get_value_from_map(map, {x, y}) + 1 end)
    |> Enum.sum()
  end

  defp do_calculate_basins(map) do
    basins =
      get_low_points(map)
      |> Enum.map(fn {x, y} ->
        {basil_coords, _checked} = get_basin_coords(map, {x, y})

        basil_coords
        |> Enum.uniq()
        |> length()
      end)
      |> Enum.sort(&(&1 >= &2))

    [top_1 | [top_2 | [top_3 | _tail]]] = basins

    top_1 * top_2 * top_3
  end

  defp get_basin_coords(map, {x, y}, checked_coords \\ []) do
    around_coords =
      [
        {x + 1, y},
        {x - 1, y},
        {x, y + 1},
        {x, y - 1}
      ]
      |> Enum.reject(&(&1 in checked_coords))
      |> Enum.reject(fn {x, y} ->
        value = get_value_from_map(map, {x, y})
        value in [nil, 9]
      end)

    updated_checked_coords = [{x, y} | checked_coords]

    # We need a reduce here to keep tje list of checked coords up to date and
    # avoid accessing tons of times the same coords.
    {basil_coords, checked_coords} =
      Enum.reduce(around_coords, {[{x, y}], updated_checked_coords}, fn
        {cx, cy}, {acc_basil_coords, acc_checked_coords} ->
          {basil_coords, checked_coords} = get_basin_coords(map, {cx, cy}, acc_checked_coords)

          acc_checked_coords = Enum.uniq(checked_coords ++ acc_checked_coords)
          acc_basil_coords = Enum.uniq(basil_coords ++ acc_basil_coords)
          {acc_basil_coords, acc_checked_coords}
      end)

    {basil_coords, checked_coords}
  end

  defp get_low_points(map) do
    coords = calculate_available_coords(map)

    Enum.reduce(coords, [], fn {x, y}, acc ->
      value = get_value_from_map(map, {x, y})

      around_values =
        [
          get_value_from_map(map, {x + 1, y}),
          get_value_from_map(map, {x - 1, y}),
          get_value_from_map(map, {x, y + 1}),
          get_value_from_map(map, {x, y - 1})
        ]
        |> Enum.reject(&is_nil/1)

      if Enum.all?(around_values, &(&1 > value)) do
        [{x, y} | acc]
      else
        acc
      end
    end)
  end

  defp calculate_available_coords(map) do
    max_y = length(map)

    max_x =
      map
      |> hd()
      |> length()

    for x <- 0..(max_x - 1) do
      for y <- 0..(max_y - 1) do
        {x, y}
      end
    end
    |> List.flatten()
  end

  defp get_value_from_map(_map, {x, _y}) when x < 0, do: nil
  defp get_value_from_map(_map, {_x, y}) when y < 0, do: nil

  defp get_value_from_map(map, {x, y}) do
    map
    |> Enum.at(y, [])
    |> Enum.at(x)
  end
end
