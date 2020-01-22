defmodule Jeopardy.Game do
  alias Jeopardy.Sessions
  alias  Jeopardy.Games

  def fetch_sessions do
    Sessions.list_sessions() |> list_to_sanitize
  end

  defp list_to_sanitize(list) do
    for n <- list, do: sanitize_map(n)
  end

  defp sanitize_map(struct) do
    sanitize(struct, [:score, :answers])
    |> Map.put(:game, sanitize(struct.game, [:id]))
    |> Map.put(:player, sanitize(struct.user, [:id]))
    |> Map.put(:clues , retrieveClues(struct.answered_clues))
  end

  defp sanitize(struct, val) do
    Map.from_struct(struct) |> Map.take(val)
  end

  defp retrieveClues(answered_clues) do
    if answered_clues != nil && Kernel.length(answered_clues) != 0 do
      len = Kernel.length(answered_clues) - 1
      numbers = 0..len
      numbers_list = Enum.to_list(numbers)
      new_clue_list= Enum.map(numbers_list, fn n ->
        sanitize(Games.get_clue!(Enum.at(answered_clues, n)), [:id,  :question, :answer]) end)
        new_clue_list |> IO.inspect(label: "clue_list")
      end
    end
  end

  # conversion of ecto to map : https://stackoverflow.com/questions/36512627/elixir-convert-struct-to-map,
  # https://coderwall.com/p/fhsehq/fix-encoding-issue-with-ecto-and-poison
