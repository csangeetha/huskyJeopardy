defmodule Jeopardy.Games.Game do
  use Ecto.Schema
  import Ecto.Changeset

  schema "games" do
     has_many :categories, Jeopardy.Games.Category, foreign_key: :category_id

    timestamps()
  end

  @doc false
  def changeset(game, attrs) do
    game
    |> cast(attrs, [])
    |> validate_required([])
  end
end
