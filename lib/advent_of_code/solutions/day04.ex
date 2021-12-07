defmodule AdventOfCode.Solutions.Day04 do
  @moduledoc """
  Solution for day 4 exercise.

  ### Exercise
  https://adventofcode.com/2021/day/4
  """

  require Logger

  alias AdventOfCode.Utils

  def bingo(filename) do
    result =
      filename
      |> File.read!()
      |> parse_file()
      |> play_bingo(:normal)
      |> parse_result()

    IO.puts("Bingo normal result: #{result}")
  end

  def bingo_opposite(filename) do
    result =
      filename
      |> File.read!()
      |> parse_file()
      |> play_bingo(:opposite)
      |> parse_result()

    IO.puts("Bingo opposite result: #{result}")
  end

  defp parse_file(file_content) do
    [play_numbers | boards] =
      file_content
      |> String.replace("\r\n", "\n")
      |> String.split("\n\n", trim: true)

    parsed_play_numbers =
      play_numbers
      |> String.split(",", trim: true)
      |> Enum.map(&String.to_integer/1)

    parsed_boards =
      boards
      |> Enum.map(fn board ->
        rows = String.split(board, "\n", trim: true)

        Enum.map(rows, fn row ->
          row
          |> String.split(" ", trim: true)
          |> Enum.map(&String.to_integer/1)
        end)
      end)

    {parsed_play_numbers, parsed_boards}
  end

  defp play_bingo({play_numbers, boards}, mode) do
    case mode do
      :normal -> do_play_bingo(boards, play_numbers)
      :opposite -> do_play_bingo_opposite(boards, play_numbers)
    end
  end

  defp parse_result({board, [last_number | _] = current_numbers}) do
    unmarked_numbers = get_unmarked_numbers(board, current_numbers)

    Enum.sum(unmarked_numbers) * last_number
  end

  defp do_play_bingo(boards, [current_number | pending_numbers], past_numbers \\ []) do
    current_numbers = [current_number | past_numbers]

    winning_board = Enum.find(boards, &board_wins?(&1, current_numbers))

    case winning_board do
      nil -> do_play_bingo(boards, pending_numbers, current_numbers)
      board -> {board, current_numbers}
    end
  end

  # Opposite bingo is about finding the last winning board.
  defp do_play_bingo_opposite(boards, numbers, past_numbers \\ [])

  defp do_play_bingo_opposite([last_board], [current_number | pending_numbers], past_numbers) do
    current_numbers = [current_number | past_numbers]

    if board_wins?(last_board, current_numbers),
      do: {last_board, current_numbers},
      else: do_play_bingo_opposite([last_board], pending_numbers, current_numbers)
  end

  defp do_play_bingo_opposite(boards, [current_number | pending_numbers], past_numbers) do
    current_numbers = [current_number | past_numbers]

    boards_left = Enum.reject(boards, &board_wins?(&1, current_numbers))
    do_play_bingo_opposite(boards_left, pending_numbers, current_numbers)
  end

  # A board wins if a column or a row has all it's numbers on the current numbers
  # already seen.
  #
  defp board_wins?(board, current_numbers) do
    # To ease check, we transpose the matrix and append it to the original board
    # so we can check columns and rows at once.
    transposed_board = Utils.transpose_matrix(board)

    (board ++ transposed_board)
    |> Enum.any?(fn row ->
      Enum.all?(row, &(&1 in current_numbers))
    end)
  end

  defp get_unmarked_numbers(board, current_numbers) do
    board
    |> List.flatten()
    |> Enum.reject(&(&1 in current_numbers))
  end
end
