defmodule AdventOfCode.Solutions.Day08 do
  @moduledoc """
  Solution for day 8 exercise.

  ### Exercise
  https://adventofcode.com/2021/day/8
  """

  require Logger

  @entry_separator " | "

  def calculate_segments(filename, mode) do
    entries =
      filename
      |> File.read!()
      |> parse_entries()

    result = guess_entries(entries, mode)

    IO.puts("Result guessing segments in #{mode} is #{result}")
  end

  defp parse_entries(file_content) do
    file_content
    |> String.replace("\r\n", "\n")
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_entry/1)
  end

  defp parse_entry(entry_str) do
    [patterns, signals] =
      entry_str
      |> String.split(@entry_separator)
      |> Enum.map(&String.split(&1, " ", trim: true))

    %{patterns: patterns, signals: signals}
  end

  defp guess_entries(entries, mode) do
    Enum.reduce(entries, 0, fn entry, acc -> acc + guess_entry(entry, mode) end)
  end

  defp guess_entry(%{patterns: patterns, signals: signals}, :direct) do
    recognisable_patterns = get_direct_patterns(patterns)

    signals
    |> Enum.map(&sort_signal/1)
    |> Enum.map(&Map.get(recognisable_patterns, &1))
    |> Enum.reject(&is_nil/1)
    |> length()
  end

  defp guess_entry(%{patterns: patterns, signals: signals}, :full) do
    recognisable_patterns =
      patterns
      |> get_direct_patterns()
      |> get_indirect_patterns()

    signals
    |> Enum.map(&sort_signal/1)
    |> Enum.map(&Map.get(recognisable_patterns, &1))
    |> Enum.reject(&is_nil/1)
    |> Enum.map(&to_string/1)
    |> Enum.join()
    |> String.to_integer()
  end

  defp get_direct_patterns(patterns) do
    patterns
    |> Enum.map(&sort_signal/1)
    |> Enum.map(&direct_guess_pattern/1)
    |> Enum.into(%{})
  end

  defp get_indirect_patterns(direct_patterns) do
    all_patterns = Map.keys(direct_patterns)

    # This order is specifically crafted because there are some guessing
    # functions that need previous guesses.
    direct_patterns
    |> traverse_map()
    |> guess_pattern(0, all_patterns)
    |> guess_pattern(3, all_patterns)
    |> guess_pattern(6, all_patterns)
    |> guess_pattern(9, all_patterns)
    |> guess_pattern(2, all_patterns)
    |> guess_pattern(5, all_patterns)
    |> traverse_map()
  end

  defp guess_pattern(patterns, 0, all_patterns) do
    %{7 => pattern_7, 4 => pattern_4} = patterns

    pattern_0 =
      Enum.find(all_patterns, fn pattern ->
        length(pattern) == 6 &&
          length(pattern_4 -- pattern) == 1 &&
          length(pattern_7 -- pattern) == 0
      end)

    Map.put(patterns, 0, pattern_0)
  end

  defp guess_pattern(patterns, 3, all_patterns) do
    %{4 => pattern_4, 7 => pattern_7} = patterns

    pattern_3 =
      Enum.find(all_patterns, fn pattern ->
        length(pattern) == 5 &&
          length(pattern_4 -- pattern) == 1 &&
          length(pattern_7 -- pattern) == 0
      end)

    Map.put(patterns, 3, pattern_3)
  end

  defp guess_pattern(patterns, 6, all_patterns) do
    %{8 => pattern_8, 1 => pattern_1} = patterns

    pattern_6 =
      Enum.find(all_patterns, fn pattern ->
        length(pattern) == 6 &&
          length(pattern_8 -- pattern) == 1 &&
          length(pattern_1 -- pattern) == 1
      end)

    Map.put(patterns, 6, pattern_6)
  end

  defp guess_pattern(patterns, 9, all_patterns) do
    %{4 => pattern_4} = patterns

    pattern_9 =
      Enum.find(all_patterns, fn pattern ->
        length(pattern) == 6 &&
          length(pattern_4 -- pattern) == 0
      end)

    Map.put(patterns, 9, pattern_9)
  end

  defp guess_pattern(patterns, 2, all_patterns) do
    %{9 => pattern_9, 1 => pattern_1} = patterns

    pattern_2 =
      Enum.find(all_patterns, fn pattern ->
        length(pattern) == 5 &&
          length(pattern_9 -- pattern) == 2 &&
          length(pattern_1 -- pattern) == 1
      end)

    Map.put(patterns, 2, pattern_2)
  end

  defp guess_pattern(patterns, 5, all_patterns) do
    %{6 => pattern_6, 4 => pattern_4} = patterns

    pattern_5 =
      Enum.find(all_patterns, fn pattern ->
        length(pattern) == 5 &&
          length(pattern_6 -- pattern) == 1 &&
          length(pattern_4 -- pattern) == 1
      end)

    Map.put(patterns, 5, pattern_5)
  end

  defp guess_pattern(patterns, _, _), do: patterns

  defp direct_guess_pattern(pattern) when length(pattern) == 2, do: {pattern, 1}
  defp direct_guess_pattern(pattern) when length(pattern) == 4, do: {pattern, 4}
  defp direct_guess_pattern(pattern) when length(pattern) == 3, do: {pattern, 7}
  defp direct_guess_pattern(pattern) when length(pattern) == 7, do: {pattern, 8}
  defp direct_guess_pattern(pattern), do: {pattern, nil}

  defp sort_signal(signal) do
    signal
    |> String.graphemes()
    |> Enum.sort()
  end

  defp traverse_map(map) do
    map
    |> Enum.reduce(%{}, fn
      {_k, nil}, acc -> acc
      {k, v}, acc -> Map.put(acc, v, k)
    end)
    |> Enum.into(%{})
  end
end
