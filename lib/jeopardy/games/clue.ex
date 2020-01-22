defmodule Jeopardy.Games.Clue do
  use Ecto.Schema
  import Ecto.Changeset

  alias Jeopardy.Games.Category

  schema "clues" do
    field :answer, :string
    field :question, :string
    field :value, :integer
    belongs_to :category, Category

    timestamps()
  end

  @doc false
  def changeset(clue, attrs) do
    clue
    |> cast(attrs, [:question, :answer, :value, :category_id])
    |> validate_required([:question, :answer, :value, :category_id])
  end
end
