defmodule Jeopardy.Games.Category do
  use Ecto.Schema
  import Ecto.Changeset

    
  schema "categories" do
    field :title, :string
    belongs_to :game, Jeopardy.Games.Game
    has_many :clues, Jeopardy.Games.Clue, foreign_key: :clue_id

    timestamps()
  end

  @doc false
  def changeset(category, attrs) do
    category
    |> cast(attrs, [:title, :game_id])
    |> validate_required([:title])
  end
end
