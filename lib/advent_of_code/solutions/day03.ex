defmodule AdventOfCode.Solutions.Day03 do
  @moduledoc """
  Solution for day 3 exercise.

  ### Exercise
  https://adventofcode.com/2021/day/3
  """

  require Logger

  def energy_consumption(filename) do
    [gamma, epsilon] =
      filename
      |> File.read!()
      |> parse_file()
      |> calculate_energy_indicators()

    result = values_to_integer(gamma) * values_to_integer(epsilon)

    IO.puts("Energy consumption of #{result}")
  end

  def life_support_rating(filename) do
    [o2_generator, co2_scrubber] =
      filename
      |> File.read!()
      |> parse_file()
      |> calculate_life_support_indicators()

    result = values_to_integer(o2_generator) * values_to_integer(co2_scrubber)

    IO.puts("Life support rating of #{result}")
  end

  defp parse_file(file_content) do
    file_content
    |> String.replace("\r\n", "\n")
    |> String.split("\n")
    |> Enum.reject(&(&1 == ""))
    |> Enum.map(&String.graphemes/1)
  end

  defp calculate_energy_indicators(values) do
    transposed_values = transpose_values(values)

    gamma = Enum.map(transposed_values, &most_frequent_value/1)
    epsilon = Enum.map(gamma, &opposite_binary/1)

    [gamma, epsilon]
  end

  defp calculate_life_support_indicators(values) do
    o2_generator = calculate_life_indicator(values, :o2_generator)
    co2_scrubber = calculate_life_indicator(values, :co2_scrubber)

    [o2_generator, co2_scrubber]
  end

  defp calculate_life_indicator(values, mode, position \\ 0)

  defp calculate_life_indicator([value], _mode, _position), do: value

  defp calculate_life_indicator(values, mode, position) do
    transposed_values = transpose_values(values)

    filtering_value =
      transposed_values
      |> Enum.at(position)
      |> most_frequent_value()

    filtering_value =
      case mode do
        :o2_generator -> filtering_value
        :co2_scrubber -> opposite_binary(filtering_value)
      end

    filtered_values = Enum.reject(values, &(Enum.at(&1, position) != filtering_value))

    calculate_life_indicator(filtered_values, mode, position + 1)
  end

  defp values_to_integer(values) do
    values
    |> Enum.join()
    |> Integer.parse(2)
    |> elem(0)
  end

  defp opposite_binary("0"), do: "1"
  defp opposite_binary("1"), do: "0"

  defp most_frequent_value(list) do
    list
    |> Enum.frequencies()
    |> case do
      %{"0" => zero_occ, "1" => one_occ} when zero_occ > one_occ -> "0"
      _ -> "1"
    end
  end

  # This function transposes a list of lists (aka a matrix) to be able to
  # easily make calculations using columns of values
  defp transpose_values(values) do
    values
    |> List.zip()
    |> Enum.map(&Tuple.to_list/1)
  end
end
