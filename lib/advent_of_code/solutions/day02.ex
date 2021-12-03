defmodule AdventOfCode.Solutions.Day02 do
  @moduledoc """
  Solution for day 2 exercise.

  ### Exercise
  https://adventofcode.com/2021/day/2

  """

  require Logger

  def first_part(filename) do
    [x, y] =
      filename
      |> File.read!()
      |> parse_orders()
      |> compute_orders()

    IO.puts("Result of #{x * y}")
  end

  def second_part(filename) do
    [x, y, _aim] =
      filename
      |> File.read!()
      |> parse_orders()
      |> compute_orders_with_aim()

    IO.puts("Result of #{x * y}")
  end

  defp parse_orders(file_content) do
    file_content
    |> String.replace("\r\n", "\n")
    |> String.split("\n")
    |> Enum.reject(&(&1 == ""))
    |> Enum.map(&String.split(&1, " "))
    |> Enum.map(fn
      ["forward", number] -> {:forward, String.to_integer(number)}
      ["up", number] -> {:up, String.to_integer(number)}
      ["down", number] -> {:down, String.to_integer(number)}
    end)
  end

  defp compute_orders(orders) do
    Enum.reduce(orders, [0, 0], fn
      {:forward, number}, [x, y] -> [x + number, y]
      {:down, number}, [x, y] -> [x, y + number]
      {:up, number}, [x, y] -> [x, y - number]
    end)
  end

  defp compute_orders_with_aim(orders) do
    Enum.reduce(orders, [0, 0, 0], fn
      {:forward, number}, [x, y, aim] -> [x + number, y + aim * number, aim]
      {:down, number}, [x, y, aim] -> [x, y, aim + number]
      {:up, number}, [x, y, aim] -> [x, y, aim - number]
    end)
  end
end
