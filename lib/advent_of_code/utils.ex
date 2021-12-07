defmodule AdventOfCode.Utils do
  @moduledoc """
  Module with utilities to be used by various exercises.
  """

  @doc """
  Function that receives a list of lists and transposes it: changes columns to
  be rows and vice versa.
  """
  def transpose_matrix(matrix) do
    matrix
    |> List.zip()
    |> Enum.map(&Tuple.to_list/1)
  end
end
