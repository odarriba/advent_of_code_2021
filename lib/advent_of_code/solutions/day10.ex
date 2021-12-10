defmodule AdventOfCode.Solutions.Day10 do
  @moduledoc """
  Solution for day 10 exercise.

  ### Exercise
  https://adventofcode.com/2021/day/10
  """

  require Logger

  def score(filename) do
    input =
      filename
      |> File.read!()
      |> parse_input()

    {syntax_errors_score, autocompletion_score} = calculate_score(input)

    IO.puts("Syntaxt error score is #{syntax_errors_score}")
    IO.puts("Autocompletion score is #{autocompletion_score}")
  end

  defp parse_input(file_content) do
    file_content
    |> String.replace("\r\n", "\n")
    |> String.split("\n", trim: true)
    |> Enum.map(&String.graphemes/1)
  end

  defp calculate_score(input) do
    compiled_lines = Enum.map(input, &compile_line/1)

    syntax_errors_score =
      compiled_lines
      |> Enum.map(&syntax_error_to_score/1)
      |> Enum.sum()

    autocompletion_scores_per_line =
      compiled_lines
      |> Enum.map(&autocompletion_to_score/1)
      |> Enum.reject(&is_nil/1)

    autocompletion_score =
      autocompletion_scores_per_line
      |> Enum.sort()
      |> Enum.at(div(length(autocompletion_scores_per_line), 2))

    {syntax_errors_score, autocompletion_score}
  end

  defp compile_line(line) do
    expected_closing_chars = []

    result =
      Enum.reduce_while(line, expected_closing_chars, fn
        "(", acc -> {:cont, [")" | acc]}
        "[", acc -> {:cont, ["]" | acc]}
        "{", acc -> {:cont, ["}" | acc]}
        "<", acc -> {:cont, [">" | acc]}
        char, [char | acc] -> {:cont, acc}
        char, _ -> {:halt, {:syntax_error, char}}
      end)

    case result do
      # Complete line
      [] -> :ok
      # Syntax error
      {:syntax_error, char} -> {:syntax_error, line, char}
      # incomplete line
      missing_closing_chars -> {:incomplete, line, missing_closing_chars}
    end
  end

  # Function to calculate scores per line for syntax errors and autocompletions

  defp syntax_error_to_score({:syntax_error, _line, ")"}), do: 3
  defp syntax_error_to_score({:syntax_error, _line, "]"}), do: 57
  defp syntax_error_to_score({:syntax_error, _line, "}"}), do: 1197
  defp syntax_error_to_score({:syntax_error, _line, ">"}), do: 25137
  defp syntax_error_to_score(_), do: 0

  defp autocompletion_to_score({:incomplete, _line, chars}),
    do: calculate_autocompletion_score(chars)

  defp autocompletion_to_score(_), do: nil

  # Autocompletion score for a line has to be calculated character by character
  defp calculate_autocompletion_score(chars, score \\ 0)
  defp calculate_autocompletion_score([], score), do: score

  defp calculate_autocompletion_score([char | others], score) do
    current_score = score * 5 + autocompletion_char_score(char)
    calculate_autocompletion_score(others, current_score)
  end

  defp autocompletion_char_score(")"), do: 1
  defp autocompletion_char_score("]"), do: 2
  defp autocompletion_char_score("}"), do: 3
  defp autocompletion_char_score(">"), do: 4
end
