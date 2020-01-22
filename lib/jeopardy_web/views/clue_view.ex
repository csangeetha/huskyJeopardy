defmodule JeopardyWeb.ClueView do
  use JeopardyWeb, :view
  alias JeopardyWeb.ClueView

  def render("index.json", %{clues: clues}) do
    %{data: render_many(clues, ClueView, "clue.json")}
  end

  def render("show.json", %{clue: clue}) do
    %{data: render_one(clue, ClueView, "clue.json")}
  end

  def render("clue.json", %{clue: clue}) do
    %{id: clue.id,
      question: clue.question,
      answer: clue.answer,
      value: clue.value}
  end
end
