defmodule AdventOfCode.Solutions.Day01 do
  @moduledoc """
  Solution for day 1 exercise.

  ### Exercise

  As the submarine drops below the surface of the ocean, it automatically
  performs a sonar sweep of the nearby sea floor. On a small screen, the sonar
  sweep report (your puzzle input) appears: each line is a measurement of the
  sea floor depth as the sweep looks further and further away from the
  submarine.

  For example, suppose you had the following report:

  ```
  199
  200
  208
  210
  200
  207
  240
  269
  260
  263
  ```

  This report indicates that, scanning outward from the submarine, the sonar
  sweep found depths of 199, 200, 208, 210, and so on.

  The first order of business is to figure out how quickly the depth increases,
  just so you know what you're dealing with - you never know if the keys will get
  carried into deeper water by an ocean current or a fish or something.

  To do this, count the number of times a depth measurement increases from the
  previous measurement. (There is no measurement before the first measurement.)
  In the example above, the changes are as follows:

  ```
  199 (N/A - no previous measurement)
  200 (increased)
  208 (increased)
  210 (increased)
  200 (decreased)
  207 (increased)
  240 (increased)
  269 (increased)
  260 (decreased)
  263 (increased)
  ```

  In this example, there are 7 measurements that are larger than the previous measurement.

  How many measurements are larger than the previous measurement?
  """

  require Logger

  def first_part(filename) do
    result =
      filename
      |> File.read!()
      |> parse_file()
      |> calculate_increases()

    Logger.info("Detected #{result} increases")
  end

  def second_part(filename) do
    result =
      filename
      |> File.read!()
      |> parse_file()
      |> prepare_groups()
      |> calculate_increases()

    Logger.info("Detected #{result} increases using grouping")
  end

  defp parse_file(file_contents) do
    file_contents
    |> String.replace("\r\n", "\n")
    |> String.split("\n")
    |> Enum.reject(&(&1 == ""))
    |> Enum.map(&String.to_integer/1)
  end

  defp calculate_increases(measurements) do
    Logger.info("Received #{length(measurements)} data points...")

    {increases, _last} =
      Enum.reduce(measurements, {0, nil}, fn
        measure, {0, nil} -> {0, measure}
        measure, {increases, last} when measure > last -> {increases + 1, measure}
        measure, {increases, _last} -> {increases, measure}
      end)

    increases
  end

  defp prepare_groups(measurements) do
    num_groups = length(measurements) - 3

    Enum.reduce(0..num_groups, [], fn idx, acc ->
      new_datapoint =
        Enum.at(measurements, idx) +
          Enum.at(measurements, idx + 1) +
          Enum.at(measurements, idx + 2)

      [new_datapoint | acc]
    end)
    |> Enum.reverse()
  end
end
